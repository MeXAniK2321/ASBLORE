item_pandora_treasure = class({})
LinkLuaModifier("modifier_treasure_taken", "items/item_pandora_treasure", LUA_MODIFIER_MOTION_NONE)
function item_pandora_treasure:IsStealable() return true end
function item_pandora_treasure:IsHiddenWhenStolen() return false end
function item_pandora_treasure:OnSpellStart()
	local caster = self:GetCaster()
	if self:GetCaster():HasModifier("modifier_treasure_taken") then
	else
	self:SpendCharge(0)
	caster:AddNewModifier(caster, self, "modifier_treasure_taken", {})
	local item = CreateItem("item_last_star", caster, self)
	    caster:AddItem(item)
		end
	


end
modifier_treasure_taken = class ({})
function modifier_treasure_taken:IsHidden() return true end
function modifier_treasure_taken:IsDebuff() return false end
function modifier_treasure_taken:IsPurgable() return false end
function modifier_treasure_taken:IsPurgeException() return false end
function modifier_treasure_taken:RemoveOnDeath() return false end