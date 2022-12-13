LinkLuaModifier("modifier_item_dress", "items/item_dress", LUA_MODIFIER_MOTION_NONE)

item_dress = class({})

function item_dress:GetIntrinsicModifierName()
    return "modifier_item_dress"
end

modifier_item_dress = class({})

function modifier_item_dress:IsHidden()
	return true
end

function modifier_item_dress:AllowIllusionDuplicate()
	return true
end
function modifier_item_dress:OnCreated()
	self.ability = self:GetAbility()
end
function modifier_item_dress:IsPurgable()
    return false
end

function modifier_item_dress:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, 
MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
   MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		
		
    }

    return funcs
end

function modifier_item_dress:GetModifierMagicalResistanceBonus()
if self:GetParent():HasItemInInventory("item_serp_molot") then
return 0

else
    return 15
end
end
function modifier_item_dress:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor('hp_regen')
end
function modifier_item_dress:GetModifierConstantManaRegen()
    return self:GetAbility():GetSpecialValueFor('mp_regen')
end