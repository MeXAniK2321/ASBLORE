modifier_ryougi_shikiR_debuff = class({})

--------------------------------------------------------------------------------
function modifier_ryougi_shikiR_debuff:IsHidden()
    return false
end

function modifier_ryougi_shikiR_debuff:IsDebuff()
    return false
end

function modifier_ryougi_shikiR_debuff:IsStunDebuff()
    return false
end

function modifier_ryougi_shikiR_debuff:IsPurgable()
    return false
end

function modifier_ryougi_shikiR_debuff:OnCreated(kv)
    if IsServer() then
    end
end