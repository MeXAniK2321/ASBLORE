modifier_ice_chance = class({})

--------------------------------------------------------------------------------

function modifier_ice_chance:IsDebuff()
	return true
end

function modifier_ice_chance:IsStunDebuff()
	return false
end
function modifier_ice_chance:IsHidden()
	return false
end
function modifier_ice_chance:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_ice_chance:OnCreated( kv )
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

		self.sound_target = "Pandora.ice"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end
function modifier_ice_chance:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_ice_chance:OnDestroy( kv )
	-- references

		self.sound_target = "Pandora.ice"
		StopSoundOn( self.sound_target, self:GetParent() )
	end


--------------------------------------------------------------------------------

function modifier_ice_chance:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}

	return funcs
end

function modifier_ice_chance:GetModifierMoveSpeedBonus_Percentage()
	return -50
end
function modifier_ice_chance:GetDisableHealing()
	return 1
end

--------------------------------------------------------------------------------

function modifier_ice_chance:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff_frost.vpcf"
end

function modifier_ice_chance:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end