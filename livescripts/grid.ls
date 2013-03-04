require! ['util', 'mask', 'cell', 'config']

temp-cells-store = null # 在grid未建造好之前，临时hold cells

create-grid = (params) ->
  temp-cells-store := []
  scroll-view = Ti.UI.create-scroll-view {
    hide-vells-of-cells: !->
      for cell in @cells
        cell.vell.visible = false 
  }  <<< config.grid <<< params

  add-grid-rows scroll-view
  scroll-view.cells = [cell for cell in temp-cells-store]
  scroll-view

add-grid-rows = !(view) ->
  row-amount = view.data.length / config.grid.cells-in-a-row
  add-grid-cells = add-grid-cells-factory!
  row-amount = view.data.length / config.grid.cells-in-a-row
  for i in [1 to row-amount]
    top = (i - 1) * (config.cell.size + config.cell.y-spacer)
    row-view = Ti.UI.create-view {
      layout: 'horizontal'
      focusable: false
      top: (i - 1) * (config.cell.size + config.cell.y-spacer)
      height: config.cell.size + config.cell.y-spacer
    }
    add-grid-cells row-view, view.data
    view.add row-view

add-grid-cells-factory = ->
  data-index = 0
  !(row-view, data) ->
    for i in [ 1 to config.grid.cells-in-a-row]
      cell-data = data[data-index]
      wrapped-cell-view = cell.create-cell {
        image: cell-data.avatar
        name: cell-data.name # TODO：将要移除
        yoyo-type: 'contact-avatar-cell'
        cell-index: data-index
        data: cell-data # 将phone-number、missing-calls等数据传到cell-view中使用
      }
      row-view.add wrapped-cell-view
      temp-cells-store.push wrapped-cell-view.cell
      data-index++

module.exports <<< {create-grid}
