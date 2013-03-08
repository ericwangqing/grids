require! ['config']

data-loader = (->
  contacts = load-contacts!
  cursor = 0
  {
    has-more-data: ->
      cursor < contacts.length

    load-data: ->
      end = Math.min contacts.length, cursor + config.data-loader.amount-of-a-load
      console.log "load-data from #{cursor} to #{end}"
      end = 1.5 * config.data-loader.amount-of-a-load if cursor is 0 # 第一次load多些，铺满屏幕
      result = contacts[cursor to end - 1]
      cursor := end
      result 
  })()


function load-contacts
  contacts-amount = if config.DEBUG then config.DEBUG.contacts-amount else config.yoyo.contacts-amount
  contacts = [random-generate-contact i for i in [1 to contacts-amount]]

function random-generate-contact index
  avatar: get-avatar-url!
  name: ['张三', '李四', '令狐冲', 'Alexander Li', '东方不败'][(random 5 - 1)] + index
  missed-calls: (random 10) < 6
  new-messages: (random 10) < 9
  new-sn-updates: (random 100) < 5 

function get-avatar-url
  if config.DEBUG
    '/images/default_avatar_0.png' 
  else
    # '/images/1x1-pixel.png' 
    '/images/' + (random 12) + '.jpg' 
    # '/images/' + 1 + '.jpg' 

function random n
  Math.ceil n * Math.random!

module.exports = data-loader