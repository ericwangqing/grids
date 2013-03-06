dip-to-pixel = (density-pixels) ->
  density-pixels * Ti.Platform.display-caps.dpi / 160 

create-push-animation = (duration, scale) ->
  matrix2d = Ti.UI.create2DMatrix!
  matrix2d = matrix2d.scale scale, scale
  Ti.UI.create-animation {
      transform: matrix2d
      duration: duration
      autoreverse : false
      }

module.exports = {dip-to-pixel, create-push-animation} 