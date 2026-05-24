require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_switch_mp = class({})
sukuna_switch_mp._sukuna_stance =
{
	{
		"sukuna_m_q",
		"sukuna_p_q",
	},
	{
		"sukuna_m_w",
		"sukuna_p_w",
	},
	{
		"sukuna_m_e",
		"sukuna_p_e",
	},
	{
		"sukuna_m_d",
		"sukuna_p_d",
	},
	{
		"sukuna_switch_book",
		"sukuna_p_f",
	},
}

-- function sukuna_switch_mp:OnAbilityUpgrade(hAbility)
-- 	print("dsada")
-- 	local hCaster = self:GetCaster()
-- 	for _, tAbilities in ipairs(self._sukuna_stance) do
-- 		if TableContains(tAbilities, hAbility:GetAbilityName()) then
-- 			local nLevel = hAbility:GetLevel()
-- 			for _, sAbilityName in ipairs(tAbilities) do
-- 				local _hAbility = hCaster:FindAbilityByName(sAbilityName)
-- 				if IsNotNull(_hAbility) and _hAbility ~= hAbility then
-- 					_hAbility:SetLevel(nLevel)
-- 				end
-- 			end
-- 		end
-- 	end
-- end
function sukuna_switch_mp:ResetToggleOnRespawn()
	return false
end
-- function sukuna_switch_mp:OnOwnerDied()									end
-- function sukuna_switch_mp:OnOwnerSpawned()
-- 	if type(self._bGetToggleState) == "boolean"
-- 		and self._bGetToggleState ~= self:GetToggleState() then
-- 		self:ToggleAbility()
-- 	end
-- 	return self.BaseClass.OnOwnerSpawned(self)
-- end
function sukuna_switch_mp:GetAbilityTextureName()
	if self:GetToggleState() then
		return "heroes/sukuna/sukuna_switch_mp_mage"
	end
	return self.BaseClass.GetAbilityTextureName(self)
end
function sukuna_switch_mp:OnToggle()
	local hCaster = self:GetCaster()

	self:SwitchStance(self:GetToggleState())
end
function sukuna_switch_mp:SwitchStance(bSwitch)
	local hCaster = self:GetCaster()

	-- local hBook = hCaster:FindAbilityByName("sukuna_switch_book")
	-- if IsNotNull(hBook) then

	-- end

	for _, tAbils in ipairs(self._sukuna_stance) do
		local hAbility1 = hCaster:FindAbilityByName(tAbils[1])
		local hAbility2 = hCaster:FindAbilityByName(tAbils[2])
		if bSwitch then
			if not hAbility1:IsHidden() and hAbility2:IsHidden() then
				hCaster:SwapAbilities(tAbils[1], tAbils[2], false, true)
			end
		else
			if hAbility1:IsHidden() and not hAbility2:IsHidden() then
				hCaster:SwapAbilities(tAbils[1], tAbils[2], true, false)
			end
		end
	end
end



item_sukuna_switch_mp = class(sukuna_switch_mp)
item_sukuna_switch_mp._sukuna_stance = sukuna_switch_mp._sukuna_stance



item_sukuna_switch_mp_box = class(sukuna_switch_mp)
item_sukuna_switch_mp_box._sukuna_stance = sukuna_switch_mp._sukuna_stance


function item_sukuna_switch_mp_box:Spawn()
-- 	if not IsServer() then return end
-- 	Timers:CreateTimer(0.1, function()
-- 	local hCaster = self:GetCaster()
-- 	local hOld = hCaster:FindItemInInventory("item_sukuna_switch_mp")
-- 	if IsNotNull(hOld) then
-- 		hCaster:SwapItems(hOld:GetItemSlot(), self:GetItemSlot())
-- 		hCaster:RemoveItem(hOld)
-- 	end
-- end)
end
function item_sukuna_switch_mp_box:GetIntrinsicModifierName()
	return "modifier_item_sukuna_switch_mp_box"
end


--====================================================================================================--
LinkLuaModifier("modifier_item_sukuna_switch_mp_box", "heroes/sukuna/sukuna_switch_mp", LUA_MODIFIER_MOTION_NONE)

modifier_item_sukuna_switch_mp_box = class({})

function modifier_item_sukuna_switch_mp_box:IsHidden()												return true end
function modifier_item_sukuna_switch_mp_box:RemoveOnDeath()											return false end
function modifier_item_sukuna_switch_mp_box:IsPurgable()												return false end
function modifier_item_sukuna_switch_mp_box:GetAttributes()											return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_sukuna_switch_mp_box:DeclareFunctions()
	local t =
	{
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return t
end
function modifier_item_sukuna_switch_mp_box:OnCreated(hTable)
	self.caster  = self:GetCaster()
	self.parent  = self:GetParent()
	self.ability = self:GetAbility()
	
	self.iBonusDmg	  = self.ability:GetSpecialValueFor("bonus_attk_damage")
	self.iBonusHealth   = self.ability:GetSpecialValueFor("bonus_health")
	self.iBonusAllStats = self.ability:GetSpecialValueFor("bonus_allstats")
	self.iBonusSpellAmp = self.ability:GetSpecialValueFor("bonus_spell_amp")

	if IsServer() and IsNotNull(self.parent) and not self.parent:HasScepter() then
		self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end
function modifier_item_sukuna_switch_mp_box:GetModifierPreAttack_BonusDamage()
	return self.iBonusDmg
end
function modifier_item_sukuna_switch_mp_box:GetModifierHealthBonus()
	return self.iBonusHealth
end
function modifier_item_sukuna_switch_mp_box:GetModifierBonusStats_Strength()
	return self.iBonusAllStats
end
function modifier_item_sukuna_switch_mp_box:GetModifierBonusStats_Agility()
	return self.iBonusAllStats
end
function modifier_item_sukuna_switch_mp_box:GetModifierBonusStats_Intellect()
	return self.iBonusAllStats
end
function modifier_item_sukuna_switch_mp_box:GetModifierSpellAmplify_Percentage()
	return self.iBonusSpellAmp
end



