wad_of_money = class({})

LinkLuaModifier( "modifier_wad_of_money_thinker", "heroes/wad_of_money.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wad_of_money", "heroes/wad_of_money.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function wad_of_money:Spawn()
    if IsServer() then
        self:SetThink( "OnIntervalThink", self, 0.25 )
    end
end
function wad_of_money:GetIntrinsicModifierName()
    return "modifier_air_banner"
end
function wad_of_money:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("hoof_stomp_datadriven")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function wad_of_money:OnIntervalThink()
    if IsServer() then
        self:SetActivated(not self:GetCaster():HasModifier("modifier_doomslayer_doom"))
    end

    return 0.25
end

function wad_of_money:IsStealable()
   return false
end

function wad_of_money:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function wad_of_money:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_AOE
end

function wad_of_money:OnSpellStart()
    if IsServer() then
        local target = CreateModifierThinker(self:GetCaster(), self, "modifier_wad_of_money_thinker", nil, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
local gold = -250
local caster = self:GetCaster()
	PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )
        local info = {
			EffectName = "particles/wad_of_moneu.vpcf",
			Ability = self,
			iMoveSpeed = self:GetSpecialValueFor( "movement_speed" ),
			Source = self:GetCaster(),
			Target = target,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
		}

        ProjectileManager:CreateTrackingProjectile( info )

        EmitSoundOn( "daisuke_6", self:GetCaster() )
    end
	if IsServer() then
        --self:SetStackCount(0)

       
    end
end


--------------------------------------------------------------------------------

function wad_of_money:OnProjectileHit( hTarget, vLocation )
    local caster = self:GetCaster()
	if hTarget ~= nil then
        EmitSoundOn( "daisuke_4_1", hTarget )

        if IsServer() then
            local caster = self:GetCaster()
  
          local particle_fx = "particles/money_explosion5.vpcf"

        local effect_fx =   ParticleManager:CreateParticle(particle_fx, PATTACH_WORLDORIGIN, caster)
                            ParticleManager:SetParticleControl(effect_fx, 0, vLocation)
                            ParticleManager:SetParticleControl(effect_fx, 3, vLocation)
    
            local nearby_targets = FindUnitsInRadius(caster:GetTeam(), vLocation, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    
            for i, target in pairs(nearby_targets) do
                local dist = (target:GetAbsOrigin() - vLocation):Length2D()
                local r = self:GetSpecialValueFor("max_damage") + self:GetCaster():FindTalentValue("special_bonus_tsuna_25")
    
              
                 local damage = {
                    victim = target,
                    attacker = caster,
                    damage = r,
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self
                }
                target:AddNewModifier(self:GetCaster(), self, "modifier_wad_of_money", {duration = self:GetSpecialValueFor("stun")})
    
                ApplyDamage(damage)  
            end
        end

		UTIL_Remove(hTarget)
	end

	return true
end


modifier_wad_of_money_thinker = class ({})

function modifier_wad_of_money_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

modifier_wad_of_money = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_wad_of_money:IsHidden()
	return false
end

function modifier_wad_of_money:IsDebuff()
	return true
end

function modifier_wad_of_money:IsStunDebuff()
	return false
end

function modifier_wad_of_money:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_wad_of_money:OnCreated( kv )
	
	
		

end


function modifier_wad_of_money:OnRefresh( kv )
end

function modifier_wad_of_money:OnRemoved()
	
end

function modifier_wad_of_money:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_wad_of_money:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_wad_of_money:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end