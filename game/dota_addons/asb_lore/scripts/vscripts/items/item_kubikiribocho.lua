LinkLuaModifier("modifier_kubikiribocho", "items/item_kubikiribocho", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_kubikiribocho_resist_debuff", "items/item_kubikiribocho", LUA_MODIFIER_MOTION_NONE)


item_kubikiribocho = class({})

function item_kubikiribocho:GetIntrinsicModifierName()
    return "modifier_kubikiribocho"
	end

modifier_kubikiribocho = class({})


function modifier_kubikiribocho:IsHidden()
    return true
end
function modifier_kubikiribocho:RemoveOnDeath() return false end
function modifier_kubikiribocho:IsPurgable()
    return false
end

function modifier_kubikiribocho:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_kubikiribocho:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
   MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
   MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
   MODIFIER_EVENT_ON_ATTACK_LANDED,
    }

    return funcs
end

function modifier_kubikiribocho:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('bonus_damage')
end
function modifier_kubikiribocho:GetModifierBonusStats_Strength()
    return 20
end
function modifier_kubikiribocho:GetModifierAttackSpeedBonus_Constant()
	 return self:GetAbility():GetSpecialValueFor('as')
end



function modifier_kubikiribocho:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			if not params.attacker:IsIllusion() then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_kubikiribocho_resist_debuff", {duration = 1.5 })
			end
		end
	end
end


modifier_item_kubikiribocho_resist_debuff = class({})
 
--------------------------------------------------------------------------------

function modifier_item_kubikiribocho_resist_debuff:IsDebuff()
	return true
end

function modifier_item_kubikiribocho_resist_debuff:IsStunDebuff()
	return false
end
function modifier_item_kubikiribocho_resist_debuff:IsHidden()
	return false
end
function modifier_item_kubikiribocho_resist_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_item_kubikiribocho_resist_debuff:DeclareFunctions()
    local funcs = {
        
       
        
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
    }

    return funcs
end


  function  modifier_item_kubikiribocho_resist_debuff:GetModifierIncomingPhysicalDamage_Percentage()
return self:GetAbility():GetSpecialValueFor('phys_damage')
end  

--------------------------------------------------------------------------------

function modifier_item_kubikiribocho_resist_debuff:GetEffectName()
	return "particles/kubikiribocho_armor_broke.vpcf"
end

function modifier_item_kubikiribocho_resist_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end