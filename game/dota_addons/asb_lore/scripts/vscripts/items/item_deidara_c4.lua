LinkLuaModifier("modifier_deidara_c4", "items/item_deidara_c4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_deidara_c4_stat", "items/item_deidara_c4", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_c4_replace", "modifiers/modifier_c4_replace", LUA_MODIFIER_MOTION_NONE)
item_deidara_c4 = class({})

function item_deidara_c4:GetIntrinsicModifierName()
    return "modifier_deidara_c4"
	end
function item_deidara_c4:OnSpellStart()



	if not IsServer() then return end
    local caster = self:GetCaster()
    local player = caster:GetPlayerID()
    local origin = caster:GetAbsOrigin() + RandomVector(100)
	local duration = 20
	

    if self.len and IsValidEntity(self.len) and self.len:IsAlive() then
        FindClearSpaceForUnit(self.len, origin, true)
        self.len:SetHealth(self.len:GetMaxHealth())
        
    else
        self.len = CreateUnitByName("npc_dota_c4_deidara", origin, true, caster, caster, caster:GetTeamNumber())
        self.len:SetControllableByPlayer(player, true)
        
    end
	EmitSoundOn("deidara.c4_plant", caster)
	
end
	
	
	
	






modifier_deidara_c4 = class({})


function modifier_deidara_c4:IsHidden()
    return true
end
function modifier_deidara_c4:RemoveOnDeath() return false end
function modifier_deidara_c4:IsPurgable()
    return false
end
function modifier_deidara_c4:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_deidara_c4:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_deidara_c4:DeclareFunctions()
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

function modifier_deidara_c4:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_deidara_c4:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_deidara_c4:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_deidara_c4:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_deidara_c4:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_deidara_c4:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_deidara_c4:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         