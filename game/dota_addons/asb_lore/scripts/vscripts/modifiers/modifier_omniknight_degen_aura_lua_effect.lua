modifier_omniknight_degen_aura_lua_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_omniknight_degen_aura_lua_effect:IsHidden()
	return false
end

function modifier_omniknight_degen_aura_lua_effect:IsDebuff()
	return true
end

function modifier_omniknight_degen_aura_lua_effect:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_omniknight_degen_aura_lua_effect:OnCreated( kv )

	self.resistance = self:GetAbility():GetSpecialValueFor( "resist" )
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "speed_bonus" )
end

function modifier_omniknight_degen_aura_lua_effect:OnRefresh( kv )
	-- references
	self.resistance = self:GetAbility():GetSpecialValueFor( "resist" )
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "speed_bonus" )
end

function modifier_omniknight_degen_aura_lua_effect:OnRemoved()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_omniknight_degen_aura_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end
function modifier_omniknight_degen_aura_lua_effect:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end
function modifier_omniknight_degen_aura_lua_effect:GetModifierMagicalResistanceBonus()
	return self.resistance
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_omniknight_degen_aura_lua_effect:GetEffectName()
	return "particles/omniknight_degen_aura_debuff1.vpcf"
end

function modifier_omniknight_degen_aura_lua_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end