local assets =
{
	Asset( "ANIM", "anim/caprica.zip" ),
	Asset( "ANIM", "anim/ghost_caprica_build.zip" ),
}

local skins =
{
	normal_skin = "caprica",
	ghost_skin = "ghost_caprica_build",
}

return CreatePrefabSkin("caprica_none",
{
	base_prefab = "caprica",
	type = "base",
	assets = assets,
	skins = skins, 
	skin_tags = {"CAPRICA", "CHARACTER", "BASE"},
	build_name_override = "caprica",
	rarity = "Character",
})