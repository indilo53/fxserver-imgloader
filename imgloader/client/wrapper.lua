function CreateImage(params)
	
	local params = params or {}
	local image  = nil

	TriggerEvent('imgloader:createImage', params, function(_image)
		image = _image
	end)

	return image

end