modifier_homura_timestop = class({})
function modifier_homura_timestop:IsHidden() return false end
function modifier_homura_timestop:IsDebuff() return true end
function modifier_homura_timestop:IsPurgable() return false end
function modifier_homura_timestop:IsPurgeException() return false end
function modifier_homura_timestop:RemoveOnDeath() return true end
function modifier_homura_timestop:AllowIllusionDuplicate() return true end
function modifier_homura_timestop:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.skills_table = {
                            ["homura_timestop"] = "homura_grenade",
                            
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
        

         local ability = self:GetParent():FindAbilityByName("devil_homura")
        if ability:IsActivated() then
            ability:SetActivated(false)
        end
    end
		
        
		end

        self.parent:Purge(false, true, false, true, true)
    end



function modifier_homura_timestop:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_homura_timestop:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			
if IsServer() then
        local ability = self:GetParent():FindAbilityByName("devil_homura")
        if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
    end
            
       

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("bad_time_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end