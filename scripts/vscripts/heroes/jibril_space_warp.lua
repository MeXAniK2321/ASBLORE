jibril_space_warp = class({})
LinkLuaModifier( "modifier_dark_willow_terrorize_lua", "modifiers/modifier_dark_willow_terrorize_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function jibril_space_warp:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()



	local radius = 300
	
	local debuffDuration = 1.5



if target:TriggerSpellAbsorb( self ) then return end

	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = caster:GetOrigin() + blinkDirection
	  
	target:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( target, blinkPosition, true )

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) 
	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)
 
target:AddNewModifier(caster, self, "modifier_dark_willow_terrorize_lua", {duration = 2})
	
	caster:MoveToTargetToAttack(target)
	
	
	self:PlayEffects( point, radius, debuffDuration )
	EmitSoundOn("jibril.4", caster)
end
function jibril_space_warp:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/jibril_space_warp.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

