require! ['config', 'util', 'avatar']

get-loader = ->
  contacts = load-contacts!
  cursor = 0
  {
    has-more-data: ->
      cursor < contacts.length

    load-data: ->
      end = Math.min contacts.length, cursor + config.data-loader.amount-of-a-load
      console.log "load-data from #{cursor} to #{end}"
      end = config.data-loader.initial-load-ratio * config.data-loader.amount-of-a-load if cursor is 0 # 第一次load多些，铺满屏幕
      result = contacts[cursor to end - 1]
      cursor := end
      result 
  }
 

load-contacts = ->
  file = Ti.Filesystem.get-file Ti.Filesystem.applicationDataDirectory, 'contacts.json'
  if file.exists!
    contacts = JSON.parse file.read!.text
  else
    contacts-loader = require 'yoyo.android.contacts.loader'
    contacts = contacts-loader.get-all-contacts!
    avatar-selector = avatar.generate-default-avatar-selector!
    [avatar-selector.counting-duration contact for contact in contacts]
    file.write JSON.stringify prepare-contacts-with-saved-avatars contacts, avatar-selector
  contacts

prepare-contacts-with-saved-avatars = (contacts, avatar-selector) ->
  copy-contacts = []
  for contact in contacts
    copy-contact = {} <<< contact
    if copy-contact.avatar
      avatar-name = 'sys-' + contact.name
      file = Ti.Filesystem.get-file Ti.Filesystem.application-data-directory, avatar-name
      file.write copy-contact.avatar
      copy-contact.avatar = avatar-name
    else
      copy-contact.avatar = contact.avatar = avatar-selector.get-avatar-name contact
      Ti.API.info 'yoyo', "contact: #{contact.name}, avatar: #{contact.avatar}"
    copy-contacts.push copy-contact
  copy-contacts


random-generate-contact = (index) ->
  avatar: get-avatar-url!
  name: ['张三', '李四', '令狐冲', 'Alexander Li', '东方不败'][(random 5 - 1)] + index
  phone-number: config.DEBUG.fake-phone-number
  missed-calls: (random 10) < 6
  new-messages: (random 10) < 9
  new-sn-updates: (random 100) < 5 

get-avatar-url = ->
  if config.DEBUG
    '/images/default_avatar_0.png' 
  else
    # '/images/1x1-pixel.png' 
    '/images/' + (util.random 12) + '.jpg' 
    # '/images/' + 1 + '.jpg' 


module.exports <<< {get-loader}