local playerVehicle 			= false
local isGettingTackled			= false
local keybinds = {}
local keyStates = {}

local tackleLib			<const> = 'missmic2ig_11'
local tackleAnim		<const>	= 'mic_2_ig_11_intro_goon'
local tackleVictimAnim	<const> = 'mic_2_ig_11_intro_p_one'

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
end



local function performTackle()
	local closestPlayer, closestPlayerPed, distance = lib.getClosestPlayer(GetEntityCoords(cache.ped), Config.TackleDistance, false)
	if not closestPlayer then
		return
	end

	if IsPedInAnyVehicle(closestPlayerPed) then
		return
	end

	local shouldTackle = lib.callback.await('lsrp_tackle', false, GetPlayerServerId(closestPlayer))
	if not shouldTackle then
		return
	end
	
	playTackle()
end


local function keyPress(kbind, index)
	keyStates[index] = true
	if #keyStates >= #Config.tackleKeyBinds then
		performTackle()
	end
end
local function keyRelease(kbind, index)
	keyStates[index] = nil
end

local function initialize()
	if not Config.tackleKeyBinds or #Config.tackleKeyBinds <= 0 or next(Config.tackleKeyBinds) == nil then
		print('[LSRP_TACKLE]: Your settings are not set up correctly. Please follow the default config values!')
		return
	end

	for i=1, #Config.tackleKeyBinds do
		keybinds[i] = {}
		keybinds[i].bind = lib.addKeybind({
			name = ('tackle%s'):format(i),
			description = Config.tackleKeyBinds[i].description,
			defaultKey = Config.tackleKeyBinds[i].defaultKey,
			disabled = cache.vehicle and true,
			onPressed = function(self)
				keyPress(self.name, i)
				print(('pressed %s (%s)'):format(self.currentKey, self.name))
			end,
			onReleased = function(self)
				keyRelease(self.name, i)
				print(('released %s (%s)'):format(self.currentKey, self.name))
			end
		})
	end

end CreateThread(initialize)

--[[ Enetering vehicle ]]--
lib.onCache('vehicle', function(value)
	playerVehicle = value and true
	for i=1, #keybinds.bind do
		keybinds[i].bind:disable(playerVehicle)
	end
end)


--[[ Skill check ]]--
lib.callback.register('lsrp_tackle:try', function()
    return lib.skillCheck({speedMultiplier = 5.0}, Config.tackletemptKeys)
end)