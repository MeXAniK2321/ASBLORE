modifier_cor_leonis_self = class({})
function modifier_cor_leonis_self:IsHidden() return false end
function modifier_cor_leonis_self:IsDebuff() return true end
function modifier_cor_leonis_self:IsPurgable() return false end
function modifier_cor_leonis_self:IsPurgeException() return false end
function modifier_cor_leonis_self:RemoveOnDeath() return true end
function modifier_cor_leonis_self:AllowIllusionDuplicate() return true end

function modifier_cor_leonis_self:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["cor_leonis"] = "second_hand",
							
                            
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
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/cor_leonis_self_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
		
        
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_cor_leonis_self:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_cor_leonis_self:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

          

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                
                   
                end
            end
        end
    end