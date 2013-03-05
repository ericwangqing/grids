require! ['config']

load-contacts = ->
  contacts-amount = if config.DEBUG then 6 else 60
  contacts = [{avatar: (get-avatar-url i), name: i} for i in [1 to contacts-amount]]

function get-avatar-url index
  if config.DEBUG
    '/images/default_avatar_0.png' 
  else
    '/images/' + (Math.ceil 12 * Math.random!) + '.png' 

module.exports <<< {load-contacts}