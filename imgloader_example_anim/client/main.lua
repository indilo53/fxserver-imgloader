AddEventHandler('imgloader:ready', function()

  Citizen.CreateThread(function()

    RequestStreamedTextureDict('custom_imgs_2', true)

    while not HasStreamedTextureDictLoaded('custom_imgs_2') do
      Citizen.Wait(0)
    end

    for k,v in pairs(Config.Animations) do
      LoadImage('imgloader_example2:' .. k, v.txd, v.name .. '0')
    end

  end)

end)


for k,v in pairs(Config.Animations) do

  local scope = function(k, v)

    Citizen.CreateThread(function()

      while true do

        for i=v.first, v.last, 1 do

          local camRot  = GetGameplayCamRot()

          SetImage('imgloader_example2:' .. k, {
            txd    = v.txd,
            name   = v.name .. i,
            x      = v.x,
            y      = v.y,
            z      = v.z,
            rotX   = -90.0,
            rotY   = 0.0,
            rotZ   = camRot.z,
            scaleX = v.width,
            scaleY = v.height,
            scaleZ = 0.0,
            alpha  = 100.0,
          })

          Citizen.Wait(20)

        end

      end

    end)

  end

  scope(k, v)

end