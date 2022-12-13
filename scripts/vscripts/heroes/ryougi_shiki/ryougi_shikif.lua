LinkLuaModifier("modifier_ryougi_shikiF", "heroes/ryougi_shiki/modifier_ryougi_shikiF",
    LUA_MODIFIER_MOTION_NONE)

ryougi_shikiF = class({})

function ryougi_shikiF:Spawn()
    if IsServer() then
        self:SetLevel(1)
    end
end

function ryougi_shikiF:OnAbilityPhaseStart()
    StartAnimation(self:GetCaster(), {
        duration = 1.0,
        activity =     ACT_DOTA_CHANNEL_END_ABILITY_1,
        rate = 1.0
    })

    local randomSound = math.random(1, 2)

    if randomSound == 1 then
        EmitSoundOn("Ryougi.F1", self:GetCaster())
    else
        EmitSoundOn("Ryougi.F1Alt", self:GetCaster())
    end

    return true
end

function ryougi_shikiF:OnAbilityPhaseInterrupted()
    if "Ryougi.F1" then
        StopSoundOn("Ryougi.F1", self:GetCaster())
    end
    if "Ryougi.F1Alt" then
        StopSoundOn("Ryougi.F1Alt", self:GetCaster())
    end
end

function ryougi_shikiF:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

    caster:AddNewModifier(caster, self, "modifier_ryougi_shikiF", {duration = duration})

    EmitSoundOn("Ryougi.F2", self:GetCaster())
end
