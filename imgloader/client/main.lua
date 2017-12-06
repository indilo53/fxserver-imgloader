local MaxImages        = 20
local Scaleforms       = {}
local UsedScaleforms   = {}
local ImageSrcs        = {}
local DrawedImages     = {}

function LoadImage(name, txd, imagename)

  local scaleform = nil
  local id        = nil

  if DrawedImages[name] ~= nil then

    scaleform = DrawedImages[name].scaleform
    id        = DrawedImages[name].scaleformId
 
  else

    for i=1, #Scaleforms, 1 do

      local used = false

      for j=1, #UsedScaleforms, 1 do
        if UsedScaleforms[j] == i then
          used = true
          break
        end
      end

      if not used then
        scaleform = Scaleforms[i]
        id        = i
        table.insert(UsedScaleforms, i)
        break
      end

    end

  end

  if scaleform == nil then
    return false
  end

  if ImageSrcs[name] ~= txd .. '/' .. imagename then
    
    PushScaleformMovieFunction(scaleform, 'LOAD_IMAGE')
    PushScaleformMovieFunctionParameterString(txd)
    PushScaleformMovieFunctionParameterString(imagename)
    PopScaleformMovieFunctionVoid()

    ImageSrcs[name] = txd .. '/' .. imagename
  
  end

  DrawedImages[name] = {
    scaleformId = id,
    scaleform   = scaleform,
    x           = 0.0,
    y           = 0.0,
    z           = 0.0,
    rotX        = 0.0,
    rotY        = 0.0,
    rotZ        = 0.0,
    scaleX      = 1.0,
    scaleY      = 0.5,
    scaleZ      = 1.0,
    alpha       = 100.0,
  }

  return scaleform

end

function SetImage(name, key, val)

  if DrawedImages[name] ~= nil then

    if type(key) == 'table' then

      for k,v in pairs(key) do
        DrawedImages[name][k] = v
      end

    else
      DrawedImages[name][key] = val
    end

  end

end

function UnloadImage(name)

  if DrawedImages[name] ~= nil then

    for i=1, #UsedScaleforms, 1 do
      if UsedScaleforms[i] == DrawedImages[name].scaleformId then
        table.remove(UsedScaleforms, i)
        DrawedImages[name] = nil
        break
      end
    end

  end

end

AddEventHandler('imgloader:loadImage',   LoadImage)
AddEventHandler('imgloader:setImage',    SetImage)
AddEventHandler('imgloader:unloadImage', UnloadImage)

-- Load scaleforms
Citizen.CreateThread(function()

  for i=1, MaxImages, 1 do
   
    Scaleforms[i] = RequestScaleformMovie('imgloader_' .. i)

    while not HasScaleformMovieLoaded(Scaleforms[i]) do
      Citizen.Wait(0)
    end

  end

  print('IMGLOADER => READY')

  TriggerEvent('imgloader:ready')

  while true do

    for k,v in pairs(DrawedImages) do

      PushScaleformMovieFunction(v.scaleform, 'SET_ALPHA')
      PushScaleformMovieFunctionParameterFloat(v.alpha)
      PopScaleformMovieFunctionVoid()

      DrawScaleformMovie_3dNonAdditive(
        v.scaleform,  -- scaleform
        v.x,          -- posX
        v.y,          -- posY
        v.z,          -- posZ
        v.rotX,       -- rotX
        v.rotY,       -- rotY
        v.rotZ,       -- rotZ
        2.0,        -- p7
        1.0,        -- sharpness
        1.0,        -- p9
        v.scaleX,     -- scaleX
        v.scaleY,     -- scaleY
        v.scaleZ,     -- scaleZ
        0           -- p13
      )

    end

    Citizen.Wait(0)

  end

end)
