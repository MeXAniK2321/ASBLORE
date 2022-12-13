modifier_rimuru_shield = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_rimuru_shield:IsHidden()
	return false
end

function modifier_rimuru_shield:IsDebuff()
	return false
end

function modifier_rimuru_shield:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_rimuru_shield:OnCreated( kv )
	if IsServer() then
		-- Play Effects
		self.sound_cast = "rimuru.shield"
		EmitSoundOn( self.sound_cast, self:GetParent() )
	end
end

function modifier_rimuru_shield:OnRefresh( kv )
	
end

function modifier_rimuru_shield:OnDestroy( kv )
	if IsServer() then
		StopSoundOn( self.sound_cast, self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_rimuru_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

function modifier_rimuru_shield:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor('resist')
end
function modifier_rimuru_shield:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor('armor')
end
--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_rimuru_shield:GetEffectName()
	return "particles/rimuru_shield.vpcf"
end

function modifier_rimuru_shield:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end