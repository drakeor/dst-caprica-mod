local assets=
{ 
    Asset("ANIM", "anim/stormscale.zip"),

    Asset("ATLAS", "images/inventoryimages/stormscale.xml"),
    Asset("IMAGE", "images/inventoryimages/stormscale.tex"),
}

local prefabs = 
{

}

-- DebugSpawn("stormscale")

local function fn(colour)

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("stormscale")
    anim:SetBuild("stormscale")
    anim:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "stormscale"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/stormscale.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    MakeHauntableLaunch(inst)

    return inst
end

return  Prefab("common/inventory/stormscale", fn, assets, prefabs)