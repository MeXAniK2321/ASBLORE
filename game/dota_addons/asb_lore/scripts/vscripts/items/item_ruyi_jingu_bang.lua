LinkLuaModifier("modifier_ruyi_jingu_bang", "items/item_ruyi_jingu_bang", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ruyi_jingu_bang_stat", "items/item_ruyi_jingu_bang", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_secret_buff", "items/item_ruyi_jingu_bang", LUA_MODIFIER_MOTION_NONE)

item_ruyi_jingu_bang = class({})

function item_ruyi_jingu_bang:GetIntrinsicModifierName()
    return "modifier_ruyi_jingu_bang"
	end
function item_ruyi_jingu_bang:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	if self:GetCaster():HasModifier("modifier_gods_arrival") then
	
	 else
	caster:AddNewModifier(caster, self, "modifier_item_secret_buff", {duration = 5})
	end
	
	
end

modifier_ruyi_jingu_bang = class({})


function modifier_ruyi_jingu_bang:IsHidden()
    return true
end
function modifier_ruyi_jingu_bang:RemoveOnDeath() return false end
function modifier_ruyi_jingu_bang:IsPurgable()
    return false
end
function modifier_ruyi_jingu_bang:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_ruyi_jingu_bang:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_ruyi_jingu_bang:DeclareFunctions()
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

function modifier_ruyi_jingu_bang:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_ruyi_jingu_bang:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_ruyi_jingu_bang:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_ruyi_jingu_bang:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_ruyi_jingu_bang:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_ruyi_jingu_bang:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
 modifier_item_secret_buff = class({})
function modifier_item_secret_buff:IsHidden() return true end
function modifier_item_secret_buff:IsDebuff() return false end
function modifier_item_secret_buff:IsPurgable() return true end
function modifier_item_secret_buff:IsPurgeException() return true end
function modifier_item_secret_buff:RemoveOnDeath() return true end
                 