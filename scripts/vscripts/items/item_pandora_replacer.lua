item_pandora_replacer = class({})

LinkLuaModifier( "modifier_replaced", "items/item_pandora_replacer", LUA_MODIFIER_MOTION_NONE )
function item_pandora_replacer:OnSpellStart()
	local caster = self:GetCaster()
	
	
	self:SpendCharge()

	local gold = caster:GetGold()
	local xp = caster:GetCurrentXP()
caster:AddNewModifier(caster, self, "modifier_replaced", {})
	--local hero = CreateUnitByName("npc_dota_hero_sniper", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
	--PlayerResource:GetPlayer(caster:GetPlayerOwnerID()):SetAssignedHeroEntity(hero)
	local hero = PlayerResource:ReplaceHeroWith(caster:GetPlayerOwnerID(), "npc_dota_hero_death_prophet", 0, 0)
	


    hero:ModifyGold(gold - hero:GetGold(), true, 0)
    hero:AddExperience(xp - hero:GetCurrentXP(), 0, false, false)

	local cast_fx = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
					ParticleManager:ReleaseParticleIndex(cast_fx)

	local table_sounds = {	"Pandora.0" }

	EmitSoundOn(table_sounds[RandomInt(1, #table_sounds)], hero)
	--self:SpendCharge()




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

	for _,ally in pairs(enemies) do
	local item = ally:FindItemInInventory("item_pandora_replacer")
  item:SpendCharge()
  end
end
modifier_replaced = class ({})
function modifier_replaced:IsHidden() return true end
function modifier_replaced:IsDebuff() return false end
function modifier_replaced:IsPurgable() return false end
function modifier_replaced:IsPurgeException() return false end
function modifier_replaced:RemoveOnDeath() return false end