item_lerolero = class({})
LinkLuaModifier("modifier_item_lerolero", "items/item_lerolero", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lerolero_buff", "items/item_lerolero", LUA_MODIFIER_MOTION_NONE)

function item_lerolero:GetIntrinsicModifierName()
	return "modifier_item_lerolero"
end
function item_lerolero:OnSpellStart()
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

			caster.lerolero_LEVELS_TABLE = caster.lerolero_LEVELS_TABLE or {}
			caster.lerolero_LEVELS_TABLE[self:GetName()] = self:GetLevel()
		end
	end

	--EmitSoundOn("DOTA_Item.BlackKingBar.Activate", caster)--
	--EmitSoundOn("anime_chatwheel_non_sorted_8_8", caster)--

	caster:Purge(false, true, false, true, true)

	caster:AddNewModifier(caster, self, "modifier_item_lerolero_buff", {duration = duration})
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cooldown"))
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_lerolero = class({})
function modifier_item_lerolero:IsHidden() return true end
function modifier_item_lerolero:IsDebuff() return false end
function modifier_item_lerolero:IsPurgable() return false end
function modifier_item_lerolero:IsPurgeException() return false end
function modifier_item_lerolero:RemoveOnDeath() return false end
function modifier_item_lerolero:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_lerolero:DeclareFunctions()
	local func = { 	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,}
	return func
end
function modifier_item_lerolero:GetModifierBonusStats_Strength()
	return self.bonus_str
end
function modifier_item_lerolero:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
function modifier_item_lerolero:GetModifierMagicalResistanceBonus()
	return 0
end

function modifier_item_lerolero:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")

	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_item_lerolero:OnIntervalThink()
	if IsServer() then
		if self.parent 
			and not self.parent:IsNull() 
			and self.ability 
			and not self.ability:IsNull()
			then

			self.parent.lerolero_LEVELS_TABLE = self.parent.lerolero_LEVELS_TABLE or {}
			local level = self.parent.lerolero_LEVELS_TABLE[self.ability:GetName()] or self.ability:GetLevel()

			if level > self.ability:GetLevel() then
				self.ability:SetLevel(level)
			end
		end
	end
end
function modifier_item_lerolero:OnRefresh(table)
	self:OnCreated(table)
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_lerolero_buff = class({})
function modifier_item_lerolero_buff:IsHidden() return false end
function modifier_item_lerolero_buff:IsDebuff() return false end
function modifier_item_lerolero_buff:IsPurgable() return false end
function modifier_item_lerolero_buff:IsPurgeException() return false end
function modifier_item_lerolero_buff:RemoveOnDeath() return true end
function modifier_item_lerolero_buff:CheckState()
	local state = {	[MODIFIER_STATE_MAGIC_IMMUNE] = true,}
	return state
end
function modifier_item_lerolero_buff:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, }
	return func
end

function modifier_item_lerolero_buff:GetModifierMagicalResistanceBonus()
	return self.resistance
end
function modifier_item_lerolero_buff:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.scale = self.ability:GetSpecialValueFor("model_scale")
	self.resistance = self.ability:GetSpecialValueFor("resistance")
end
function modifier_item_lerolero_buff:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_lerolero_buff:GetEffectName()
	return "particles/lerolero.vpcf"
end
function modifier_item_lerolero_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_avatar.vpcf"
end
function modifier_item_lerolero_buff:StatusEffectPriority()
	return 10
end
function modifier_item_lerolero_buff:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end