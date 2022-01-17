-- Generated from template

if CAddonTemplateGameMode == nil then
    print("ALL OK1")
    CAddonTemplateGameMode = class({})
end

function Precache(context)
    print("ALL OK2")
    --[[
        Precache things we know we'll use.  Possible file types include (but not limited to):
            PrecacheResource( "model", "*.vmdl", context )
            PrecacheResource( "soundfile", "*.vsndevts", context )
            PrecacheResource( "particle", "*.vpcf", context )
            PrecacheResource( "particle_folder", "particles/folder", context )
    ]]
end

require("game_setup")
-- Create the game mode when we activate
function Activate()
    GameRules.AddonTemplate = CAddonTemplateGameMode()
    GameRules.AddonTemplate:InitGameMode()
    print("ALL OK3")
end

function CAddonTemplateGameMode:InitGameMode()
    print("Template addon is loaded.")
    GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
    CreateUnitByName("npc_dota_hero_axe",Vector(0,50,0),true,nil,nil,DOTA_TEAM_BADGUYS)
    --GameSetup:init()
    GameRules:SetUseUniversalShopMode(true)

    CreateUnitByName("gnoll_boy", Vector(0, 200, 0), true, nil, nil, DOTA_TEAM_BADGUYS)
    ListenToGameEvent("entity_killed", Dynamic_Wrap(self, "OnUnitKilled"), self)
end

function CAddonTemplateGameMode:OnUnitKilled (args)
    local unit=EntIndexToHScript(args.entindex_killed)
    if unit then
        if unit:IsHero() then
            print(unit:GetName())
        end
    end
    --args.entindex_attacker
    --args.entindex_inflictor
    --args.damagebits
end


-- Evaluate the state of the game
GInit = false
function CAddonTemplateGameMode:OnThink()
    --print("ALL OK4")
    if GInit then
        print("CreateENEMY")
        CreateUnitByName("npc_dota_creature_gnoll_assassin", Vector(0, 1, 0), true, nil, nil, DOTA_TEAM_BADGUYS)
        GInit = false
    end
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        --print( "Template addon script is running." )

    elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        return nil
    end
    return 1
end