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

-- DebugSpawn("stormspear")

local function fn(colour)

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

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("stormspear")
    anim:SetBuild("stormspear")
    anim:PlayAnimation("idle")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "stormspear"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/stormspear.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )

    return inst
end

return  Prefab("common/inventory/stormspear", fn, assets, prefabs)