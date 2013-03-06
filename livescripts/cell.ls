require! ['config', 'info-bar']

create-cell = (params) ->
  wrapper-config = get-wrapper-config params
  cell-config = get-cell-config params
  image-config =  cell-config{height, width, image}
    
  cell = Ti.UI.create-view cell-config 
  cell.image-view = Ti.UI.create-image-view image-config
  cell.add cell.image-view
  bar = info-bar.create-info-bar cell.data
  cell.add bar
  warpper-cell-to-keep-rect-x-at-runtime cell, wrapper-config

get-wrapper-config = (params) ->
  wrapper-config = {
    height: config.cell.size
    width: config.cell.size
  } <<< params{left, top}

get-cell-config = (params) ->
  cell-config = {
    yoyo-type: config.cell.yoyo-type
    height: config.cell.size
    width: config.cell.size
    border-radius: config.cell.radius 
  } <<< params <<< {left: 0, top: 0}

warpper-cell-to-keep-rect-x-at-runtime = (cell, wrapper-config) -> # 当cell圆角时（有borderRadius），取不到它的rect.x
  wrapper-cell = Ti.UI.create-view wrapper-config
  wrapper-cell.add cell
  cell.wrapper = wrapper-cell
  wrapper-cell.cell = cell
  wrapper-cell

module.exports <<< {create-cell}