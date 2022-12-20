deidara_boom = class({})

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function deidara_boom:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function deidara_boom:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local targets = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC

	-- load data
	local radius = 500
	

	-- precache int and damage
	
	local damageTable = {
		-- victim = target,
		attacker = caster,
		-- damage = 500,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	
	local allies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		targets,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
local Player = PlayerResource:GetPlayer(caster:GetPlayerID())
    
	for _,ally in pairs(allies) do
		
		
		if ally:HasModifier( "modifier_c1_explosion" ) or ally:HasModifier( "modifier_c4_explosion" ) or ally:GetUnitName() == "npc_dota_c4_deidara"  then							
				damageTable.victim = ally								
				damageTable.damage = 4000			 
				ApplyDamage(damageTable)
				EmitSoundOnClient("deidara.boom", Player)
				end
	  if ally:HasModifier( "modifier_c1_centipide_root" ) then
	 ally:RemoveModifierByName("modifier_c1_centipide_root")
	  EmitSoundOnClient("deidara.boom", Player)
	  end


end
end

