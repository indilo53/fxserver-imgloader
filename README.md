# fxserver-imgloader
FXServer Image Loader

Experimental image loader for FiveM using multiple copies of a specially crafted scaleform (imgloader.gfx).

Usage:

```
start imgloader
```

Then import wrapper in your script :

```lua
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

client_scripts {
	'@imgloader/client/wrapper.lua',
	'etc...',
}

```

You can test the example, it is a sample zone manager using imgloader.

### API

```
local image = CreateImage({
  txd    = 'texture_dictionnary',
  name   = 'iamge_name',
  x      = 0.0,
  y      = 0.0,
  z      = 0.0,
  rotX   = 0.0,
  rotY   = 0.0,
  rotZ   = 0.0,
  scaleX = 1.0,
  scaleY = 0.5,
  scaleZ = 0.0,
  alpha  = 100.0,
})

image.set({
  txd    = 'texture_dictionnary',
  name   = 'iamge_name',
  x      = 0.0,
  y      = 0.0,
  z      = 0.0,
  rotX   = 0.0,
  rotY   = 0.0,
  rotZ   = 0.0,
  scaleX = 1.0,
  scaleY = 0.5,
  scaleZ = 0.0,
  alpha  = 100.0,
})

image.set('alpha', 100.0)

image.show()

image.hide()

image.play(txd, prefix, length, delay)

image.pause()

image.unload()
```

