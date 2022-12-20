LinkLuaModifier("modifier_generic_kb", "heroes/modifiers/modifier_generic_kb", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_generic_model_change", "heroes/modifiers/modifier_generic_model_change",
    LUA_MODIFIER_MOTION_NONE)

modifier_ryougi_shikiT_invu = class({})

--------------------------------------------------------------------------------
function modifier_ryougi_shikiT_invu:IsHidden()
    return false
end

function modifier_ryougi_shikiT_invu:IsDebuff()
    return false
end

function modifier_ryougi_shikiT_invu:IsStunDebuff()
    return false
end

function modifier_ryougi_shikiT_invu:IsPurgable()
    return false
end

function modifier_ryougi_shikiT_invu:OnCreated(kv)
    if IsServer() then
        EndAnimation(self:GetParent())

        
        self.target_modifier = tempTable:RetATValue(kv.target)
        self.target = self.target_modifier:GetParent()
        
        
        GridNav:DestroyTreesAroundPoint(self.target:GetAbsOrigin(), 2500, false)
            --[[
        local dummy = CreateUnitByName("bground",
            self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 600, true, self:GetParent(),
            self:GetParent(), self:GetParent():GetTeamNumber())

        Timers:CreateTimer(1.0, function()
            dummy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_model_change", {
                duration = 12.0,
                model = "models/assets/others/circulo_negro/circulo_negro.vmdl"
            })
        end)
        ]]

 
        Timers:CreateTimer(0.8, function()
             local effect_cast = ParticleManager:CreateParticleForPlayer( "particles/shiki_ulti_particle.vpcf", PATTACH_ABSORIGIN, self:GetParent(),self:GetParent():GetPlayerOwner() )
                 
                ParticleManager:SetParticleControl( effect_cast, 0, self.target:GetAbsOrigin() - self:GetParent():GetForwardVector() *  150 )
                ParticleManager:SetParticleControl( effect_cast, 1, Vector( 700, 700, 700 ) )

                local effect_cast2 = ParticleManager:CreateParticleForPlayer( "particles/shiki_ulti_particle.vpcf", PATTACH_ABSORIGIN, self:GetParent(),self.target:GetPlayerOwner() )
                 
                ParticleManager:SetParticleControl( effect_cast2, 0, self.target:GetAbsOrigin() - self:GetParent():GetForwardVector() *  150 )
                ParticleManager:SetParticleControl( effect_cast2, 1, Vector( 700, 700, 700 ) )
            local direction = self.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()
            direction = direction:Normalized()

            self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_generic_kb", {
                duration = 4.0,
                distance = 450,
                height = 1,
                direction_x = direction[1],
                direction_y = direction[2]
            })

            StartAnimation(self:GetParent(), {
                duration = 4.0,
                activity = ACT_DOTA_CHANNEL_ABILITY_5,
                rate = 1.0
            })

            --
            --
            --[[ EFECTO DE CAMINATA ]]
            --
            --

            Timers:CreateTimer(2.0, function()
                EmitGlobalSound("Ryougi.T1")
                EmitGlobalSound("Ryougi.T8")
               
                local particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_flash.vpcf"
                local exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT, self:GetParent())
                ParticleManager:SetParticleControl(exp4, 3, self:GetParent():GetAbsOrigin())
                ParticleManager:ReleaseParticleIndex(exp4)

                Timers:CreateTimer(2.0, function()
                    self:GetParent()
                        :SetAbsOrigin(self.target:GetAbsOrigin() + self:GetParent():GetForwardVector() * 200)
                    StartAnimation(self:GetParent(), {
                        duration = 0.7,
                        activity = ACT_DOTA_CHANNEL_ABILITY_7,
                        rate = 1.0
                    })
                    EmitGlobalSound("Ryougi.T2")
                    EmitGlobalSound("Ryougi.T7")

                    local particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_screen.vpcf"
                    local exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT_FOLLOW, self:GetParent())
                    ParticleManager:SetParticleControl(exp4, 2, self:GetParent():GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex(exp4)

                    local particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_screen.vpcf"
                    local exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT_FOLLOW, self.target)
                    ParticleManager:SetParticleControl(exp4, 2, self:GetParent():GetAbsOrigin())
                    ParticleManager:ReleaseParticleIndex(exp4)

                    particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_hit.vpcf"
                    exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT, self:GetParent())
                    ParticleManager:SetParticleControl(exp4, 3, self:GetParent():GetAbsOrigin() +
                        self:GetParent():GetForwardVector() * -250)
                    ParticleManager:ReleaseParticleIndex(exp4)

                    Timers:CreateTimer(0.8, function()
                        self:GetParent():SetAbsOrigin(self.target:GetAbsOrigin() + self:GetParent():GetForwardVector() *
                                                          200)
                        StartAnimation(self:GetParent(), {
                            duration = 1.4,
                            activity = ACT_DOTA_CHANNEL_ABILITY_6,
                            rate = 1.0
                        })
                        EmitGlobalSound("Ryougi.T7")
 
                        local particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_screen.vpcf"
                        local exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT_FOLLOW,
                            self:GetParent())
                        ParticleManager:SetParticleControl(exp4, 2, self:GetParent():GetAbsOrigin())
                        ParticleManager:ReleaseParticleIndex(exp4)

                        local particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_screen.vpcf"
                        local exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT_FOLLOW, self.target)
                        ParticleManager:SetParticleControl(exp4, 2, self:GetParent():GetAbsOrigin())
                        ParticleManager:ReleaseParticleIndex(exp4)

                        particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_hit.vpcf"
                        exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT, self:GetParent())
                        ParticleManager:SetParticleControl(exp4, 3, self:GetParent():GetAbsOrigin() +
                            self:GetParent():GetForwardVector() * -250)
                        ParticleManager:ReleaseParticleIndex(exp4)

                        Timers:CreateTimer(1.5, function()
                            self:GetParent():SetAbsOrigin(self.target:GetAbsOrigin() +
                                                              self:GetParent():GetForwardVector() * 200)
                            StartAnimation(self:GetParent(), {
                                duration = 1.5,
                                activity = ACT_DOTA_CHANNEL_END_ABILITY_6,
                                rate = 1.0
                            })
                            EmitGlobalSound("Ryougi.T7")

                            local particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_screen.vpcf"
                            local exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT_FOLLOW,
                                self:GetParent())
                            ParticleManager:SetParticleControl(exp4, 2, self:GetParent():GetAbsOrigin())
                            ParticleManager:ReleaseParticleIndex(exp4)

                            local particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_screen.vpcf"
                            local exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT_FOLLOW,
                                self.target)
                            ParticleManager:SetParticleControl(exp4, 2, self:GetParent():GetAbsOrigin())
                            ParticleManager:ReleaseParticleIndex(exp4)

                            particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_hit.vpcf"
                            exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT, self:GetParent())
                            ParticleManager:SetParticleControl(exp4, 3, self:GetParent():GetAbsOrigin() +
                                self:GetParent():GetForwardVector() * -250)
                            ParticleManager:ReleaseParticleIndex(exp4)

                            Timers:CreateTimer(0.8, function()
                                local particleImpact9 = "particles/ryougi_eff/ryougi_t/ryougi_t_initial.vpcf"
                                --local exp9 = ParticleManager:CreateParticle(particleImpact9, PATTACH_POINT,
                                   -- self:GetParent())
                                --ParticleManager:SetParticleControl(exp9, 0, dummy:GetAbsOrigin())
                                --ParticleManager:ReleaseParticleIndex(exp9)
                            end)
                               
                            Timers:CreateTimer(1.5, function()
                                ParticleManager:DestroyParticle(effect_cast, true)
                                ParticleManager:ReleaseParticleIndex(effect_cast)
                                ParticleManager:DestroyParticle(effect_cast2, true)
                                ParticleManager:ReleaseParticleIndex(effect_cast2)
                                FindClearSpaceForUnit(self:GetParent(),self:GetParent():GetAbsOrigin(),false)
                                FindClearSpaceForUnit(self.target,self.target:GetAbsOrigin(),false)
                                 --[[
                                StartAnimation(self:GetParent(), {
                                    duration = 3.2,
                                    activity = ACT_DOTA_CHANNEL_END_ABILITY_5,
                                    rate = 1.0
                                })
                                   ]]
                                --dummy:ForceKill(true)
                                --UTIL_Remove(dummy)
                            end)
                             
                        end)
                    end)
                end)
            end)
        end)
    end
end

function modifier_ryougi_shikiT_invu:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_INVULNERABLE] = true
    }

    return state
end

function modifier_ryougi_shikiT_invu:OnDestroy(kv)
    local agility = self:GetAbility():GetSpecialValueFor("agility")
    local damage = self:GetAbility():GetSpecialValueFor("damage")

    self.target:RemoveModifierByName("modifier_ryougi_shikiT_invu_2")

    local info = {
        victim = self.target,
        attacker = self:GetParent(),
        damage = damage + self:GetParent():GetAgility() * agility,
        damage_type = DAMAGE_TYPE_MAGICAL
    }

    ApplyDamage(info)

    local particleImpact4 = "particles/ryougi_eff/ryougi_t/ryougi_t_final_blood.vpcf"
    local exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT, self:GetParent())
    ParticleManager:SetParticleControl(exp4, 0,
        self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * -150)
    ParticleManager:ReleaseParticleIndex(exp4)

    particleImpact4 = "particles/ryougi_eff/ryougi_w/ryougi_hit.vpcf"
    exp4 = ParticleManager:CreateParticle(particleImpact4, PATTACH_POINT, self:GetParent())
    ParticleManager:SetParticleControl(exp4, 0,
        self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * -150)
    ParticleManager:ReleaseParticleIndex(exp4)

    self.target:RemoveModifierByName("modifier_ryougi_shiki_T_target")
end
