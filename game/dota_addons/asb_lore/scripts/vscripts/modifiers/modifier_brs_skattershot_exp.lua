modifier_brs_skattershot_exp = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_brs_skattershot_exp:IsHidden()
	return false
end

function modifier_brs_skattershot_exp:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_brs_skattershot_exp:IsStunDebuff()
	return true
end

function modifier_brs_skattershot_exp:IsPurgable()
	return true
end

function modifier_brs_skattershot_exp:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_brs_skattershot_exp:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.radius = 300
	

	if not IsServer() then return end
	local caster = self:GetCaster()
	-- precache damage
	

	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	
	
	

end



function modifier_brs_skattershot_exp:OnRefresh( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.radius = 300

	if not IsServer() then return end
	-- update damage
	self.damageTable.damage = damage
end

function modifier_brs_skattershot_exp:OnRemoved()
end

function modifier_brs_skattershot_exp:OnDestroy()
	if not IsServer() then return end
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play overhead event
		SendOverheadEventMessage(
			nil,
			OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,
			self:GetParent(),
			self.damageTable.damage,
			nil
		)
	end

end

--------------------------------------------------------------------------------
-- Status Effects


--------------------------------------------------------------------------------
-- Graphics & Animations
