--------------------------------------------------------------------------------
modifier_generic_model_change = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_model_change:IsHidden()
    return true
end

function modifier_generic_model_change:IsDebuff()
    return false
end

function modifier_generic_model_change:IsStunDebuff()
    return false
end

function modifier_generic_model_change:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_model_change:OnCreated(kv)
    if IsServer() then
        self.model = kv.model
    end
end

function modifier_generic_model_change:OnRefresh(kv)
    self:OnCreated(kv)
end

function modifier_generic_model_change:OnRemoved()
end

function modifier_generic_model_change:OnDestroy()
    if not IsServer() then
        return
    end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_generic_model_change:DeclareFunctions()
    local funcs = {MODIFIER_PROPERTY_MODEL_CHANGE}

    return funcs
end

function modifier_generic_model_change:GetModifierModelChange()
    return self.model
end