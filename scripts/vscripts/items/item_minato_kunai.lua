LinkLuaModifier("modifier_item_minato_kunai", "items/item_minato_kunai", LUA_MODIFIER_MOTION_NONE)

item_minato_kunai = class({})
 
function item_minato_kunai:OnSpellStart()
    if not IsServer() then return end
    local player = self:GetCaster():GetPlayerID()
    if player then
        ParticleManager:CreateParticle("particles/blink_dagger_ti9_lvl2_end1.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
        local particle = ParticleManager:CreateParticle("particles/blink_dagger_ti9_start1.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
        ParticleManager:SetParticleControl(particle, 0, self:GetCaster():GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, Vector(100, 100, 0))
        Timers:CreateTimer(1, function()        
            if particle then
                ParticleManager:DestroyParticle(particle, false)
                ParticleManager:ReleaseParticleIndex(particle)    
            end
        end)
    end
    ParticleManager:CreateParticle("particles/blink_dagger_ti9_start1.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
    self:GetCaster():EmitSound("minato.kunai")
    local origin_point = self:GetCaster():GetAbsOrigin()
    local target_point = self:GetCursorPosition()
    local difference_vector = target_point - origin_point
    if difference_vector:Length2D() > 1200 then
        target_point = origin_point + (target_point - origin_point):Normalized() * 1200
    end
    self:GetCaster():SetAbsOrigin(target_point)
    FindClearSpaceForUnit(self:GetCaster(), target_point, false)
    ProjectileManager:ProjectileDodge(self:GetCaster())
    ParticleManager:CreateParticle("particles/blink_dagger_ti9_lvl2_end1.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
end

function item_minato_kunai:GetIntrinsicModifierName()
    return "modifier_item_minato_kunai"
end

modifier_item_minato_kunai = class({})

function modifier_item_minato_kunai:IsHidden()
    return true
end

function modifier_item_minato_kunai:IsPurgable()
    return false
end

function modifier_item_minato_kunai:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }

    return funcs
end

function modifier_item_minato_kunai:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor('amp')
end

function modifier_item_minato_kunai:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('int')
end

function modifier_item_minato_kunai:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor('bonus_regen')
end
function modifier_item_minato_kunai:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('agi')
end
function modifier_item_minato_kunai:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('str')
end
function modifier_item_minato_kunai:GetModifierMoveSpeedBonus_Constant()
    if self:GetParent():HasItemInInventory("item_boots") or self:GetParent():HasItemInInventory("item_travel_boots") or self:GetParent():HasItemInInventory("item_guardian_greaves") or self:GetParent():HasItemInInventory("item_phase_boots") or self:GetParent():HasItemInInventory("item_travel_boots_2") or self:GetParent():HasItemInInventory("item_tranquil_boots") or self:GetParent():HasItemInInventory("item_arcane_boots") or self:GetParent():HasItemInInventory("item_power_treads") then
    return 0
	else
	return 80
	end
end
  function modifier_item_minato_kunai:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end      


function modifier_item_minato_kunai:OnTakeDamage( params )
    if not IsServer() then return end
	if params.attacker == self:GetParent() then return end
    if params.unit == self:GetParent() then
        self:GetAbility():StartCooldown(3.0)
    end
end