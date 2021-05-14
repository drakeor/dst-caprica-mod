local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

-- Your character's stats
TUNING.CAPRICA_HEALTH = 150
TUNING.CAPRICA_HUNGER = 150
TUNING.CAPRICA_SANITY = 200
TUNING.CAPRICA_OVERHEAT_KILL_TIME = 240
TUNING.CAPRICA_SANITY_RAIN_BOOST = 0.5

-- Custom starting inventory
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.CAPRICA = {
	"flint",
	"flint",
	"twigs",
	"twigs",
	"stormspear"
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.CAPRICA
end
local prefabs = FlattenTree(start_inv, true)

-- Hijack the WX-78 events
local function dorainsparks(inst, dt)
    if inst.components.moisture ~= nil and inst.components.moisture:GetMoisture() > 0 then
        local t = GetTime()
		
		if t > inst.spark_time + inst.spark_time_offset then
			inst.components.sanity:DoDelta(TUNING.CAPRICA_SANITY_RAIN_BOOST)

			inst.spark_time_offset = 3 + math.random() * 2
			inst.spark_time = t
			local x, y, z = inst.Transform:GetWorldPosition()

		end
        
    end
end

-- Hijack the WX-78 events
local function onisraining(inst, israining)
    if israining then
        if inst.spark_task == nil then
            inst.spark_task = inst:DoPeriodicTask(.1, dorainsparks, nil, .1)
        end
    elseif inst.spark_task ~= nil then
        inst.spark_task:Cancel()
        inst.spark_task = nil
    end
end

-- When the character is revived from human
local function onbecamehuman(inst)
	
	-- Set speed when not a ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "caprica_speed_mod", 1)

	-- Watching rain event
	if not inst.watchingrain then
        inst.watchingrain = true
        inst:WatchWorldState("israining", onisraining)
        onisraining(inst, TheWorld.state.israining)
    end
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "caprica_speed_mod")
end

local function onlightning(inst)
	inst.sg:GoToState("electrocute")
    --inst.components.health:SetPercent(1)
	--inst.SoundEmitter:PlaySound("dontstarve/common/lightningrod")
	inst.components.health:DoDelta(TUNING.HEALING_SUPERHUGE, false, "lightning")
    inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/charged", "overcharge_sound")
	SpawnPrefab("lightning_rod_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

	-- Hacky way to make lightning sticks charge
	inst.components.playerlightningtarget:SetOnStrikeFn(onlightning)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 

	-- Immune to electrical damage
	inst:AddTag("electricdamageimmune")

	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "caprica.tex" )
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- Set starting inventory
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	--inst:AddTag("lightningrod")

	-- choose which sounds this character will play
	inst.soundsname = "willow"

	-- Spark
	inst.spark_task = nil
    inst.spark_time = 0
    inst.spark_time_offset = 3
    inst.watchingrain = false

	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"

	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.CAPRICA_HEALTH)
	inst.components.hunger:SetMax(TUNING.CAPRICA_HUNGER)
	inst.components.sanity:SetMax(TUNING.CAPRICA_SANITY)
	
	-- Dragons last longer before overheating
	inst.components.temperature:SetOverheatHurtRate(TUNING.WILSON_HEALTH / TUNING.CAPRICA_OVERHEAT_KILL_TIME)

	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
end

return MakePlayerCharacter("caprica", prefabs, assets, common_postinit, master_postinit, prefabs)
