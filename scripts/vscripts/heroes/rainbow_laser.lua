rainbow_laser = class({})



 function rainbow_laser:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("little_devil")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function rainbow_laser:IsStealable() return true end
function rainbow_laser:IsHiddenWhenStolen() return false end
function rainbow_laser:GetManaCost(iLevel)
    return self.BaseClass.GetManaCost(self, iLevel)
end
function rainbow_laser:OnAbilityPhaseStart()
    self.spark_charge_fx =  ParticleManager:CreateParticle("", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
                            ParticleManager:SetParticleControlEnt(self.spark_charge_fx, 0, self:GetCaster(), 5, "attach_attack1", Vector(0,0,0), true)
                            ParticleManager:SetParticleControlEnt(self.spark_charge_fx, 1, self:GetCaster(), 5, "attach_attack1", Vector(0,0,0), true)

    return true
end
function rainbow_laser:OnAbilityPhaseInterrupted()
    if self.spark_charge_fx then
        ParticleManager:DestroyParticle(self.spark_charge_fx, false)
        ParticleManager:ReleaseParticleIndex(self.spark_charge_fx)
    end
end
function rainbow_laser:GetChannelTime()
    return self.BaseClass.GetChannelTime(self)
end
function rainbow_laser:OnSpellStart()
    local caster = self:GetCaster()
    local distance = self:GetCastRange(caster:GetAbsOrigin(), caster) + caster:GetCastRangeBonus()
    local point = self:GetCursorPosition() + (caster:GetForwardVector() * 350) 
    local direction = (point - caster:GetAbsOrigin()):Normalized()

    local end_point = caster:GetAbsOrigin() + direction * distance

    self.anime_overhead_effect_damage = OVERHEAD_ALERT_DAMAGE

    self.anime_overhead_effect_heal = OVERHEAD_ALERT_HEAL

    if self.spark_charge_fx then
        ParticleManager:DestroyParticle(self.spark_charge_fx, false)
        ParticleManager:ReleaseParticleIndex(self.spark_charge_fx)
    end

    local spark_particle = "particles/rainbow_laser.vpcf"
    self.rainbow_laser_pfx = ParticleManager:CreateParticle(spark_particle, PATTACH_WORLDORIGIN, nil)
    local attach_point = caster:ScriptLookupAttachment("attach_attack1")

    ParticleManager:SetParticleControl(self.rainbow_laser_pfx, 0, caster:GetAttachmentOrigin(attach_point) + direction * 30)
    ParticleManager:SetParticleControl(self.rainbow_laser_pfx, 9, caster:GetAttachmentOrigin(attach_point) + direction * 30)

    end_point = GetGroundPosition( end_point, nil )
    end_point.z = caster:GetAttachmentOrigin(attach_point).z

    ParticleManager:SetParticleControl(self.rainbow_laser_pfx, 1, end_point)

    EmitSoundOn("frisk.5_1", caster)
end
function rainbow_laser:OnChannelThink(flInterval)
    local caster = self:GetCaster()
    local distance = self:GetCastRange(caster:GetAbsOrigin(), caster) + caster:GetCastRangeBonus()
    local point = self:GetCursorPosition() + (caster:GetForwardVector() * 350) 
    local direction = (point - caster:GetAbsOrigin()):Normalized()

    local end_point = caster:GetAbsOrigin() + direction * distance

    local start_width = self:GetSpecialValueFor("start_width")
    local end_width = self:GetSpecialValueFor("end_width")

    local damage_heal = ((self:GetSpecialValueFor("damage_heal_full") or 1) / (self:GetChannelTime() or 1)) * flInterval
    local interval = self:GetSpecialValueFor("interval")

    damage_heal = caster:HasTalent("special_bonus_anime_marisa_25R") and damage_heal or damage_heal --NEW LINE

    local enemies = FindUnitsInLine(caster:GetTeamNumber(),
                                    caster:GetAbsOrigin() + direction * 250,
                                    end_point,
                                    nil,
                                    start_width,
                                    self:GetAbilityTargetTeam(),
                                    self:GetAbilityTargetType(),
                                    self:GetAbilityTargetFlags() )

    for _, enemy in pairs(enemies) do
        if caster:GetTeamNumber() ~= enemy:GetTeamNumber() then
            local damage_table = 
                                {  
                                    victim      = enemy, 
                                    attacker    = caster,
                                    damage      = damage_heal, 
                                    damage_type = self:GetAbilityDamageType(), 
                                    ability     = self
                                }

            ApplyDamage(damage_table)

        elseif enemy ~= caster then
            enemy:Heal(damage_heal * 0.5, self)
        end

        EmitSoundOn("Marisa.Spark.Impact.1", enemy)
    end

    self:CreateVisibilityNode(end_point, start_width, flInterval)

    EmitSoundOnLocationWithCaster(end_point, "Marisa.Spark.Loop.1", caster)
end
function rainbow_laser:OnChannelFinish(bInterrupted)
    local caster = self:GetCaster()

    StopSoundOn("frisk.5_1", caster)

    if self.rainbow_laser_pfx then
        ParticleManager:DestroyParticle(self.rainbow_laser_pfx, false)
        ParticleManager:ReleaseParticleIndex(self.rainbow_laser_pfx)
    end
end