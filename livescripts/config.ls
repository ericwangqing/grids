require! 'util'

config =
  # DEBUG: true
  data-loader:
    amount-of-a-load: 12
    # minimal-rows-when-scolling: 24
    interval-to-load: 10 # 用户无操作就load data
    max-waiting-scroll-loader = 1
  main-window:
    yoyo-type: "main-window"
    background-color: 'black'
    nav-bar-hidden: false
    title: 'YoYo通讯录'
  grid:
    yoyo-type: 'contacts-grid'
    cells-in-a-row: 3
    scroll-type: 'vertical'
    content-height: 'auto'
    content-width: 'auto'
  cell:
    yoyo-type: 'contact-avatar-cell'
    size: util.dToP 118
    radius: util.dToP 5
    scale-when-touch: 1.5
    animation-duration: 30
    x-spacer: util.dToP 7.5
    y-spacer: util.dToP 7.5 
  mask:
    background-color: 'black'
    opacity: 0.9 
    top: 0
    left: 0
    # width: Ti.UI.FILL
    # height: Ti.UI.FILL
  mask-label:
    background-color: 'white'
    font: {font-size: 60}
    text-align: Ti.UI.TEXT_ALIGNMENT_CENTER
    width: 'auto'
    height: 'auto'
    top: 300
  calling-mask:
    move-threshold: 10
    button-cell-size-ratio: 0.5

  animations: {}
    
config.animations.show-mask-animation = util.create-push-animation config.cell.animation-duration, config.cell.scale-when-touch
config.animations.hide-mask-animation = util.create-push-animation config.cell.animation-duration, 1 # 恢复

module.exports <<< config