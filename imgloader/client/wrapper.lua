function LoadImage(name, txd, imagename)
  TriggerEvent('imgloader:loadImage', name, txd, imagename)
end

function SetImage(name, key, val)
  TriggerEvent('imgloader:setImage', name, key, val)
end

function UnloadImage(name)
  TriggerEvent('imgloader:unloadImage', name)
end
