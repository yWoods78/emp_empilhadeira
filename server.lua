local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
woo = {}
Tunnel.bindInterface("emp_empilhadeira",woo)

function woo.pagamento()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
        randmoney = (math.random(500,750))
	    vRP.giveMoney(user_id,parseInt(randmoney))
		TriggerClientEvent("Notify",source, "sucesso","Você recebeu <b>$"..vRP.format(parseInt(randmoney)).." reais</b>.", 5000)
	end
end
