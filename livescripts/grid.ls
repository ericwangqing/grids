require! ['util', 'mask', 'cell', 'config']

# scroll-loader-counter = 0 
create-grid-container = (data-loader) ->
  grid-container = Ti.UI.create-scroll-view config.grid
  grid = Ti.UI.create-view {
    cells: []
    last-row-index: 0
  }
  grid-container.add grid
  grid-container.grid = grid

  add-grid-cells-loader grid-container, grid, data-loader
  initialize-grid grid, data-loader
  grid-container

initialize-grid = !(grid, data-loader) ->
  add-grid-rows grid, data-loader.load-data!

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
    image: cell-data.avatar-blob or cell-data.avatar
    cell-index: data-index
    data: cell-data # 将phone-number、missed-calls等数据传到cell-view中使用
  }

add-grid-cells-loader = !(grid-container, grid, data-loader) ->
  periodical-load-grid-cells grid, data-loader if config.data-loader.periodical-load
  previous-y = 0
  scroll-handler = !(e) ->
    if data-loader.has-more-data! 
      add-grid-rows grid, data-loader.load-data! if is-scroll-down pre = previous-y, previous-y := e.y and is-random-to-load!
    else
      grid-container.remove-event-listener 'scroll', scroll-handler
  grid-container.add-event-listener 'scroll', scroll-handler

is-scroll-down = (previous-y, current-y) ->
  current-y > previous-y 

is-random-to-load = ->
  Math.random! < config.data-loader.scroll-to-load-ratio

periodical-load-grid-cells = !(grid, data-loader) ->
  timer = set-interval (!->
    if data-loader.has-more-data! and grid.last-row-index * config.grid.cells-in-a-row < config.data-loader.auto-load-up-limit
      add-grid-rows grid, data-loader.load-data!
    else
      clear-interval timer
    ), config.data-loader.interval-to-load 

module.exports <<< {create-grid-container}
