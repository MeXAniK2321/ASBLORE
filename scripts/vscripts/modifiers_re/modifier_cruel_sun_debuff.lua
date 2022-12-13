modifier_cruel_sun_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_cruel_sun_debuff:IsHidden()
	return false
end

function modifier_cruel_sun_debuff:IsDebuff()
	return true
end

function modifier_cruel_sun_debuff:IsStunDebuff()
	return true
end

function modifier_cruel_sun_debuff:IsPurgable()
	return true
end

function modifier_cruel_sun_debuff:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_cruel_sun_debuff:OnCreated( kv )
	if not IsServer() then return end
	self.projectile = kv.projectile
	
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = 1000,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )
	local sound_cast = "escanor.4_1"
	EmitSoundOn( sound_cast, self:GetParent() )
	
	
	
end

function modifier_cruel_sun_debuff:OnRefresh( kv )
end

function modifier_cruel_sun_debuff:OnRemoved()
	if not IsServer() then return end
	-- destroy tree
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 120, false )
end

function modifier_cruel_sun_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_cruel_sun_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_cruel_sun_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_cruel_sun_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_cruel_sun_debuff:GetEffectName()
	return "particles/sunshine1.vpcf"
end

function modifier_cruel_sun_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_cruel_sun_debuff:GetStatusEffectName()
	return "particles/status_effect_mars_spear2.vpcf"
end
