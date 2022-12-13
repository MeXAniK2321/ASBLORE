return_from_death = class({})
LinkLuaModifier( "modifier_return_from_death", "modifiers/modifier_return_from_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_return_from_death_buff", "modifiers/modifier_return_from_death_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
-- Passive Modifier
function return_from_death:GetIntrinsicModifierName()
	return "modifier_return_from_death"
end
function return_from_death:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("unthinkable_present")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end