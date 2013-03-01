exports.create-mask = (view) ->
  mask = Ti.UI.create-view {
    opacity: 0.9
    background-color: 'blue'
    width: Ti.UI.FILL
    height: Ti.UI.FILL
    visible: false
    # z-index: 1
  }

  label = Ti.UI.create-label {
    background-color: 'white'
    font: {font-size: 24}
    text-align: Ti.UI.TEXT_ALIGNMENT_CENTER
    width: 'auto'
    height: 'auto'
    top: 50
  }

  mask.yoyo-label = label
  mask.add label

  mask.add-event-listener 'singletap', (e) ->
    console.log "mask singletapped"
    if mask.visible
      mask.yoyo-label.set-text ''
      mask.hide!
      view.is-call-mask-shown = false
    else
      console.log "mask clicked even hidden"

  view.mask = mask
  view.add mask

exports.mask-calling = (mask) ->
  mask.yoyo-label.set-text 'YoYo为您打电话'

