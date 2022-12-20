LinkLuaModifier("modifier_item_shinigami", "items/item_shinigami", LUA_MODIFIER_MOTION_NONE)

item_shinigami = class({})

function item_shinigami:GetIntrinsicModifierName()
    return "modifier_item_shinigami"
	end


modifier_item_shinigami = class({})


function modifier_item_shinigami:IsHidden()
    return true
end
function modifier_item_shinigami:RemoveOnDeath() return false end
function modifier_item_shinigami:IsPurgable()
    return false
end
function modifier_item_shinigami:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
    self.parent:AddNewModifier(self.parent, self.parent:FindAbilityByName("ichigoF"), "modifier_ebaniyzhazj", 
{
                max_count = 2,
                start_count = 2,
                replenish_time = self.parent:FindAbilityByName("ichigoF"):GetCooldown(1)
            }
        )

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_item_shinigami:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_shinigami:DeclareFunctions()
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


function modifier_item_shinigami:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_item_shinigami:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('str')
end

function modifier_item_shinigami:GetModifierPreAttack_BonusDamage()
return self:GetAbility():GetSpecialValueFor('dmg')
end
                 