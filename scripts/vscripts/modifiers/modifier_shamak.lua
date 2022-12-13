modifier_shamak = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_shamak:IsHidden()
	return false
end

function modifier_shamak:IsDebuff()
	return true
end

function modifier_shamak:IsStunDebuff()
	return false
end

function modifier_shamak:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_shamak:OnCreated( kv )
	
	self.armor = self:GetAbility():GetSpecialValueFor( "root" )


	if not IsServer() then return end
	if not self.thinker then return end

	-- precache damage
	
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( interval )





end

function modifier_shamak:OnRefresh( kv )
	
end

function modifier_shamak:OnRemoved()
end

function modifier_shamak:OnDestroy()
	if not IsServer() then return end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_shamak:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_SILENCED] = true,
		
		
	}

	return state
end
function modifier_shamak:DeclareFunctions()
local func = {
 MODIFIER_PROPERTY_FIXED_DAY_VISION,
 MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
 MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
 }
 return func
end
function modifier_shamak:GetModifierMoveSpeedBonus_Percentage()
	return self.armor
end
function modifier_shamak:GetFixedNightVision()
	return 10
end
function modifier_shamak:GetFixedDayVision()
	return 10
end

