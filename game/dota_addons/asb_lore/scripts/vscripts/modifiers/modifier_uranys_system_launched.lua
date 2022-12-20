modifier_uranys_system_launched = class({})
function modifier_uranys_system_launched:IsHidden() return false end
function modifier_uranys_system_launched:IsDebuff() return false end
function modifier_uranys_system_launched:IsPurgable() return false end
function modifier_uranys_system_launched:IsPurgeException() return false end
function modifier_uranys_system_launched:RemoveOnDeath() return false end
function modifier_uranys_system_launched:AllowIllusionDuplicate() return true end

function modifier_uranys_system_launched:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,	
MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,				}
    return func
end


function modifier_uranys_system_launched:GetModifierModelChange()

    return "models/ikaros/untitled.vmdl"

end
function modifier_uranys_system_launched:GetModifierModelScale()

	return 30
	
end

function modifier_uranys_system_launched:GetAttackSound()
	return "ikaros.shot"
end

function modifier_uranys_system_launched:GetModifierProjectileName()
	return "particles/uranys_system_launched_projectile.vpcf"
end

function modifier_uranys_system_launched:GetModifierProjectileSpeedBonus()
	return 1300
end



function modifier_uranys_system_launched:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            
							
							["watermelon_hit"] = "artemis_launcher",
                            ["angel_initialize"] = "aegis_activate",
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
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
       

     
		 
        EmitSoundOn("ikaros.6", self.parent)
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_uranys_system_launched:OnRefresh(table)
    self:OnCreated(table)
end
