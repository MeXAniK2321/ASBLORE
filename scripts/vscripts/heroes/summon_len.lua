summon_len = class({})
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)

function summon_len:OnSpellStart()
	if not IsServer() then return end
    local caster = self:GetCaster()
    local player = caster:GetPlayerID()
    local level = self:GetLevel()
    local origin = caster:GetAbsOrigin() + RandomVector(100)
	local duration = 30
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})

    if self.len and IsValidEntity(self.len) and self.len:IsAlive() then
        FindClearSpaceForUnit(self.len, origin, true)
        self.len:SetHealth(self.len:GetMaxHealth())
        
    else
        self.len = CreateUnitByName("npc_dota_len_"..level, origin, true, caster, caster, caster:GetTeamNumber())
        self.len:SetControllableByPlayer(player, true)
        
    end
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cooldown"))
end