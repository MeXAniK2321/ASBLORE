modifier_rental_goa = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_rental_goa:IsHidden()
	return false
end

function modifier_rental_goa:IsDebuff()
	return true
end

function modifier_rental_goa:IsStunDebuff()
	return false
end

function modifier_rental_goa:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_rental_goa:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage" )+ self:GetCaster():FindTalentValue("special_bonus_subaru_20") -- special value
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
		self.sound_target = "subaru.2_1"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_rental_goa:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "damage" )+ self:GetCaster():FindTalentValue("special_bonus_subaru_20") -- special value
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

function modifier_rental_goa:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_rental_goa:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_rental_goa:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_rental_goa:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_rental_goa:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end