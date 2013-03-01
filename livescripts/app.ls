require! ['grid', 'util']

grids-data = [{avatar: (get-avatar-url i), name: i} for i in [1 to 24]]

win = Ti.UI.create-window(
  background-color: 'black'
  nav-bar-hidden: false
  title: 'YoYo通讯录'
) 

win.add grid.create-scroll-grid-view {data: grids-data}

win.open!

function get-avatar-url index
  '/images/' + ((index - 1) % 12 + 1) + '.png' 
  # '/images/0.png' # DEBUG

