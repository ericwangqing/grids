require! ['util', 'mask']

DEFAULT_DIMENSION_CONFIG =
  cell-width: util.dToP 118
  cell-height: util.dToP 118
  x-spacer: util.dToP 7.5
  y-spacer: util.dToP 7.5
  cells-in-a-row: 3

create-scroll-grid-view = (params) ->
  config = {} <<< DEFAULT_DIMENSION_CONFIG <<< params
  scroll-view = Ti.UI.create-scroll-view {
    scroll-type: 'vertical'
    content-height: 'auto'
    content-width: 'auto'
    # is-call-mask-shown: false # 用于指示mask是否出现。
    duration-to-show-mask: 200
    # avatar-longpress-handler: (cell)->
    #   console.log '#{cell.name} was longpressed ...'
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

      row-view.add cell-view
      data-index++

add-listeners = !(view) ->
  add-push-cell-listeners view
  add-long-press-listeners view


add-push-cell-listeners = !(view) ->
  add-same-listener-to-multiple-cell-events view, ['touchstart'], !(e, cell) ->
    Ti.API.info "--> #{cell.name} was singletapped"
    cell.origin-x = e.x
    cell.origin-y = e.y
    set-timeout (->
      if !cell.is-moved and !view.calling-mask.visible
        view.calling-mask.show-then-hide!
      else
        cell.is-moved = false
      ), 50

  add-same-listener-to-multiple-cell-events view, ['touchmove', 'doubletap', 'longpress'], !(e, cell) ->
    cell.is-moved = true if mask.is-significant-move e, cell
    cell.is-moved = false if e.type is 'touchmove' and !mask.is-significant-move e, cell # tap时会有轻微移位


create-push-animation = (view) ->
  matrix2d = Ti.UI.create2DMatrix!
  matrix2d = matrix2d.scale 0.8
  Ti.UI.create-animation {
      transform: matrix2d
      duration: view.duration-to-show-mask
      autoreverse : true
      }

add-long-press-listeners = !(view) ->
  add-same-listener-to-multiple-cell-events view, ['doubletap', 'longpress'], !(e, cell) ->
    Ti.API.info "--> #{cell.name} was touchstart in longpress handler"
    cell.animate (create-push-animation view), !->
      view.info-mask.show! 


add-same-listener-to-multiple-cell-events = !(element, events, listener) ->
  for event in events
    add-listener-to-cell-event element, event, listener

add-listener-to-cell-event = !(listened-element, event, handler) ->
  listened-element.add-event-listener event, !(e) ->
    handler e, e.source if is-yoyo-contact-cell e.source
      

add-masks = (view) ->
  view.calling-mask = mask.create-mask 'Calling Mask'
  view.info-mask = mask.create-mask 'Info Mask'
  view.add view.calling-mask
  view.add view.info-mask

is-yoyo-contact-cell = (ui-element) ->
  ui-element.yoyo-type is 'contact-avatar-cell'

exports.create-scroll-grid-view = create-scroll-grid-view
