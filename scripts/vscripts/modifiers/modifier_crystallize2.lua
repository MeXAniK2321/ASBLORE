modifier_crystallize2 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_crystallize2:IsHidden()
	return false
end

function modifier_crystallize2:IsDebuff()
	return true
end

function modifier_crystallize2:IsStunDebuff()
	return false
end

function modifier_crystallize2:IsPurgable()
	return true
end

function modifier_crystallize2:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_crystallize2:OnCreated( kv )
	-- references
	self.duration = 0.5
	self.damage = 600

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	
end

function modifier_crystallize2:OnRefresh( kv )
	
end

function modifier_crystallize2:OnRemoved()
end

function modifier_crystallize2:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_crystallize2:CheckState()
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

function modifier_crystallize2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_crystallize2:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end


--------------------------------------------------------------------------------
-- Interval Effects
function modifier_crystallize2:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_crystallize2:Silence()
	-- add silence
	

	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )



	local sound_cast = "shu.5_2"
	EmitSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end
function modifier_crystallize2:GetEffectName()
	return "particles/shu_crystall_debuff.vpcf"
end
function modifier_crystallize2:GetStatusEffectName()
	return "particles/test_effect.vpcf"
end
function modifier_crystallize2:StatusEffectPriority(  )
	return MODIFIER_PRIORITY_ULTRA
end