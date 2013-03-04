load-contacts = ->
  contacts = [{avatar: (get-avatar-url i), name: i} for i in [1 to 60]]

function get-avatar-url index
  '/images/' + (Math.ceil 12 * Math.random!) + '.png' 
  # '/images/default_avatar_0.png' # DEBUG

module.exports <<< {load-contacts}