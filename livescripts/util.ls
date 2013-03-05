dToP = (density-pixels) ->
  density-pixels * Ti.Platform.display-caps.dpi / 160 

create-push-animation = (duration, scale) ->
  matrix2d = Ti.UI.create2DMatrix!
  matrix2d = matrix2d.scale scale, scale
  Ti.UI.create-animation {
      transform: matrix2d
      duration: duration
      autoreverse : false
      }

bring-to-front = !(element) -> # fix titanium的z-index不起作用的问题
  container = element.parent
  container.remove element
  container.add element

module.exports = {dToP, create-push-animation, bring-to-front}