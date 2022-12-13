modifier_ryougi_shikiF = class({})

--------------------------------------------------------------------------------
function modifier_ryougi_shikiF:IsHidden()
    return false
end

function modifier_ryougi_shikiF:IsDebuff()
    return false
end

function modifier_ryougi_shikiF:IsStunDebuff()
    return false
end

function modifier_ryougi_shikiF:IsPurgable()
    return false
end

function modifier_ryougi_shikiF:OnCreated(kv)
    if IsServer() then
        self.agility = 10
        ----aca efecto 2-----
        local particle_cast_a = "particles/ryougi_eff/ryougi_aura/ryougi_aurainicio.vpcf"
        local effect_cast_a = ParticleManager:CreateParticle(particle_cast_a, PATTACH_POINT, self:GetParent())
        ParticleManager:SetParticleControl(effect_cast_a, 0, self:GetParent():GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(effect_cast_a)
    end

end
--------------------------------------------------------------------------------
function modifier_ryougi_shikiF:DeclareFunctions()
    local funcs = {MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL}

    return funcs
end

function modifier_ryougi_shikiF:OnDestroy(kv)

    local particle_cast_a = "particles/ryougi_eff/ryougi_aura/ryougi_aurafinal.vpcf"
    local effect_cast_a = ParticleManager:CreateParticle(particle_cast_a, PATTACH_POINT, self:GetParent())
    ParticleManager:SetParticleControl(effect_cast_a, 3, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(effect_cast_a)

end

function modifier_ryougi_shikiF:GetModifierBonusStats_Agility()
    return self.agility
end

function modifier_ryougi_shikiF:GetModifierProcAttack_BonusDamage_Physical()
    return self:GetParent():GetAgility() * 0.5
end

function modifier_ryougi_shikiF:GetEffectName()
    return "particles/ryougi_eff/ryougi_aura/ryougi_aura.vpcf"
end

function modifier_ryougi_shikiF:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
