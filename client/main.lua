local playerVehicle 			= false
local isTackling				= false
local PlayerData 				= {}
local isGettingTackled			= false
local tackleLib			<const> = 'missmic2ig_11'
local tackleAnim		<const>	= 'mic_2_ig_11_intro_goon'
local tackleVictimAnim	<const> = 'mic_2_ig_11_intro_p_one'
local lastTackleTime			= 0

RegisterNetEvent('lsrp_tackle:getTackled', function(target)
	isGettingTackled = true

	local playerPed = cache.ped
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))

	RequestAnimDict(tackleLib)

	while not HasAnimDictLoaded(tackleLib) do
		Wait(10)
	end

	AttachEntityToEntity(playerPed, targetPed, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
	TaskPlayAnim(playerPed, tackleLib, tackleVictimAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)

	Wait(3000)
	DetachEntity(playerPed, true, false)

	SetPedToRagdoll(playerPed, 1000, 1000, 0, 0, 0, 0)
	Wait(4000)
	isGettingTackled = false
end)

local function playTackle()
	lib.requestAnimDict(tackleLib)
	TaskPlayAnim(cache.ped, tackleLib, tackleAnim, 8.0, -8.0, 3000, 0, 0, false, false, false)
	Wait(6000)
	isTackling = false
end

local function mainThread()
	local sleep = 0
	while true do
		sleep = playerVehicle and 200 or 0
		if playerVehicle then
			goto continue
		end


		if IsControlPressed(0, 21) and IsControlPressed(0, 47) then

			if (GetGameTimer() - lastTackleTime) <= Config.TackleDelay then
				sleep = 500
				goto continue
			end

			if isTackling or isGettingTackled then
				sleep = 200
				goto continue 
			end

			Wait(0)
			local closestPlayer, closestPlayerPed, distance = lib.getClosestPlayer(GetEntityCoords(cache.ped), Config.TackleDistance, false)
			if not closestPlayer then
				return
			end
			if IsPedInAnyVehicle(closestPlayerPed) then
				return
			end
			isTackling = true
			local shouldTackle = lib.callback.await('lsrp_tackle', false, GetPlayerServerId(closestPlayer))
			if not shouldTackle then
				isTackling = false
				return
			end
			lastTackleTime = GetGameTimer()
			playTackle()


		end

		:: continue ::

		Wait(sleep)
	end
end	CreateThread(mainThread)

lib.onCache('vehicle', function(value)
	playerVehicle = value
end)

lib.callback.register('lsrp_tackle:try', function()
    return lib.skillCheck({speedMultiplier = 2.5}, {'W'})
end)