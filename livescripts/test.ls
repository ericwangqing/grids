require! ['config']

create-window = ->
  win = Ti.UI.create-window config.main-window 
  a = create-view {name: 'a', left: 0, top: 0, z-index: 3, background-color: 'blue'}
  b = create-view {name: 'b', left: 200, top: 200, z-index: 2, background-color: 'green'}
  c = create-view {name: 'c', left: 400, top: 400, z-index: 1, background-color: 'red'}
  win.add a
  win.add b
  win.add c
  win



create-view = (params) ->
  view-config = {name:"wrapper"} <<< params <<< {height: 600, width: 600}
  view-config.background-color = 'yellow'
  view = Ti.UI.create-view view-config
  inner = Ti.UI.create-view params <<< {left: 0, top: 0, height: 600, width: 600, border-radius: 10} 
  view.add inner
  z-index = 4
  scaled = false
  view.add-event-listener 'singletap' (e)->
    animation = if scaled then config.animations.hide-mask-animation else config.animations.show-mask-animation
    wrapper = e.source.parent
    console.log "before: #{e.source.name}, z-index:#{wrapper.z-index}"
    wrapper.animate animation, ->
      # z = if scaled then z-index++ else z-index--
      wrapper.z-index = z-index++
      scaled := !scaled
      console.log "z-index: #{z-index}"
      console.log "after: #{e.source.name}, z-index:#{wrapper.z-index}"
  view

module.exports <<< {create-window}