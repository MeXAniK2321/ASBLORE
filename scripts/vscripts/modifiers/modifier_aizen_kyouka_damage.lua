modifier_aizen_kyouka_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aizen_kyouka_damage:IsHidden()
	return true
end

function modifier_aizen_kyouka_damage:IsDebuff()
	return true
end

function modifier_aizen_kyouka_damage:IsStunDebuff()
	return false
end

function modifier_aizen_kyouka_damage:IsPurgable()
	return true
end

function modifier_aizen_kyouka_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_aizen_kyouka_damage:OnCreated( kv )
	-- references
	self.duration = 0.8
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	
	
end

function modifier_aizen_kyouka_damage:OnRefresh( kv )
	
end

function modifier_aizen_kyouka_damage:OnRemoved()
end

function modifier_aizen_kyouka_damage:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_aizen_kyouka_damage:DeclareFunctions()
	local funcs = {
		

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_aizen_kyouka_damage:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end

	-- silence
	self:Silence()
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_aizen_kyouka_damage:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_aizen_kyouka_damage:Silence()
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



	-- destroy
	self:Destroy()
end

