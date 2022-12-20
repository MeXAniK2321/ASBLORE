LinkLuaModifier("modifier_pukachu", "items/item_pukachu", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pukachu_stat", "items/item_pukachu", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pikachu_swap", "heroes/pikachu/pikachu", LUA_MODIFIER_MOTION_NONE)
item_pukachu = class({})

function item_pukachu:GetIntrinsicModifierName()
    return "modifier_pukachu"
	end


modifier_pukachu = class({})


function modifier_pukachu:IsHidden()
    return true
end
function modifier_pukachu:RemoveOnDeath() return false end
function modifier_pukachu:IsPurgable()
    return false
end
function modifier_pukachu:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
    self.flag = 0
	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end


function item_pukachu:OnSpellStart()
    if(self.flag == 1) then return end
    self.flag = 1
    self.parent = self:GetCaster()
    self.parent:AddNewModifier(
        self.parent, -- player source
		self, -- ability source
		"modifier_pikachu_swap", -- modifier name
		{ duration = 1000000} -- kv
	)
    local particle_cast = "particles/billy_cum.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
end



function modifier_pukachu:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_pukachu:DeclareFunctions()
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

function modifier_pukachu:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_pukachu:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_pukachu:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_pukachu:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_pukachu:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_pukachu:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_pukachu:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('arm')
end                         