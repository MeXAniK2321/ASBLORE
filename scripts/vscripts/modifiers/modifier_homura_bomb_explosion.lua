modifier_homura_bomb_explosion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_homura_bomb_explosion:IsHidden()
	return true
end

function modifier_homura_bomb_explosion:IsDebuff()
	return false
end

function modifier_homura_bomb_explosion:IsPurgable()
	return false
end

function modifier_homura_bomb_explosion:OnCreated()
		
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_homura_bomb_explosion:OnDestroy( kv )
    self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = 1000000 ,
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(), --Optional.
		}
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- damage enemies
	for _,enemy in pairs(enemies) do
	if enemy:HasModifier( "modifier_explosion2" )  then
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		
		
		end
	end
	
end

function modifier_homura_bomb_explosion:OnRefresh( kv )
	
end

function modifier_homura_bomb_explosion:OnRemoved()
end







