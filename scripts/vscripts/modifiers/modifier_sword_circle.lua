modifier_sword_circle = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sword_circle:IsHidden()
	return false
end

function modifier_sword_circle:IsDebuff()
	return true
end

function modifier_sword_circle:IsStunDebuff()
	return false
end

function modifier_sword_circle:IsPurgable()
	return false
end

function modifier_sword_circle:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sword_circle:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_vergil_20")

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( 2 )

	-- play effects
	local sound_cast = ""
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_sword_circle:OnRefresh( kv )
	
end

function modifier_sword_circle:OnRemoved()
end

function modifier_sword_circle:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sword_circle:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_sword_circle:Silence()
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
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_sword_circle_blood", -- modifier name
		{ duration = 2.5 } -- kv
	)

	-- play effects
	self:PlayEffects()

	local sound_cast = "vergil.1"
	StopSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sword_circle:GetEffectName()
	return "particles/sword_circle.vpcf"
end

function modifier_sword_circle:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_sword_circle:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/sword_circle_exp.vpcf"
	local sound_cast = "vergil.1_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
modifier_sword_circle_blood = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sword_circle_blood:IsHidden()
	return false
end

function modifier_sword_circle_blood:IsDebuff()
	return true
end

function modifier_sword_circle_blood:IsStunDebuff()
	return false
end

function modifier_sword_circle_blood:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sword_circle_blood:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "bleed_damage" )
	self.interval = 0.5

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- Play Effects
		self.sound_target = ""
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_sword_circle_blood:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "bleed_damage" ) -- special value
	self.interval = 0.5

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- Play Effects
		self.sound_target = ""
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_sword_circle_blood:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_sword_circle_blood:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sword_circle_blood:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sword_circle_blood:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_sword_circle_blood:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end