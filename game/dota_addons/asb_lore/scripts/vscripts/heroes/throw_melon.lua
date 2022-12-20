throw_melon = class({})

LinkLuaModifier( "modifier_throw_melon_thinker", "heroes/throw_melon.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_angel_slave", "heroes/throw_melon.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
function throw_melon:GetIntrinsicModifierName()
    return "modifier_angel_slave"
end
--------------------------------------------------------------------------------
function throw_melon:IsStealable()
   return false
end

function throw_melon:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function throw_melon:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function throw_melon:OnSpellStart()
    if IsServer() then
	if  self:GetCaster():HasModifier( "modifier_uranys_system_launched" ) or self:GetCaster():HasModifier( "modifier_uranus_system" )  then
	 local target = CreateModifierThinker(self:GetCaster(), self, "modifier_throw_melon_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)

        local info = {
			EffectName = "particles/uranus_system_shot1.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

        ProjectileManager:CreateTrackingProjectile( info )

        EmitSoundOn( "ikaros.shot", self:GetCaster() )
	else
        local target = CreateModifierThinker(self:GetCaster(), self, "modifier_throw_melon_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)

        local info = {
			EffectName = "particles/watermelon_model.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

        ProjectileManager:CreateTrackingProjectile( info )

        EmitSoundOn( "ikaros.1", self:GetCaster() )
    end
	end
	
	if IsServer() then
        --self:SetStackCount(0)

       
    end
	end



--------------------------------------------------------------------------------

function throw_melon:OnProjectileHit( hTarget, vLocation )
    local caster = self:GetCaster()
	if hTarget ~= nil then
	if  self:GetCaster():HasModifier( "modifier_uranys_system_launched" ) or self:GetCaster():HasModifier( "modifier_uranus_system" )  then
	  EmitSoundOn( "ikaros.shot_exp", hTarget )

        if IsServer() then
            local caster = self:GetCaster()
  
          local particle_fx = "particles/ikaros_shot_exp.vpcf"

        local effect_fx =   ParticleManager:CreateParticle(particle_fx, PATTACH_WORLDORIGIN, caster)
                            ParticleManager:SetParticleControl(effect_fx, 0, vLocation)
                            ParticleManager:SetParticleControl(effect_fx, 3, vLocation)
    
            local nearby_targets = FindUnitsInRadius(caster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - vLocation):Length2D()
                local r = self:GetSpecialValueFor("max_damage") + self:GetCaster():FindTalentValue("special_bonus_ikaros_20")
    
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
	
	else
        EmitSoundOn( "ikaros.1_1", hTarget )

        if IsServer() then
            local caster = self:GetCaster()
  
          local particle_fx = "particles/watermelon_explosion.vpcf"

        local effect_fx =   ParticleManager:CreateParticle(particle_fx, PATTACH_WORLDORIGIN, caster)
                            ParticleManager:SetParticleControl(effect_fx, 0, vLocation)
                            ParticleManager:SetParticleControl(effect_fx, 3, vLocation)
    
            local nearby_targets = FindUnitsInRadius(caster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - vLocation):Length2D()
                local r = self:GetSpecialValueFor("max_damage") + self:GetCaster():FindTalentValue("special_bonus_ikaros_20")
    
                local damage = {
                    victim = target,
                    attacker = caster,
                    damage = r,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self
                }
                
                target:AddNewModifier(self:GetCaster(), self, "modifier_generic_slow", {duration = self:GetSpecialValueFor("stun")})
    
                ApplyDamage(damage)  
            end
        end

		UTIL_Remove(hTarget)
	end

	return true
end
end


modifier_throw_melon_thinker = class ({})

function modifier_throw_melon_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

modifier_angel_slave = class ({})
function modifier_angel_slave:IsHidden() return true end
function modifier_angel_slave:IsDebuff() return false end
function modifier_angel_slave:IsPurgable() return false end
function modifier_angel_slave:IsPurgeException() return false end
function modifier_angel_slave:RemoveOnDeath() return false end

function modifier_angel_slave:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_angel_slave:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_angel_slave:OnIntervalThink()
    if IsServer() then
	
        local pink_girl = self:GetParent():FindAbilityByName("cerceus")
        if pink_girl and not pink_girl:IsNull() then
            if self:GetParent():HasScepter() then
                if pink_girl:IsHidden() then
                    pink_girl:SetHidden(false)
                end
            else
                if not pink_girl:IsHidden() then
                    pink_girl:SetHidden(true)
                end
            end
        end
    end
end
