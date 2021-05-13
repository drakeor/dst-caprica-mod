-- Prefabs

PrefabFiles = {
	"caprica",
	"caprica_none",
    "stormspear"
}


-- Assets

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/caprica.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/caprica.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/caprica.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/caprica.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/caprica_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/caprica_silho.xml" ),

    Asset( "IMAGE", "bigportraits/caprica.tex" ),
    Asset( "ATLAS", "bigportraits/caprica.xml" ),
	
	Asset( "IMAGE", "images/map_icons/caprica.tex" ),
	Asset( "ATLAS", "images/map_icons/caprica.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_caprica.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_caprica.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_caprica.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_caprica.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_caprica.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_caprica.xml" ),
	
	Asset( "IMAGE", "images/names_caprica.tex" ),
    Asset( "ATLAS", "images/names_caprica.xml" ),
	
	Asset( "IMAGE", "images/names_gold_caprica.tex" ),
    Asset( "ATLAS", "images/names_gold_caprica.xml" ),
}

-- Caprica has the stormdragon property
AddPrefabPostInit("caprica", function(inst)
    inst:AddTag("stormdragon")
end)

-- TUNING

TUNING = GLOBAL.TUNING

TUNING.STORMSPEAR =
{
    DAMAGE = 25,
    ATTACKWEAR = 0.75,
    SHADOW_WEAR = 0.5,
}


-- Weapon Lines
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

local NAMES = GLOBAL.STRINGS.NAMES
local RECIPE_DESC = GLOBAL.STRINGS.RECIPE_DESC
local DESC = GLOBAL.STRINGS.CHARACTERS
	
NAMES.STORMSPEAR = "Storm Spear"
RECIPE_DESC.STORMSPEAR = "Warning~ may attract lightning"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.STORMSPEAR = "Particularly shocking!"

AddMinimapAtlas("images/map_icons/caprica.xml")



-- The character select screen lines
STRINGS.CHARACTER_TITLES.caprica = "The Storm-Catcher"
STRINGS.CHARACTER_NAMES.caprica = "Caprica"
STRINGS.CHARACTER_DESCRIPTIONS.caprica = "*Loves the Rain\n*Uses an electric spears\n*Sheds scales"
STRINGS.CHARACTER_QUOTES.caprica = "\"SCREEEEEEEE!!!!!\""
STRINGS.CHARACTER_SURVIVABILITY.caprica = "Slim"

-- Custom speech strings
STRINGS.CHARACTERS.CAPRICA = require "speech_caprica"

-- The character's name as appears in-game 
STRINGS.NAMES.CAPRICA = "Caprica"
STRINGS.SKIN_NAMES.caprica_none = "Caprica"

-- The skins shown in the cycle view window on the character select screen.
-- A good place to see what you can put in here is in skinutils.lua, in the function GetSkinModes
local skin_modes = {
    { 
        type = "ghost_skin",
        anim_bank = "ghost",
        idle_anim = "idle", 
        scale = 0.75, 
        offset = { 0, -25 } 
    },
}

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("caprica", "FEMALE", skin_modes)
