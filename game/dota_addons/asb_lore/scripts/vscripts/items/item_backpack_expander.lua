LinkLuaModifier( "modifier_item_backpack_expander", "items/item_backpack_expander", LUA_MODIFIER_MOTION_NONE )

item_backpack_expander = item_backpack_expander or class({})

function item_backpack_expander:CastFilterResult()
    if IsServer() then
	    if self:GetCaster():HasModifier("modifier_item_backpack_expander") then
			return UF_FAIL_CUSTOM
	    end
	    
		return UF_SUCCESS
    end
end
function item_backpack_expander:OnSpellStart()
    local hCaster = self:GetCaster()
	
	if hCaster:HasModifier("modifier_item_backpack_expander") then
	    return
	end
	
	hCaster:AddNewModifier(hCaster, self, "modifier_item_backpack_expander", {})
	self:SpendCharge(0)
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_backpack_expander = class({})

function modifier_item_backpack_expander:IsHidden() return false end
function modifier_item_backpack_expander:IsDebuff() return false end
function modifier_item_backpack_expander:IsPurgable() return false end
function modifier_item_backpack_expander:IsPurgeException() return false end
function modifier_item_backpack_expander:RemoveOnDeath() return false end
function modifier_item_backpack_expander:GetTexture()
    return "backpack_expander"
end
function modifier_item_backpack_expander:CheckState()
	local func = {	
	                [MODIFIER_STATE_CAN_USE_BACKPACK_ITEMS] = true
				 }	
	
	return func
end
function modifier_item_backpack_expander:OnCreated(tInfo)
	local hParent = self:GetParent()

	if not IsServer() then return end

	for i = DOTA_ITEM_SLOT_7, DOTA_ITEM_SLOT_9 do
		local hItem = hParent:GetItemInSlot(i)
		if IsNotNull(hItem) then
			-- hCaster:TakeItem(hItem)
			-- hCaster:AddItem(hItem)
			hItem:SetItemState(1)
			hItem:RefreshIntrinsicModifier()
		end
	end

	hParent:CalculateStatBonus(true)
end
function modifier_item_backpack_expander:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_item_backpack_expander:OnDestroy()
	local hParent = self:GetParent()

	for i = DOTA_ITEM_SLOT_7, DOTA_ITEM_SLOT_9 do
		local hItem = hParent:GetItemInSlot(i)
		if IsNotNull(hItem) then
			hItem:SetItemState(0)
			hParent:RemoveModifierByNameAndCaster(hItem:GetIntrinsicModifierName(), hParent)
		end
	end

	hParent:CalculateStatBonus(true)
end