modifier_geass_suicide = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_geass_suicide:IsHidden()
	return false
end

function modifier_geass_suicide:IsDebuff()
	return true
end

function modifier_geass_suicide:IsStunDebuff()
	return false
end

function modifier_geass_suicide:IsPurgable()
	return true
end

function modifier_geass_suicide:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_geass_suicide:OnCreated( kv )
	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	
end

function modifier_geass_suicide:OnRefresh( kv )
	
end

function modifier_geass_suicide:OnRemoved()
end

function modifier_geass_suicide:OnDestroy()
	if not IsServer() then return end

    if self:GetCaster():HasModifier( "modifier_item_ultimate_scepter" ) then
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	else
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	end

	-- play effects
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_geass_suicide:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_geass_suicide:GetEffectName()
	return ""
end

function modifier_geass_suicide:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_geass_suicide:GetStatusEffectName()
	return ""
end

function modifier_geass_suicide:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end


function modifier_geass_suicide:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/geass_suicide.vpcf"
	local sound_target = "lulu.suicide"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end