modifier_sunshine = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_sunshine:IsHidden()
	return false
end

function modifier_sunshine:IsDebuff()
	return true
end

function modifier_sunshine:IsStunDebuff()
	return false
end

function modifier_sunshine:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_sunshine:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	self.interval = 1

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
		self.sound_target = "escanor.burn"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_sunshine:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "burn_damage" ) + self:GetCaster():FindTalentValue("special_bonus_escanor_25")
	self.interval = 1

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

function modifier_sunshine:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_sunshine:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_sunshine:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_sunshine:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_sunshine:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end