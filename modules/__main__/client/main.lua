local self = ESX.Modules['__MAIN__']

-- Pause menu disables HUD display
if Config.EnableHud then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(300)

			if IsPauseMenuActive() and not ESX.IsPAused then
				ESX.IsPAused = true
				ESX.UI.HUD.SetDisplay(0.0)
			elseif not IsPauseMenuActive() and ESX.IsPAused then
				ESX.IsPAused = false
				ESX.UI.HUD.SetDisplay(1.0)
			end
		end
	end)
end

ESX.Loop('server-sync-ammo', function()

  local playerPed = PlayerPedId()

  if IsPedShooting(playerPed) then
    local _,weaponHash = GetCurrentPedWeapon(playerPed, true)
    local weapon = ESX.GetWeaponFromHash(weaponHash)

    if weapon then
      local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
      TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
    end
  end

end, 250, {
  function() return ESX.PlayerLoaded and (not ESX.IsDead) end
})

local previousCoords

ESX.Loop('server-sync-coords', function()

  local playerPed = PlayerPedId()

  if DoesEntityExist(playerPed) then

    local playerCoords = GetEntityCoords(playerPed)
    previousCoords     = previousCoords or playerCoords
    local distance     = #(playerCoords - previousCoords)

    if distance > 1 then
      previousCoords = playerCoords
      local playerHeading = ESX.Math.Round(GetEntityHeading(playerPed), 1)
      local formattedCoords = {x = ESX.Math.Round(playerCoords.x, 1), y = ESX.Math.Round(playerCoords.y, 1), z = ESX.Math.Round(playerCoords.z, 1), heading = playerHeading}
      TriggerServerEvent('esx:updateCoords', formattedCoords)
    end

  end

end, 1000, {
  function() return ESX.PlayerLoaded and (not ESX.IsDead) end
})

-- Disable wanted level
if Config.DisableWantedLevel then

  ESX.Loop('disable-wanted-level', function()

    local playerId = PlayerId()

    if GetPlayerWantedLevel(playerId) ~= 0 then
      SetPlayerWantedLevel(playerId, 0, false)
      SetPlayerWantedLevelNow(playerId, false)
    end

  end, 0)

end

-- Pickups
local pickupsInRange      = {}
local closestUsablePickup = nil

ESX.Loop('get-pickups-in-range', function()

  local playerPed    = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)

  pickupsInRange      = {}
  closestUsablePickup = nil

  for pickupId, pickup in pairs(pickups) do

    local distance = #(playerCoords - pickup.coords)

    if distance < 5.0 then

      pickupsInRange[#pickupsInRange + 1] = pickup

      if distance < 1.0 then
        closestUsablePickup = pickup
      end

    end

  end

end, 500)

ESX.Loop('draw-pickups', function()

  local playerPed    = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)

  for i=1, #pickupsInRange, 1 do

    local pickup = pickupsInRange[i]

    ESX.ShowFloatingHelpNotification(pickup.label, {
      x = pickup.coords.x,
      y = pickup.coords.y,
      z = pickup.coords.z + 0.25
    }, 100)

  end

end, 0)

ESX.Loop('pickup-actions', function()

  local playerPed = PlayerPedId()
  local pickup    = closestUsablePickup

  if IsControlJustReleased(0, 38) then
    if IsPedOnFoot(playerPed) then

      Citizen.CreateThread(function()

        local dict, anim = 'weapons@first_person@aim_rng@generic@projectile@sticky_bomb@', 'plant_floor'
        ESX.Streaming.RequestAnimDict(dict)
        TaskPlayAnim(playerPed, dict, anim, 8.0, 1.0, 1000, 16, 0.0, false, false, false)
        Citizen.Wait(1000)
        TriggerServerEvent('esx:onPickup', pickup.id)
        PlaySoundFrontend(-1, 'PICK_UP', 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)

      end)

    end
  end

end, 0, {
  function() return closestUsablePickup ~= nil end
})
