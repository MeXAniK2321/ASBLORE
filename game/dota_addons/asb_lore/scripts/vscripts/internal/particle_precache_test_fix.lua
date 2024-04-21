---------------------------------------------------------------------------------------
-- TEST FIX FOR PARTICLE AUTO PRECACHE
---------------------------------------------------------------------------------------

if IsServer() then
    -- Effects created with the projectile manager seem to be initiated properly without precaching.
    -- Note: Might also work with modifier's GetEffectName() function.
    local CreateEffectFixProjectile = function(sEffectName)
        local hExplosion =  {   
                                Ability             = nil,
                                EffectName          = sEffectName,
                                vSpawnOrigin        = Vector(0, 0, 0),
                                fDistance           = 0,
                                fStartRadius        = 0,
                                fEndRadius          = 0,
                                Source              = nil,
                                bHasFrontalCone     = false,
                                bReplaceExisting    = false,
                                iUnitTargetTeam     = 0,
                                iUnitTargetFlags    = 0,
                                iUnitTargetType     = 0,
                                fExpireTime         = GameRules:GetGameTime() + FrameTime(),
                                --bDeleteOnHit        = false,
                                vVelocity           = 0,
                                bProvidesVision     = false,
                                iVisionRadius     	= 0,
                                iVisionTeamNumber 	= 0,
                                --ExtraData 			= {}
                            }

        return ProjectileManager:CreateLinearProjectile(hExplosion)
    end
    --==============================================================================================================--
    local VALVE_CScriptParticleManager_CreateParticle = CScriptParticleManager.CreateParticle
    CScriptParticleManager.CreateParticle = function(self, sParticleName, iParticleAttachment, hOwner)
        local iProjectile = CreateEffectFixProjectile(sParticleName)
        if iProjectile and ProjectileManager:IsValidProjectile(iProjectile) then
            ProjectileManager:DestroyLinearProjectile(iProjectile)
            --print("HMMMMM")
        end
        
        --print("Server: Overriding Gaben Particle Function...")

        return VALVE_CScriptParticleManager_CreateParticle(self, sParticleName, iParticleAttachment, hOwner)
    end
end

