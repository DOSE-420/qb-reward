RewardTimers = {}
RegisterNetEvent('qb-reward:taketimeleft')
AddEventHandler('qb-reward:taketimeleft', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local result = exports.oxmysql:executeSync('SELECT rewardPlaytime, rewardTimer FROM players WHERE citizenid = @citizenid', 
    { 
        ['@citizenid'] = Player.PlayerData.citizenid
    })
	TriggerClientEvent('qb-reward:syncMyTime', src, math.floor(result[1].rewardTimer))
	TriggerClientEvent('qb-reward:synctimer', src, result[1].rewardPlaytime)
	RewardTimers[Player.PlayerData.citizenid] = result[1].rewardPlaytime
end)

Citizen.CreateThread(function()
    while true do
		for k, v in pairs(QBCore.Functions.GetPlayers()) do
			local Player = QBCore.Functions.GetPlayer(v)
			if RewardTimers and RewardTimers[Player.PlayerData.citizenid] then
				RewardTimers[Player.PlayerData.citizenid] = RewardTimers[Player.PlayerData.citizenid] + Config.Reward.Refresh
				TriggerClientEvent('qb-reward:synctimer', v, RewardTimers[Player.PlayerData.citizenid])
				if RewardTimers[Player.PlayerData.citizenid] >= Config.Reward.Timer then
					RewardTimers[Player.PlayerData.citizenid] = 0
					exports.oxmysql:executeSync('UPDATE players SET rewardTimer = @rewardTimer, rewardPlaytime = 0 WHERE citizenid = @citizenid',
					{ 
						['@rewardTimer'] = os.date("%Y-%m-%d %H:%M:%S", os.time()), 
						['@citizenid'] = Player.PlayerData.citizenid, 
					})
					TriggerClientEvent('QBCore:Notify', v, 'You got the bonus!')
					TriggerClientEvent('qb-reward:syncMyTime', v, math.floor(os.time()))
					
					Player.Functions.AddMoney('bank', Config.Reward.Price.price)
					TriggerClientEvent('qb-phone:client:addBankMoney', v, Config.Reward.Price.price)
					
				else
					exports.oxmysql:executeSync('UPDATE players SET rewardPlaytime = @rewardPlaytime WHERE citizenid = @citizenid',
					{ 
						['@rewardPlaytime'] = RewardTimers[Player.PlayerData.citizenid] , 
						['@citizenid'] = Player.PlayerData.citizenid, 
					})
				end
			end
		end
        Wait(Config.Reward.Refresh * 1000)
	end
end)
	
