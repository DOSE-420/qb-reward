RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	TriggerServerEvent('qb-reward:taketimeleft')
end)

local LastClaim = 0
RegisterNetEvent('qb-reward:syncMyTime')
AddEventHandler('qb-reward:syncMyTime', function(_LastClaim)
	LastClaim = _LastClaim
end)

RegisterNetEvent('qb-reward:synctimer')
AddEventHandler('qb-reward:synctimer', function(nowtime)
    timer = Config.Reward.Timer - nowtime
	local hours = math.floor((timer%86400)/3600)
	local minutes = math.floor((timer%3600)/60)
    if (hours < 10) then
        hours = "0" .. hours
    end
    if (minutes < 10) then
        minutes = "0" .. minutes
    end
	if tonumber(hours) < ((Config.Reward.Timer * 60) * 60) + 1 then
		timer = hours..':'..minutes
	else
		timer = 'Reset...'
	end
end)

Citizen.CreateThread(function()
    while true do
        Wait(500)
        if LocalPlayer.state['isLoggedIn'] then
			if not timer then TriggerServerEvent('qb-reward:taketimeleft') end
			local show = true
            if IsPauseMenuActive() then
                show = false
            end
            SendNUIMessage({
                action = 'tick',
				show = show,
				timer = timer,
				pricetext = Config.Reward.Price.text,
            })
        else
            SendNUIMessage({
                action = 'tick',
                show = false,
            })
        end
    end
end)
