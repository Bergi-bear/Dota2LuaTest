---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Bergi.
--- DateTime: 13.01.2022 11:46
---
cool_beans = class({})
function cool_beans:OnSpellStart()
    print("here")
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()
    if target then
        local damageTable = {
            victim       = target,
            attacker     = caster,
            damage       = self:GetAbilityDamage(),
            damage_type  = DAMAGE_TYPE_PHYSICAL,
            --damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
            --ability      = playerHero:GetAbilityByIndex(0), --Optional.
        }

        ApplyDamage(damageTable)
    end
end