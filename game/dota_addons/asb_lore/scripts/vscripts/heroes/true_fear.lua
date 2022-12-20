true_fear = class({})
LinkLuaModifier( "modifier_true_fear", "heroes/true_fear", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_true_fear_astral", "heroes/true_fear", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- AOE Radius
function true_fear:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function true_fear:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local damage = self:GetSpecialValueFor("nova_damage")
	local radius = self:GetSpecialValueFor("radius")
	local debuffDuration = self:GetSpecialValueFor("duration")

	local vision_radius = 900
	local vision_duration = 6

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- Precache damage	 
	
	caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_true_fear_astral", -- modifier name
			{ duration = 2.234 } -- kv
		)
		
	for _,enemy in pairs(enemies) do
		-- Apply damage
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 2.25 } -- kv
		)
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_true_fear", -- modifier name
			{ duration = 2.234 } -- kv
		)
	

		-- Add modifier
		
	end

	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision_radius, vision_duration, true )
local sound_cast = "chara.5"
		EmitSoundOn( sound_cast, caster )
	self:PlayEffects( point, radius, debuffDuration )
end

--------------------------------------------------------------------------------
-- Ability Considerations
function true_fear:AbilityConsiderations()
	-- Scepter
	local bScepter = caster:HasScepter()

	-- Linken & Lotus
	local bBlocked = target:TriggerSpellAbsorb( self )

	-- Break
	local bBroken = caster:PassivesDisabled()

	-- Advanced Status
	local bInvulnerable = target:IsInvulnerable()
	local bInvisible = target:IsInvisible()
	local bHexed = target:IsHexed()
	local bMagicImmune = target:IsMagicImmune()

	-- Illusion Copy
	local bIllusion = target:IsIllusion()
end

--------------------------------------------------------------------------------
function true_fear:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/chara_true_fear_new.vpcf"
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
modifier_true_fear = class({})

--------------------------------------------------------------------------------

function modifier_true_fear:IsHidden()
    return false
end

function modifier_true_fear:IsPurgable()
    return false
end
function modifier_true_fear:RemoveOnDeath()
    return true
end
function modifier_true_fear:OnCreated()
local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
CustomGameEventManager:Send_ServerToPlayer(Player, "touch_the_child", {} )
end
function modifier_true_fear:OnDestroy()
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	CustomGameEventManager:Send_ServerToPlayer(Player, "screamer_end1", {} )
end

--------------------------------------------------------------------------------

function modifier_true_fear:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end



modifier_true_fear_astral = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_true_fear_astral:IsHidden()
	return false
end

function modifier_true_fear_astral:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_true_fear_astral:IsStunDebuff()
	return true
end

function modifier_true_fear_astral:IsPurgable()
	return true
end

function modifier_true_fear_astral:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_true_fear_astral:OnCreated( kv )

	self:GetParent():AddNoDraw()
	self:PlayEffects()
	
end




function modifier_true_fear_astral:OnRemoved()
end

function modifier_true_fear_astral:OnDestroy()

	self:GetParent():RemoveNoDraw()
	self:PlayEffects2()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_true_fear_astral:CheckState()
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
function modifier_true_fear_astral:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/frisk_blur.vpcf"
	local particle_cast2 = ""
	

	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	
end
function modifier_true_fear_astral:PlayEffects2()
	-- Get Resources
	local particle_cast1 = "particles/frisk_blur.vpcf"
	local particle_cast2 = ""
	

	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetParent():GetOrigin() )

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast2, PATTACH_WORLDORIGIN, nil, self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	
end