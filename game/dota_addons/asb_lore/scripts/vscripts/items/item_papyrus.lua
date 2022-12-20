LinkLuaModifier("modifier_papyrus", "items/item_papyrus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_papyrus_stat", "items/item_papyrus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_blue_bones", "heroes/boner.lua", LUA_MODIFIER_MOTION_NONE )
item_papyrus = class({})
function item_papyrus:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

if caster:HasModifier("modifier_blue_bones") then
caster:RemoveModifierByName( "modifier_blue_bones" )
else
caster:AddNewModifier( self:GetCaster(), self, "modifier_blue_bones", {} )
end
end

function item_papyrus:GetIntrinsicModifierName()
    return "modifier_papyrus"
	end


modifier_papyrus = class({})


function modifier_papyrus:IsHidden()
    return true
end
function modifier_papyrus:RemoveOnDeath() return false end
function modifier_papyrus:IsPurgable()
    return false
end
function modifier_papyrus:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_papyrus:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_papyrus:DeclareFunctions()
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

function modifier_papyrus:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_papyrus:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_papyrus:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_papyrus:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_papyrus:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_papyrus:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_papyrus:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         