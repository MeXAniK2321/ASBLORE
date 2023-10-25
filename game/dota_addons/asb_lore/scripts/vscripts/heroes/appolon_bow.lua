appolon_bow = appolon_bow or class({})

LinkLuaModifier( "modifier_appolon_bow_thinker", "heroes/appolon_bow.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_air_banner", "heroes/appolon_bow.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function appolon_bow:IsStealable() return false end
function appolon_bow:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function appolon_bow:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end
function appolon_bow:OnSpellStart()
    local caster = self:GetCaster()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)
   
    EmitSoundOn( "ikaros.5_1", self:GetCaster() )
    
	if IsServer() then
        --self:SetStackCount(0)
        self.bow_fx = 	ParticleManager:CreateParticle("particles/ikaros_appolon.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster)
						ParticleManager:SetParticleControlEnt(self.bow_fx, 0, self:GetCaster(), 5, "appolon_attach_2", Vector(0,0,0), true)
						ParticleManager:SetParticleControlEnt(self.bow_fx, 1, self:GetCaster(), 5, "appolon_attach_2", Vector(0,0,0), true)
    end
end
function appolon_bow:OnChannelFinish( bInterrupted )
	-- unit identifier
	local caster = self:GetCaster()
	local target = CreateModifierThinker(self:GetCaster(), self, "modifier_appolon_bow_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	local channel_pct = (GameRules:GetGameTime() - self:GetChannelStartTime())/self:GetChannelTime()
    local damage = self:GetSpecialValueFor( "damage" )
    local info = {
			     EffectName = "particles/appolon_arrow.vpcf",
			     Ability = self,
			     iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			     Source = self:GetCaster(),
			     Target = target,
			     iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		         }

    ProjectileManager:CreateTrackingProjectile( info )
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_7)

	self.bow_damage = damage*channel_pct
	if self.bow_fx then
	    ParticleManager:DestroyParticle(self.bow_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.bow_fx)
	end
		
end


--------------------------------------------------------------------------------

function appolon_bow:OnProjectileHit( hTarget, vLocation )
    local caster = self:GetCaster()
	if hTarget ~= nil then
        EmitSoundOn( "ikaros.5_1_1", hTarget )

        if IsServer() then
            local caster = self:GetCaster()
            local particle_fx = "particles/appolon_nuke.vpcf"

            local effect_fx =   ParticleManager:CreateParticle(particle_fx, PATTACH_WORLDORIGIN, caster)
                                ParticleManager:SetParticleControl(effect_fx, 0, vLocation)
                                ParticleManager:SetParticleControl(effect_fx, 3, vLocation)
    
            local nearby_targets = FindUnitsInRadius(caster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - vLocation):Length2D()
               
    
                local damage = {
                    victim = target,
                    attacker = caster,
                    damage = self.bow_damage,
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


modifier_appolon_bow_thinker = modifier_appolon_bow_thinker or class ({})

function modifier_appolon_bow_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

modifier_air_banner = modifier_air_banner or class ({})
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