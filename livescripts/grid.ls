require! ['util', 'mask', 'cell', 'config']

create-grid = (data-loader) ->
  grid = Ti.UI.create-scroll-view {
    cells: []
    last-row-index: 0
    hide-vells-of-cells: !->
      for cell in @cells
        cell.vell.visible = false 
  }  <<< config.grid

  add-grid-rows grid, data-loader.load-data!
  grid.add-event-listener 'scroll', (e) ->
    if data-loader.has-more-data!
      add-grid-rows grid, data-loader.load-data!
  grid

add-grid-rows = !(grid, data) ->
  add-grid-cells = add-grid-cells-factory!
  row-amount = data.length / config.grid.cells-in-a-row
  for i in [1 to row-amount]
    top = (grid.last-row-index + i - 1) * (config.cell.size + config.cell.y-spacer)
    add-grid-cells grid, top, data
  grid.last-row-index += row-amount

add-grid-cells-factory = ->
  data-index = 0
  !(grid, top, data) ->
    for i in [ 1 to config.grid.cells-in-a-row]
      left = (i - 1) * (config.cell.size + config.cell.x-spacer)
      wrapped-cell = create-wrapped-cell-with-data top, left, data, data-index
      grid.add wrapped-cell # wrap cell for get rect.x at runtime, because the rect.x of a cell with borderRadius is always 0.
      grid.cells.push wrapped-cell.cell
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
