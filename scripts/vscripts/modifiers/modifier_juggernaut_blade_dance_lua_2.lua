modifier_juggernaut_blade_dance_lua_2 = class({})
function modifier_juggernaut_blade_dance_lua_2:IsHidden() return true end
function modifier_juggernaut_blade_dance_lua_2:IsDebuff() return false end
function modifier_juggernaut_blade_dance_lua_2:IsPurgable() return false end
function modifier_juggernaut_blade_dance_lua_2:IsPurgeException() return false end
function modifier_juggernaut_blade_dance_lua_2:RemoveOnDeath() return false end
function modifier_juggernaut_blade_dance_lua_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_juggernaut_blade_dance_lua_2:DeclareFunctions()
	local func = { 	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,}
	return func
end
function modifier_juggernaut_blade_dance_lua_2:GetModifierBonusStats_Strength()
	return self.strength
end
function modifier_juggernaut_blade_dance_lua_2:GetModifierBonusStats_Agility()
	return self.agility
end
function modifier_juggernaut_blade_dance_lua_2:GetModifierBonusStats_Intellect()
	return self.intellect
end
function modifier_juggernaut_blade_dance_lua_2:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.strength = self.ability:GetSpecialValueFor("bonus_strength")
	self.agility = self.ability:GetSpecialValueFor("bonus_agility")
	self.intellect = self.ability:GetSpecialValueFor("bonus_intellect")
end