modifier_muken = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_muken:IsHidden()
	return false
end

function modifier_muken:IsDebuff()
	return true
end

function modifier_muken:IsStunDebuff()
	return false
end

function modifier_muken:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_muken:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "bleed_damage" )+ self:GetCaster():FindTalentValue("special_bonus_mori_20") -- special value
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
		self.sound_target = "mori.1_1"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_muken:OnRefresh( kv )
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

function modifier_muken:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_muken:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_muken:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_muken:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_muken:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end