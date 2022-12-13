modifier_taboo_and_there_will_be_nothing = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_taboo_and_there_will_be_nothing:IsHidden()
	return false
end

function modifier_taboo_and_there_will_be_nothing:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_taboo_and_there_will_be_nothing:IsStunDebuff()
	return true
end

function modifier_taboo_and_there_will_be_nothing:IsPurgable()
	return true
end

function modifier_taboo_and_there_will_be_nothing:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_taboo_and_there_will_be_nothing:OnCreated( kv )
	-- references

	self.radius = 25
	

	if not IsServer() then return end
	local caster = self:GetCaster()
	-- precache damage
	if caster:HasModifier( "modifier_lunatic_nightmare" )  then
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + 3000
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	self:GetParent():AddNoDraw()
	self:PlayEffects()
	else
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	
	-- ApplyDamage(damageTable)

	-- play effects
	self:GetParent():AddNoDraw()
	self:PlayEffects()
end
end


function modifier_taboo_and_there_will_be_nothing:OnRefresh( kv )
	-- references

	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end
	-- update damage
	self.damageTable.damage = self.damage
end

function modifier_taboo_and_there_will_be_nothing:OnRemoved()
end

function modifier_taboo_and_there_will_be_nothing:OnDestroy()
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

	-- play effects
	self:GetParent():RemoveNoDraw()
	local sound_loop = "flandr.murder"
	StopSoundOn( sound_loop, self:GetCaster() )
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_end1", {} )
	local sound_cast = "flandr.murder2"
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_taboo_and_there_will_be_nothing:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_taboo_and_there_will_be_nothing:PlayEffects()
	-- Get Resources
	local particle_cast1 = ""
	local particle_cast2 = ""
	local sound_loop = "flandr.murder"
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	CustomGameEventManager:Send_ServerToPlayer(Player, "emit_video7", {} )
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_loop, self:GetCaster() )
end
