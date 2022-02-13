
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
require("FakeInit")
require("Printable")
-- Create the game mode when we activate
function Activate()
    GameRules.AddonTemplate = CAddonTemplateGameMode()
    GameRules.AddonTemplate:InitGameMode()
    print("ALL OK3")
end

function CAddonTemplateGameMode:InitGameMode()
    print("Template addon is loaded.")
    GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
    --local axe=CreateUnitByName("npc_dota_hero_axe", Vector(-5373.85,-3296.91, 128), true, nil, nil, DOTA_TEAM_BADGUYS)

    --axe:AddItemByName("item_blink_staff")
    GameSetup:init()
    GameRules:SetUseUniversalShopMode(true)

    local tmpUnit = CreateUnitByName("gnoll_boy", Vector(-5373.85, -3296.91, 128), true, nil, nil, DOTA_TEAM_BADGUYS)
    --этот предмет не создаётся
    local item = CreateItem("item_blink_staff", nil, nil)
    CreateItemOnPositionForLaunch(Vector(-5373.85, -3296.91, 128), item)
    --с этим всё отлично работает
    local item2 = CreateItem("item_blink_staff", nil, nil)
    CreateItemOnPositionForLaunch(Vector(-5373.85, -3206.91, 128), item2)

    --local player = PlayerResource:GetPlayer(0)
    --local hero = player:GetAssignedHero()
    --hero:AddItemByName("item_blink_staff")

    ListenToGameEvent("entity_killed", Dynamic_Wrap(self, "OnUnitKilled"), self)
    ListenToGameEvent("player_spawn", Dynamic_Wrap(self, 'On_player_spawn'), self)
    ListenToGameEvent("game_start", Dynamic_Wrap(self, 'On_game_start'), self)
    ListenToGameEvent("tree_cut", Dynamic_Wrap(self, 'On_tree_cut'), self)

end

function CAddonTemplateGameMode:On_tree_cut(data)
    local x,y=data.tree_x, data.tree_y
    x=x+math.random(-50,50)
    y=y+math.random(-50,50)
    local item = CreateItem("item_blink_staff", nil, nil)
    CreateItemOnPositionForLaunch(Vector(x,y, 128), item)
    local data2=HERO[data.killerID]
    if not data2 then
        HERO[data.killerID]={}
        data2=HERO[data.killerID]
    end
    if not data2.TreeCount then
        data2.TreeCount=1
    else
        data2.TreeCount=data2.TreeCount+1
        print(data2.TreeCount)
    end
end


function CAddonTemplateGameMode:On_game_start(data)
    print("[BAREBONES] game_start")
    PrintTable(data)
end

function CAddonTemplateGameMode:On_player_spawn (data)
    local id = data.userid
    print("Создан юнит ", id)
end

function CAddonTemplateGameMode:OnUnitKilled (args)
    local unit = EntIndexToHScript(args.entindex_killed)
    local killer = EntIndexToHScript(args.entindex_attacker)
    print(killer:GetName() .. " УБИЙЦА")
    print("ID=" .. killer:GetPlayerOwnerID())

    if unit then
        if unit:IsHero() then
            print(unit:GetName() .. "11111111111111111")
        end
    end
    --args.entindex_attacker
    --args.entindex_inflictor
    --args.damagebits
end


-- Evaluate the state of the game
GInit = true

function CAddonTemplateGameMode:OnThink()
    --print("ALL OK4")
    if GInit then
        print("FakeInit")
        FakeInit()
        GInit = false
    end
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        --print( "Template addon script is running." )

    elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
        return nil
    end
    return 1
end