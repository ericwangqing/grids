require! ['config']

data-loader = (->
  contacts = load-contacts!
  cursor = 0
  {
    has-more-data: ->
      cursor < contacts.length

    load-data: ->
      end = Math.min contacts.length, cursor + config.data-loader.amount-of-a-load
      # end = 2 * config.data-loader.amount-of-a-load if cursor is 0 # 第一次load多些，铺满屏幕
      result = contacts[cursor to end - 1]
      cursor := end
      result
  })()


function load-contacts
  contacts-amount = if config.DEBUG then 6 else 600
  contacts = [{avatar: (get-avatar-url i), name: i} for i in [1 to contacts-amount]]

function get-avatar-url index
  if config.DEBUG
    '/images/default_avatar_0.png' 
  else
    '/images/' + (Math.ceil 12 * Math.random!) + '.png' 

module.exports = data-loader