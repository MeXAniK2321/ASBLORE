LinkLuaModifier("modifier_item_knife", "items/item_nanaya_knife", LUA_MODIFIER_MOTION_NONE)

item_nanaya_knife = class({})

function item_nanaya_knife:GetIntrinsicModifierName()
    return "modifier_item_knife"
	end


modifier_item_knife = class({})


function modifier_item_knife:IsHidden()
    return true
end
function modifier_item_knife:RemoveOnDeath() return false end
function modifier_item_knife:IsPurgable()
    return false
end
function modifier_item_knife:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	if IsServer() then
            EmitGlobalSound("nanaya.kill")
            EmitGlobalSound("nanaya.heart")
            self.parent:FindAbilityByName("nanaya_blood"):SetLevel(2)
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
            self.parent:FindAbilityByName("nanaya_slashes"):SetLevel(1)
                self.parent:SwapAbilities("nanaya_slashes", "nanaya_blood", true, false)
	end
end

function modifier_item_knife:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_knife:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end


function modifier_item_knife:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('hp')
end

function modifier_item_knife:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('str')
end

function modifier_item_knife:GetModifierPreAttack_BonusDamage()
return self:GetAbility():GetSpecialValueFor('dmg')
end
                 