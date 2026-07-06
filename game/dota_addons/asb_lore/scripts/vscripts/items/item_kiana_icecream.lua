LinkLuaModifier("modifier_kiana_icecream", "items/item_kiana_icecream", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kiana_icecream_stat", "items/item_kiana_icecream", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_domain_of_genesis", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domain_of_genesis_stat", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upgrade_core", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_sirin_awakening", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_core_upgrade_2", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_core_upgrade_3", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_finality_herrsher_form", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flameshion_herrsher_form", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirin_herrsher_form", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drifter_core", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_herrsher_mode_cooldown", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_finality_aquired", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ultimate_start", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier( "modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE )

item_kiana_icecream = class({})

function item_kiana_icecream:GetIntrinsicModifierName()
    return "modifier_kiana_icecream"
end
function item_kiana_icecream:OnSpellStart()
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_will_of_the_herrsher")
	if modifier then
		if caster:HasModifier("modifier_form_change") then
		caster:RemoveModifierByName("modifier_form_change")
		end
		self:HerrsherForm()
	end
end
function item_kiana_icecream:HerrsherForm()
	local caster    = self:GetCaster()
	local nduration = 45

	if caster:HasModifier("modifier_core_upgrade_3") and not caster:HasModifier("modifier_finality_herrsher_form")  then
		EmitSoundOn("kiana.final_words", caster)
		caster:AddNewModifier(caster, self, "modifier_finality_herrsher_form", {duration = nduration})
		caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = nduration, bThirdTheme = true})
	elseif caster:HasModifier("modifier_core_upgrade_2") and not caster:HasModifier("modifier_flameshion_herrsher_form") then
		caster:AddNewModifier(caster, self, "modifier_flameshion_herrsher_form", {duration = nduration})
		caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = nduration, bSecondTheme = true})
	--elseif caster:HasModifier("modifier_upgrade_core") then
	--caster:AddNewModifier(caster, self, "modifier_drifter_core", {duration = 30})
	elseif caster:HasModifier("modifier_sirin_awakening") and not caster:HasModifier("modifier_sirin_herrsher_form") then
		caster:AddNewModifier(caster, self, "modifier_sirin_herrsher_form", {duration = nduration})
		caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = nduration})
	else
		self:EndCooldown()
	end
	
	print("HMMM")
end


modifier_kiana_icecream = class({})


function modifier_kiana_icecream:IsHidden()
    return true
end
function modifier_kiana_icecream:RemoveOnDeath() return false end
function modifier_kiana_icecream:IsPurgable()
    return false
end
function modifier_kiana_icecream:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_kiana_icecream:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_kiana_icecream:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
    }

    return funcs
end

function modifier_kiana_icecream:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_kiana_icecream:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('hp')
end

function modifier_kiana_icecream:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_kiana_icecream:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_kiana_icecream:GetModifierSpellAmplify_Percentage()
	return self:GetAbility():GetSpecialValueFor('amp')
end

function modifier_kiana_icecream:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end                      