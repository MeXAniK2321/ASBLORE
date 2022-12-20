modifier_kurohitsugi = class({})

--------------------------------------------------------------------------------

function modifier_kurohitsugi:IsDebuff()
	return true
end

function modifier_kurohitsugi:IsStunDebuff()
	return true
end
function modifier_kurohitsugi:OnDestroy()
	if self:GetCaster():HasModifier("modifier_hogyoku_evolution") then
self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) 
else
self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) 
end
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- play effects


end

--------------------------------------------------------------------------------

