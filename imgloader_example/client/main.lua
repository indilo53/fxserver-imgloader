AddEventHandler('imgloader:ready', function()

  Citizen.CreateThread(function()
    
    RequestStreamedTextureDict('custom_imgs', true)

    while not HasStreamedTextureDictLoaded('custom_imgs') do
      Citizen.Wait(0)
    end

    while true do

      local playerPed = GetPlayerPed(-1)
      local coords    = GetEntityCoords(playerPed)

      for k,v in pairs(Config.Zones) do

        if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance then

          LoadImage('zone_' .. k, v.txd, v.name)
          
          SetImage('zone_' .. k, {
            x      = v.x,
            y      = v.y,
            z      = v.z,
            rotX   = -90.0,
            rotY   = 0.0,
            rotZ   = 0.0,
            scaleX = v.width,
            scaleY = v.height,
            scaleZ = 0.0,
            alpha  = 100.0,
          })

          if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) <= v.size / 2 then
            SetImage('zone_' .. k, 'alpha', 50.0)
          end

        else
          UnloadImage('zone_' .. k)
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
