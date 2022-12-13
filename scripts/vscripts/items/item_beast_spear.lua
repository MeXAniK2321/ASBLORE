item_beast_spear = class({})
LinkLuaModifier("modifier_item_beast_spear", "items/item_beast_spear", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_beast_spear_buff", "items/item_beast_spear", LUA_MODIFIER_MOTION_NONE)

function item_beast_spear:GetIntrinsicModifierName()
	return "modifier_item_beast_spear"
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_beast_spear = class({})
function modifier_item_beast_spear:IsHidden() return true end
function modifier_item_beast_spear:IsDebuff() return false end
function modifier_item_beast_spear:IsPurgable() return false end
function modifier_item_beast_spear:IsPurgeException() return false end
function modifier_item_beast_spear:RemoveOnDeath() return false end
function modifier_item_beast_spear:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_beast_spear:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_mkb = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_monkey_king_bar", {})
		self.modifier_venom = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_orb_of_venom", {})
	end
end
function modifier_item_beast_spear:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_beast_spear:OnDestroy()
	if IsServer() then
		self.modifier_venom:Destroy()
		self.modifier_mkb:Destroy()
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_beast_spear_buff = class({})
function modifier_item_beast_spear_buff:IsHidden() return false end
function modifier_item_beast_spear_buff:IsDebuff() return false end
function modifier_item_beast_spear_buff:IsPurgable() return true end
function modifier_item_beast_spear_buff:IsPurgeException() return true end
function modifier_item_beast_spear_buff:RemoveOnDeath() return true end
function modifier_item_beast_spear_buff:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_EVASION_CONSTANT,
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,}
	return func
end
function modifier_item_beast_spear_buff:GetModifierEvasion_Constant()
	return self.evasion
end
function modifier_item_beast_spear_buff:GetModifierAttackSpeedBonus_Constant()
	return self.as
end
function modifier_item_beast_spear_buff:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.evasion = self.ability:GetSpecialValueFor("evasion")
	self.as = self.ability:GetSpecialValueFor("as")
end
function modifier_item_beast_spear_buff:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_beast_spear_buff:GetEffectName()
	return 
end
function modifier_item_beast_spear_buff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end