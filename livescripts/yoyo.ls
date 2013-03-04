require! ['grid', 'mask', 'data-loader', 'config']
create-yoyo-window = ->
  contacts = data-loader.load-contacts!
  win = create-main-window!
  win.add create-yoyo-grid contacts
  win

create-main-window = ->
  win = Ti.UI.create-window config.main-window 

create-yoyo-grid = (contacts) ->
  yoyo-grid = grid.create-grid {data: contacts}
  add-masks yoyo-grid
  yoyo-grid

add-masks = !(grid) ->
  grid.main-mask = mask.create-mask {yoyo-name: 'Calling Mask'}
  grid.second-mask = mask.create-mask {yoyo-name: 'Info Mask'}
  grid.main-mask.parent = grid.second-mask.parent = grid
  add-show-main-mask-listener grid
  add-show-second-mask-listener grid
  grid.add grid.main-mask
  grid.add grid.second-mask

add-show-main-mask-listener = !(grid) ->
  add-listener-to-cell-event grid, 'singletap', !(e, cell) ->
    animate-cell-then-show-mask cell, grid.animation, grid.main-mask

add-show-second-mask-listener = !(grid) ->
  add-listener-to-cell-event grid, 'doubletap', !(e, cell) ->
    animate-cell-then-show-mask cell, grid.animation, grid.second-mask
     
add-listener-to-cell-event = !(listened-element, event, handler) ->
  listened-element.add-event-listener event, !(e) ->
    # console.log "cell got event: #{e.type}, cell is: #{e.source.parent}"
    handler e, e.source.parent if is-yoyo-contact-cell e.source.parent
      
add-same-listener-to-multiple-cell-events = !(element, events, listener) ->
  for event in events
    add-listener-to-cell-event element, event, listener

animate-cell-then-show-mask = !(tapped-cell, animation, mask) ->
  console.log "animation: %j", animation
  tapped-cell.parent.animate animation, !-> # tapped-cell外层有wrapper，用来做圆角。
    switch mask.yoyo-name # 用yoyo-type代替yoyo-name，可以扩展出新的mask开场动画。
    case 'Calling Mask'
      mask.show tapped-cell.parent, tapped-cell.parent.rect.x, tapped-cell.parent.parent.rect.y 
    case 'Info Mask'
      mask.background-color = '#E2E1E1'
      mask.show tapped-cell.parent # 动画cell
    default
      mask.show!

is-yoyo-contact-cell = (ui-element) ->
  ui-element.yoyo-type is 'contact-avatar-cell'


module.exports <<< {create-yoyo-window}