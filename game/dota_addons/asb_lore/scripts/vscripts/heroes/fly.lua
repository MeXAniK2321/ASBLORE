LinkLuaModifier("modifier_misaka_shield", "heroes/fly", LUA_MODIFIER_MOTION_NONE)

misaka_shield = class({})

function misaka_shield:IsStealable() return true end
function misaka_shield:IsHiddenWhenStolen() return false end
function misaka_shield:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function misaka_shield:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")

    caster:RemoveModifierByNameAndCaster("modifier_misaka_shield", caster)
    caster:AddNewModifier(caster, self, "modifier_misaka_shield", {duration = duration})
end
---------------------------------------------------------------------------------------------------------------------
modifier_misaka_shield = class({})
function modifier_misaka_shield:IsHidden() return false end
function modifier_misaka_shield:IsDebuff() return false end
function modifier_misaka_shield:IsPurgable() return true end
function modifier_misaka_shield:IsPurgeException() return true end
function modifier_misaka_shield:RemoveOnDeath() return true end
function modifier_misaka_shield:CheckState()
    local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    return state
end

function modifier_misaka_shield:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

  

    if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/ember_spirit_ambient_head.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon_l", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
        end
        --self:AddParticle(self.particle_time, false, false, -1, false, false)

        

        EmitSoundOn("Misaka.Shield.Loop.1", self.parent)
        EmitSoundOn("Misaka.Shield.Loop.2", self.parent)

        
    end
end
function modifier_misaka_shield:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_misaka_shield:OnDestroy()
    if IsServer() then
     
        end

        ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

        
end