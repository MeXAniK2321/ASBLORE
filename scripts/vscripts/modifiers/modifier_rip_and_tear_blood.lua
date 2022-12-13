modifier_rip_and_tear_blood = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_rip_and_tear_blood:IsHidden()
	return false
end

function modifier_rip_and_tear_blood:IsDebuff()
	return true
end

function modifier_rip_and_tear_blood:IsStunDebuff()
	return false
end

function modifier_rip_and_tear_blood:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_rip_and_tear_blood:OnCreated( kv )
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

		
	end
end

function modifier_rip_and_tear_blood:OnRefresh( kv )
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

function modifier_rip_and_tear_blood:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_rip_and_tear_blood:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_rip_and_tear_blood:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_rip_and_tear_blood:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_rip_and_tear_blood:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end