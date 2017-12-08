local AnimatedImages = {}

AddEventHandler('imgloader:ready', function()

  Citizen.CreateThread(function()

    for k,v in pairs(Config.Animations) do
      
      RequestStreamedTextureDict(v.txd, true)

      while not HasStreamedTextureDictLoaded(v.txd) do
        Citizen.Wait(0)
      end

      AnimatedImages[k] = CreateImage({
        x      = v.x,
        y      = v.y,
        z      = v.z,
        rotX   = -90.0,
        rotY   = 0.0,
        scaleX = v.width,
        scaleY = v.height,
        scaleZ = 0.0,
        alpha  = 100.0,
      })

      AnimatedImages[k].play(v.txd, v.prefix, v.length)

      AnimatedImages[k].show()
    
    end

    while true do

      local camRot = GetGameplayCamRot()

      for k,v in pairs(Config.Animations) do
        AnimatedImages[k].set('rotZ', camRot.z)
      end

      Citizen.Wait(0)

    end

  end)

end)