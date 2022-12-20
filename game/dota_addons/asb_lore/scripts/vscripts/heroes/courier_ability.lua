courier_ability = class({})
LinkLuaModifier( "modifier_courier_ability", "heroes/courier_ability", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function courier_ability:GetIntrinsicModifierName()
	return "modifier_courier_ability"
end
modifier_courier_ability = class({})

function modifier_courier_ability:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,
    }

    return funcs
end

function modifier_courier_ability:GetModifierMoveSpeed_Max( params )
    return 1100
end

function modifier_courier_ability:GetModifierMoveSpeed_Limit( params )
    return 1100
end

function modifier_courier_ability:GetModifierIgnoreMovespeedLimit( params )
    return 1
end

function modifier_courier_ability:IsHidden()
    return true
end
function modifier_courier_ability:GetBonusNightVision()
    return -9999999
end
function modifier_courier_ability:GetBonusDayVision()

    return -999999

end

function modifier_courier_ability:GetModifierMoveSpeedBonus_Percentage()
	return 9999999999
end

function modifier_courier_ability:CheckState()
    local state = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
         [MODIFIER_STATE_MUTED] = true,
         [MODIFIER_STATE_NO_HEALTH_BAR] = true,
    }
    return state
end