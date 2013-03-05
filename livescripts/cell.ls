require! ['config']

create-cell = (params) ->
  wrapper-config = get-wrapper-config params
  cell-config = get-cell-config params
  image-config =  cell-config{height, width, image}
  vell-config = get-vell-config cell-config
    
  cell = Ti.UI.create-view cell-config 
  cell.image-view = Ti.UI.create-image-view image-config
  cell.vell = Ti.UI.create-view vell-config
  cell.add cell.image-view
  cell.add cell.vell 
  add-listeners cell
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

get-vell-config = (cell-config) ->
  vell-config = config.vell <<< cell-config{height, width, border-radius} <<< {visible: false}

add-listeners = !(cell) ->
  cell.image-view.add-event-listener 'singletap', (e) ->
    show-vells-except-clicked-cell e.source.parent

show-vells-except-clicked-cell = !(cell) ->
  grid = cell.parent.parent
  for a-cell in grid.cells
    a-cell.vell.show! if a-cell.cell-index isnt cell.cell-index

warpper-cell-to-keep-rect-x-at-runtime = (cell, wrapper-config) -> # 当cell圆角时（有borderRadius），取不到它的rect.x
  wrapper-cell = Ti.UI.create-view wrapper-config
  wrapper-cell.add cell
  cell.wrapper = wrapper-cell
  wrapper-cell.cell = cell
  wrapper-cell

module.exports <<< {create-cell}