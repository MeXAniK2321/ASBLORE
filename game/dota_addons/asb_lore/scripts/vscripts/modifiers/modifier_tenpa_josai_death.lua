modifier_tenpa_josai_death = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tenpa_josai_death:IsHidden()
	return false
end

function modifier_tenpa_josai_death:IsDebuff()
	return false
end
function modifier_tenpa_josai_death:RemoveOnDeath() return true end
function modifier_tenpa_josai_death:IsStunDebuff()
	return false
end

function modifier_tenpa_josai_death:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tenpa_josai_death:OnCreated( kv )
	-- references
	local damage = 99999
	

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetParent(),
		damage = 9999999,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 0.2 )
end

function modifier_tenpa_josai_death:OnRefresh( kv )
	-- references
	local damage = 999999
	

	if not IsServer() then return end

	-- update damage
	self.damageTable.damage = damage	
end

function modifier_tenpa_josai_death:OnRemoved()
end

function modifier_tenpa_josai_death:OnDestroy()
end

-- Interval Effects
function modifier_tenpa_josai_death:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_tenpa_josai_death:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_tenpa_josai_death:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end