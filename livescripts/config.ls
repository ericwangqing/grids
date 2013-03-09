require! 'util'

p$ = util.dip-to-pixel

config =
  yoyo:
    contacts-amount: 200
  # DEBUG:
  #   contacts-amount: 6
  data-loader:
    amount-of-a-load: 15
    # minimal-rows-when-scolling: 24
    interval-to-load: 2000 # 用户2s无操作就load data
    auto-load-up-limit: 100 # 最多自动load 100个
    periodical-load: true
    scroll-to-load-ratio: 0.2 # 触发data-loader的几率，以免触发过多loader，降低responsiveness。
  main-window:
    yoyo-type: "main-window"
    background-color: 'black'
    # nav-bar-hidden: true
    title: 'YoYo通讯录'
  grid:
    yoyo-type: 'contacts-grid'
    cells-in-a-row: 3
    scroll-type: 'vertical'
    content-height: 'auto'
    content-width: 'auto'
  cell:
    yoyo-type: 'contact-avatar-cell'
    size: p$ 118
    radius: p$ 5
    scale-when-touch: 1.5
    animation-duration: 30
    x-spacer: p$ 7.5
    y-spacer: p$ 7.5 
  mask:
    background-color: 'black'
    opacity: 0.9 
    top: 0
    left: 0
  mask-label:
    font: {font-size: 60}
    text-align: Ti.UI.TEXT_ALIGNMENT_CENTER
    width: 'auto'
    height: 'auto'
    top: 300
  calling-mask:
    move-threshold: 10
    button-cell-size-ratio: 0.5
  info-bar:
    # background-image: '/images/contact_name_background.png'
    background-gradient:
      type: 'linear'
      colors:['transparent', 'black']
      start-point: {x: '50%', y: '0%'}
      end-point: {x: '50%', y: '100%'}
    width: p$ 118
    height: p$ 18
    left: 0
    bottom: 0
  info-bar-username-label:
    color: 'white'
    font: {font-size: p$ 15}
    bottom: 0
    left: p$ 5
  info-bar-signs:
    width: p$ 54 
    height: p$ 18
    bottom: 0
    right: p$ 5
  info-bar-icon:
    width: p$ 18
    height: p$ 18

  animations: {}
    
config.animations.show-mask-animation = util.create-push-animation config.cell.animation-duration, config.cell.scale-when-touch
config.animations.hide-mask-animation = util.create-push-animation config.cell.animation-duration, 1 # 恢复

module.exports <<< config