require! ['util', 'mask']

DEFAULT_DIMENSION_CONFIG =
  cell-width: util.dToP 118
  cell-height: util.dToP 118
  x-spacer: util.dToP 7.5
  y-spacer: util.dToP 7.5
  cells-in-a-row: 3
  cell-scale-when-touch: 1.4
  cell-animation-duration: 100

create-scroll-grid-view = (params) ->
  config = {} <<< DEFAULT_DIMENSION_CONFIG <<< params
  scroll-view = Ti.UI.create-scroll-view {
    scroll-type: 'vertical'
    content-height: 'auto'
    content-width: 'auto'
    animation: create-push-animation config.cell-animation-duration, config.cell-scale-when-touch
    data: config.data
  }

  add-grid-rows scroll-view, config
  add-listeners scroll-view
  add-masks scroll-view
  scroll-view

add-grid-rows = !(view, config) ->
  row-amount = config.data.length / config.cells-in-a-row
  add-grid-cells = add-grid-cells-factory!
  for i in [1 to row-amount]
    row-view = Ti.UI.create-view {
      layout: 'horizontal'
      focusable: false
      top: (i - 1) * (config.cell-height + config.y-spacer)
      height: config.cell-height + config.y-spacer
    }
    add-grid-cells row-view, config
    row-view.parent = view
    view.add row-view

add-grid-cells-factory = ->
  data-index = 0
  !(row-view, config) ->
    for i in [ 1 to config.cells-in-a-row]
      cell-data = config.data[data-index]
      cell-view = Ti.UI.create-image-view {
        left: config.x-spacer
        height: config.cell-height
        width: config.cell-width
        image: cell-data.avatar
        name: cell-data.name # TODO：将要移除
        # z-index: 0
        is-moved: false # 记录是否被按下

        yoyo-type: 'contact-avatar-cell'
        data: cell-data # 将phone-number、missing-calls等数据传到cell-view中使用
      }
      cell-view.parent = row-view
      row-view.add cell-view
      data-index++

add-listeners = !(view) ->
  add-main-mask-listeners view
  add-second-mask-listeners view


add-main-mask-listeners = !(view) ->
  add-same-listener-to-multiple-cell-events view, ['singletap'], !(e, cell) ->
    animate-cell-then-show-mask cell, view.animation, view.main-mask

add-second-mask-listeners = !(view) ->
  add-same-listener-to-multiple-cell-events view, ['doubletap'], !(e, cell) ->
    animate-cell-then-show-mask cell, view.animation, view.second-mask
     

animate-cell-then-show-mask = !(cell, animation, mask) ->
  cell.animate animation, !->
      mask.show cell.rect.x, cell.parent.rect.y # for table row

add-same-listener-to-multiple-cell-events = !(element, events, listener) ->
  for event in events
    add-listener-to-cell-event element, event, listener

add-listener-to-cell-event = !(listened-element, event, handler) ->
  listened-element.add-event-listener event, !(e) ->
    handler e, e.source if is-yoyo-contact-cell e.source
      
create-push-animation = (duration, scale) ->
  matrix2d = Ti.UI.create2DMatrix!
  matrix2d = matrix2d.scale scale
  Ti.UI.create-animation {
      transform: matrix2d
      duration: duration
      autoreverse : true
      }

add-masks = !(view) ->
  view.main-mask = mask.create-mask 'Calling Mask'
  view.second-mask = mask.create-mask 'Info Mask'
  view.add view.main-mask
  view.add view.second-mask

is-yoyo-contact-cell = (ui-element) ->
  ui-element.yoyo-type is 'contact-avatar-cell'

module.exports <<< {create-scroll-grid-view}
