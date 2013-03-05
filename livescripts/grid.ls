require! ['util', 'mask', 'cell', 'config']

temp-cells-store = null # 在grid未建造好之前，临时hold cells

create-grid = (params) ->
  temp-cells-store := []
  grid = Ti.UI.create-scroll-view {
    hide-vells-of-cells: !->
      for cell in @cells
        cell.vell.visible = false 
  }  <<< config.grid <<< params

  add-grid-rows grid
  grid.cells = [cell for cell in temp-cells-store]
  grid

add-grid-rows = !(grid) ->
  add-grid-cells = add-grid-cells-factory!
  row-amount = grid.data.length / config.grid.cells-in-a-row
  for i in [1 to row-amount]
    top = (i - 1) * (config.cell.size + config.cell.y-spacer)
    add-grid-cells grid, top, grid.data

add-grid-cells-factory = ->
  data-index = 0
  !(grid, top, data) ->
    for i in [ 1 to config.grid.cells-in-a-row]
      left = (i - 1) * (config.cell.size + config.cell.x-spacer)
      wrapped-cell = create-wrapped-cell-with-data top, left, data, data-index
      grid.add wrapped-cell # wrap cell for get rect.x at runtime, because the rect.x of a cell with borderRadius is always 0.
      temp-cells-store.push wrapped-cell.cell
      data-index++

create-wrapped-cell-with-data = (top, left, data, data-index) ->
  cell-data = data[data-index]
  cell.create-cell {
    top: top
    left: left
    image: cell-data.avatar
    cell-index: data-index
    data: cell-data # 将phone-number、missing-calls等数据传到cell-view中使用
  }

module.exports <<< {create-grid}
