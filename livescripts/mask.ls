
require! ['calling-mask', 'util', 'config']

create-mask = (params) ->
  mask = Ti.UI.create-view config.mask <<< {visible: false} <<< params
  #  注意这里方法的顺序不能够改。
  add-text-label mask
  convert-mask-show mask 
  customize-for-diffrent-mask mask
  add-single-tap-close-mask-handler mask
  mask

add-text-label = !(mask) ->
  label = Ti.UI.create-label config.mask-label <<< {text: mask.yoyo-type}
  mask.yoyo-label = label
  mask.add label

convert-mask-show = !(mask) ->
  old-show = mask.show
  mask.show = !(cell) ->
    mask.cell = cell
    old-show.call mask

add-single-tap-close-mask-handler = !(mask) ->
  origin-background-color = mask.background-color
  origin-text = mask.yoyo-label.text
  mask.add-event-listener 'singletap', (e) ->
    mask.parent.scrolling-enabled = true
    if mask.visible
      hide-mask mask, origin-text, origin-background-color
    else
      console.log "mask clicked even hidden"

hide-mask = !(mask, origin-text, origin-background-color) ->
  mask.cell.animate config.animations.hide-mask-animation, !->
    mask.yoyo-label.set-text origin-text
    mask.set-background-color origin-background-color if origin-background-color
    mask.hide!
    mask.parent.hide-vells-of-cells!

customize-for-diffrent-mask = (mask) ->
  switch mask.yoyo-type 
  case 'Calling Mask'
    calling-mask.create-calling-mask mask
  case 'Info Mask'
    null

module.exports <<< {create-mask}
