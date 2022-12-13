LinkLuaModifier("modifier_murchielago", "items/item_murchielago", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_passive_ressurection", "items/item_murchielago", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_murchielago_stat", "items/item_murchielago", LUA_MODIFIER_MOTION_NONE)

item_murchielago = class({})

function item_murchielago:GetIntrinsicModifierName()
    return "modifier_murchielago"
	end

function item_murchielago:OnSpellStart()
    local caster = self:GetCaster()
	if self:GetCaster():HasModifier("modifier_ulquiorra_ressurection") or self:GetCaster():HasModifier("modifier_ulquiorra_ressurection_segunda_etapa") or  self:GetCaster():HasModifier("modifier_passive_ressurection")then
	else
    caster:AddNewModifier(caster, self, "modifier_passive_ressurection", {})
      EmitSoundOn("ulquiorra.4", caster)
	  end
end
modifier_passive_ressurection = class({})
function modifier_passive_ressurection:IsHidden() return true end
function modifier_passive_ressurection:IsDebuff() return true end
function modifier_passive_ressurection:IsPurgable() return false end
function modifier_passive_ressurection:IsPurgeException() return false end
function modifier_passive_ressurection:RemoveOnDeath() return false end
function modifier_passive_ressurection:AllowIllusionDuplicate() return true end
function modifier_passive_ressurection:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,                   
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
    return func
end

function modifier_passive_ressurection:GetModifierModelChange()
    return "models/ulqiorra/ulquiorra_murchielago.vmdl"
end
function modifier_passive_ressurection:GetModifierModelScale()
	return 70
end
function modifier_passive_ressurection:GetModifierSpellAmplify_Percentage()
    return 25
end
function modifier_passive_ressurection:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["ulquiorra_ressurection"] = "lansa_de_luna",
                            
                        }


    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
            
        if IsServer() then
       

        	
		local hideit = 
	{
	"ulquiorra_ressurection_segunda_etapa",
		
	}

	for _,hideability in pairs(hideit) do
	   	hideability = self:GetParent():FindAbilityByName(hideability)
		  if hideability and not hideability:IsActivated() then
            hideability:SetActivated(true)
        end
		end
  
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_passive_ressurection:GetEffectName()

	return "particles/ulquiorra_ressurection.vpcf"
	end
function modifier_passive_ressurection:OnRefresh(table)
    self:OnCreated(table)
end


modifier_murchielago = class({})


function modifier_murchielago:IsHidden()
    return true
end
function modifier_murchielago:RemoveOnDeath() return false end
function modifier_murchielago:IsPurgable()
    return false
end
function modifier_murchielago:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	 local hideit = 
	{
	"passive_ressurection_segunda_etapa",
		
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

function modifier_murchielago:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_murchielago:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end
  function modifier_murchielago:GetModifierPhysicalArmorBonus()
return 4
end
function modifier_murchielago:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_murchielago:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_murchielago:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_murchielago:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_murchielago:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_murchielago:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
                      