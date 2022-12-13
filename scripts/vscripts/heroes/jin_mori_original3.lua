jin_mori_original3 = class({})

LinkLuaModifier( "modifier_jin_mori_original3_thinker", "heroes/jin_mori_original3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_air_banner", "heroes/jin_mori_original3.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function jin_mori_original3:Spawn()
    if IsServer() then
        self:SetThink( "OnIntervalThink", self, 0.25 )
    end
end
function jin_mori_original3:GetIntrinsicModifierName()
    return "modifier_air_banner"
end
function jin_mori_original3:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("hoof_stomp_datadriven")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function jin_mori_original3:OnIntervalThink()
    if IsServer() then
        self:SetActivated(not self:GetCaster():HasModifier("modifier_doomslayer_doom"))
    end

    return 0.25
end

function jin_mori_original3:IsStealable()
   return false
end

function jin_mori_original3:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function jin_mori_original3:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function jin_mori_original3:OnSpellStart()
    if IsServer() then
        local target = CreateModifierThinker(self:GetCaster(), self, "modifier_jin_mori_original3_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)

        local info = {
			EffectName = "particles/jin_mori_original3.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

        ProjectileManager:CreateTrackingProjectile( info )

        EmitSoundOn( "mori.6", self:GetCaster() )
    end
	if IsServer() then
        --self:SetStackCount(0)

       
    end
end


--------------------------------------------------------------------------------

function jin_mori_original3:OnProjectileHit( hTarget, vLocation )
    local caster = self:GetCaster()
	if hTarget ~= nil then
        EmitSoundOn( "mori.6_2", hTarget )

        if IsServer() then
            local caster = self:GetCaster()
  
          local particle_fx = "particles/jin_mori_original3_sfx_destroy.vpcf"

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
                
                target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun")+ self:GetCaster():FindTalentValue("special_bonus_tsuna_25l")})
    
                ApplyDamage(damage)  
            end
        end

		UTIL_Remove(hTarget)
	end

	return true
end


modifier_jin_mori_original3_thinker = class ({})

function modifier_jin_mori_original3_thinker:CheckState()
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

function modifier_air_banner:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("banner_air")
        if vongolle and not vongolle:IsNull() then
            if self:GetParent():HasScepter() then
                if vongolle:IsHidden() then
                    vongolle:SetHidden(false)
                end
            else
                if not vongolle:IsHidden() then
                    vongolle:SetHidden(true)
                end
            end
        end
    end
end