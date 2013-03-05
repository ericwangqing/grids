require! ['grid', 'mask', 'data-loader', 'config', 'util']
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
  grid.main-mask = mask.create-mask {yoyo-type: 'Calling Mask'}
  grid.second-mask = mask.create-mask {yoyo-type: 'Info Mask'}
  add-show-main-mask-listener grid
  add-show-second-mask-listener grid
  grid.add grid.main-mask
  grid.add grid.second-mask

add-show-main-mask-listener = !(grid) ->
  add-listener-to-cell-event grid, 'singletap', !(e, cell) ->
    animate-cell-then-show-mask cell, config.animations.show-mask-animation, grid.main-mask

add-show-second-mask-listener = !(grid) ->
  add-listener-to-cell-event grid, 'doubletap', !(e, cell) ->
    animate-cell-then-show-mask cell, config.animations.show-mask-animation, grid.second-mask
     
add-listener-to-cell-event = !(listened-element, event, handler) ->
  listened-element.add-event-listener event, !(e) ->
    cell = e.source.parent # avatar在cell里面
    # console.log "cell got event: #{e.type}, cell is: #{e.source.parent}"
    handler e, cell if is-yoyo-contact-cell cell 
      
add-same-listener-to-multiple-cell-events = !(element, events, listener) ->
  for event in events
    add-listener-to-cell-event element, event, listener

animate-cell-then-show-mask = !(tapped-cell, animation, mask) ->
  cell = tapped-cell.wrapper 
  util.bring-to-front cell # z-index不知为何在这里不起作用。
  util.bring-to-front mask
  cell.animate animation, !-> 
    switch mask.yoyo-type 
    case 'Calling Mask'
      mask.show cell, cell.rect.x, cell.rect.y 
    case 'Info Mask'
      mask.background-color = 'black'
      mask.show cell # 动画cell
    default
      mask.show!

is-yoyo-contact-cell = (ui-element) ->
  ui-element.yoyo-type is 'contact-avatar-cell'

module.exports <<< {create-yoyo-window}