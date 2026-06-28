LinkLuaModifier("modifier_item_watch", "items/item_watch", LUA_MODIFIER_MOTION_NONE)

item_watch = item_watch or class({})

function item_watch:GetIntrinsicModifierName()
    return "modifier_item_watch"
end
function item_watch:OnSpellStart()
    local hCaster  = self:GetCaster()
	local fCDReuce = self:GetSpecialValueFor('cd_reduce')
	
	local bCheck = false
	for i = 0, hCaster:GetAbilityCount() - 1 do
		local hAbility = hCaster:GetAbilityByIndex(i)
		if IsNotNull(hAbility) and hAbility:GetCooldownTimeRemaining() > 0 and not LoreIsAbilityRequiredLevel(hAbility:GetName(), 30) then
		    local fCooldownRemaining = hAbility:GetCooldownTimeRemaining()
		    hAbility:EndCooldown()
		    hAbility:StartCooldown( fCooldownRemaining - (fCooldownRemaining * fCDReuce) )
			bCheck = true
		end
	end
	
	if not bCheck then
		self:EndCooldown()
		self:StartCooldown(5.0)
	end
	
	local nSakuyaFX = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_bracers_of_aeons/fv_bracers_of_aeons_timedialate.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
			          ParticleManager:ReleaseParticleIndex(nSakuyaFX)
	EmitSoundOn("sakuya_active", hCaster)
end


modifier_item_watch = modifier_item_watch or class({})

function modifier_item_watch:IsHidden() return true end
function modifier_item_watch:AllowIllusionDuplicate() return true end
function modifier_item_watch:IsPurgable() return false end
function modifier_item_watch:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                      MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
                      MODIFIER_PROPERTY_MANA_BONUS,
                      MODIFIER_PROPERTY_HEALTH_BONUS,
                      MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                      MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
                      MODIFIER_PROPERTY_CAST_RANGE_BONUS,
                  }

    return funcs
end
function modifier_item_watch:GetModifierSpellAmplify_Percentage()
    return (self:GetParent():HasItemInInventory("item_yoru") or self:GetParent():HasItemInInventory("item_angel_halo"))
	       and 0
		   or self:GetAbility():GetSpecialValueFor('dmg')
end
function modifier_item_watch:GetModifierPercentageCooldown()
    if self:GetParent():HasItemInInventory("item_octarine_core") then return 0 end
    
	return self:GetAbility():GetSpecialValueFor('cd')
end
function modifier_item_watch:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mp')
end
function modifier_item_watch:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('hp')
end
function modifier_item_watch:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('int')
end
function modifier_item_watch:GetModifierPercentageManacost()
    return self:GetAbility():GetSpecialValueFor('reduce_mana')
end
function modifier_item_watch:GetModifierCastRangeBonus()
	return 300
end