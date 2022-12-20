modifier_war_chance = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_war_chance:IsHidden()
	return false
end

function modifier_war_chance:IsDebuff()
	return true
end

function modifier_war_chance:IsStunDebuff()
	return false
end

function modifier_war_chance:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_war_chance:OnCreated( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "war_damage" )
	

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		ApplyDamage( self.damageTable )

		-- Start interval
	

		-- Play Effects
		self.sound_target = "Pandora.war"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_war_chance:OnRefresh( kv )
	-- references
	local tick_damage = self:GetAbility():GetSpecialValueFor( "war_damage" )
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
		

		-- Play Effects
		self.sound_target = ""
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_war_chance:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_war_chance:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false,
	[MODIFIER_STATE_DISARMED] = true
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_war_chance:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_war_chance:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end