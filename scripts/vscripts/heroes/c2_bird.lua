c2_bird = class({})

LinkLuaModifier( "modifier_c2_bird_thinker", "heroes/c2_bird.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_air_banner", "heroes/c2_bird.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function c2_bird:Spawn()
    if IsServer() then
        self:SetThink( "OnIntervalThink", self, 0.25 )
    end
end
function c2_bird:GetIntrinsicModifierName()
    return "modifier_air_banner"
end


function c2_bird:OnIntervalThink()
    if IsServer() then
        self:SetActivated(not self:GetCaster():HasModifier("modifier_doomslayer_doom"))
    end

    return 0.25
end

function c2_bird:IsStealable()
   return false
end

function c2_bird:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function c2_bird:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function c2_bird:OnSpellStart()
    if IsServer() then
        local target = CreateModifierThinker(self:GetCaster(), self, "modifier_c2_bird_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)

        local info = {
			EffectName = "particles/deidara_bird.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

        ProjectileManager:CreateTrackingProjectile( info )

        EmitSoundOn( "deidara.bird", self:GetCaster() )
    end
	if IsServer() then
        --self:SetStackCount(0)

       
    end
end


--------------------------------------------------------------------------------

function c2_bird:OnProjectileHit( hTarget, vLocation )
    local caster = self:GetCaster()
	if hTarget ~= nil then
        EmitSoundOn( "X.Canon2", hTarget )

        if IsServer() then
            local caster = self:GetCaster()
  
          local particle_fx = "particles/bird_exp.vpcf"

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
                
                target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun")+ self:GetCaster():FindTalentValue("special_bonus_deidara_20")})
    
                ApplyDamage(damage)  
            end
        end

		UTIL_Remove(hTarget)
	end

	return true
end


modifier_c2_bird_thinker = class ({})

function modifier_c2_bird_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

modifier_air_banner = class ({})
function modifier_air_banner:IsHidden() return true end
function modifier_air_banner:IsDebuff() return false end
function modifier_air_banner:IsPurgable() return false end
function modifier_air_banner:IsPurgeException() return false end
function modifier_air_banner:RemoveOnDeath() return false end

function modifier_air_banner:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_air_banner:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_air_banner:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_air_banner:GetModifierBaseAttackTimeConstant()
	return 5.0
end
