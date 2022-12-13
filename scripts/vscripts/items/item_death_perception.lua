LinkLuaModifier("modifier_item_death_perception", "items/item_death_perception", LUA_MODIFIER_MOTION_NONE)
 

item_death_perception = class({})

function item_death_perception:GetIntrinsicModifierName()
    return "modifier_item_death_perception"
	end


    modifier_item_death_perception = class({})


function modifier_item_death_perception:IsHidden()
    return true
end
function modifier_item_death_perception:RemoveOnDeath() return false end
function modifier_item_death_perception:IsPurgable()
    return false
end
function modifier_item_death_perception:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_item_death_perception:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_death_perception:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }

    return funcs
end

function modifier_item_death_perception:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_item_death_perception:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('int')
end
function modifier_item_death_perception:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('agi')
end