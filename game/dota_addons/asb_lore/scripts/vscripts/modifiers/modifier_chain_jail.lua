modifier_chain_jail = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chain_jail:IsHidden()
	return false
end

function modifier_chain_jail:IsDebuff()
	return true
end

function modifier_chain_jail:IsStunDebuff()
	return false
end

function modifier_chain_jail:IsPurgable()
if self:GetCaster():HasModifier("modifier_emperor_time") then
return false 
else
	return true
	end
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_chain_jail:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage_per_second_tooltip" )+ self:GetCaster():FindTalentValue("special_bonus_kurapika_25")
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
		self.sound_target = "kurapika.3"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_chain_jail:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage_per_second_tooltip" ) + self:GetCaster():FindTalentValue("special_bonus_kurapika_25")
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

function modifier_chain_jail:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_chain_jail:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_chain_jail:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_chain_jail:GetEffectName()
	return "particles/chain_jail.vpcf"
end

function modifier_chain_jail:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end