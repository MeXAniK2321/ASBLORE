item_pikachu_replacer = class({})

LinkLuaModifier( "modifier_replaced", "items/item_pikachu_replacer", LUA_MODIFIER_MOTION_NONE )
function item_pikachu_replacer:OnSpellStart()
	local caster = self:GetCaster()
	local player = caster
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	local arcana1 = 418417801   --Chumba
	local arcana2 = 167912041	--Miku
    local arcana6 = 222299685	--Kepchila
	local arcana7 = 117795030   --Tlen
	self:SpendCharge(0)
	if id32 == arcana1 then
	self.hero = "npc_dota_hero_bane"
	elseif id32 == arcana2 then
	self.hero = "npc_dota_hero_terrorblade"
	elseif id32 == arcana6 then
	self.hero = "npc_dota_hero_dragon_knight"
	elseif id32 == arcana7 then
    self.hero = "npc_dota_hero_dragon_knight"
	else
	self.hero = "npc_dota_hero_beastmaster"
	end
	local gold = caster:GetGold()
	local xp = caster:GetCurrentXP()
caster:AddNewModifier(caster, self, "modifier_replaced", {})
	--local hero = CreateUnitByName("npc_dota_hero_sniper", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
	--PlayerResource:GetPlayer(caster:GetPlayerOwnerID()):SetAssignedHeroEntity(hero)
	local hero = PlayerResource:ReplaceHeroWith(caster:GetPlayerOwnerID(), self.hero, 0, 0)
	


    hero:ModifyGold(gold - hero:GetGold(), true, 0)
    hero:AddExperience(xp - hero:GetCurrentXP(), 0, false, false)

	local cast_fx = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
					ParticleManager:ReleaseParticleIndex(cast_fx)

	local table_sounds = {	"gay.hammer" }

	EmitSoundOn(table_sounds[RandomInt(1, #table_sounds)], hero)
	--self:SpendCharge(0)




	if caster and not caster:IsNull() and IsValidEntity(caster) then
		UTIL_Remove(caster)
	end
	hero:AddNewModifier(caster, self, "modifier_replaced", {})
	
	local enemies = FindUnitsInRadius(
		hero:GetTeamNumber(),	-- int, your team number
		hero:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	
end
modifier_replaced = class ({})
function modifier_replaced:IsHidden() return true end
function modifier_replaced:IsDebuff() return false end
function modifier_replaced:IsPurgable() return false end
function modifier_replaced:IsPurgeException() return false end
function modifier_replaced:RemoveOnDeath() return false end