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