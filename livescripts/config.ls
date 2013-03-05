require! 'util'

config =
  # DEBUG: true
  main-window:
    yoyo-type: "main-window"
    background-color: 'black'
    nav-bar-hidden: false
    title: 'YoYo通讯录'
  cell:
    yoyo-type: 'contact-avatar-cell'
    size: util.dToP 118
    radius: util.dToP 5
    scale-when-touch: 1.5
    animation-duration: 60
    x-spacer: util.dToP 7.5
    y-spacer: util.dToP 7.5
    vell:
      background-color: 'black'
      opacity: 0.9
  grid:
    yoyo-type: 'contacts-grid'
    cells-in-a-row: 3
    scroll-type: 'vertical'
    content-height: 'auto'
    content-width: 'auto'

config.grid.animation = util.create-push-animation config.cell.animation-duration, config.cell.scale-when-touch

module.exports <<< config