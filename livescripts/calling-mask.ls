MOVING_THRESHOLD = 5
BUTTON_NAMES = ['call-botton-left', 'call-botton-right', 'message-button-up', 'message-button-down']

create = (mask) ->
  add-buttons mask
  add-listeners mask
  convert-show-method-of-mask-to-show-buttons-in-different-places mask
  mask.make-call = !->
    mask.yoyo-label.set-text 'YoYo为您打电话'
    mask.set-background-color 'green'

  mask.send-message = !->
    mask.yoyo-label.set-text 'YoYo为您发短信'
    mask.set-background-color 'yellow'

  mask

add-buttons = !(mask) ->
  for button-name in BUTTON_NAMES
    mask[button-name] = button = Ti.UI.create-image-view {
      image: select-phone-or-message-icon button-name
      width: 100
      height: 100
      yoyo-name: button-name
      # visible: false
    }
    add-button-listeners button, mask
    mask.add button

add-listeners = !(mask) ->
  add-swipt-listeners mask

add-swipt-listeners = !(mask) ->
  mask.add-event-listener 'touchstart', (e) ->
    mask.origin-x = e.x
    mask.origin-y = e.y

  mask.add-event-listener 'touchmove', !(e) ->
    mask.make-call! if is-significant-horizontal-move e, mask 
    mask.send-message! if is-significant-vertical-move e, mask 

is-significant-horizontal-move = (e, mask) ->
  Math.abs(e.x - mask.origin-x) > MOVING_THRESHOLD and Math.abs(e.x - mask.origin-x) >= Math.abs(e.y - mask.origin-y)

is-significant-vertical-move = (e, mask) ->
  Math.abs(e.y - mask.origin-y) > MOVING_THRESHOLD and Math.abs(e.y - mask.origin-y) >= Math.abs(e.x - mask.origin-x)

add-button-listeners = !(button, mask) ->
  button.add-event-listener 'singletap', (e) ->
    e.cancel-bubble = true
    mask.make-call! if (button.yoyo-name.index-of 'call') > -1
    mask.send-message! if (button.yoyo-name.index-of 'message') > -1
  

convert-show-method-of-mask-to-show-buttons-in-different-places = !(mask) ->
  mask.old-show = mask.show
  mask.show = (cell-left, cell-top) ->
    console.log "cell-left: #{cell-left}, cell-top: #{cell-top}"
    cell-width = 251
    icon-justic-offset = 60
    left = cell-left + icon-justic-offset
    top = cell-top + icon-justic-offset
    set-position mask[BUTTON_NAMES[0]], top, left - cell-width
    set-position mask[BUTTON_NAMES[1]], top, left + cell-width
    set-position mask[BUTTON_NAMES[2]], top - cell-width, left
    set-position mask[BUTTON_NAMES[3]], top + cell-width, left
    mask.old-show!

set-position = !(element, top, left) ->
  element.set-top top
  element.set-left left

select-phone-or-message-icon = (button-name) ->
  return '/images/phone_icon.png' if (button-name.index-of 'call') > -1
  return '/images/message_icon.png' if (button-name.index-of 'message') > -1
  
module.exports <<< {create}