modifier_rimuru_harvest_begin = class({})
function modifier_rimuru_harvest_begin:IsHidden() return true end
function modifier_rimuru_harvest_begin:IsDebuff() return false end
function modifier_rimuru_harvest_begin:IsPurgable() return false end
function modifier_rimuru_harvest_begin:IsPurgeException() return false end
function modifier_rimuru_harvest_begin:RemoveOnDeath() return false end
function modifier_rimuru_harvest_begin:AllowIllusionDuplicate() return true end




function modifier_rimuru_harvest_begin:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
        self.caster:RemoveModifierByName("modifier_demon_lord_awake_started")
    self.skills_table = {
                            
							
                            ["rimuru_black_flame"] = "rimuru_harvest_festival",
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
       

     
		 
        
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_rimuru_harvest_begin:OnRefresh(table)
    self:OnCreated(table)
end