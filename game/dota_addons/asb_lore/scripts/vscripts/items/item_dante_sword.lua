LinkLuaModifier("modifier_dante_sword", "items/item_dante_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dante_sword_stat", "items/item_dante_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dante_uebok", "items/item_dante_sword", LUA_MODIFIER_MOTION_NONE)

item_dante_sword = item_dante_sword or class({})

function item_dante_sword:GetIntrinsicModifierName()
    return "modifier_dante_sword"
end

function item_dante_sword:OnSpellStart()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_dante_uebok", { duration = 5 } )
    EmitSoundOn("dante.fuck_you", caster)
end


modifier_dante_uebok = modifier_dante_uebok or class({})

function modifier_dante_uebok:IsHidden() return true end
function modifier_dante_uebok:RemoveOnDeath() return true end
function modifier_dante_uebok:IsPurgable() return false end


modifier_dante_sword = modifier_dante_sword or class({})

function modifier_dante_sword:IsHidden() return true end
function modifier_dante_sword:RemoveOnDeath() return false end
function modifier_dante_sword:IsPurgable() return false end
function modifier_dante_sword:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_dante_sword:OnCreated(table)
    self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end
function modifier_dante_sword:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                      MODIFIER_PROPERTY_HEALTH_BONUS,
                      MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                      MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                      MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		              MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE,
		              MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                  }

    return funcs
end
function modifier_dante_sword:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end
function modifier_dante_sword:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end
function modifier_dante_sword:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_dante_sword:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_dante_sword:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_dante_sword:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         