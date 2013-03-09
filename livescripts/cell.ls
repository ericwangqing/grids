require! ['config', 'info-bar', 'util']

create-cell = (params) ->
  wrapper-config = get-wrapper-config params
  cell-config = get-cell-config params
  image-config = {image: util.get-cached-image-blob cell-config.image} <<< cell-config{height, width}
  cell = Ti.UI.create-view cell-config 
  cell.image-view = Ti.UI.create-image-view image-config
  cell.add cell.image-view
  bar = info-bar.create-info-bar cell.data
  cell.add bar
  warpper-cell-to-keep-rect-x-at-runtime cell, wrapper-config

get-wrapper-config = do ->
  wrapper-config = {
    height: config.cell.size
    width: config.cell.size
  }
  (params) ->
    wrapper-config <<< params{left, top}

get-cell-config = do ->
  cell-config = {
    yoyo-type: config.cell.yoyo-type
    height: config.cell.size
    width: config.cell.size
    border-radius: config.cell.radius 
  } 
  (params) ->
    cell-config <<< params{image, cell-index, data}

warpper-cell-to-keep-rect-x-at-runtime = (cell, wrapper-config) -> # 当cell圆角时（有borderRadius），取不到它的rect.x
  wrapper-cell = Ti.UI.create-view wrapper-config
  wrapper-cell.add cell
  cell.wrapper = wrapper-cell
  wrapper-cell.cell = cell
  wrapper-cell

module.exports <<< {create-cell}