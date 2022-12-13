LinkLuaModifier("modifier_rhitta", "items/item_rhitta", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rhitta_stat", "items/item_rhitta", LUA_MODIFIER_MOTION_NONE)

item_rhitta = class({})

function item_rhitta:GetIntrinsicModifierName()
    return "modifier_rhitta"
	end


modifier_rhitta = class({})


function modifier_rhitta:IsHidden()
    return true
end
function modifier_rhitta:RemoveOnDeath() return false end
function modifier_rhitta:IsPurgable()
    return false
end
function modifier_rhitta:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_rhitta:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_rhitta:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }

    return funcs
end



function modifier_rhitta:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_rhitta:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_rhitta:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_rhitta:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end

function modifier_rhitta:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

                  