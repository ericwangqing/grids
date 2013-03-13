generate-default-avatar-selector = ->
  # 暂时用简单的线性平均方法确定用户之默认头像
  max-out-duration = max-in-duration = 0
  selector = 
    counting-duration: !(contact) ->
      max-in-duration := contact.amount-of-income-duration if contact.amount-of-income-duration > max-in-duration
      max-out-duration := contact.amount-of-outcome-duration if contact.amount-of-outcome-duration > max-out-duration
    get-avatar-name: (contact) ->
      ear = Math.ceil contact.amount-of-income-duration / max-in-duration / 0.2
      mouth = Math.ceil contact.amount-of-outcome-duration / max-out-duration / 0.2
      avatar-name = '/images/default-' + (mouth * 5 + ear) + '.jpg'
    get-max-out-duration: ->
      max-out-duration
    get-max-in-duration: ->
      max-in-duration

module.exports <<< {generate-default-avatar-selector}

