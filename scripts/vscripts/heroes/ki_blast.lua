ki_blast = class({})

LinkLuaModifier( "modifier_ki_blast_thinker", "heroes/ki_blast.lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function ki_blast:Spawn()
    if IsServer() then
        self:SetThink( "OnIntervalThink", self, 0.25 )
    end
end
function ki_blast:GetIntrinsicModifierName()
    return "modifier_air_banner"
end


function ki_blast:OnIntervalThink()
    

    return 0.25
end

function ki_blast:IsStealable()
   return false
end

function ki_blast:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function ki_blast:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function ki_blast:OnSpellStart()
    if IsServer() then
        local target = CreateModifierThinker(self:GetCaster(), self, "modifier_ki_blast_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
if IsASBPatreon(self:GetCaster()) then
    self.info = {
			EffectName = "particles/ki_blast_drip.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}
else
        self.info = {
			EffectName = "particles/ki_blast.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}
		end

        ProjectileManager:CreateTrackingProjectile( self.info )

        EmitSoundOn( "goku.6", self:GetCaster() )
    end
	if IsServer() then
        --self:SetStackCount(0)

       
    end
end


--------------------------------------------------------------------------------

function ki_blast:OnProjectileHit( hTarget, vLocation )
    local caster = self:GetCaster()
	if hTarget ~= nil then
        EmitSoundOn( "goku.4_1", hTarget )

        if IsServer() then
            local caster = self:GetCaster()
  
          local particle_fx = "ki_blast_exp"

        local effect_fx =   ParticleManager:CreateParticle(particle_fx, PATTACH_WORLDORIGIN, caster)
                            ParticleManager:SetParticleControl(effect_fx, 0, vLocation)
                            ParticleManager:SetParticleControl(effect_fx, 3, vLocation)
    
            local nearby_targets = FindUnitsInRadius(caster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - vLocation):Length2D()
                local r = self:GetSpecialValueFor("max_damage") 
    
                local damage = {
                    victim = target,
                    attacker = caster,
                    damage = r,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self
                }
                
                target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun")})
    
                ApplyDamage(damage)  
            end
        end

		UTIL_Remove(hTarget)
	end

	return true
end


modifier_ki_blast_thinker = class ({})

function modifier_ki_blast_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

