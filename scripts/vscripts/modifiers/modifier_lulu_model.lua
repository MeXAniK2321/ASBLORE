modifier_lulu_model = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lulu_model:IsHidden()
	return true
end

function modifier_lulu_model:IsDebuff()
	return false
end

function modifier_lulu_model:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lulu_model:OnCreated( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end

function modifier_lulu_model:OnRefresh( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )	
end

function modifier_lulu_model:OnRemoved()
end

function modifier_lulu_model:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_lulu_model:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		
	}
	return funcs
end
function modifier_lulu_model:GetModifierModelChange()

    return "models/lulu/lulu.vmdl"
	
end