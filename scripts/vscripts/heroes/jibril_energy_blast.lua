jibril_energy_blast = class({})

LinkLuaModifier( "modifier_jibril_energy_blast_thinker", "heroes/jibril_energy_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_angel_devil", "heroes/jibril_energy_blast.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jibril_energy_blast:GetIntrinsicModifierName()
    return "modifier_angel_devil"
end
function jibril_energy_blast:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("jibril_kurianse")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end


function jibril_energy_blast:IsStealable()
   return false
end

function jibril_energy_blast:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function jibril_energy_blast:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function jibril_energy_blast:OnSpellStart()
    if IsServer() then
        local target = CreateModifierThinker(self:GetCaster(), self, "modifier_jibril_energy_blast_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)

        local info = {
			EffectName = "particles/jibril_energy_blast.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

        ProjectileManager:CreateTrackingProjectile( info )

        EmitSoundOn( "jibril.sfx_2", self:GetCaster() )
    end
	if IsServer() then
        --self:SetStackCount(0)

       
    end
end


--------------------------------------------------------------------------------

function jibril_energy_blast:OnProjectileHit( hTarget, vLocation )
    local caster = self:GetCaster()
	if hTarget ~= nil then
        EmitSoundOn( "jibril.1_exp", hTarget )

        if IsServer() then
            local caster = self:GetCaster()
  
          local particle_fx = "particles/jibril_energy_blast_explosion.vpcf"

        local effect_fx =   ParticleManager:CreateParticle(particle_fx, PATTACH_WORLDORIGIN, caster)
                            ParticleManager:SetParticleControl(effect_fx, 0, vLocation)
                            ParticleManager:SetParticleControl(effect_fx, 3, vLocation)
    
            local nearby_targets = FindUnitsInRadius(caster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - vLocation):Length2D()
                local r = self:GetSpecialValueFor("max_damage") + self:GetCaster():FindTalentValue("special_bonus_jibril_20")
    
                local damage = {
                    victim = target,
                    attacker = caster,
                    damage = r,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self
                }
                
                target:AddNewModifier(self:GetCaster(), self, "modifier_generic_burn", {duration = self:GetSpecialValueFor("stun")+ self:GetCaster():FindTalentValue("special_bonus_tsuna_25l")})
    
                ApplyDamage(damage)  
            end
        end

		UTIL_Remove(hTarget)
	end

	return true
end
modifier_jibril_energy_blast_thinker = class ({})

function modifier_jibril_energy_blast_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

modifier_angel_devil = class ({})
function modifier_angel_devil:IsHidden() return true end
function modifier_angel_devil:IsDebuff() return false end
function modifier_angel_devil:IsPurgable() return false end
function modifier_angel_devil:IsPurgeException() return false end
function modifier_angel_devil:RemoveOnDeath() return false end

function modifier_angel_devil:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_angel_devil:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_angel_devil:OnIntervalThink()
    if IsServer() then
        local jibril_kun = self:GetParent():FindAbilityByName("jibril_kurianse")
        if jibril_kun and not jibril_kun:IsNull() then
            if self:GetParent():HasScepter() then
                if jibril_kun:IsHidden() then
                    jibril_kun:SetHidden(false)
                end
            else
                if not jibril_kun:IsHidden() then
                    jibril_kun:SetHidden(true)
                end
            end
        end
    end
end