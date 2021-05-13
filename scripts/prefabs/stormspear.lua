local assets=
{ 
    Asset("ANIM", "anim/stormspear.zip"),
    Asset("ANIM", "anim/swap_stormspear.zip"), 

    Asset("ATLAS", "images/inventoryimages/stormspear.xml"),
    Asset("IMAGE", "images/inventoryimages/stormspear.tex"),
}

local prefabs = 
{

}


local function OnEquip(inst, owner) 
    --owner.AnimState:OverrideSymbol("swap_object", "swap_wands", "purplestaff")
    owner.AnimState:OverrideSymbol("swap_object", "swap_stormspear", "symbol0")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function OnUnequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function OnAttack(inst, attacker, target)

    local pos = Vector3(inst.Transform:GetWorldPosition())
    SpawnPrefab("sparks").Transform:SetPosition(pos:Get())

	inst.components.weapon.attackwear = target ~= nil 
        and target:IsValid() 
		and (target:HasTag("shadow") or target:HasTag("shadowminion") or target:HasTag("shadowchesspiece") or target:HasTag("stalker") or target:HasTag("stalkerminion"))
		and TUNING.STORMSPEAR.SHADOW_WEAR
		or TUNING.STORMSPEAR.ATTACKWEAR
end


-- DebugSpawn("stormspear")

local function fn(colour)

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("stormspear")
    anim:SetBuild("stormspear")
    anim:PlayAnimation("idle")

    inst:AddTag("weapon")
    inst.entity:SetPristine()


    inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.STORMSPEAR.DAMAGE)
	inst.components.weapon:SetOnAttack(OnAttack)
    inst.components.weapon:SetElectric()

    inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "stormspear"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/stormspear.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )

    MakeHauntableLaunch(inst)

    return inst
end

return  Prefab("common/inventory/stormspear", fn, assets, prefabs)