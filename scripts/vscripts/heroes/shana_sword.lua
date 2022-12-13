LinkLuaModifier("modifier_yuno_sharpness_axe", "heroes/shana_sword.lua", LUA_MODIFIER_MOTION_NONE)

Yuno_sharpness_axe = class({}) 

function Yuno_sharpness_axe:GetIntrinsicModifierName()
    return "modifier_yuno_sharpness_axe"
end

modifier_yuno_sharpness_axe = class({})

function modifier_yuno_sharpness_axe:IsHidden()
    return true
end

function modifier_yuno_sharpness_axe:IsPurgable()
    return false
end

function modifier_yuno_sharpness_axe:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }

    return funcs
end

function modifier_yuno_sharpness_axe:OnAttackLanded( params )
    if not IsServer() then return end
    local parent = self:GetParent()
    local target = params.target
    if parent == params.attacker and target:GetTeamNumber() ~= parent:GetTeamNumber() then
        if self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() then return end
        if target:IsOther() then
            return nil
        end
        if target:IsBoss() then return end
        local damage_bonus = self:GetAbility():GetSpecialValueFor("damage")
        local base_damage = self:GetAbility():GetSpecialValueFor("base_damage")
        local damage = damage_bonus / 100 * params.original_damage
        damage = damage + base_damage
        target:EmitSound("Hero_PhantomAssassin.CoupDeGrace")
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 1, target:GetOrigin() )
        ParticleManager:SetParticleControlForward( nFXIndex, 1, self:GetParent():GetForwardVector() )
        ParticleManager:SetParticleControlEnt( nFXIndex, 10, target, PATTACH_ABSORIGIN_FOLLOW, nil, target:GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
        ApplyDamage({ victim = target, attacker = self:GetParent(), damage = damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility() })
    end
end