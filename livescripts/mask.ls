MASK-SHOW-DURATION = 1500

MASK-BACKGROUND-COLOR = 'black'

require! ['calling-mask', 'util']

create-mask = (params) ->
  mask = Ti.UI.create-view {
    # opacity: 0.9
    # background-color: MASK-BACKGROUND-COLOR
    top: 0
    left: 0
    width: Ti.UI.FILL
    height: Ti.UI.FILL
    visible: false
    # z-index: 1
  } <<< params

  #  注意这里方法的顺序不能够改。
  add-text-label mask
  convert-mask-show mask
  customize-for-diffrent-mask mask
  add-single-tap-close-mask-handler mask
  mask

add-text-label = !(mask) ->
  label = Ti.UI.create-label {
    background-color: 'white'
    font: {font-size: 60}
    text: mask.yoyo-type 
    text-align: Ti.UI.TEXT_ALIGNMENT_CENTER
    width: 'auto'
    height: 'auto'
    top: 300
  }
  mask.yoyo-label = label
  mask.add label

convert-mask-show = !(mask) ->
  old-show = mask.show
  mask.show = !(cell) ->
    mask.cell = cell
    old-show.call mask

add-single-tap-close-mask-handler = !(mask) ->
  mask-origin-background-color = mask.background-color
  mask-origin-text = mask.yoyo-label.text
  mask.add-event-listener 'singletap', (e) ->
    if mask.visible
      mask.cell.animate (util.create-push-animation 60, 1), !->
        mask.yoyo-label.set-text mask-origin-text
        mask.set-background-color mask-origin-background-color if mask-origin-background-color
        mask.hide!
        mask.parent.hide-vells-of-cells!
    else
      console.log "mask clicked even hidden"

customize-for-diffrent-mask = (mask) ->
  switch mask.yoyo-type 
  case 'Calling Mask'
    calling-mask.create mask
  case 'Info Mask'
    null

module.exports <<< {create-mask}
