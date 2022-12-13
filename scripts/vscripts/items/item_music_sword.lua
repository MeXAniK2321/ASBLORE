LinkLuaModifier("modifier_music_sword", "items/item_music_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_music_sword_stat", "items/item_music_sword", LUA_MODIFIER_MOTION_NONE)

item_music_sword = class({})

function item_music_sword:GetIntrinsicModifierName()
    return "modifier_music_sword"
	end


modifier_music_sword = class({})


function modifier_music_sword:IsHidden()
    return true
end
function modifier_music_sword:RemoveOnDeath() return false end
function modifier_music_sword:IsPurgable()
    return false
end
function modifier_music_sword:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_music_sword:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_music_sword:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_music_sword:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end

function modifier_music_sword:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_music_sword:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_music_sword:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_music_sword:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_music_sword:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_music_sword:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                       