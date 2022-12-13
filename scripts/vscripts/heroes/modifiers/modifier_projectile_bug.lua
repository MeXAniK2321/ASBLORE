modifier_projectile_bug = class({})

--------------------------------------------------------------------------------
function modifier_projectile_bug:IsHidden() return false end

function modifier_projectile_bug:IsDebuff() return false end

function modifier_projectile_bug:IsStunDebuff() return false end

function modifier_projectile_bug:IsPurgable() return false end

function modifier_projectile_bug:OnCreated(kv)
    if IsServer() then self.intelligence = 0 end
end
--------------------------------------------------------------------------------
function modifier_projectile_bug:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return funcs
end

function modifier_projectile_bug:OnDestroy(kv)
    if not IsServer() then return end
end

function modifier_projectile_bug:GetModifierBonusStats_Intellect()
    return self.intelligence
end

function modifier_projectile_bug:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true
    }

    return state
end
