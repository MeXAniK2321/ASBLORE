muramasa_upgrade = class({})
LinkLuaModifier("modifier_eye_of_karma","abilities/muramasa/muramasa_upgrade", LUA_MODIFIER_MOTION_NONE)

function muramasa_upgrade:GetIntrinsicModifierName()
    return "modifier_eye_of_karma"
end


function muramasa_upgrade:CastFilterResult()
    local caster = self:GetCaster()
    if(caster:GetAbilityByIndex(1):GetName() ~="muramasa_throw") and
       (caster:GetLevel() < 29 
       or caster:GetAbilityByIndex(1):GetName() =="muramasa_throw" or 
       not caster:HasModifier("modifier_muramasa_tsumukari_buff") or caster:GetAbilityByIndex(5):GetName() == "muramasa_tsumukari_combo" 
       or caster:FindAbilityByName("muramasa_tsumukari_combo"):IsCooldownReady() == false or caster:FindAbilityByName("muramasa_tsumukari_release"):IsCooldownReady() == false) then
        return UF_FAIL_CUSTOM
    else
        return UF_SUCESS
    end
end

function muramasa_upgrade:GetCustomCastError()
    local caster = self:GetCaster()
    if(   caster:GetAbilityByIndex(1):GetName() ~="muramasa_throw" ) then
        return "Skills are already upgraded"
    end
end


function muramasa_upgrade:OnSpellStart()
local caster = self:GetCaster()
if(caster:GetAbilityByIndex(1):GetName() ~="muramasa_throw" and caster:GetLevel() > 29   and 
caster:HasModifier("modifier_muramasa_tsumukari_buff")) then
    if caster:FindAbilityByName("muramasa_tsumukari_combo"):IsCooldownReady()  then
             
        caster:SwapAbilities("muramasa_tsumukari_combo", "muramasa_tsumukari_release", true, false)

        Timers:CreateTimer("muramasa_combo_window",{
            endTime = 3,
            callback = function()
            local index5ability = caster:GetAbilityByIndex(5):GetName()
            if index5ability == "muramasa_tsumukari_combo"  then
                if(caster:HasModifier("modifier_muramasa_tsumukari_buff")) then
                    caster:SwapAbilities("muramasa_tsumukari_combo", "muramasa_tsumukari_release", false, true)
                else
                    caster:SwapAbilities("muramasa_tsumukari_combo", "muramasa_tsumukari", false, true)
                end
            end
             
        end
        })

    end

else
    if(caster:FindTalentValue("special_bonus_fate_muramasa_15r") == 5) then
        local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false) 
         for k,v in pairs(targets) do            
            ApplyDamage({
                    victim = v,
                    attacker = caster,
                    damage = self:GetSpecialValueFor("base_dmg") + caster:GetBaseAgility()*self:GetSpecialValueFor("dmg_per_agi"),
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    damage_flags = 0,
                    ability = self
                })
        end 
    end
    caster:SwapAbilities("muramasa_dance", "muramasa_dance_upgraded", false, true)
    caster:SwapAbilities("muramasa_throw", "muramasa_throw_upgraded", false, true)
    caster:SwapAbilities("muramasa_rush", "muramasa_rush_upgraded", false, true)
    end
end

modifier_eye_of_karma = class({})

function modifier_eye_of_karma:GetTexture()
	return "custom/muramasa/muramasa_eye_of_karma_attribute"
end
 

function modifier_eye_of_karma:GetModifierIncomingDamage_Percentage() 
    if( not self:GetCaster().EyeOfKarmaAcquired) then
        return 0
    else
        return  (self:GetParent():GetHealthPercent() < 50 and -1*self:GetAbility():GetSpecialValueFor("att_damage_reduction") or 0)  
    end
end

function modifier_eye_of_karma:GetBonusDayVision() 
    if( not self:GetCaster().EyeOfKarmaAcquired) then
        return 0
    else
        return  (self:GetParent():GetHealthPercent() < 50 and 400 or 0)  
    end
end


function modifier_eye_of_karma:GetBonusNightVision() 
    if( not self:GetCaster().EyeOfKarmaAcquired) then
        return 0
    else
        return  (self:GetParent():GetHealthPercent() < 50 and 400 or 0)  
    end
end

function modifier_eye_of_karma:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, 
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION     
		
    }
 
    return funcs
end


function modifier_eye_of_karma:IsHidden()	
    return (self:GetParent():GetHealthPercent() > 50 and true or false) 
end
function modifier_eye_of_karma:RemoveOnDeath()return false end 
function modifier_eye_of_karma:IsDebuff() 	return false end
 
