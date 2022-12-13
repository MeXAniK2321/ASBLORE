modifier_void_spirit_astral_step_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_void_spirit_astral_step_lua:IsHidden()
	return false
end

function modifier_void_spirit_astral_step_lua:IsDebuff()
	return true
end

function modifier_void_spirit_astral_step_lua:IsStunDebuff()
	return false
end

function modifier_void_spirit_astral_step_lua:IsPurgable()
	return true
end

function modifier_void_spirit_astral_step_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_void_spirit_astral_step_lua:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "pop_damage" )
	self.slow = -self:GetAbility():GetSpecialValueFor( "movement_slow_pct" )
end

function modifier_void_spirit_astral_step_lua:OnRefresh( kv )
	
end  

function modifier_void_spirit_astral_step_lua:OnRemoved()
end

function modifier_void_spirit_astral_step_lua:OnDestroy()
	if not IsServer() then return end

  
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	
	
	

	-- play effects
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_void_spirit_astral_step_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_void_spirit_astral_step_lua:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_void_spirit_astral_step_lua:GetEffectName()
	return "particles/void_spirit_astral_step_debuff1.vpcf"
end

function modifier_void_spirit_astral_step_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_void_spirit_astral_step_lua:GetStatusEffectName()
	return "particles/void_spirit_astral_step_debuff1.vpcf"
end

function modifier_void_spirit_astral_step_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_void_spirit_astral_step_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/void_spirit_astral_step_dmg1.vpcf"
	local sound_target = "ikki.tsunou"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end