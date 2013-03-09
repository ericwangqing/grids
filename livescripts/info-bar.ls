require! ['config', 'util']

create-info-bar = (data) ->
  bar = create-bar!
  bar.add username-label = create-username-label data.name
  bar.add info-signs = create-info-signs data
  bar

create-bar = ->
  Ti.UI.create-view config.info-bar 

create-username-label = (name) ->
  Ti.UI.create-label {text: name} <<< config.info-bar-username-label

create-info-signs = (data) ->
    container = Ti.UI.create-view config.info-bar-signs 
    right = 0 # signs靠右排放，用来追踪右侧距离。
    offset = config.info-bar-icon.width
    if data.new-sn-updates
      # TODO: 这里目前只是考虑一种微博更新，多种更新需要再设计
      container.add new-sn-update-sign = create-sign 'hint_weibo', data.new-sn-updates, right 
      right += offset
    if data.new-messages
      container.add new-message-sign = create-sign 'hint_message', data.new-messages, right
      right += offset
    if data.missed-calls
      container.add missed-call-sign = create-sign 'hint_missed_call', data.missed-calls, right 
    container

create-sign = (sign-name, amount, right) ->
  # TODO: amount 目前尚未考虑
  Ti.UI.create-image-view {
    image: util.get-cached-image-blob get-sign-icon-path sign-name
    right: right
    } <<< config.info-bar-icon

get-sign-icon-path = (sign-name) ->
  '/images/' + sign-name + '.png' 

module.exports <<< {create-info-bar}
