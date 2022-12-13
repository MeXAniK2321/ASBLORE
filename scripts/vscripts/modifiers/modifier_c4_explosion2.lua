modifier_c4_explosion2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_c4_explosion2:IsHidden()
	return false
end

function modifier_c4_explosion2:IsDebuff()
	return true
end

function modifier_c4_explosion2:IsStunDebuff()
	return false
end

function modifier_c4_explosion2:IsPurgable()
	return false
end

function modifier_c4_explosion2:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_c4_explosion2:OnCreated( kv )
	-- references
	self.duration = 1
	

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	local sound_cast = ""
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_c4_explosion2:OnRefresh( kv )
	
end

function modifier_c4_explosion2:OnRemoved()
end

function modifier_c4_explosion2:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_c4_explosion2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end



function modifier_c4_explosion2:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end

	-- silence
	self:Silence()
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_c4_explosion2:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_c4_explosion2:Silence()

	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- play effects
	self:PlayEffects()

	local sound_cast = ""
	StopSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations

function modifier_c4_explosion2:PlayEffects()
	-- stop sound
	local sound_end = "deidara.c1_explode"
	StopSoundOn( sound_end, self:GetParent() )
	
	-- Get Resources
	local particle_cast = "particles/deidara_c1.vpcf"
	local sound_target = "deidara.c1_explode"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end
