LinkLuaModifier("modifier_key_for_9", "items/item_key_for_9", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_key_for_9_stat", "items/item_key_for_9", LUA_MODIFIER_MOTION_NONE)

item_key_for_9 = class({})

function item_key_for_9:GetIntrinsicModifierName()
    return "modifier_key_for_9"
end
function item_key_for_9:GetAOERadius()
    return 10000
end
function item_key_for_9:GetAbilityTextureName()
     return self.BaseClass.GetAbilityTextureName(self)
end
function item_key_for_9:OnAbilityPhaseStart()
	--==================================================--
	self.iProjectiles  = self.iProjectiles or {}
	--==================================================--
    local hCaster    = self:GetCaster()
    local vDirection = GetDirection(self:GetCursorPosition(), hCaster:GetOrigin())
    local vVelocity  = vDirection

    self.fSpeed = self.fSpeed or self:GetSpecialValueFor("movespeed")
    
    self.vSpawnLocation  = self:GetCaster():GetAbsOrigin() + GetDirection(self:GetCaster():GetCursorPosition(), self:GetCaster():GetAbsOrigin()) * 300
    
    self.nHollowPurpleFX = ParticleManager:CreateParticle("particles/heroes/ringmaster/ringmaster_key_for_9_sparks_ring.vpcf", PATTACH_WORLDORIGIN, nil)
                           ParticleManager:SetParticleControlTransform(self.nHollowPurpleFX, 0, self.vSpawnLocation, self:GetCaster():GetAngles())
						   ParticleManager:SetParticleControl(self.nHollowPurpleFX, 1, vVelocity)
                           ParticleManager:SetParticleControl(self.nHollowPurpleFX, 6, Vector(self.fSpeed, 0, 0))
	
	
	Timers:CreateTimer(0.2, function()
		EmitSoundOn("gachi.wrench" .. RandomInt(1,3), hCaster)
		if self:IsInAbilityPhase() then
		    return 0.2
	    end
    end)
	
	local tSounds = {"gachi.ooo1", "gachi.mmm2"}
	EmitSoundOn(tSounds[RandomInt(1, #tSounds)], hCaster)
    
    return true
end
function item_key_for_9:OnSpellStart()
    local hCaster    = self:GetCaster()
    local vDirection = hCaster:GetForwardVector()
    local vVelocity  = vDirection * self.fSpeed
    local fRadius    = self:GetSpecialValueFor("radius")
    local fDistance  = self:GetSpecialValueFor("distance")
    
    local hExplosion =  {   
                            Ability             = self,
                            EffectName          = "",
                            vSpawnOrigin        = self.vSpawnLocation,
                            fDistance           = fDistance,
                            fStartRadius        = fRadius,
                            fEndRadius          = fRadius,
                            Source              = hCaster,
                            bHasFrontalCone     = false,
                            bReplaceExisting    = false,
                            iUnitTargetTeam     = self:GetAbilityTargetTeam(),
                            iUnitTargetFlags    = self:GetAbilityTargetFlags(),
                            iUnitTargetType     = self:GetAbilityTargetType(),
                            --fExpireTime         = GameRules:GetGameTime() + 30,
                            --bDeleteOnHit        = false,
                            vVelocity           = vVelocity,
                            bProvidesVision     = true,
                            iVisionRadius     	= fRadius,
                            iVisionTeamNumber 	= hCaster:GetTeamNumber(),
                            --ExtraData 			= { nHollowPurpleVFX = self.nHollowPurpleFX }
                        }

    ProjectileManager:CreateLinearProjectile(hExplosion)
    ParticleManager:SetParticleControl(self.nHollowPurpleFX, 1, vVelocity * 4)
	
	if self.nHollowPurpleFX then
	    table.insert(self.iProjectiles, self.nHollowPurpleFX)
	end
	
    EmitSoundOn("gachi.takeitboy", hCaster)
end
function item_key_for_9:OnAbilityPhaseInterrupted()
    if self.nHollowPurpleFX then
        ParticleManager:DestroyParticle(self.nHollowPurpleFX, false)
        ParticleManager:ReleaseParticleIndex(self.nHollowPurpleFX)
    end
    --StopSoundOn("Gojo.hollow_purple_launch_test", self:GetCaster())
end
function item_key_for_9:OnProjectileThink(vLocation)
    GridNav:DestroyTreesAroundPoint(vLocation, 300, false)
	EmitSoundOnLocationWithCaster(vLocation, "gachi.wrench" .. RandomInt(1,3), self:GetCaster())
end
function item_key_for_9:OnProjectileHit(hTarget, vLocation)
	if IsNotNull(self) then
		if not IsNotNull(hTarget) then
            if self.iProjectiles and #self.iProjectiles > 0 then
                ParticleManager:DestroyParticle(self.iProjectiles[1], false)
                ParticleManager:ReleaseParticleIndex(self.iProjectiles[1])
				table.remove(self.iProjectiles, 1)
            end
            return
        end
		
        local hCaster   = self:GetCaster()
        local fDamage   = self:GetSpecialValueFor("damage")

        local hDamageTable =    {  
                                    victim 		 = hTarget,
                                    attacker 	 = hCaster,
                                    damage 		 = fDamage,
                                    damage_type  = self:GetAbilityDamageType(),
                                    ability 	 = self,
                             		damage_flags = 0
                                }
                                
        local hKnockBackTable = {
                                    should_stun        = 1,
                                    knockback_duration = 1,
                                    duration           = 1,
                                    knockback_distance = 200,
                                    knockback_height   = 200,
                                    center_x           = vLocation.x,
                                    center_y           = vLocation.y,
                                    center_z           = vLocation.z
                                }
                                
        hTarget:RemoveModifierByName("modifier_knockback")
        hTarget:AddNewModifier(hCaster, self, "modifier_knockback", hKnockBackTable, hTarget:IsOpposingTeam(hCaster:GetTeamNumber()))
        
        ApplyDamage(hDamageTable)
    end
end


modifier_key_for_9 = class({})


function modifier_key_for_9:IsHidden()
    return true
end

function modifier_key_for_9:IsPurgable()

    return false
end
function modifier_key_for_9:RemoveOnDeath() return false end
function modifier_key_for_9:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_key_for_9:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_key_for_9:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }

    return funcs
end

function modifier_key_for_9:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_key_for_9:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_key_for_9:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_key_for_9:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_key_for_9:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_key_for_9:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
  function modifier_key_for_9:GetModifierPreAttack_BonusDamage()
return self:GetAbility():GetSpecialValueFor('arm')
end                         