earth_negation = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earth_negation_astral", "heroes/earth_negation", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function earth_negation:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()



	local radius = 300
	
	local debuffDuration = 1.5



if target:TriggerSpellAbsorb( self ) then return end

	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection


	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )

	-- load data
   caster:AddNewModifier(caster, self, "modifier_earth_negation_astral", {duration = 0.4})	
	
	
	
	

end


modifier_earth_negation_astral = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_earth_negation_astral:IsHidden()
	return false
end

function modifier_earth_negation_astral:IsDebuff()
	return false
end

function modifier_earth_negation_astral:IsStunDebuff()
	return true
end

function modifier_earth_negation_astral:IsPurgable()
	return true
end

function modifier_earth_negation_astral:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_earth_negation_astral:OnCreated( kv )
	
	self:PlayEffects()
	self:GetParent():AddNoDraw()
end




function modifier_earth_negation_astral:OnRemoved()
end

function modifier_earth_negation_astral:OnDestroy()
	if not IsServer() then return end


	local caster = self:GetCaster()


	self:GetParent():RemoveNoDraw()

	
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
	local damage = self:GetAbility():GetSpecialValueFor( "damage" ) 
	local duration = self:GetAbility():GetSpecialValueFor( "stun_duration" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	
	
 local knockback = { should_stun = 1,
                        knockback_duration = 1,5,
                        duration = 1.5,
                        knockback_distance = 0,
                        knockback_height = -180,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }
local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
			for _,enemy in pairs(enemies) do
    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)
damageTable.victim = enemy	
	ApplyDamage(damageTable)
	end
	local point = caster:GetOrigin()
	local radius = 350
		self:PlayEffects( point, radius, 2 )
		self:PlayEffects2( point, radius, 2 )
	EmitSoundOn("Pandora.3", caster)
end
function modifier_earth_negation_astral:PlayEffects2( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/earth_negation.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_earth_negation_astral:CheckState()
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
function modifier_earth_negation_astral:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/vergil_blur.vpcf"
	local particle_cast2 = ""


	-- Create Particle
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast1, 0, self:GetCaster():GetOrigin() )

	
	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	

end

