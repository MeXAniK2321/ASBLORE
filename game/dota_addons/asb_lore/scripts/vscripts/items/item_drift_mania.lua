LinkLuaModifier("modifier_item_drift_mania", "items/item_drift_mania", LUA_MODIFIER_MOTION_NONE)
 

item_drift_mania = class({})

function item_drift_mania:GetIntrinsicModifierName()
    return "modifier_item_drift_mania"
	end


    modifier_item_drift_mania = class({})


function modifier_item_drift_mania:IsHidden()
    return true
end
function modifier_item_drift_mania:RemoveOnDeath() return false end
function modifier_item_drift_mania:IsPurgable()
    return false
end
function modifier_item_drift_mania:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_item_drift_mania:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_drift_mania:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        
    }

    return funcs
end

function modifier_item_drift_mania:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_item_drift_mania:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor('spell_amp')
end