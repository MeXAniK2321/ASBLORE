modifier_jin_mori_original_attack = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_jin_mori_original_attack:IsHidden()
	return true
end
function modifier_jin_mori_original_attack:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_jin_mori_original_attack:OnCreated( kv )
	-- references
	self.base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )	
	self.attack_factor = self:GetAbility():GetSpecialValueFor( "attack_factor" )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_jin_mori_original_attack:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,

	}

	return funcs
end

function modifier_jin_mori_original_attack:GetModifierDamageOutgoing_Percentage( params )
	if IsServer() then
		return self.attack_factor
	end
end
function modifier_jin_mori_original_attack:GetModifierPreAttack_BonusDamage( params )
	if IsServer() then
		-- base damage will get reduced, so multiply it by its inverse
		if self:GetCaster():HasModifier("modifier_young_tiger") then
		return (self.base_damage * 2) * 100/(100+self.attack_factor)
		else
		return self.base_damage  * 100/(100+self.attack_factor)
		end
	end
end
--------------------------------------------------------------------------------
-- Graphics & Animations
-- function modifier_jin_mori_original_attack:GetEffectName()
-- 	return "particles/string/here.vpcf"
-- end

-- function modifier_jin_mori_original_attack:GetEffectAttachType()
-- 	return PATTACH_ABSORIGIN_FOLLOW
-- end