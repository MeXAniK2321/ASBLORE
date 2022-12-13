modifier_crystallize = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_crystallize:IsHidden()
	return false
end

function modifier_crystallize:IsDebuff()
	return true
end

function modifier_crystallize:IsStunDebuff()
	return true
end

function modifier_crystallize:IsPurgable()
	return false
end

function modifier_crystallize:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_crystallize:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	
end

function modifier_crystallize:OnRefresh( kv )
	
end

function modifier_crystallize:OnRemoved()
end

function modifier_crystallize:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_crystallize:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

function modifier_crystallize:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_crystallize:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_crystallize:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_crystallize:Silence()
	-- add silence
	

	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- play effects

	local sound_cast = "shu.5_2"
	EmitSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end
function modifier_crystallize:GetEffectName()
	return "particles/shu_crystall_debuff.vpcf"
end
function modifier_crystallize:GetStatusEffectName()
	return "particles/test_effect.vpcf"
end
function modifier_crystallize:StatusEffectPriority(  )
	return MODIFIER_PRIORITY_ULTRA
end