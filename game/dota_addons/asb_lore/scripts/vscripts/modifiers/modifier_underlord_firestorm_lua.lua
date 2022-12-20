modifier_underlord_firestorm_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_underlord_firestorm_lua:IsHidden()
	return false
end

function modifier_underlord_firestorm_lua:IsDebuff()
	return true
end

function modifier_underlord_firestorm_lua:IsStunDebuff()
	return false
end

function modifier_underlord_firestorm_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_underlord_firestorm_lua:OnCreated( kv )
	-- references
	if not IsServer() then return end
	local interval = kv.interval
	self.damage_pct = kv.damage

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		-- damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( interval )
end

function modifier_underlord_firestorm_lua:OnRefresh( kv )
	if not IsServer() then return end
	self.damage_pct = kv.damage
end

function modifier_underlord_firestorm_lua:OnRemoved()
end

function modifier_underlord_firestorm_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_underlord_firestorm_lua:OnIntervalThink()
	-- check health
	local damage = self.damage_pct

	-- apply damage
	self.damageTable.damage = damage
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_underlord_firestorm_lua:GetEffectName()
	return "particles/abyssal_underlord_firestorm_wave_burn1.vpcf"
end

function modifier_underlord_firestorm_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end