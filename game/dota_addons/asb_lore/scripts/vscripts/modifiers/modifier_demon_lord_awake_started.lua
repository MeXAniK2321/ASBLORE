modifier_demon_lord_awake_started = class({})
function modifier_demon_lord_awake_started:IsHidden() return true end
function modifier_demon_lord_awake_started:IsDebuff() return false end
function modifier_demon_lord_awake_started:IsPurgable() return false end
function modifier_demon_lord_awake_started:IsPurgeException() return false end
function modifier_demon_lord_awake_started:RemoveOnDeath() return false end
function modifier_demon_lord_awake_started:AllowIllusionDuplicate() return true end




function modifier_demon_lord_awake_started:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            
							
                            ["rimuru_black_flame"] = "rimuru_merciless",
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
function modifier_demon_lord_awake_started:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			

            

           
        end
    end
end

function modifier_demon_lord_awake_started:OnRefresh(table)
    self:OnCreated(table)
end