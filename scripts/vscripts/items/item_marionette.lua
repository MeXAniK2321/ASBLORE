LinkLuaModifier("modifier_item_marionette", "items/item_marionette", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_marionette_aura", "items/item_marionette", LUA_MODIFIER_MOTION_NONE)
item_marionette = class({})

function item_marionette:GetIntrinsicModifierName()
    return "modifier_item_marionette"
end

modifier_item_marionette = class({})

function modifier_item_marionette:IsHidden()
	return true
end

function modifier_item_marionette:IsPurgable()
    return false
end

function modifier_item_marionette:DeclareFunctions()
    local funcs = {
        
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        
		
    }

    return funcs
end


function modifier_item_marionette:GetModifierBonusStats_Intellect()
    return 30
end

function modifier_item_marionette:IsAura()
	return true
end

function modifier_item_marionette:GetModifierAura()
	return "modifier_item_marionette_aura"
end

function modifier_item_marionette:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_item_marionette:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED
end


function modifier_item_marionette:GetAuraRadius()
	return 99999
end

modifier_item_marionette_aura = class({})

function modifier_item_marionette_aura:IsHidden()
	return true
end

function modifier_item_marionette_aura:AllowIllusionDuplicate()
	return true
end

function modifier_item_marionette_aura:IsPurgable()
    return false
end

function modifier_item_marionette_aura:DeclareFunctions()
    local funcs = {
	    MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        
		
    }

    return funcs
end
function modifier_item_marionette_aura:GetModifierMoveSpeedBonus_Constant()
   
	return 45
	
end

function modifier_item_marionette_aura:GetModifierSpellAmplify_Percentage()

    return 55
end
