muramasa_rush = class({})
LinkLuaModifier("modifier_muramasa_rush_burn","abilities/muramasa/muramasa_rush", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muramasa_rush_mr","abilities/muramasa/muramasa_rush", LUA_MODIFIER_MOTION_NONE)

function muramasa_rush:OnUpgrade()
    local caster = self:GetCaster() 
   if(caster:FindAbilityByName("muramasa_rush_upgraded"):GetLevel()< self:GetLevel()) then
      caster:FindAbilityByName("muramasa_rush_upgraded"):SetLevel(self:GetLevel())
   end
    
  end

 
 
 


function muramasa_rush:OnSpellStart()
    self.ChannelTime = 0
    local caster = self:GetCaster()
    caster:FindAbilityByName("muramasa_rush_upgraded"):StartCooldown(caster:FindAbilityByName("muramasa_rush_upgraded"):GetCooldown(caster:FindAbilityByName("muramasa_rush_upgraded"):GetLevel()))
    self.RushPoint = self:GetCursorPosition()
    caster.firstenemy = nil
    local ability = self
 
    --caster:RemoveModifierByName("modifier_muramasa_rush_mr" )
    local speed = self:GetSpecialValueFor("speed")  
    local max_range = self:GetSpecialValueFor("range")  
    local range = (self.RushPoint - caster:GetAbsOrigin()):Length2D()
    if(range > max_range) then
        range = max_range

    end
    local rush_time = range/speed
     --caster:AddNewModifier(caster, ability, "modifier_muramasa_rush_mr",{duration = rush_time })
    StartAnimation(caster, {duration=rush_time, activity=ACT_DOTA_CAST_ABILITY_4_END, rate=1.0})

    local qdProjectile = 
    {
        Ability = ability,
        EffectName = "particles/muramasa/muramasa_throw_projectile.vpcf",
        iMoveSpeed = speed,
        vSpawnOrigin = caster:GetOrigin(),
        fDistance = range,
        fStartRadius = 150,
        fEndRadius = 150,
        Source = caster,
        bHasFrontalCone = true,
        bReplaceExisting = true,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + 2.0,
        bDeleteOnHit = false,
        vVelocity = caster:GetForwardVector() * speed
    }
     
    
    local projectile = ProjectileManager:CreateLinearProjectile(qdProjectile)
    caster:AddNewModifier(caster, self, "modifier_stunned", { duration = rush_time })
    local sin = Physics:Unit(caster)
    caster:SetPhysicsFriction(0)
    caster:SetPhysicsVelocity(caster:GetForwardVector() * speed)
    caster:SetNavCollisionType(PHYSICS_NAV_BOUNCE)
      caster:SetGroundBehavior (PHYSICS_GROUND_LOCK)

      self.rushfx = ParticleManager:CreateParticle("particles/muramasa/muramasa_rush_self.vpcf", PATTACH_ABSORIGIN_FOLLOW  , caster )
   

    Timers:CreateTimer("muramasa_rush", {
        endTime = rush_time,
        callback = function()
        caster:OnPreBounce(nil)
        caster:SetBounceMultiplier(0)
        caster:PreventDI(false)
        caster:SetPhysicsVelocity(Vector(0,0,0))
        caster:RemoveModifierByName("pause_sealenabled")
        
        caster:SetGroundBehavior (PHYSICS_GROUND_NOTHING)
        ParticleManager:DestroyParticle(  self.rushfx , true)
        ParticleManager:ReleaseParticleIndex(  self.rushfx )
        FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
    return end
    })

    caster:OnPreBounce(function(unit, normal) -- stop the pushback when unit hits wall
        Timers:RemoveTimer("muramasa_rush")
        unit:OnPreBounce(nil)
        unit:SetBounceMultiplier(0)
        unit:PreventDI(false)
        unit:SetPhysicsVelocity(Vector(0,0,0))
        unit:SetGroundBehavior (PHYSICS_GROUND_NOTHING)
        caster:RemoveModifierByName("pause_sealenabled")
      
        ParticleManager:DestroyParticle(  self.rushfx , true)
        ParticleManager:ReleaseParticleIndex(  self.rushfx )
        FindClearSpaceForUnit(unit, unit:GetAbsOrigin(), true)
        ProjectileManager:DestroyLinearProjectile(projectile)
    end)

 

end

function muramasa_rush:OnProjectileHit_ExtraData(hTarget, vLocation, table)
    if hTarget == nil then return end
    local caster = self:GetCaster()
    if caster.firstenemy == nil then
        if hTarget:IsHero() and self:GetAutoCastState()  == true and caster:FindTalentValue("special_bonus_fate_muramasa_25r") == 5 then
            caster.firstenemy = hTarget
            self.swordfx = ParticleManager:CreateParticle("particles/muramasa/muramasa_sword_in_enemy.vpcf", PATTACH_OVERHEAD_FOLLOW  , hTarget )
            Timers:CreateTimer( 1.2, function()
                caster.firstenemy = nil
                ParticleManager:DestroyParticle(  self.swordfx, true)
                ParticleManager:ReleaseParticleIndex(  self.swordfx)
            end)
        end
    end
  
    local damage = self:GetSpecialValueFor("damage")
    local duration = self:GetSpecialValueFor("duration")
 
    self.sound = "Tsubame_Slash_"..math.random(1,3)
    hTarget:EmitSound(self.sound)
                        ApplyDamage({
                    victim = hTarget,
                    attacker = caster,
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    damage_flags = 0,
                    ability = self
                })
                

    hTarget:AddNewModifier(caster, self , "modifier_muramasa_rush_burn",{duration = duration })
    --caster:PerformAttack( hTarget, true, true, true, true, false, false, false )
end
 
modifier_muramasa_rush_burn = class({})

function modifier_muramasa_rush_burn:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
           }
end


function modifier_muramasa_rush_burn:GetEffectName()
    return "particles/muramasa/muramasa_rush_burn.vpcf"
end
function modifier_muramasa_rush_burn:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_muramasa_rush_burn:IsDebuff() return true end
function modifier_muramasa_rush_burn:OnCreated()
    self:StartIntervalThink(0.5)
end
function modifier_muramasa_rush_burn:OnIntervalThink()
    if(not IsServer() ) then return end
    local caster = self:GetCaster()
    local target = self:GetParent()
    local damage = self:GetAbility():GetSpecialValueFor("burn_dmg_per_tick")


    ApplyDamage({
        victim = target,
        attacker = caster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = 0,
        ability = self:GetAbility()
    })

end
function modifier_muramasa_rush_burn:GetModifierProvidesFOWVision()
    return  self:GetCaster().EyeOfKarmaAcquired and 1 or 0 
end


modifier_muramasa_rush_mr = class({})


function modifier_muramasa_rush_mr:DeclareFunctions()
    return {
        --MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
               }
end

function modifier_muramasa_rush_mr:CheckState()
    local state =   { 
					[MODIFIER_STATE_INVULNERABLE] = true,

                    }
    return state
end



function modifier_muramasa_rush_mr:GetModifierMagicalResistanceBonus()
    return  self:GetAbility():GetSpecialValueFor("bonus_mr") 
end
