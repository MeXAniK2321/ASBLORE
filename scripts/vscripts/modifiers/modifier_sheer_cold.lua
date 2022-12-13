modifier_sheer_cold = class({})

--------------------------------------------------------------------------------

function modifier_sheer_cold:IsDebuff()
	return true
end

function modifier_sheer_cold:IsStunDebuff()
	return false
end
function modifier_sheer_cold:IsHidden()
	return false
end
function modifier_sheer_cold:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
function modifier_sheer_cold:OnCreated( kv )
	local tick_damage = 70 
	self.interval = 0.25

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
function modifier_sheer_cold:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_sheer_cold:OnDestroy( kv )
	-- references

		
	end


--------------------------------------------------------------------------------

function modifier_sheer_cold:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}

	return funcs
end

function modifier_sheer_cold:GetModifierMoveSpeedBonus_Percentage()
	return -20
end
function modifier_sheer_cold:GetDisableHealing()
	return 1
end

--------------------------------------------------------------------------------

function modifier_sheer_cold:GetEffectName()
	return "particles/units/heroes/hero_abaddon/abaddon_curse_frostmourne_debuff_frost.vpcf"
end

function modifier_sheer_cold:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end