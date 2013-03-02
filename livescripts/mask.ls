MASK-SHOW-DURATION = 1500

require! ['calling-mask']

create-mask = (mask-name) ->
  mask = Ti.UI.create-view {
    opacity: 0.9
    background-color: 'blue'
    width: Ti.UI.FILL
    height: Ti.UI.FILL
    visible: false
    yoyo-name: mask-name
    # z-index: 1
  }

  add-text-label mask
  add-single-tap-close-mask-handler mask
  customize-for-diffrent-mask mask, mask-name
  mask

add-text-label = !(mask) ->
  label = Ti.UI.create-label {
    background-color: 'white'
    font: {font-size: 60}
    text: mask.yoyo-name
    text-align: Ti.UI.TEXT_ALIGNMENT_CENTER
    width: 'auto'
    height: 'auto'
    top: 300
  }
  mask.yoyo-label = label
  mask.add label

add-single-tap-close-mask-handler = !(mask) ->
  mask.add-event-listener 'singletap', (e) ->
    if mask.visible
      mask.yoyo-label.set-text mask.yoyo-name
      mask.set-background-color 'blue'
      mask.hide!
    else
      console.log "mask clicked even hidden"

customize-for-diffrent-mask = (mask, mask-name) ->
  switch mask-name 
  case 'Calling Mask'
    calling-mask.create mask
  case 'Info Mask'
    null

module.exports <<< {create-mask}
