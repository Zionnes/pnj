--------Désactive le spawn des PNJ flics

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(375)
        local myCoords = GetEntityCoords(GetPlayerPed(-1))
        ClearAreaOfCops(myCoords.x, myCoords.y, myCoords.z, 100.0, 0)
    end
end)

Citizen.CreateThread(function()
	for i = 1, 12 do
		Citizen.InvokeNative(0xDC0F817884CDD856, i, false)
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300)
       
        if GetPlayerWantedLevel(PlayerId()) ~= 0 then
            SetPlayerWantedLevel(PlayerId(), 0, false)
            SetPlayerWantedLevelNow(PlayerId(), false)
        end
    end
end)

---------- Plus aucune armes droppées par les PNJ

local pedindex = {}

function SetWeaponDrops() 
    local handle, ped = FindFirstPed()
    local finished = false 
    repeat 
        if not IsEntityDead(ped) then
                pedindex[ped] = {}
        end
        finished, ped = FindNextPed(handle) 
    until not finished
    EndFindPed(handle)

    for peds,_ in pairs(pedindex) do
        if peds ~= nil then -- ne pas laisse pas tomber les armes à la mort pour les peds.
            SetPedDropsWeaponsWhenDead(peds, false) 
        end
    end
end

Citizen.CreateThread(function()
    while true do
       -- Citizen.Wait(0)
        Citizen.Wait(500)
        SetWeaponDrops()
    end
end)

----------- Enlève les armes dropées par les véhicules

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(375)
        DisablePlayerVehicleRewards(PlayerId())
    end
end)

------------- Réduire les véhicules de PNJ, [entre 0 et 1]

DensityMultiplier = 0.3
Citizen.CreateThread(function()
	while true do
	    Citizen.Wait(1)
	    SetVehicleDensityMultiplierThisFrame(DensityMultiplier)
	    SetPedDensityMultiplierThisFrame(DensityMultiplier)
	    SetRandomVehicleDensityMultiplierThisFrame(DensityMultiplier)
	    SetParkedVehicleDensityMultiplierThisFrame(DensityMultiplier)
	    SetScenarioPedDensityMultiplierThisFrame(DensityMultiplier, DensityMultiplier)
	end
end)

----- Fixe dégats

Citizen.CreateThread(function()
    while true do
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.3) -- Dégat cout de poing
    N_0x4757f00bc6323cfe(-1553120962, 1.5) -- Dégat véhicule
	Wait(100)
    end
end)

-------Désactive le cout de crosse

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
	local ped = PlayerPedId()
        if IsPedArmed(ped, 6) then
	       DisableControlAction(1, 140, true)
       	   DisableControlAction(1, 141, true)
           DisableControlAction(1, 142, true)
        end
    end
end)

---------Stamina infinie

Citizen.CreateThread( function()
    while true do
      Citizen.Wait(200)
      RestorePlayerStamina(PlayerId(), 1.0)
    end
  end)


---------------Désactive le contrôle du véhicule dans les airs 
 
 local vehicleClassDisableControl = {
    [0] = true,     --compacts
    [1] = true,     --sedans
    [2] = true,     --SUV's
    [3] = true,     --coupes
    [4] = true,     --muscle
    [5] = true,     --sport classic
    [6] = true,     --sport
    [7] = true,     --super
    [8] = false,    --motorcycle
    [9] = true,     --offroad
    [10] = true,    --industrial
    [11] = true,    --utility
    [12] = true,    --vans
    [13] = false,   --bicycles
    [14] = false,   --boats
    [15] = false,   --helicopter
    [16] = false,   --plane
    [17] = true,    --service
    [18] = true,    --emergency
    [19] = false    --military
}

-- Main thread
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(1)

        local player = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(player, false)
        local vehicleClass = GetVehicleClass(vehicle)

        -- Désactivez les touches si le joueur est dans le siège du conducteur et que la classe du véhicule correspond au tableau
        if ((GetPedInVehicleSeat(vehicle, -1) == player) and vehicleClassDisableControl[vehicleClass]) then
 
            if IsEntityInAir(vehicle) then
                DisableControlAction(2, 59)
                DisableControlAction(2, 60)
            end
        end
    end
end)


---------------- /ME

local color = {r = 150, g = 125, b = 246, alpha = 255} -- Color of the text rgb(107, 52, 254)
local font = 8 -- Font of the text
local time = 8000 -- Duration of the display of the text : 1000ms = 1sec
local nbrDisplaying = 1

RegisterCommand('me', function(source, args)
    local text = "* L'individu" 
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' *'
    TriggerServerEvent('3dme:shareDisplay', text)
end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    local offset = 1 + (nbrDisplaying*0.12)
    Display(GetPlayerFromServerId(source), text, offset)
end)

Citizen.CreateThread(function()
	while true do 
		print('^4Merci Skafir#9090^^')
        Wait(60*1000*10)
	end
end)

function Display(mePlayer, text, offset)
    local displaying = true
    Citizen.CreateThread(function()
        Wait(time)
        displaying = false
    end)
    Citizen.CreateThread(function()
        nbrDisplaying = nbrDisplaying + 1
        print(nbrDisplaying)
        while displaying do
            Wait(0)
            local coordsMe = GetEntityCoords(GetPlayerPed(mePlayer), false)
            local coords = GetEntityCoords(PlayerPedId(), false)
            local dist = GetDistanceBetweenCoords(coordsMe['x'], coordsMe['y'], coordsMe['z'], coords['x'], coords['y'], coords['z'], true)
            if dist < 50 then
                DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']+offset, text)
            end
        end
        nbrDisplaying = nbrDisplaying - 1
    end)
end

function DrawText3D(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 0.45*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

--- Touche changement de place véhicules 1.2.3.4

Citizen.CreateThread(function()
    while true do
        local plyPed = PlayerPedId()
        if IsPedSittingInAnyVehicle(plyPed) then
            local plyVehicle = GetVehiclePedIsIn(plyPed, false)
            CarSpeed = GetEntitySpeed(plyVehicle) * 3.6 
            if CarSpeed <= 75.0 then -- Change pas de place quand le véhicules est a 75km
                if IsControlJustReleased(0, 157) then -- conducteur : 1
                    SetPedIntoVehicle(plyPed, plyVehicle, -1)
                    Citizen.Wait(10)
                end
                if IsControlJustReleased(0, 158) then -- avant droit : 2
                    SetPedIntoVehicle(plyPed, plyVehicle, 0)
                    Citizen.Wait(10)
                end
                if IsControlJustReleased(0, 160) then -- arriere gauche : 3
                    SetPedIntoVehicle(plyPed, plyVehicle, 1)
                    Citizen.Wait(10)
                end
                if IsControlJustReleased(0, 164) then -- arriere droit : 4
                    SetPedIntoVehicle(plyPed, plyVehicle, 2)
                    Citizen.Wait(10)
                end
            end
        end
        Citizen.Wait(10) 
    end
end)