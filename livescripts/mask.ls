MOVING_THRESHOLD = 5
MASK-SHOW-DURATION = 1500

exports.create-mask = (mask-name) ->
  mask = Ti.UI.create-view {
    opacity: 0.9
    background-color: 'blue'
    width: Ti.UI.FILL
    height: Ti.UI.FILL
    origin-x: null
    origin-y: null
    visible: false
    yoyo-name: mask-name
    # z-index: 1
  }

  label = Ti.UI.create-label {
    background-color: 'white'
    font: {font-size: 60}
    text: mask-name
    text-align: Ti.UI.TEXT_ALIGNMENT_CENTER
    width: 'auto'
    height: 'auto'
    top: 300
  }

  mask.yoyo-label = label
  mask.add label

  mask.add-event-listener 'singletap', (e) ->
    console.log "mask singletapped"
    if mask.visible
      mask.yoyo-label.set-text mask.yoyo-name
      mask.set-background-color 'blue'
      mask.hide!
    else
      console.log "mask clicked even hidden"

  mask.add-event-listener 'touchstart', (e) ->
    mask.origin-x = e.x
    mask.origin-y = e.y

  mask.add-event-listener 'touchmove', (e) ->
    mask-calling mask if mask.yoyo-name is 'Calling Mask' and is-significant-move e, mask

  mask.show-then-hide = !->
    mask.show!
    mask.auto-hide-timer = set-timeout (!->
      mask.hide!
      mask.set-background-color 'blue'
      ), MASK-SHOW-DURATION,

  mask


is-significant-move = (e, cell) ->
  Math.abs(e.x - cell.origin-x) > MOVING_THRESHOLD or Math.abs(e.y - cell.origin-y) > MOVING_THRESHOLD
    
exports.is-significant-move = is-significant-move

mask-calling = (mask) ->
  clear-timeout mask.auto-hide-timer if mask.auto-hide-timer
  mask.yoyo-label.set-text 'YoYo为您打电话'
  mask.set-background-color 'green'

