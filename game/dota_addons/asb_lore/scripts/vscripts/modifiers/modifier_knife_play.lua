modifier_knife_play = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_knife_play:IsHidden()
	return false
end

function modifier_knife_play:IsDebuff()
	return true
end

function modifier_knife_play:IsStunDebuff()
	return false
end

function modifier_knife_play:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_knife_play:OnCreated( kv )
	-- references
	self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )
end

function modifier_knife_play:OnRefresh( kv )
	-- references
	self.move_slow = self:GetAbility():GetSpecialValueFor( "move_slow" )	
end

function modifier_knife_play:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_knife_play:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_knife_play:GetModifierMoveSpeedBonus_Percentage()
	return self.move_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_knife_play:GetEffectName()
	return "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger_debuff.vpcf"
end

function modifier_knife_play:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end