require! ['util', 'mask']

MOVING_THRESHOLD = 1

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
    data: config.data
    # z-index: 0
    is-call-mask-shown: false # 用于指示mask是否出现。
    duration-to-show-call-mask: 200
    avatar-tapped-handler: ->
      console.log 'tapped'
  }

  add-grid-rows scroll-view, config
  add-listeners scroll-view
  add-mask scroll-view
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
        yoyo-type: 'contact-avatar-cell'
        data: cell-data # 将phone-number、missing-calls等数据传到cell-view中使用
      }
      row-view.add cell-view
      data-index++

add-listeners = !(view) ->
  add-push-cell-listeners view
  add-long-hold-listeners view

add-push-cell-listeners = !(view) ->
  matrix2d = Ti.UI.create2DMatrix!
  matrix2d = matrix2d.scale 0.8
  push-cell-animation = Ti.UI.create-animation {
      transform: matrix2d
      duration: view.duration-to-show-call-mask
      autoreverse : true
      }

  view.add-event-listener 'singletap', (e) ->
    if is-yoyo-contact-cell e.source
      Ti.API.info "--> #{e.source.name} was singletapped"
      e.source.animate push-cell-animation,->
        view.avatar-tapped-handler 


add-long-hold-listeners = !(view) ->
  view.add-event-listener 'touchstart', (e) ->
    if is-yoyo-contact-cell e.source
      Ti.API.info "--> #{e.source.name} was touchstart"
      e.source.show-mask-timer = set-timeout (->
          view.is-call-mask-shown = true
          show-mask view
          ), view.duration-to-show-call-mask + 1
 
  view.add-event-listener 'touchend', (e) ->
    if is-yoyo-contact-cell e.source
      Ti.API.info "--> #{e.source.name} was touchend at z-index: #{e.source.zIndex}"
      clear-timeout e.source.show-mask-timer if e.source.show-mask-timer

  view.add-event-listener 'touchmove', (->
    origin-x = null
    origin-y = null
    (e) ->
      console.log "view touchmove origin-x: #{origin-x}, origin-y: #{origin-y}; x: #{e.x}, y: #{e.y}"
      return if !view.is-call-mask-shown
      console.log "show touchmove on mask"
      origin-x := e.x if not origin-x
      origin-y := e.y if not origin-y
      if (e.x - origin-x) > MOVING_THRESHOLD or (e.y - origin-y) > MOVING_THRESHOLD
        mask.mask-calling view.mask
    )()

add-mask = (view) ->
  mask.create-mask view

show-mask = (view)->
  view.mask.show!


is-yoyo-contact-cell = (ui-element) ->
  ui-element.yoyo-type is 'contact-avatar-cell'

exports.create-scroll-grid-view = create-scroll-grid-view
