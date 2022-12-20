gaster_blaster = class({})
LinkLuaModifier("modifier_gaster_blaster", "heroes/gaster_blaster", LUA_MODIFIER_MOTION_NONE)


--------------------------------------------------------------------------------
-- Ability Start
function gaster_blaster:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("sans_punch")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function gaster_blaster:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)
	self.offset  = Vector(0, 0, 200)
	local spawn_point = caster:GetAbsOrigin() + self.offset
	local position = spawn_point
	if target then
		point = target:GetOrigin()
	end

 local ice_unit = CreateModifierThinker(caster, self, "modifier_gaster_blaster", {duration = 0.7, point = spawn_point}, position, caster:GetTeamNumber(), true)
		ice_unit:SetForwardVector(caster:GetForwardVector())
		if self:GetCaster():HasModifier("modifier_last_breath_form") then
		self:EndCooldown()
		self:StartCooldown(1)
		local delay = 0.7
		Timers:CreateTimer(delay,function()	
	local projectile_name = "particles/gaster_blaster_last_breath.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "dragon_slave_distance" )
	local projectile_speed = self:GetSpecialValueFor( "dragon_slave_speed" )
	local projectile_start_radius = self:GetSpecialValueFor( "dragon_slave_width_initial" )
	local projectile_end_radius = self:GetSpecialValueFor( "dragon_slave_width_end" )

	-- get direction
	local direction = point-caster:GetOrigin()
	direction.z = 0
	local projectile_direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	
	
	self:PlayEffects1( caster, radius, debuffDuration )
	end)
		else
	local delay = 0.7
		Timers:CreateTimer(delay,function()	
	local projectile_name = "particles/gaster_blaster.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "dragon_slave_distance" )
	local projectile_speed = self:GetSpecialValueFor( "dragon_slave_speed" )
	local projectile_start_radius = self:GetSpecialValueFor( "dragon_slave_width_initial" )
	local projectile_end_radius = self:GetSpecialValueFor( "dragon_slave_width_end" )

	-- get direction
	local direction = point-caster:GetOrigin()
	direction.z = 0
	local projectile_direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	
	
	self:PlayEffects1( caster, radius, debuffDuration )
	end)
	end
	
	
end

--------------------------------------------------------------------------------
-- Projectile
function gaster_blaster:OnProjectileHitHandle( target, location, projectile )
	if not target then return end

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = self:GetAbilityDamage(),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()

	-- play effects
	self:PlayEffects( target, direction )
end
function gaster_blaster:PlayEffects1( caster,duration )
	-- Get Resources
	local particle_cast = ""
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	

	-- Create Sound
	
end

--------------------------------------------------------------------------------
function gaster_blaster:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end



modifier_gaster_blaster = class({})
function modifier_gaster_blaster:IsHidden() return true end
function modifier_gaster_blaster:IsDebuff() return false end
function modifier_gaster_blaster:IsPurgable() return false end
function modifier_gaster_blaster:IsPurgeException() return false end
function modifier_gaster_blaster:RemoveOnDeath() return true end
function modifier_gaster_blaster:CheckState()
    local state = { [MODIFIER_STATE_INVULNERABLE] = true,
	                                            [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,}
    return state
end
function modifier_gaster_blaster:OnCreated(kv)
    if IsServer() then
	local caster = self:GetParent()
	self.point = kv.point
	EmitSoundOn("Sans.gaster", caster )
if self:GetCaster():HasItemInInventory("item_chomusuke") then
self:PlayEffects2()
else	
        self:GetParent():SetOriginalModel("models/sans/untitled.vmdl")
        self:GetParent():SetModelScale(0.14)
		end
		self:StartIntervalThink(0.69)
		self:PlayEffects1()
    end
end
function modifier_gaster_blaster:OnIntervalThink()

self:PlayEffects()
if self:GetCaster():HasItemInInventory("item_chomusuke") then
EmitSoundOn("Sans.tom_blaster", self:GetParent() )
end
end

function modifier_gaster_blaster:PlayEffects()
	local particle_cast = "particles/gaster_blaster_shockwave.vpcf"
	local radius = 300

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin())
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_gaster_blaster:PlayEffects1()
	local particle_cast = "particles/test_gaster_blaster_light.vpcf"
	local radius = 300

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin())
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_gaster_blaster:PlayEffects2()
	local particle_cast = "particles/test_bad_tom_blaster.vpcf"
	local radius = 300

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin())
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
