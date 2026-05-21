require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_p_f = class({})

function sukuna_p_f:OnSpellStart()
	local hCaster = self:GetCaster()

	hCaster:AddNewModifier(hCaster, self, "modifier_sukuna_p_f_cursed_heal", {duration = self:GetSpecialValueFor("heal_duration")})

	EmitSoundOn("sukuna_aura.heal", hCaster)
end



--====================================================================================================--
LinkLuaModifier("modifier_sukuna_p_f_cursed_heal", "heroes/sukuna/sukuna_p_f", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_p_f_cursed_heal = class({})

function modifier_sukuna_p_f_cursed_heal:IsHidden()											return false end
function modifier_sukuna_p_f_cursed_heal:IsDebuff()											return false end
function modifier_sukuna_p_f_cursed_heal:IsPurgable()										return false end
function modifier_sukuna_p_f_cursed_heal:IsPurgeException()									return false end
function modifier_sukuna_p_f_cursed_heal:RemoveOnDeath()									return true end
function modifier_sukuna_p_f_cursed_heal:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_sukuna_p_f_cursed_heal:GetPriority()										return MODIFIER_PRIORITY_NORMAL end
function modifier_sukuna_p_f_cursed_heal:DeclareFunctions()
	local t = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
	return t
end
function modifier_sukuna_p_f_cursed_heal:GetModifierConstantHealthRegen(keys)
	return self.heal_per_second
end
function modifier_sukuna_p_f_cursed_heal:GetModifierTotal_ConstantBlock(keys)
	if keys.damage >= self.heal_damage_interrupt then
		self:Destroy()
	end
end
function modifier_sukuna_p_f_cursed_heal:OnAbilityExecuted(keys)
	if keys.unit ~= self._hParent or IsNull(keys.ability) then return end
	if TableContains(self.tAbilitiesInterrupt, keys.ability:GetAbilityName()) then
		self:Destroy()
	end
end
function modifier_sukuna_p_f_cursed_heal:OnCreated(tInfo)
	self._hCaster  = self:GetCaster()
	self._hParent  = self:GetParent()
	self._hAbility = self:GetAbility()

	self.heal_per_second = self._hAbility:GetSpecialValueFor("heal_per_second")
	self.heal_damage_interrupt = self._hAbility:GetSpecialValueFor("heal_damage_interrupt")

	self.tAbilitiesInterrupt =
	{
		"sukuna_m_q",
		"sukuna_m_w",
		"sukuna_m_e",
		"sukuna_m_d",
		"sukuna_b_q",
		"sukuna_b_w",
		"sukuna_b_e",
		"sukuna_b_d",
	}
end
function modifier_sukuna_p_f_cursed_heal:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_sukuna_p_f_cursed_heal:GetEffectName()
	return "particles/heroes/sukuna/sukuna_reverse/sukuna_reverse_heal.vpcf"
end
function modifier_sukuna_p_f_cursed_heal:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end