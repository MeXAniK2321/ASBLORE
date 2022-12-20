item_pukachu_replacer = class({})

LinkLuaModifier( "modifier_replaced", "items/item_pukachu_replacer", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pukachu_replaced", "modifiers/modifier_pukachu_replaced", LUA_MODIFIER_MOTION_NONE )
function item_pukachu_replacer:GetIntrinsicModifierName()
    return "modifier_pukachu_replaced"
end
modifier_replaced = class ({})
function modifier_replaced:IsHidden() return true end
function modifier_replaced:IsDebuff() return false end
function modifier_replaced:IsPurgable() return false end
function modifier_replaced:IsPurgeException() return false end
function modifier_replaced:RemoveOnDeath() return false end