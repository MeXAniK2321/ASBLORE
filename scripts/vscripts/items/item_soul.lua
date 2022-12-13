item_soul_scythe = class({})
LinkLuaModifier("modifier_item_soul_scythe", "items/item_soul", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_soul_scythe_buff", "items/item_soul", LUA_MODIFIER_MOTION_NONE)

function item_soul_scythe:GetIntrinsicModifierName()
	return "modifier_item_soul_scythe"
end
function item_soul_scythe:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_item_soul_scythe_buff", {duration = duration})
	
	EmitSoundOn("soul.piano", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_soul_scythe = class({})
function modifier_item_soul_scythe:IsHidden() return true end
function modifier_item_soul_scythe:IsDebuff() return false end
function modifier_item_soul_scythe:IsPurgable() return false end
function modifier_item_soul_scythe:IsPurgeException() return false end
function modifier_item_soul_scythe:RemoveOnDeath() return false end
function modifier_item_soul_scythe:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_soul_scythe:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_desolator = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_desolator", {})
		self.modifier_mkb = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_monkey_king_bar", {})
	end
end
function modifier_item_soul_scythe:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_soul_scythe:OnDestroy()
	if IsServer() then
		self.modifier_desolator:Destroy()
		self.modifier_mkb:Destroy()
	end
end

---------------------------------------------------------------------------------------------------------------------
modifier_item_soul_scythe_buff = class({})
function modifier_item_soul_scythe_buff:IsHidden() return false end
function modifier_item_soul_scythe_buff:IsDebuff() return false end
function modifier_item_soul_scythe_buff:IsPurgable() return true end
function modifier_item_soul_scythe_buff:IsPurgeException() return true end
function modifier_item_soul_scythe_buff:RemoveOnDeath() return true end
function modifier_item_soul_scythe_buff:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					}
	return func
end

function modifier_item_soul_scythe_buff:GetModifierAttackSpeedBonus_Constant()
	return 80
end
function modifier_item_soul_scythe_buff:GetModifierMoveSpeedBonus_Constant()
	return 40
end
function modifier_item_soul_scythe_buff:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	
	self.as = self.ability:GetSpecialValueFor("as")
	self.bonus_ms = self.ability:GetSpecialValueFor("bonus_ms")
end
function modifier_item_soul_scythe_buff:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_soul_scythe_buff:GetEffectName()
	return "particles/windrunner_windrun_cascade_red.vpcf"
end
function modifier_item_soul_scythe_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
