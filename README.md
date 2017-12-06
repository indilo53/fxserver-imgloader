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

```
API

LoadImage(name, textureDictionnaryName, imageName)
UnloadImage(name)

SetImage(name, key, val)

or

SetImage(name, {
  key1 = val1,
  key2 = val2,
})
```

