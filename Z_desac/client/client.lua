ESX = nil 
local player = GetPlayerPed(-1)
local coords = GetEntityCoords(player)
---------------------------------
-------- Message F8  ------------
---------------------------------
print ("^5Crée par : ZiOnnes YT#7829") 
print ("^3Discord  : https://discord.gg/jSMKhqgYqQ") 
---------------------------------
-- Obtient la bibliothèque ESX --
---------------------------------

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
        TriggerEvent("esx:getSharedObject", function(obj)
        ESX = obj
        end)
    end
end)


---------------------------------
---- Désactiver les roulades ----
---------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)
        if IsControlPressed(0, 25)
            then DisableControlAction(0, 22, true)
        end
    end
end) 


---------------------------------
------ désactiver driveby -------
---------------------------------
local passengerDriveBy = false

Citizen.CreateThread(function()
    while true do
        Wait(1)

        playerPed = GetPlayerPed(-1)
        car = GetVehiclePedIsIn(playerPed, false)
        if car then
            if GetPedInVehicleSeat(car, -1) == playerPed then
                SetPlayerCanDoDriveBy(PlayerId(), false)
            elseif passengerDriveBy then
                SetPlayerCanDoDriveBy(PlayerId(), true)
            else
                SetPlayerCanDoDriveBy(PlayerId(), false)
            end
        end
    end
end) 


---------------------------------
------- Retirer crosshair ------- ( point blanc )
---------------------------------
Citizen.CreateThread(function()
    local isSniper = false
    while true do
        Citizen.Wait(0)
        local ped = GetPlayerPed(-1)
        local currentWeaponHash = GetSelectedPedWeapon(ped)
        if currentWeaponHash == 100416529 then
            isSniper = true
        elseif currentWeaponHash == 205991906 then
            isSniper = true
        elseif currentWeaponHash == -952879014 then
            isSniper = true
        elseif currentWeaponHash == GetHashKey('WEAPON_HEAVYSNIPER_MK2') then
            isSniper = true
        else
            isSniper = false
        end
        if not isSniper then
            HideHudComponentThisFrame(14)
        end
    end
end) 


---------------------------------
--------- mettre train ---------- 
---------------------------------
Citizen.CreateThread(function()
    SwitchTrainTrack(0, true)
    SwitchTrainTrack(3, true)
    N_0x21973bbf8d17edfa(0, 120000)
    SetRandomTrains(true)
end) 


---------------------------------
--- DESACTIVERCOUPS DE CROSS ---- 
---------------------------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
           DisableControlAction(1, 140, true)
              DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end
    end
end)


---------------------------------
------- No drop arme pnj -------- 
---------------------------------
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    -- List of pickup hashes (https://pastebin.com/8EuSv2r1)
    RemoveAllPickupsOfType(0xDF711959) -- carbine rifle
    RemoveAllPickupsOfType(0xF9AFB48F) -- pistol
    RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
  end
end)

-- Si vous voulez désactivez quelque chose vous avez juste a supprimé des tirets jusqu'aux dernier end)

--------------------------------------------------
---- Ce script à été crée par ZiOnnes YT#7829 ----
--------------------------------------------------