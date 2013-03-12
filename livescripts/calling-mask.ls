require! ['config', 'util']

create-calling-mask = (mask) ->
  add-buttons mask
  add-mask-swipt-listeners mask
  hide-label mask
  convert-show-method-of-mask mask
  convert-hide-method-of-mask mask
  mask.make-call = !->
    mask.yoyo-label.set-text 'YoYo为您打电话'
    # Ti.Platform.openURL 'tel:' + mask.get-phone-number!
    intent = Ti.Android.create-intent {
      action: Ti.Android.ACTION_CALL
      data: 'tel:' + mask.get-phone-number!

    }
    Ti.Android.currentActivity.startActivity intent

    console.log "[yoyo] Call => #{mask.get-phone-number!}"
    mask.fire-event 'singletap'

  mask.send-message = !->
    mask.yoyo-label.set-text 'YoYo为您发短信'
    Ti.Platform.openURL 'sms:' + mask.get-phone-number!
    console.log "[yoyo] Call => #{mask.get-phone-number!}"
    mask.fire-event 'singletap'

  mask.get-phone-number = ->
    phones = mask.cell-wrapper.cell.data.phones
    short-numbers = [phone for phone in phones when phone.length is 5]
    return short-number[0] if short-numbers.length > 0
    return mask.cell-wrapper.cell.data.recent-number or phones[0]


  mask

add-buttons = !(mask) ->
  mask.buttons = {}
  for button-name in ['left', 'right', 'up', 'down']
    mask.buttons[button-name] = button = create-button button-name
    icon = create-button-icon button-name
    button.add icon
    add-button-listeners button, mask
    mask.add button

create-button = (button-name) ->
  button-size = config.cell.size / config.cell.scale-when-touch
  Ti.UI.create-view {
    yoyo-type: button-name
    width: button-size 
    height: button-size
    border-radius: config.cell.radius
  } 

create-button-icon = (button-name) ->
  icon-size = config.cell.size * config.calling-mask.button-cell-size-ratio
  center-offset = config.cell.size / config.cell.scale-when-touch / 2
  Ti.UI.create-image-view {
    image: util.get-cached-image-blob select-phone-or-message-icon button-name 
    width: icon-size
    height: icon-size
    center: 
      x: center-offset
      y: center-offset
  }

add-mask-swipt-listeners = !(mask) ->
  mask.add-event-listener 'touchstart', (e) ->
    mask.origin-x = e.x
    mask.origin-y = e.y

  mask.add-event-listener 'touchmove', !(e) ->
    mask.make-call! if is-significant-horizontal-move e, mask 
    mask.send-message! if is-significant-vertical-move e, mask 

is-significant-horizontal-move = (e, mask) ->
  Math.abs(e.x - mask.origin-x) > config.calling-mask.move-threshold and Math.abs(e.x - mask.origin-x) >= Math.abs(e.y - mask.origin-y)

is-significant-vertical-move = (e, mask) ->
  Math.abs(e.y - mask.origin-y) > config.calling-mask.move-threshold and Math.abs(e.y - mask.origin-y) >= Math.abs(e.x - mask.origin-x)

add-button-listeners = !(button, mask) ->
  button.add-event-listener 'singletap', (e) ->
    e.cancel-bubble = true
    mask.make-call! if is-call-button button.yoyo-type
    mask.send-message! if is-message-button button.yoyo-type

hide-label = !(mask) ->
  mask.yoyo-label.text = ''

convert-show-method-of-mask = !(mask) ->
  old-show = mask.show
  mask.show = (cell, cell-left, cell-top, aminator) ->
    if !mask.visible
      move-cell-upon-mask mask, cell
      show-buttons-in-different-places mask, cell-left, cell-top
      old-show.call mask, cell
      aminator! # 展示动画

convert-hide-method-of-mask = !(mask) ->
  old-hide = mask.hide
  mask.hide = ->
    move-cell-back-to-grid mask, mask.cell-wrapper
    old-hide.call mask

move-cell-upon-mask = !(mask, cell) ->
  mask.grid.remove cell
  mask.add cell

move-cell-back-to-grid = !(mask, cell) ->
  mask.remove cell
  mask.grid.add cell

show-buttons-in-different-places = !(mask, left, top) ->
  cell-offset = (config.cell.size + config.cell.x-spacer) # 调整到button所在cell
  in-cell-offset = (config.cell.size - config.cell.size  / config.cell.scale-when-touch) / 2 # 在所在cell内定位
  set-position mask.buttons.left, top + in-cell-offset, left - cell-offset
  set-position mask.buttons.right, top + in-cell-offset, left + cell-offset + 2 * in-cell-offset
  set-position mask.buttons.up, top - cell-offset, left + in-cell-offset
  set-position mask.buttons.down, top + cell-offset + 2 * in-cell-offset, left + in-cell-offset

set-position = !(element, top, left) ->
  element.set-top top
  element.set-left left

select-phone-or-message-icon = (button-name) ->
  return '/images/phone_icon.png' if is-call-button button-name
  return '/images/message_icon.png' if is-message-button button-name

is-call-button = (button-name) ->
  button-name in ['left', 'right']
  
is-message-button = (button-name) ->
  button-name in ['up', 'down']

module.exports <<< {create-calling-mask}