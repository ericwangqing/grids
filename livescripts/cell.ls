require! ['config']

create-cell = (params) ->
  cell-config = {
    height: config.cell.size
    width: config.cell.size
    border-radius: config.cell.radius
  } <<< params
  # delete cell-config.image
  image-config =  cell-config{height, width, image}
  vell-config = {background-color:'black', opacity: 0.9, visible: false} <<< cell-config{height, width}
    
  cell = Ti.UI.create-view cell-config
  cell.image-view = Ti.UI.create-image-view image-config
  cell.vell = Ti.UI.create-view vell-config
  cell.add cell.image-view
  cell.add cell.vell 

  add-listeners cell
  warpper-cell-to-keep-rect-x-at-runtime cell

add-listeners = !(cell) ->
  cell.image-view.add-event-listener 'singletap', (e) ->
    show-vells-except-clicked-cell e.source.parent

show-vells-except-clicked-cell = !(cell) ->
  grid = cell.parent.parent.parent
  for a-cell in grid.cells
    a-cell.vell.show! if a-cell.cell-index isnt cell.cell-index

warpper-cell-to-keep-rect-x-at-runtime = (cell) -> # 当cell圆角时（有borderRadius），取不到它的rect.x
  wrapper-cell = Ti.UI.create-view {
    left: config.cell.x-spacer
    height: config.cell.size
    width: config.cell.size
  }

  wrapper-cell.add cell
  cell.wrapper = wrapper-cell
  wrapper-cell.cell = cell
  wrapper-cell

module.exports <<< {create-cell}