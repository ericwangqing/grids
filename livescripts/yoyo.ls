require! ['grid', 'mask', 'data-loader', 'config', 'util']
create-yoyo-window = ->
  # contacts = data-loader.load-contacts!
  win = create-main-window!
  win.add create-yoyo-grid-and-masks!
  win

create-main-window = ->
  win = Ti.UI.create-window config.main-window 

create-yoyo-grid-and-masks = ->
  yoyo-grid-container = grid.create-grid-container data-loader
  add-masks yoyo-grid-container
  yoyo-grid-container

add-masks = !(grid-container) ->
  grid = grid-container.grid
  grid.main-mask = mask.create-mask {yoyo-type: 'Calling Mask'}
  grid.second-mask = mask.create-mask {yoyo-type: 'Info Mask'}
  add-show-main-mask-listener grid
  add-show-second-mask-listener grid
  grid.main-mask.grid = grid.second-mask.grid = grid
  grid-container.add grid.main-mask
  grid-container.add grid.second-mask

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
  mask.grid.parent.scrolling-enabled = false
  wrapper = tapped-cell.wrapper 
  switch mask.yoyo-type 
  case 'Calling Mask'
    <-! mask.show wrapper, wrapper.rect.x, wrapper.rect.y 
    wrapper.animate animation
    # console.log "the cell tapped is: #{wrapper.cell.data.name}"
  case 'Info Mask'
    mask.background-color = 'black'
    mask.show wrapper # 动画cell
  default
    mask.show!

is-yoyo-contact-cell = (ui-element) ->
  ui-element.yoyo-type is 'contact-avatar-cell'

module.exports <<< {create-yoyo-window}