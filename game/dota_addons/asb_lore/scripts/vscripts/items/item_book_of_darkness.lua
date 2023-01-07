LinkLuaModifier("modifier_book_of_darknaass", "items/item_book_of_darkness", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_book_of_darknaass_stat", "items/item_book_of_darkness", LUA_MODIFIER_MOTION_NONE)

item_book_of_darkness = class({})

function item_book_of_darkness:GetIntrinsicModifierName()
    return "modifier_book_of_darknaass"
end

function item_book_of_darkness:OnSpellStart()
    if(self.dummy ~= nil and self.dummy:IsAlive()  ) then
        self.dummy:ForceKill(false)
    end
    self.dummy = CreateUnitByName("reinforce_toilet", self:GetCaster():GetAbsOrigin() +
    self:GetCaster():GetForwardVector() * 100 + Vector(0, 0, 150), true, self:GetCaster(), self:GetCaster(),
    self:GetCaster():GetTeamNumber())
	self.dummy:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
     
    self.dummy:SetForwardVector(self:GetCaster():GetForwardVector())
end

modifier_book_of_darknaass = class({})


function modifier_book_of_darknaass:IsHidden()
    return true
end
function modifier_book_of_darknaass:RemoveOnDeath() return false end
function modifier_book_of_darknaass:IsPurgable()
    return false
end
function modifier_book_of_darknaass:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_book_of_darknaass:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_book_of_darknaass:DeclareFunctions()
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

function modifier_book_of_darknaass:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_book_of_darknaass:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_book_of_darknaass:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
                  