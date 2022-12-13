LinkLuaModifier("modifier_intetsu", "items/item_intetsu", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_intetsu_awake", "items/item_intetsu", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_intetsu_stat", "items/item_intetsu", LUA_MODIFIER_MOTION_NONE)

item_intetsu = class({})

function item_intetsu:GetIntrinsicModifierName()
    return "modifier_intetsu"
	end

function item_intetsu:OnSpellStart()
 local caster = self:GetCaster()
 
  
    caster:AddNewModifier(caster, self, "modifier_intetsu_awake", {duration = 6})
	EmitSoundOn("ikki.intetsu", caster)
end
	
	


modifier_intetsu_awake = class({})


function modifier_intetsu_awake:IsHidden()
    return true
end
function modifier_intetsu_awake:RemoveOnDeath() return false end
function modifier_intetsu_awake:IsPurgable()
    return false
end

modifier_intetsu = class({})


function modifier_intetsu:IsHidden()
    return true
end
function modifier_intetsu:RemoveOnDeath() return false end
function modifier_intetsu:IsPurgable()
    return false
end
function modifier_intetsu:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
local hideit = 
	{
	"ittou_shura_raiko",
		
	}

	for _,hideability in pairs(hideit) do
	   	hideability = self:GetParent():FindAbilityByName(hideability)
		  if hideability and not hideability:IsActivated() then
            hideability:SetActivated(true)
        end
		end
	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_intetsu:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_intetsu:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }

    return funcs
end

function modifier_intetsu:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_intetsu:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_intetsu:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_intetsu:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_intetsu:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_intetsu:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
                     