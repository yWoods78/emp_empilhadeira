---------------------------------------------------------------------------------------------------------------------
----- SCRIPT DESENVOLVIDO POR DEV2UP https://discord.gg/MB6kzQwXbE
---------------------------------------------------------------------------------------------------------------------

local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
woo = Tunnel.getInterface("emp_empilhadeira")
ped = PlayerPedId()


local trabalhando = false
local comcarro = false

local pegarocarro = vector3(129.64,-3005.89,7.04)

local saidadocarro = {133.09, -2993.71, 7.04, 91.03}

local inicioemp = vector3(142.7,-3005.7,6.74)

local finalemp = vector3(170.29,-3286.03,6.36)

local caixas = {
    {161.67, -3037.71, 5.97},
    {161.33, -3077.17, 5.98},
    {151.92, -3083.86, 5.9},
    {121.58, -3075.33, 6.01},
    {129.95, -3102.51, 5.9},
    {116.15, -3057.7, 6.02},
    {115.48, -3039.25, 6.02},
    {115.29, -3111.95, 6.02},
    {151.04, -3326.96, 5.5},
    {208.49, -3317.48, 5.27},
    {236.97, -3315.23, 5.27},
    {228.87, -3316.57, 5.27},
    {259.04, -3315.18, 5.27},
    {124.92, -3214.16, 5.4},
    {134.58, -3216.95, 5.34},
    {144.41, -3185.24, 5.34},
    {192.79, -3207.65, 5.28},
    {190.9, -3249.05, 5.27},
    {192.38, -3308.66, 5.26},
    {115.78, -3308.76, 5.5},
    {115.77, -3249.69, 5.5},
    {180.38, -2799.94, 5.49},
    {179.98, -2815.04, 7.62},
    {207.22, -2945.26, 5.49},
    {210.31, -3132.94, 5.27},
    {203.94, -3107.3, 5.27},
    {237.12, -3132.37, 5.27},
    {121.02, -3327.39, 5.51},
}

local selecionado = math.random(#caixas)

CreateThread(function ()
    while true do
        local sleep = 1000
        local pedcds = GetEntityCoords(ped)
        if not trabalhando and not comcarro then
            local distancia = #(pedcds - inicioemp)
            if distancia <= 5.0 then
                sleep = 4
                DrawMarker(21, inicioemp.x,inicioemp.y,inicioemp.z, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.7, 0, 205, 250, 200, 0, 0, 0, 1)
                if distancia <= 1.5 then
                    if IsControlJustPressed(0, 38) then
                        trabalhando = true
                        selecionado = math.random(#caixas)
                        criarobjeto(caixas[selecionado])
                        SetNewWaypoint(caixas[selecionado][1],caixas[selecionado][2])
                        CriandoBlip(finalemp)
                       TriggerEvent("Notify", "sucesso", "Você entrou em serviço.", 5000)
                    end
                end
            end
        elseif trabalhando and not comcarro then
            local distancia = #(pedcds - pegarocarro)
            if distancia <= 5 then
                DrawMarker(36, pegarocarro.x,pegarocarro.y,pegarocarro.z, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 1.2, 0, 205, 250, 200, 0, 0, 0, 1)
                if IsControlJustPressed(0, 38) then
                    comcarro = true
                    spawncarro()
                end
            end
        elseif trabalhando and comcarro then
            local g = GetEntityCoords(caixa)
			local h = Vdist(finalemp.x,finalemp.y,finalemp.z,g.x,g.y,g.z)
            sleep = 4
            DrawMarker(0, g.x,g.y,g.z+2.0, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 255, 255, 200, 1, 0, 0, 0)
            if h <= 10.0 then
                DrawMarker(1, finalemp.x,finalemp.y,finalemp.z, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 0, 205, 250, 200, 0, 0, 0, 0)
                if h <= 2.5 then
                    DeleteEntity(caixa)
                    woo.pagamento()
                    selecionado = math.random(#caixas)
                    criarobjeto(caixas[selecionado])
                    SetNewWaypoint(caixas[selecionado][1],caixas[selecionado][2])
                end
            end
        end
        if trabalhando then
            sleep = 4
            drawTxt("PRESSIONE  ~y~[F7]~w~  PARA FINALIZAR A ROTA",4,0.27,0.93,0.40,255,255,255,180)
            if IsControlJustPressed(0,168) then
                trabalhando = false
                comcarro = false
                RemoveBlip(blip)
                DeleteEntity(caixa)
                deleteCar(nveh)
                TriggerEvent("Notify", "aviso", "Você saiu de serviço.", 5000)
            end
        end
        Wait(sleep)
    end
end)

------------------------------------------------------------------------------------
-- Functions
------------------------------------------------------------------------------------

function criarobjeto(cds)
    caixa = CreateObject(GetHashKey('prop_boxpile_06a'),cds[1],cds[2],cds[3],true,true,true)
    SetEntityAsMissionEntity(caixa)
    SetEntityDynamic(caixa,true)
    FreezeEntityPosition(caixa,false)
end

function spawncarro()
    local mhash = GetHashKey('forklift')
    modelRequest('forklift')
    nveh = CreateVehicle(mhash,saidadocarro[1], saidadocarro[2], saidadocarro[3], saidadocarro[4],true,false)
    SetVehicleOnGroundProperly(nveh)
    SetVehicleNumberPlateText(nveh,vRP.getRegistrationNumber())
    SetEntityAsMissionEntity(nveh,true,true)
    SetModelAsNoLongerNeeded(mhash)
    TaskWarpPedIntoVehicle(GetPlayerPed(-1),nveh,-1)
	SetVehicleColours(nveh,111,111)
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlip(cds)
	blip = AddBlipForCoord(cds.x,cds.y,cds.z)
	SetBlipSprite(blip,286)
	SetBlipColour(blip,1)
	SetBlipScale(blip,0.4)
	SetBlipAsShortRange(blip,false)
	SetBlipRoute(blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Entrega das Caixas")
	EndTextCommandSetBlipName(blip)
end

function deleteCar( entity )
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function modelRequest(model)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(10)
	end
end
