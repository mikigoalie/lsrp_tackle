lib.callback.register('lsrp_tackle', function(source, target)
	if not source then return false end
	if target <= 0 then return false end


	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return false end
	
	local xTarget = ESX.GetPlayerFromId(target)
	if not xTarget then return false end

	local tryTackle = lib.callback.await('lsrp_tackle:try', xTarget.source)
	if not tryTackle then
		TriggerClientEvent('lsrp_tackle:getTackled', xTarget.source, xPlayer.source)
	end

	return tryTackle ~= true
end)