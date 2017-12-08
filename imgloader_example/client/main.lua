local ZoneImages = {}

AddEventHandler('imgloader:ready', function()

  Citizen.CreateThread(function()

    RequestStreamedTextureDict('custom_imgs', true)

    while not HasStreamedTextureDictLoaded('custom_imgs') do
      Citizen.Wait(0)
    end

    for k,v in pairs(Config.Zones) do

      ZoneImages[k] = CreateImage({
        txd    = v.txd,
        name   = v.name,
        x      = v.x,
        y      = v.y,
        z      = v.z,
        scaleX = v.width,
        scaleY = v.height,
        rotX   = -90.0,
        rotY   = 0.0,
      })

    end

    while true do

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)
      local camRot    = GetGameplayCamRot()

      for k,v in pairs(Config.Zones) do

        if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance then

          ZoneImages[k].set({
            rotZ  = camRot.z,
            alpha = 100.0
          })

          ZoneImages[k].show()

          if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) <= v.size / 2 then
            ZoneImages[k].set('alpha', 50.0)
          end

        else
          ZoneImages[k].hide()
        end

      end

      Citizen.Wait(0)

    end

  end)

end)

AddEventHandler('imgloader_example:hasEnteredMarker', function(zone)
  print('Entered ' .. zone)
end)

AddEventHandler('imgloader_example:hasExitedMarker', function(zone)
  print('Exited ' .. zone)
end)

-- Trigger event when inside zone
Citizen.CreateThread(function()
  
  local HasAlreadyEnteredMarker = false
  local LastZone                = nil

  while true do

    Wait(0)

    local playerPed   = GetPlayerPed(-1)
    local coords      = GetEntityCoords(playerPed)
    local isInMarker  = false
    local currentZone = nil

    for k,v in pairs(Config.Zones) do
      if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < v.size / 2) then
        isInMarker  = true
        currentZone = k
      end
    end

    if isInMarker and not hasAlreadyEnteredMarker then
      hasAlreadyEnteredMarker = true
      lastZone                = currentZone
      TriggerEvent('imgloader_example:hasEnteredMarker', currentZone)
    end

    if not isInMarker and hasAlreadyEnteredMarker then
      hasAlreadyEnteredMarker = false
      TriggerEvent('imgloader_example:hasExitedMarker', lastZone)
    end

  end
end)
