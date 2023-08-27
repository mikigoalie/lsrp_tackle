local tackleCache = {}

lib.callback.register('lsrp_tackle', function(source, target)
	if tackleCache[source] and (os.time() - tackleCache[source] < Config.tacklePause) then
		return false
	end

	tackleCache[source] = os.time()

	if (#GetEntityCoords(GetPlayerPed(source)) - #GetEntityCoords(GetPlayerPed(target)) > Config.TackleDistance) then
		return false
	end

	local tryTackle = lib.callback.await('lsrp_tackle:try', source)
	if tryTackle then
		TriggerClientEvent('lsrp_tackle:getTackled', target, source)
	end

	return tryTackle == true
end)