modifier_poison_chance = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_poison_chance:IsHidden()
	return false
end

function modifier_poison_chance:IsDebuff()
	return true
end

function modifier_poison_chance:IsStunDebuff()
	return false
end

function modifier_poison_chance:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_poison_chance:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "poison_damage" )
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
		self.sound_target = "Pandora.poison"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_poison_chance:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "poison_damage" )
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

function modifier_poison_chance:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_poison_chance:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_poison_chance:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_poison_chance:GetEffectName()
	return "particles/econ/items/viper/viper_ti7_immortal/viper_poison_crimson_debuff_ti7.vpcf"
end

function modifier_poison_chance:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end