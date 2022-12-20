modifier_ichigoT_casting = class({})

--------------------------------------------------------------------------------
function modifier_ichigoT_casting:IsHidden() return false end

function modifier_ichigoT_casting:IsDebuff() return false end

function modifier_ichigoT_casting:IsStunDebuff() return false end

function modifier_ichigoT_casting:IsPurgable() return false end

function modifier_ichigoT_casting:OnCreated(kv)
    if IsServer() then self.intelligence = 0 end
end
--------------------------------------------------------------------------------
function modifier_ichigoT_casting:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_TURN_RATE_OVERRIDE
    }

    return funcs
end

function modifier_ichigoT_casting:OnDestroy(kv) if not IsServer() then return end end

function modifier_ichigoT_casting:GetModifierTurnRate_Override() return 0.2 end

function modifier_ichigoT_casting:GetModifierBonusStats_Intellect()
    return self.intelligence
end

function modifier_ichigoT_casting:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
        [MODIFIER_STATE_SILENCED] = true,
        [MODIFIER_STATE_MAGIC_IMMUNE] = true
    }

    return state
end
