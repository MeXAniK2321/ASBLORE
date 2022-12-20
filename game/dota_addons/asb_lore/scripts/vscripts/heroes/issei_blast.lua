issei_blast = class({})

LinkLuaModifier( "modifier_issei_blast_thinker", "heroes/issei_blast.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oppai", "heroes/issei_blast.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function issei_blast:Spawn()
    if IsServer() then
        self:SetThink( "OnIntervalThink", self, 0.25 )
    end
end
function issei_blast:GetIntrinsicModifierName()
    return "modifier_oppai"
end


function issei_blast:OnIntervalThink()
    if IsServer() then
        self:SetActivated(not self:GetCaster():HasModifier("modifier_doomslayer_doom"))
    end

    return 0.25
end

function issei_blast:IsStealable()
   return false
end

function issei_blast:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function issei_blast:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function issei_blast:OnSpellStart()
    if IsServer() then
        local target = CreateModifierThinker(self:GetCaster(), self, "modifier_issei_blast_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
if self:GetCaster():HasModifier( "modifier_juggernaut_drive" ) or self:GetCaster():HasModifier( "modifier_balance_breaker2" ) then
 self.info = {
			EffectName = "particles/issei_crimson_blast.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}
		EmitSoundOn( "issei.1_1", self:GetCaster() )
else
        self.info = {
			EffectName = "particles/issei_blast.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}
		EmitSoundOn( "issei.1", self:GetCaster() )
		end

        ProjectileManager:CreateTrackingProjectile( self.info )

        
    end
	if IsServer() then
        --self:SetStackCount(0)

       
    end
end


--------------------------------------------------------------------------------

function issei_blast:OnProjectileHit( hTarget, vLocation )
    local caster = self:GetCaster()
	if hTarget ~= nil then
       

        if IsServer() then
            local caster = self:GetCaster()
  if self:GetCaster():HasModifier( "modifier_juggernaut_drive" ) or self:GetCaster():HasModifier( "modifier_balance_breaker2" )  then
   self.particle_fx = "particles/issei_crimson_blast_exp.vpcf"
  self.r = 1500
   EmitSoundOn( "issei.1_3", hTarget )
  else
          self.particle_fx = "particles/issei_blast_exp.vpcf"
		  self.r = self:GetSpecialValueFor("max_damage") + self:GetCaster():FindTalentValue("special_bonus_issei_20")
		   EmitSoundOn( "X.Canon2", hTarget )
		  end

        local effect_fx =   ParticleManager:CreateParticle(self.particle_fx, PATTACH_WORLDORIGIN, caster)
                            ParticleManager:SetParticleControl(effect_fx, 0, vLocation)
                            ParticleManager:SetParticleControl(effect_fx, 3, vLocation)
    
            local nearby_targets = FindUnitsInRadius(caster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - vLocation):Length2D()
                
    
                local damage = {
                    victim = target,
                    attacker = caster,
                    damage = self.r,
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


modifier_issei_blast_thinker = class ({})

function modifier_issei_blast_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

modifier_oppai = class ({})
function modifier_oppai:IsHidden() return true end
function modifier_oppai:IsDebuff() return false end
function modifier_oppai:IsPurgable() return false end
function modifier_oppai:IsPurgeException() return false end
function modifier_oppai:RemoveOnDeath() return false end

function modifier_oppai:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_oppai:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_oppai:OnIntervalThink()
    if IsServer() then
        local opppai = self:GetParent():FindAbilityByName("issei_promotion")
        if opppai and not opppai:IsNull() then
            if self:GetParent():HasScepter() then
                if opppai:IsHidden() then
                    opppai:SetHidden(false)
                end
            else
                if not opppai:IsHidden() then
                    opppai:SetHidden(true)
                end
            end
        end
    end
end