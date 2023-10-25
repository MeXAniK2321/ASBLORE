item_asta_sword = class({})
LinkLuaModifier("modifier_item_asta_sword", "items/item_asta_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_asta_sword_buff", "items/item_asta_sword", LUA_MODIFIER_MOTION_NONE)

function item_asta_sword:GetIntrinsicModifierName()
	return "modifier_item_asta_sword"
end
function item_asta_sword:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local level = self:GetSpecialValueFor("max_level")

	if self:GetLevel() < level then
		self:SetLevel(self:GetLevel() + 1)

		if caster 
			and not caster:IsNull() 
			and self 
			and not self:IsNull()
			then

			caster.asta_sword_LEVELS_TABLE = caster.asta_sword_LEVELS_TABLE or {}
			caster.asta_sword_LEVELS_TABLE[self:GetName()] = self:GetLevel()
		end
	end

	EmitSoundOn("DOTA_Item.BlackKingBar.Activate", caster)

	caster:Purge(false, true, false, true, true)

	caster:AddNewModifier(caster, self, "modifier_item_asta_sword_buff", {duration = duration})
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cooldown"))
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_asta_sword = class({})
function modifier_item_asta_sword:IsHidden() return true end
function modifier_item_asta_sword:IsDebuff() return false end
function modifier_item_asta_sword:IsPurgable() return false end
function modifier_item_asta_sword:IsPurgeException() return false end
function modifier_item_asta_sword:RemoveOnDeath() return false end
function modifier_item_asta_sword:DeclareFunctions()
	local func = { 	
	                 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	                 MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
					 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
				 }
	return func
end
function modifier_item_asta_sword:GetModifierBonusStats_Strength()
	return self.bonus_str
end
function modifier_item_asta_sword:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
function modifier_item_asta_sword:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")

	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_item_asta_sword:OnIntervalThink()
	if IsServer() then
		if self.parent 
			and not self.parent:IsNull() 
			and self.ability 
			and not self.ability:IsNull()
			then

			self.parent.asta_sword_LEVELS_TABLE = self.parent.asta_sword_LEVELS_TABLE or {}
			local level = self.parent.asta_sword_LEVELS_TABLE[self.ability:GetName()] or self.ability:GetLevel()

			if level > self.ability:GetLevel() then
				self.ability:SetLevel(level)
			end
		end
	end
end
function modifier_item_asta_sword:OnRefresh(table)
	self:OnCreated(table)
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_asta_sword_buff = class({})
function modifier_item_asta_sword_buff:IsHidden() return false end
function modifier_item_asta_sword_buff:IsDebuff() return false end
function modifier_item_asta_sword_buff:IsPurgable() return false end
function modifier_item_asta_sword_buff:IsPurgeException() return false end
function modifier_item_asta_sword_buff:RemoveOnDeath() return true end
function modifier_item_asta_sword_buff:CheckState()
	local state = {	[MODIFIER_STATE_MAGIC_IMMUNE] = true,}
	return state
end
function modifier_item_asta_sword_buff:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, }
	return func
end

function modifier_item_asta_sword_buff:GetModifierMagicalResistanceBonus()
	return 1
end
function modifier_item_asta_sword_buff:OnCreated(table)
	self.scale = 30
end
function modifier_item_asta_sword_buff:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_asta_sword_buff:GetEffectName()
	return "particles/asta_sword.vpcf"
end
function modifier_item_asta_sword_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_avatar.vpcf"
end
function modifier_item_asta_sword_buff:StatusEffectPriority()
	return 10
end
function modifier_item_asta_sword_buff:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end