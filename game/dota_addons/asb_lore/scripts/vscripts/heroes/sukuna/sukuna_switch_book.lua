require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_switch_book = class({})
sukuna_switch_book._sukuna_book =
{
	{
		"sukuna_m_q",
		"sukuna_b_q",
	},
	{
		"sukuna_m_w",
		"sukuna_b_w",
	},
	{
		"sukuna_m_e",
		"sukuna_b_e",
	},
	{
		"sukuna_m_d",
		"sukuna_b_d",
	},
}

sukuna_switch_book._sukuna_stance =
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

function sukuna_switch_book:OnAbilityUpgrade(hAbility)
	local hCaster = self:GetCaster()
	local tBookOnly =
	{
		"sukuna_p_f",
		"sukuna_switch_book",
		"sukuna_b_q",
		"sukuna_b_w",
		"sukuna_b_e",
		"sukuna_b_d",
	}

	local nLevel = hAbility:GetLevel()

	if TableContains(tBookOnly, hAbility:GetAbilityName()) then
		for _, sAbilityName in ipairs(tBookOnly) do
			local _hAbility = hCaster:FindAbilityByName(sAbilityName)
			if IsNotNull(_hAbility) and _hAbility ~= hAbility then
				_hAbility:SetLevel(nLevel)
			end
		end
	end

	for _, tAbilities in pairs(self._sukuna_stance) do
		if TableContains(tAbilities, hAbility:GetAbilityName()) then
			for _, sAbilityName in ipairs(tAbilities) do
				local _hAbility = hCaster:FindAbilityByName(sAbilityName)
				if IsNotNull(_hAbility) and _hAbility ~= hAbility then
					_hAbility:SetLevel(nLevel)
				end
			end
		end
	end
end
function sukuna_switch_book:ResetToggleOnRespawn() --NOTE: For abilities looks work this line correctly for die/spawn/respawn and state saves
	return false
end
-- function sukuna_switch_book:OnOwnerDied()									end
-- function sukuna_switch_book:OnOwnerSpawned()
-- 	if type(self._bGetToggleState) == "boolean"
-- 		and self._bGetToggleState ~= self:GetToggleState() then
-- 		self:ToggleAbility()
-- 	end
-- 	return self.BaseClass.OnOwnerSpawned(self)
-- end
function sukuna_switch_book:GetAbilityTextureName()
	if self:GetToggleState() then
		return "heroes/sukuna/sukuna_switch_book_close"
	end
	return self.BaseClass.GetAbilityTextureName(self)
end
function sukuna_switch_book:OnToggle()
	local hCaster = self:GetCaster()

	self:SwitchBook(self:GetToggleState())
end
function sukuna_switch_book:SwitchBook(bSwitch)
	local hCaster = self:GetCaster()
	for _, tAbils in ipairs(self._sukuna_book) do
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
function sukuna_switch_book:Spawn()
	if not IsServer() then return end
	local hCaster = self:GetCaster()
	local hSwitchBook = hCaster:FindItemInInventory("item_sukuna_switch_mp")
	local hSwitchBookBox = hCaster:FindItemInInventory("item_sukuna_switch_mp_box")
	if IsNotNull(hSwitchBook) or IsNotNull(hSwitchBookBox) then return end
	hCaster:AddItemByName("item_sukuna_switch_mp")

	Timers:CreateTimer(1, function()
		if IsNotNull(hCaster) then
			local hItemNOW = hCaster:GetItemInSlot(DOTA_ITEM_NEUTRAL_ACTIVE_SLOT)
			if hCaster:HasScepter() then
				if IsNotNull(hItemNOW) and hItemNOW:GetAbilityName() ~= "item_sukuna_switch_mp_box" then
					hCaster:RemoveItem(hItemNOW)
					hCaster:AddItemByName("item_sukuna_switch_mp_box")
				end
			else
				if IsNotNull(hItemNOW) and hItemNOW:GetAbilityName() ~= "item_sukuna_switch_mp" then
					hCaster:RemoveItem(hItemNOW)
					hCaster:AddItemByName("item_sukuna_switch_mp")
				end
			end
		end
		return 1
	end)
end
