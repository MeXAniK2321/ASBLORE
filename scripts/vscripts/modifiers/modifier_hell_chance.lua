modifier_hell_chance = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_hell_chance:IsHidden()
	return false
end

function modifier_hell_chance:IsDebuff()
	return true
end

function modifier_hell_chance:IsStunDebuff()
	return false
end

function modifier_hell_chance:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_hell_chance:OnCreated( kv )
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
		self.sound_target = "Pandora.fire"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_hell_chance:OnRefresh( kv )
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

function modifier_hell_chance:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_hell_chance:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_hell_chance:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_hell_chance:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_hell_chance:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end