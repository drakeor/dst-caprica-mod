local assets =
{
    Asset("ANIM", "anim/armor_stormscale.zip"),

    Asset("ATLAS", "images/inventoryimages/armor_stormscale.xml"),
    Asset("IMAGE", "images/inventoryimages/armor_stormscale.tex"),
}

local function OnBlocked(owner, data)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")
end

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_stormscale")
    else
        owner.AnimState:OverrideSymbol("swap_body", "armor_stormscale", "swap_body")
    end

    inst:ListenForEvent("blocked", OnBlocked, owner)
    inst:ListenForEvent("attacked", OnBlocked, owner)

end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)

    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_stormscale")
    inst.AnimState:SetBuild("armor_stormscale")
    inst.AnimState:PlayAnimation("anim")

    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "armor_stormscale"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/armor_stormscale.xml"
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMOR_STORMSCALE.ARMOR, TUNING.ARMOR_STORMSCALE.ABSORPTION)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    -- Provides a tiny sanity boost
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_TINY

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/armor_stormscale", fn, assets)
