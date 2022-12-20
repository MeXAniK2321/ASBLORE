sans_control = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sans_control_damage", "heroes/sans_control", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function sans_control:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()



if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetAbilityDamage()
	local duration = self:GetSpecialValueFor( "stun_duration" )


 local knockback = { should_stun = 1,
                        knockback_duration = 1.5,
                        duration = 1.5,
                        knockback_distance = 0,
                        knockback_height = 400,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    target:AddNewModifier(caster, self, "modifier_knockback", knockback)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sans_control_damage", -- modifier name
		{ duration = 1.49 } -- kv
	)
	
	
	self:PlayEffects(target)
	EmitSoundOn("Sans.up", caster)
end
function sans_control:PlayEffects( target )
	local particle_cast = "particles/sans_gravity_control_start.vpcf"
    local radius = 300

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end



modifier_sans_control_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sans_control_damage:IsHidden()
	return true
end

function modifier_sans_control_damage:IsDebuff()
	return true
end

function modifier_sans_control_damage:IsStunDebuff()
	return false
end

function modifier_sans_control_damage:IsPurgable()
	return true
end

function modifier_sans_control_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sans_control_damage:OnCreated( kv )
	-- references
	self.duration = 1.49
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	
	
end

function modifier_sans_control_damage:OnRefresh( kv )
	
end

function modifier_sans_control_damage:OnRemoved()
end

function modifier_sans_control_damage:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_sans_control_damage:DeclareFunctions()
	local funcs = {
		

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sans_control_damage:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_sans_control_damage:Silence()
	-- add silence
	

	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )


self:PlayEffects(300)
	self:Destroy()
end

function modifier_sans_control_damage:PlayEffects( radius )
	local particle_cast = "particles/centaur_warstomp1.vpcf"
	local sound_cast = "sans.impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
