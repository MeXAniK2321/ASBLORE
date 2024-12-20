LinkLuaModifier("modifier_book_of_darknaass", "items/item_book_of_darkness", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_book_of_darknaass_stat", "items/item_book_of_darkness", LUA_MODIFIER_MOTION_NONE)

item_book_of_darkness = class({})

function item_book_of_darkness:GetIntrinsicModifierName()
    return "modifier_book_of_darknaass"
end

function item_book_of_darkness:OnSpellStart()
    local hCaster = self:GetCaster()

    local vRespawnPos = hCaster:GetAbsOrigin() + hCaster:GetForwardVector() * 100

    self.hReinforcePet = self.hReinforcePet or CreateUnitByName("reinforce_toilet", vRespawnPos, true, hCaster, hCaster, hCaster:GetTeamNumber())
    self.hReinforcePet:RespawnUnit()
    self.hReinforcePet:SetForwardVector(hCaster:GetForwardVector())
    self.hReinforcePet:SetAbsOrigin(vRespawnPos)
    self.hReinforcePet:FaceTowards(hCaster:GetAbsOrigin() + hCaster:GetForwardVector() * 150)
    self.hReinforcePet:SetUnitCanRespawn(true)
    self.hReinforcePet:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), false)
    
    self.hReinforcePet:AddNewModifier(hCaster, self, "modifier_kill", {duration = 30})
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
                  