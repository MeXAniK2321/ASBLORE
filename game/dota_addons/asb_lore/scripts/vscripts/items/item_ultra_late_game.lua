
LinkLuaModifier("modifier_berserker_armor", "items/item_ultra_late_game", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_berserker_armor_buff", "items/item_ultra_late_game", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_berserker_armor_cd", "items/item_ultra_late_game", LUA_MODIFIER_MOTION_NONE )
---------------------------------------------------------------------------------------------------------------
-- Berserker Armor
---------------------------------------------------------------------------------------------------------------
item_berserker_armor = item_berserker_armor or class({})

function item_berserker_armor:GetIntrinsicModifierName()
	return "modifier_berserker_armor"
end
function item_berserker_armor:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = self:GetSpecialValueFor("active_duration")
    
    hCaster:AddNewModifier(hCaster, self, "modifier_berserker_armor_buff", {duration = fDuration})
    EmitSoundOn("berserker.activate", hCaster)
end
---------------------------------------------------------------------------------------------------------------

modifier_berserker_armor = modifier_berserker_armor or class({})

function modifier_berserker_armor:IsHidden() return false end
function modifier_berserker_armor:RemoveOnDeath() return false end
function modifier_berserker_armor:IsPurgable() return false end
function modifier_berserker_armor:DeclareFunctions()
    local tFunc =   {
                        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                        MODIFIER_PROPERTY_MIN_HEALTH,
                    }
    return tFunc
end
function modifier_berserker_armor:GetModifierPhysicalArmorBonus(keys)
    return self.nBonusArmor
end
function modifier_berserker_armor:GetModifierBonusStats_Strength(keys)
    return self.nBonusAllStats
end
function modifier_berserker_armor:GetModifierBonusStats_Agility(keys)
    return self.nBonusAllStats
end
function modifier_berserker_armor:GetModifierBonusStats_Intellect(keys)
    return self.nBonusAllStats
end
function modifier_berserker_armor:GetModifierAttackSpeedBonus_Constant()
    self.iAttkSpeedBonus = RemapValClamped(self.hParent:GetHealthPercent(), 100, 0, 0, self.iAttkSpeedV) -- Remap Percent HP from 100% to 0% return values from 0 and Max Attack Speed.
    return self.iAttkSpeedBonus 
end
function modifier_berserker_armor:GetMinHealth(keys)
    if self.hParent
        and IsNotNull(self.hParent) then
        if self.hParent:HasModifier("modifier_berserker_armor_cd") then return end
        local fHP = self.hParent:GetHealth()
        -- Idk if this is good or not but it works and it's simple so F*** it.
        if fHP <= self.fTriggerHP and not self.bOnCooldown then
            self:PassiveEffect(self.hParent)
            self:StartIntervalThink(0.1)
            self.bOnCooldown = true
        end
    end
    return self.fTriggerHP
end
function modifier_berserker_armor:OnCreated(hTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()
    
    self.fDurationP   = self.hAbility:GetSpecialValueFor("passive_duration")
    self.fTriggerHP   = self.hAbility:GetSpecialValueFor("trigger_hp")
    self.fCooldownDur = self.hAbility:GetSpecialValueFor("passive_cooldown")
    self.iAttkSpeedV  = self.hAbility:GetSpecialValueFor("passive_attackspeed")
    
    self.bOnCooldown = false
    self.fCDCounter  = self.fCDCounter or 0

    self.nBonusAllStats = self.hAbility:GetSpecialValueFor("bonus_allstats") or 85
    self.nBonusArmor    = self.hAbility:GetSpecialValueFor("bonus_armor") or 75
end
function modifier_berserker_armor:OnIntervalThink()
    if IsServer() then
        self.fCDCounter = self.fCDCounter + 0.1
        if self.fCDCounter >= self.fDurationP then
            self:StartCD()
            self.fCDCounter = 0 -- Reset Counter
           
           -- Remove the particle if it's there
            if self.iBloodParticle then
                ParticleManager:DestroyParticle( self.iBloodParticle, true )
                ParticleManager:ReleaseParticleIndex( self.iBloodParticle )
                self.iBloodParticle = nil
            end
            
            -- Stop the interval think
            self:StartIntervalThink(-1)
        end
    end
end
function modifier_berserker_armor:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_berserker_armor:OnDestroy()
    if IsServer() then
        if self.bOnCooldown then
            self:StartCD()
        end
    end
end
function modifier_berserker_armor:StartCD()
    if not self.hParent:HasModifier("modifier_berserker_armor_cd") then
        self.hParent:AddNewModifier(self.hParent, self.hAbility, "modifier_berserker_armor_cd", {duration = self.fCooldownDur})
    end
end
function modifier_berserker_armor:PassiveEffect(hParent)
    if not self.iBloodParticle then
        local iBloodParticleMaybe = ParticleManager:CreateParticle("particles/berserker_armor_blood_maybe.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hParent)
                                    ParticleManager:SetParticleControl(iBloodParticleMaybe, 0, hParent:GetAbsOrigin()) -- Main Attachment Point
        self:AddParticle(iBloodParticleMaybe, false, false, -1, false, false)
        self.iBloodParticle = iBloodParticleMaybe
        
        EmitSoundOn("berserker.passive", hParent)
    end
end
---------------------------------------------------------------------------------------------------------------

modifier_berserker_armor_buff = modifier_berserker_armor_buff or class({})

function modifier_berserker_armor_buff:IsHidden()                          return false end
function modifier_berserker_armor_buff:RemoveOnDeath()                     return true end
function modifier_berserker_armor_buff:IsPurgable()                        return false end
function modifier_berserker_armor_buff:DeclareFunctions()
    local func = {
                   MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
                   MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
                   MODIFIER_PROPERTY_IGNORE_ATTACKSPEED_LIMIT,
                 }
    return func
end
function modifier_berserker_armor_buff:OnCreated(hTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()
    
    self.iMoveSpeed   = self.hAbility:GetSpecialValueFor("active_movespeed")
    self.iActiveCast  = self.hAbility:GetSpecialValueFor("active_cast_percent")
    self.iAttackSpeed = self.hAbility:GetSpecialValueFor("active_attackspeed")
end
function modifier_berserker_armor_buff:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_berserker_armor_buff:GetModifierMoveSpeed_Absolute()
    return self.iMoveSpeed
end
function modifier_berserker_armor_buff:GetModifierPercentageCasttime()
    return self.iActiveCast
end
function modifier_berserker_armor_buff:GetModifierAttackSpeed_Limit()
    return self.iAttackSpeed
end
function modifier_berserker_armor_buff:GetEffectName()
    return "particles/berserker_armor_active_mist.vpcf"
end
function modifier_berserker_armor_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end


---------------------------------------------------------------------------------------------------------------

modifier_berserker_armor_cd = modifier_berserker_armor_cd or class({})

function modifier_berserker_armor_cd:IsHidden() return false end
function modifier_berserker_armor_cd:RemoveOnDeath() return false end
function modifier_berserker_armor_cd:IsPurgable() return false end 
function modifier_berserker_armor_cd:OnDestroy()
    if IsServer() then
        if self:GetParent():HasModifier("modifier_berserker_armor") then
            local hModifier = self:GetParent():FindModifierByNameAndCaster("modifier_berserker_armor", self:GetParent())
            
            if hModifier then
                hModifier.bOnCooldown = false
            end
        end
    end
end 


LinkLuaModifier("modifier_moonlight_goddess_bow", "items/item_ultra_late_game", LUA_MODIFIER_MOTION_NONE )
---------------------------------------------------------------------------------------------------------------
-- Moonlight Goddess Bow
---------------------------------------------------------------------------------------------------------------
item_moonlight_goddess_bow = item_moonlight_goddess_bow or class({})

function item_moonlight_goddess_bow:GetIntrinsicModifierName()
	return "modifier_moonlight_goddess_bow"
end
function item_moonlight_goddess_bow:OnSpellStart()
    local hCaster    = self:GetCaster()
    local vTarget    = self:GetCursorPosition()
    local vDirection = GetDirection(vTarget, hCaster)
    
    local f__Distance  = self:GetSpecialValueFor("distance_traveled") or 8500
    local f__Radius    = self:GetSpecialValueFor("hitbox_radius") or 150
    local i__Speed     = self:GetSpecialValueFor("projectile_speed") or 1750
    local i__SpawnDist = self:GetSpecialValueFor("spawn_distance") or 250
    
    local f__Damage    = self:GetSpecialValueFor("base_damage")
    local f__MaxDMG    = self:GetSpecialValueFor("max_damage")
    local f__ScaleF    = self:GetSpecialValueFor("distance_mult")
    local i__Radius    = self:GetSpecialValueFor("impact_radius")
    local f__StunDur   = self:GetSpecialValueFor("stun_duration")
    
    local vSpawnLoc  = hCaster:GetAbsOrigin() + vDirection * i__SpawnDist
    
    -- Absolute cringe, can't use OnProjectileHit_ExtraData for items
    if not self.hSubAbility then
	    self.hSubAbility = hCaster:AddAbility( "item_moonlight_goddess_bow_cringe" )
        
        if self.hSubAbility
            and IsNotNull(self.hSubAbility) then
            self.hSubAbility:SetLevel(1)
        else
            return
        end
    end
        
    local hGoddessArrow =  {   
	    			           Ability             = self.hSubAbility,
	    			           EffectName          = "particles/moonlight_goddess_bow_arrow.vpcf",
	    			           vSpawnOrigin        = vSpawnLoc,
	    			           fDistance           = f__Distance,
	    			           fStartRadius        = f__Radius,
	    			           fEndRadius          = f__Radius + 45,
	    			           Source              = hCaster,
	    			           bHasFrontalCone     = false,
	    			           bReplaceExisting    = false,
	    			           iUnitTargetTeam     = self:GetAbilityTargetTeam(),
	    			           iUnitTargetFlags    = self:GetAbilityTargetFlags(),
	    			           iUnitTargetType     = self:GetAbilityTargetType(),
	    			           --fExpireTime         = GameRules:GetGameTime() + 30,
	    			           --bDeleteOnHit        = true,
	    			           vVelocity           = vDirection * i__Speed,
	    			           bProvidesVision     = true,
	    			           iVisionRadius     	= f__Radius + 450,
	    			           iVisionTeamNumber 	= hCaster:GetTeamNumber(),
	    			           ExtraData 			= {
                                                        vSpawn_x = vSpawnLoc.x,
                                                        vSpawn_y = vSpawnLoc.y,
                                                        vSpawn_z = vSpawnLoc.z,
                                                        
                                                        fDamage  = f__Damage,
                                                        fMaxDMG  = f__MaxDMG,
                                                        fScaleF  = f__ScaleF,
                                                        iRadius  = i__Radius,
                                                        fStunDur = f__StunDur,
                                                        
                                                        --hAbility = self:GetAbilityIndex()
                                                        hAbility = self:GetAbilityName()
                                                      }
                     	    }

    EmitSoundOn("MGB.launch", hCaster)
    local iProjectile = ProjectileManager:CreateLinearProjectile(hGoddessArrow)
end
---------------------------------------------------------------------------------------------------------------

item_moonlight_goddess_bow_cringe = item_moonlight_goddess_bow_cringe or class({})

function item_moonlight_goddess_bow_cringe:OnProjectileHit_ExtraData(hTarget, vLocation, hTable)
    if IsNotNull(self)
        and IsNotNull(hTarget) then
        local hCaster   = self:GetCaster()
        local fDamage   = hTable.fDamage or 1500
        local iRadius   = hTable.iRadius or 250
        local vSpawnLoc = (hTable.vSpawn_x and hTable.vSpawn_z) -- PEPEGA?????
                          and Vector( hTable.vSpawn_x, 
                                      hTable.vSpawn_y, 
                                      hTable.vSpawn_z ) or nil
        --=======================================================--                 
        local fDistance = vSpawnLoc
                          and GetDistance(hTarget, vSpawnLoc)
                          or 0
        --=======================================================--
        local hAbility      = hCaster:FindAbilityByName(hTable.hAbility) or self
        local fMaxDamage    = hTable.fMaxDMG or 5000
        local fScaleFactor  = hTable.fScaleF or 1.0
        local fStunDuration = hTable.fStunDur or 2.5
        -- Calculate damage based on distance traveled and add a cap
        fDamage = fDistance > 0
                  and math.min( fMaxDamage, fDamage + (fDistance * fScaleFactor) )
                  or fDamage
        --=======================================================--
        
        local iExplosionParticle =  ParticleManager:CreateParticle("particles/moonlight_goddess_bow_arrow_explosion.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hTarget)
                                    ParticleManager:SetParticleControl(iExplosionParticle, 0, hTarget:GetAbsOrigin()) -- Main Attachment Point
                                    ParticleManager:SetParticleControl(iExplosionParticle, 2, Vector(iRadius, iRadius, 0)) -- Explosion Radius
        
        local hEnemies = FindUnitsInRadius( hCaster:GetTeamNumber(),
                                            hTarget:GetOrigin(),
                                            nil,
                                            iRadius,
                                            hAbility:GetAbilityTargetTeam(),
                                            hAbility:GetAbilityTargetType(),
                                            hAbility:GetAbilityTargetFlags(),
                                            FIND_ANY_ORDER,
                                            false )
                                            
        for _, hEnemy in pairs(hEnemies) do
            if IsNotNull(hEnemy) then
                local hDamageTable =  {  
                                        victim 		 = hEnemy,
                                        attacker 	 = hCaster,
                                        damage 		 = fDamage,
                                        damage_type  = hAbility:GetAbilityDamageType(),
                                        ability 	 = hAbility,
                                        damage_flags = 0
                                      }
        
                hEnemy:AddNewModifier(hCaster, hAbility, "modifier_stunned", {duration = fStunDuration})
                ApplyDamage(hDamageTable)
            end
        end
        
        EmitSoundOn("MGB.hit", hTarget)
        
        print("HMMMMM")
        return true
    end
end
---------------------------------------------------------------------------------------------------------------

modifier_moonlight_goddess_bow = modifier_moonlight_goddess_bow or class({})

function modifier_moonlight_goddess_bow:IsHidden() return true end
function modifier_moonlight_goddess_bow:RemoveOnDeath() return false end
function modifier_moonlight_goddess_bow:IsPurgable() return false end
function modifier_moonlight_goddess_bow:DeclareFunctions()
    local tFunc =   {
                        --MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                        MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
                        --MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS_PERCENTAGE,
                        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
                        MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
                        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT                    
                    }
    return tFunc
end
--[[function modifier_moonlight_goddess_bow:GetModifierPhysicalArmorBonus(keys)
    return self.nBonusArmor
end]]--
function modifier_moonlight_goddess_bow:GetModifierBonusStats_Strength(keys)
    return self.nBonusAllStats
end
function modifier_moonlight_goddess_bow:GetModifierBonusStats_Agility(keys)
    return self.nBonusAllStats
end
function modifier_moonlight_goddess_bow:GetModifierBonusStats_Intellect(keys)
    return self.nBonusAllStats
end
function modifier_moonlight_goddess_bow:GetModifierAttackRangeBonus(keys)
    return self.hParent:IsRangedAttacker() and self.nAttackRangeBonus
end
--[[function modifier_moonlight_goddess_bow:GetModifierProjectileSpeedBonusPercentage(keys)
    return self.hParent:IsRangedAttacker() and self.nProjSpeedExtra -- Just making sure
end]]--
function modifier_moonlight_goddess_bow:GetModifierProjectileSpeedBonus(keys)
    return self.hParent:IsRangedAttacker() and self.nProjSpeedExtra -- Just making sure
end
function modifier_moonlight_goddess_bow:GetBonusNightVision(keys)
    return self.nNightVisionBonus
end
function modifier_moonlight_goddess_bow:GetModifierSpellAmplify_Percentage(keys)
    return self.nSpellAmpBonus
end
function modifier_moonlight_goddess_bow:GetModifierMoveSpeedBonus_Constant(keys)
    return self.nMoveSpeedBonus
end
function modifier_moonlight_goddess_bow:OnCreated(hTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()
    

    self.nBonusAllStats    = self.hAbility:GetSpecialValueFor("bonus_all_stats") or 50
    --self.nBonusArmor     = self.hAbility:GetSpecialValueFor("bonus_armor") or 25
    self.nAttackRangeBonus = self.hAbility:GetSpecialValueFor("attack_range_bonus") or 400
    self.nProjSpeedExtra   = self.hAbility:GetSpecialValueFor("project_speed_extra") or 25
    self.nSpellAmpBonus    = self.hAbility:GetSpecialValueFor("spell_amp_bonus_perc") or 50
    self.nMoveSpeedBonus   = self.hAbility:GetSpecialValueFor("movespeed_bonus_const") or 75
    self.nNightVisionBonus = self.hAbility:GetSpecialValueFor("nightvision_bonus") or 800
end
function modifier_moonlight_goddess_bow:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_moonlight_goddess_bow:OnDestroy()
end


LinkLuaModifier("modifier_golden_daedalus", "items/item_ultra_late_game", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_golden_daedalus_buff", "items/item_ultra_late_game", LUA_MODIFIER_MOTION_NONE )
---------------------------------------------------------------------------------------------------------------
-- Golden Daedalus
---------------------------------------------------------------------------------------------------------------
item_golden_daedalus = item_golden_daedalus or class({})
