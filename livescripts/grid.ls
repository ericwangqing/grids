require! './util'

DEFAULT_CONFIG =
  cell-width: util.dToP 120
  cell-height: util.dToP 120
  x-spacer: util.dToP 2
  y-spacer: util.dToP 2
  cells-in-a-row: 3
  push-animation-duration: 100

create-scroll-grid-view = (params) ->
  config = {} <<< DEFAULT_CONFIG <<< params
  scroll-view = Ti.UI.create-scroll-view {
    scroll-type: 'vertical'
    content-height: 'auto'
    content-width: 'auto'
  }
  add-grid-rows scroll-view, config
  add-listeners scroll-view, config
  scroll-view

add-grid-rows = !(view, config) ->
  row-amount = config.data.length / config.cells-in-a-row
  add-grid-cells = add-grid-cells-factory!
  for i in [1 to row-amount]
    row-view = Ti.UI.create-view(
      layout: 'horizontal'
      focusable: false
      top: (i - 1) * (config.cell-height + config.y-spacer)
      height: config.cell-height + config.y-spacer
    )
    add-grid-cells row-view, config
    view.add row-view

add-grid-cells-factory = ->
  data-index = 0
  !(row-view, config) ->
    for i in [ 1 to config.cells-in-a-row]
      cell-data = config.data[data-index]
      cell-view = Ti.UI.create-image-view(
        left: config.x-spacer
        height: config.cell-height
        width: config.cell-width
        image: cell-data.avatar
        name: cell-data.name
        )
      row-view.add cell-view
      data-index++

add-listeners = !(view, config) ->
  add-push-cell-listeners view, config

add-push-cell-listeners = !(view, config) ->
  matrix2d = Ti.UI.create2DMatrix!
  matrix2d = matrix2d.scale 0.8
  push-cell-animation = Ti.UI.create-animation(
      transform: matrix2d
      duration: config.push-animation-duration
      autoreverse : true
  )
  (e) <-! view.add-event-listener 'click'
  if e.source.name
    Ti.API.info "--> #{e.source.name} was clicked"
    e.source.animate push-cell-animation

exports.create-scroll-grid-view = create-scroll-grid-view
