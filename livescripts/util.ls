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

get-cached-image-blob = (->
  cache = {}
  (image-name-or-blob) ->
    image-name-or-blob = '/images/' + (random 12) + '.jpg' if !image-name-or-blob
    if typeof image-name-or-blob is 'string'
      image-name =  image-name-or-blob
      cache[image-name] = (Ti.Filesystem.get-file Ti.Filesystem.resources-directory, image-name).read! if !cache[image-name]
      return cache[image-name]
    image-name-or-blob
  )()

random = (n) ->
  Math.ceil n * Math.random!

module.exports = {dip-to-pixel, create-push-animation, get-cached-image-blob, random} 