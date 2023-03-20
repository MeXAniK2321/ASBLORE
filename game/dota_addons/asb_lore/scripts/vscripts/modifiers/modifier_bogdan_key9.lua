modifier_bogdan_key9 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_bogdan_key9:IsHidden()
	return false
end
function modifier_bogdan_key9:OnCreated()
self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

end

function modifier_bogdan_key9:IsDebuff()
	return true
end

function modifier_bogdan_key9:IsStunDebuff()
	return false
end

function modifier_bogdan_key9:IsPurgable()
	return true
end

function modifier_bogdan_key9:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------


function modifier_bogdan_key9:OnRefresh( kv )
	
end

function modifier_bogdan_key9:OnRemoved()
end

function modifier_bogdan_key9:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_bogdan_key9:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_bogdan_key9:GetEffectName()
	return "particles/hurk_cum1.vpcf"
end

function modifier_bogdan_key9:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end