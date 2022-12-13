circle_gaster_blaster = class({})
LinkLuaModifier( "modifier_circle_gaster_blaster", "heroes/sans", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function circle_gaster_blaster:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function circle_gaster_blaster:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 1.5

	-- load data
	local delay = self:GetSpecialValueFor("delay")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_circle_gaster_blaster", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	local radius = 400
	if self:GetCaster():HasModifier("modifier_last_breath_form") then
		self:EndCooldown()
		self:StartCooldown(6)
		self:PlayEffects2( point, radius, duration )
		else
	self:PlayEffects( point, radius, duration )
	end
	
end
function circle_gaster_blaster:PlayEffects( point, radius, duration )
self.caster = self:GetCaster()
		self.arena_barrier11 = "particles/test_circle_blasters.vpcf"
	
	self.arena_barrier = ParticleManager:CreateParticle( self.arena_barrier11, PATTACH_WORLDORIGIN, self.caster )
	ParticleManager:SetParticleControl( self.arena_barrier, 0, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 1, Vector( radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.arena_barrier, 2, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 3, point )
	ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )
	ParticleManager:ReleaseParticleIndex( self.arena_barrier )


	local sound_cast = "Sans.Gaster"

	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
function circle_gaster_blaster:PlayEffects2( point, radius, duration )
self.caster = self:GetCaster()
		self.arena_barrier11 = "particles/test_circle_blasters_last_breath.vpcf"
	
	self.arena_barrier = ParticleManager:CreateParticle( self.arena_barrier11, PATTACH_WORLDORIGIN, self.caster )
	ParticleManager:SetParticleControl( self.arena_barrier, 0, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 1, Vector( radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.arena_barrier, 2, point )
	ParticleManager:SetParticleControl( self.arena_barrier, 3, point )
	ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )
	ParticleManager:ReleaseParticleIndex( self.arena_barrier )


	local sound_cast = "Sans.Gaster"

	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
modifier_circle_gaster_blaster = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_circle_gaster_blaster:IsHidden()
	return true
end

function modifier_circle_gaster_blaster:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_circle_gaster_blaster:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	local damage = self:GetAbility():GetAbilityDamage()

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_circle_gaster_blaster:OnRefresh( kv )
	
end

function modifier_circle_gaster_blaster:OnRemoved()
end

function modifier_circle_gaster_blaster:OnDestroy()
	if not IsServer() then return end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = self.duration } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	
	

	UTIL_Remove( self:GetParent() )
end



sans_evade = class({})


function sans_evade:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
	  if not IsServer() then return nil end
    local caster = self:GetCaster()
	local max_range = self:GetSpecialValueFor("blink_range")
	local direction = (point - origin)
	if direction:Length2D() > max_range then
		direction = direction:Normalized() * max_range
	end
	FindClearSpaceForUnit( caster, origin + direction, true )
	local radius = self:GetSpecialValueFor("radius")
	
	local duration = self:GetSpecialValueFor("duration")
	
	self:PlayEffects( origin, direction )
	if self:GetCaster():HasModifier("modifier_last_breath_form") then
		self:EndCooldown()
		self:StartCooldown(0.5)
		end
end

--------------------------------------------------------------------------------
function sans_evade:PlayEffects( origin, direction )
	-- Get Resources
	local particle_cast_a = "particles/sans_evade.vpcf"
	local sound_cast_a = "Sans.blink"


	

	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( particle_cast_a, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	-- At original position
	

end




LinkLuaModifier("modifier_sans_multiple_boner_thunder",   "heroes/sans", LUA_MODIFIER_MOTION_NONE)

sans_multiple_boner = class({})



function sans_multiple_boner:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function sans_multiple_boner:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()
local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
	 if enemy:HasModifier("modifier_bad_time_thinker_in") or enemy:HasModifier("modifier_last_breath_thinker_in") then
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_sans_multiple_boner_thunder", -- modifier name
		{ duration = 1 }, -- kv
		enemy:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
	local radius = 300
	local point = enemy:GetOrigin()
	self:PlayEffects(point,radius,1)
	end
	end
	if self:GetCaster():HasModifier("modifier_last_breath_form") then
		self:EndCooldown()
		self:StartCooldown(5)
		end

end
function sans_multiple_boner:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/sans_boner_sigh.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	
end

modifier_sans_multiple_boner_thunder = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sans_multiple_boner_thunder:IsHidden()
	return true
end

function modifier_sans_multiple_boner_thunder:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sans_multiple_boner_thunder:OnCreated( kv )
	if not IsServer() then return end
	local caster = self:GetCaster()

	-- references
	self.duration = 0.2
	self.radius = 350
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
	--Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_sans_multiple_boner_thunder:OnRefresh( kv )
	
end

function modifier_sans_multiple_boner_thunder:OnRemoved()
end

function modifier_sans_multiple_boner_thunder:OnDestroy()
	if not IsServer() then return end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		350,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
		enemy:AddNewModifier(
			self:GetCaster(), -- player source
			self:GetAbility(), -- ability source
			"modifier_stunned", -- modifier name
			{ duration = 1.0 } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sans_multiple_boner_thunder:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/boner.vpcf"
	local sound_cast = "Sans.boner"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

sans_global_shortcut = class({})


function sans_global_shortcut:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
    local caster = self:GetCaster()
	local max_range = self:GetSpecialValueFor("blink_range")
	local direction = (point - origin)
	if direction:Length2D() > max_range then
		direction = direction:Normalized() * max_range
	end
	FindClearSpaceForUnit( caster, origin + direction, true )
	
		local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetCaster():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- stun
	self:PlayEffects2(enemy)
	end

	-- play effects
	self:PlayEffects()
	local radius = self:GetSpecialValueFor("radius")
	
	local duration = self:GetSpecialValueFor("duration")
	
	self:PlayEffects()
	
end

--------------------------------------------------------------------------------
function sans_global_shortcut:PlayEffects()
	-- Get Resources
	local particle_cast_a = "particles/sans_evade.vpcf"
	local sound_cast_a = "Sans.blink"

 local caster = self:GetCaster()
	local origin = caster:GetOrigin()

	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( particle_cast_a, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	-- At original position
	

end
function sans_global_shortcut:PlayEffects2(target)
	-- Get Resources
	local particle_cast = "particles/all_fiction_screen2.vpcf"
	 if not IsServer() then return end
    if not target:IsIllusion() then
        local Player = PlayerResource:GetPlayer(target:GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end
