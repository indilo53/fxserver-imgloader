local ImageId        = -1
local ShowedImages   = {}
local Scaleforms     = {}
local UsedScaleforms = {}

function CreateImage(params)

  local params = params or {}
  local self   = {}

  ImageId = ImageId + 1
  
  self.id            = ImageId
  self.txd           = ''
  self.name          = ''
  self.lastSource    = ''
  self.x             = 0.0
  self.y             = 0.0
  self.z             = 0.0
  self.rotX          = 0.0
  self.rotY          = 0.0
  self.rotZ          = 0.0
  self.scaleX        = 1.0
  self.scaleY        = 0.5
  self.scaleZ        = 0.0
  self.alpha         = 100.0
  self.visible       = false
  self.waitForUpdate = false

  for k,v in pairs(params) do
    self[k] = v
  end

  self.getFreeScaleform = function()

    for i=1, #Scaleforms, 1 do

      local used = false

      for j=1, #UsedScaleforms, 1 do
        if UsedScaleforms[j] == i then
          used = true
          break
        end
      end

      if not used then
        table.insert(UsedScaleforms, i)
        return Scaleforms[i], i
      end

    end

  end

  self.freeScaleform = function(id)
    for i=1, #UsedScaleforms, 1 do
      if UsedScaleforms[i] ==id then
        table.remove(UsedScaleforms, i)
        break
      end
    end
  end

  self.show = function()
   
    self.visible = true

    if self.scaleform == nil then
      
      local scaleform, scaleformId = self.getFreeScaleform()

      self.scaleform   = scaleform
      self.scaleformId = scaleformId

      table.insert(ShowedImages, self)
   
    end

  end

  self.hide = function()
   
    self.visible = false

    if self.scaleform ~= nil then
      
      self.freeScaleform(self.scaleformId)

      for i=1, #ShowedImages, 1 do
        if ShowedImages[i] == self then
          table.remove(ShowedImages, i)
          break
        end
      end

      self.scaleform   = nil
      self.scaleformId = nil

    end

  end

  self.setSource = function(txd, name)
    self.txd  = txd
    self.name = name
  end

  self.get = function(key)
    return self[key]
  end

  self.set = function(key, val)

    if type(key) == 'table' then
      for k,v in pairs(key) do
        self[k] = v
      end
    else
      self[key] = val
    end

  end

  self.unload = function()
    
    self.hide()

    for k, v in pairs(self) do
      self[k] = nil
    end

  end

  self.play = function(txd, prefix, length, delay, timeBeforeReplay)

    if self.animating then
      return
    end

    self.animating         = true
    local delay            = delay            or 20
    local timeBeforeReplay = timeBeforeReplay or 0

    Citizen.CreateThread(function()

      while true do

        for i=0, length, 1 do

          self.setSource(txd, prefix .. i)

          Citizen.Wait(delay)

          if not self.animating then
            return
          end

        end

        Citizen.Wait(timeBeforeReplay)

      end

    end)

  end

  self.pause = function()
    self.animating = false
  end

  self.update = function()
    self.waitForUpdate = true
  end

  return self

end

AddEventHandler('imgloader:createImage', function(params, cb)
  cb(CreateImage(params))
end)

Citizen.CreateThread(function()

  for i=1, Config.MaxImages, 1 do
   
    Scaleforms[i] = RequestScaleformMovie('imgloader_' .. i)

    while not HasScaleformMovieLoaded(Scaleforms[i]) do
      Citizen.Wait(0)
    end

  end

  print('IMGLOADER => READY')

  TriggerEvent('imgloader:ready')

  while true do

    for i=1, #ShowedImages, 1 do

      if ShowedImages[i].waitForUpdate or(ShowedImages[i].lastSource ~= ShowedImages[i].txd .. '/' .. ShowedImages[i].name) then

        ShowedImages[i].waitForUpdate = false

        PushScaleformMovieFunction(ShowedImages[i].scaleform, 'LOAD_IMAGE')
        PushScaleformMovieFunctionParameterString(ShowedImages[i].txd)
        PushScaleformMovieFunctionParameterString(ShowedImages[i].name)
        PopScaleformMovieFunctionVoid()

      end

      PushScaleformMovieFunction(ShowedImages[i].scaleform, 'SET_ALPHA')
      PushScaleformMovieFunctionParameterFloat(ShowedImages[i].alpha)
      PopScaleformMovieFunctionVoid()

      DrawScaleformMovie_3dNonAdditive(
        ShowedImages[i].scaleform,  -- scaleform
        ShowedImages[i].x,          -- posX
        ShowedImages[i].y,          -- posY
        ShowedImages[i].z,          -- posZ
        ShowedImages[i].rotX,       -- rotX
        ShowedImages[i].rotY,       -- rotY
        ShowedImages[i].rotZ,       -- rotZ
        2.0,                        -- p7
        1.0,                        -- sharpness
        1.0,                        -- p9
        ShowedImages[i].scaleX,     -- scaleX
        ShowedImages[i].scaleY,     -- scaleY
        ShowedImages[i].scaleZ,     -- scaleZ
        0                           -- p13
      )

    end

    Citizen.Wait(0)

  end

end)
