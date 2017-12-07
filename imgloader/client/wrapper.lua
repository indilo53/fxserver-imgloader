function LoadImage(name, txd, imagename)

	local scaleform = nil

  TriggerEvent('imgloader:loadImage', name, txd, imagename, function(_scaleform)
  	scaleform = _scaleform
  end)

  return scaleform

end

function SetImage(name, key, val)
  TriggerEvent('imgloader:setImage', name, key, val)
end

function UnloadImage(name)
  TriggerEvent('imgloader:unloadImage', name)
end
