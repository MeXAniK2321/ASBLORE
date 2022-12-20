modifier_generic_burn = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_generic_burn:IsHidden()
	return false
end

function modifier_generic_burn:IsDebuff()
	return true
end

function modifier_generic_burn:IsStunDebuff()
	return false
end

function modifier_generic_burn:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_generic_burn:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 0.5 )
end

function modifier_generic_burn:OnRefresh( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "burn_damage" )
	

	if not IsServer() then return end

	-- update damage
	self.damageTable.damage = damage	
end

function modifier_generic_burn:OnRemoved()
end

function modifier_generic_burn:OnDestroy()
end

-- Interval Effects
function modifier_generic_burn:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_generic_burn:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_generic_burn:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end