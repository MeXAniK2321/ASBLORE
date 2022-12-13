modifier_watermelon_hit_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_watermelon_hit_damage:IsHidden()
	return true
end

function modifier_watermelon_hit_damage:IsDebuff()
	return false
end

function modifier_watermelon_hit_damage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_watermelon_hit_damage:OnCreated( kv )
	-- references

	self.bonus_crit = self:GetAbility():GetSpecialValueFor( "crit_mult" )
end

function modifier_watermelon_hit_damage:OnRefresh( kv )
end

function modifier_watermelon_hit_damage:OnRemoved()
end

function modifier_watermelon_hit_damage:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_watermelon_hit_damage:DeclareFunctions()
	local funcs = {
	
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}

	return funcs
end


function modifier_watermelon_hit_damage:GetModifierPreAttack_CriticalStrike( params )
	return self.bonus_crit
end