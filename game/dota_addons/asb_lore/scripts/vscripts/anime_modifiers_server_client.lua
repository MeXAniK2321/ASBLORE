--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    DOTA_ATTACK_RECORD_FAIL_NO = 0
    DOTA_ATTACK_RECORD_FAIL_TERRAIN_MISS = 1
    DOTA_ATTACK_RECORD_FAIL_SOURCE_MISS = 2
    DOTA_ATTACK_RECORD_FAIL_TARGET_EVADED = 3
    DOTA_ATTACK_RECORD_FAIL_TARGET_INVULNERABLE = 4
    DOTA_ATTACK_RECORD_FAIL_TARGET_OUT_OF_RANGE = 5
    DOTA_ATTACK_RECORD_CANNOT_FAIL = 6
    DOTA_ATTACK_RECORD_FAIL_BLOCKED_BY_OBSTRUCTION = 7
]]
--TODO: SOMEDAY FIX AND COMBINE ALL MODIFIER_EVENT PROCESS... UGH, CAUSE IT'S LIKE HEAL RECIEVE LOADING MAP IF MANY UNITS HAS THAT EVENT AT SAME TIME
LinkLuaModifier("modifier_anime_mechanic_perform_attack", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_perform_attack = modifier_anime_mechanic_perform_attack or class({})

function modifier_anime_mechanic_perform_attack:IsHidden()                                      return true end
function modifier_anime_mechanic_perform_attack:IsDebuff()                                      return false end
function modifier_anime_mechanic_perform_attack:IsPurgable()                                    return false end
function modifier_anime_mechanic_perform_attack:IsPurgeException()                              return false end
function modifier_anime_mechanic_perform_attack:RemoveOnDeath()                                 return false end
function modifier_anime_mechanic_perform_attack:GetAttributes()                                 return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_perform_attack:GetPriority()                                   return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_mechanic_perform_attack:IsMarbleException()                             return true end
function modifier_anime_mechanic_perform_attack:DeclareFunctions()
    local hFunc =   {
                        MODIFIER_PROPERTY_PROJECTILE_NAME,                          -- = 110 -- GetModifierProjectileName

                        --MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,             -- = -- GetActivityTranslationModifiers

                        --MODIFIER_EVENT_ON_ATTACK_START,                             -- = 159 -- OnAttackStart
                        MODIFIER_EVENT_ON_ATTACK_RECORD,                            -- = 158 -- OnAttackRecord
                        MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE,                   -- = 9 -- GetModifierOverrideAttackDamage
                        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,         -- = 3 -- GetModifierPreAttack_BonusDamagePostCrit
                        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,                 -- = 117 -- GetModifierPreAttack_CriticalStrike
                        --MODIFIER_PROPERTY_PRE_ATTACK,                               -- = 10 -- GetModifierPreAttack --??? WHAT IS THAT AND WTF IT'S DOES
                        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,                   -- = 201 -- GetAttackSound
                        --MODIFIER_EVENT_ON_ATTACK,                                   -- = 160 -- OnAttack
                        --MODIFIER_EVENT_ON_ATTACK_CANCELLED,                         -- = 225 -- OnAttackCancelled
                        --MODIFIER_EVENT_ON_ATTACK_FINISHED,                          -- = 215 -- OnAttackFinished
                        --MODIFIER_EVENT_ON_ATTACK_FAIL,                              -- = 162 -- OnAttackFail

                        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,         -- = 5 -- GetModifierProcAttack_BonusDamage_Physical
                        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,          -- = 6 -- GetModifierProcAttack_BonusDamage_Magical
                        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,             -- = 7 -- GetModifierProcAttack_BonusDamage_Pure

                        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,                      -- = 8 -- GetModifierProcAttack_Feedback
                        --MODIFIER_EVENT_ON_ATTACK_LANDED,                            -- = 161 -- OnAttackLanded

                        --MODIFIER_EVENT_ON_PROCESS_CLEAVE,                           -- = 190 -- OnProcessCleave

                        --MODIFIER_EVENT_ON_ATTACKED,                                 -- = 180 -- OnAttacked
                        MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,                    -- = 222 -- OnAttackRecordDestroy

                        --THERE U CAN ADD DAMAGE TAKE EVENT WITH RECORD CHECKING TOO, NOICE!
                    }
    return hFunc
end
function modifier_anime_mechanic_perform_attack:GetModifierProjectileName(keys)
    if IsServer()
        and not self.__iPERFORM_ATTACK_RECORD
        and self.__hParent:IsRangedAttacker() then
        --and type(self.__sProjectileName) == "string" then
        return self.__sProjectileName
    end
end
function modifier_anime_mechanic_perform_attack:OnAttackRecord(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        local hTarget   = keys.target
        if not self.__iPERFORM_ATTACK_RECORD
            and self.__hParent == hAttacker
            and IsNotNull(hAttacker)
            and IsNotNull(hTarget) then
            self.__iPERFORM_ATTACK_RECORD = keys.record
            --print("1", "OnAttackRecord", keys.record, keys.fail_type)
            --SPECIAL THING ONLY FOR MEELE ANTI-MISS ATTACKS BY CLEAVE RANGE APPLYING
            if self.__bCleaveRange
                and not hAttacker:IsRangedAttacker() then
                return self:ApplyAndRecordCleaveRange(hAttacker, hTarget)
            end
        end
        --print("1", "OnAttackRecord")
    end
end
function modifier_anime_mechanic_perform_attack:GetModifierOverrideAttackDamage(keys)
    if IsServer()
        and self.__iPERFORM_ATTACK_RECORD == keys.record then
        --print("2", "GetModifierOverrideAttackDamage", keys.record)
        return self.__fOverrideDamage
    end
end
function modifier_anime_mechanic_perform_attack:GetModifierPreAttack_BonusDamagePostCrit(keys)
    if IsServer()
        and self.__iPERFORM_ATTACK_RECORD == keys.record then
        --print("3", "GetModifierPreAttack_BonusDamagePostCrit", keys.record)
        return self.__fPostCritDamage
    end
end
function modifier_anime_mechanic_perform_attack:GetModifierPreAttack_CriticalStrike(keys)
    if IsServer()
        and self.__iPERFORM_ATTACK_RECORD == keys.record then
        --print("4", "GetModifierPreAttack_CriticalStrike", keys.record)
        return self.__fCritDamage
    end
end
function modifier_anime_mechanic_perform_attack:GetAttackSound(keys)
    if IsServer()
        and self.__iPERFORM_ATTACK_RECORD == keys.record then
        --print("5", "GetAttackSound", keys.record)
        return self.__sAttackSound
    end
end
function modifier_anime_mechanic_perform_attack:GetModifierProcAttack_BonusDamage_Physical(keys)
    if IsServer()
        and self.__iPERFORM_ATTACK_RECORD == keys.record then
        --print("6", "GetModifierProcAttack_BonusDamage_Physical", keys.record)
        return self.__fPhysicalDamage
    end
end
function modifier_anime_mechanic_perform_attack:GetModifierProcAttack_BonusDamage_Magical(keys)
    if IsServer()
        and self.__iPERFORM_ATTACK_RECORD == keys.record then
        --print("7", "GetModifierProcAttack_BonusDamage_Magical", keys.record)
        return self.__fMagicalDamage
    end
end
function modifier_anime_mechanic_perform_attack:GetModifierProcAttack_BonusDamage_Pure(keys)
    if IsServer()
        and self.__iPERFORM_ATTACK_RECORD == keys.record then
        --print("8", "GetModifierProcAttack_BonusDamage_Pure", keys.record)
        return self.__fPureDamage
    end
end
function modifier_anime_mechanic_perform_attack:GetModifierProcAttack_Feedback(keys)
    if IsServer()
        and self.__iPERFORM_ATTACK_RECORD == keys.record then
        local hAttacker = keys.attacker
        local hTarget   = keys.target
        if IsNotNull(hAttacker) then
            if self.__bSupressCleave then
                self.__hSupressCleaveModifier = hAttacker:AddNewModifier(hAttacker, self.__hAbility, "modifier_tidehunter_anchor_smash_caster", {})
            end
            if self.__bCleaveRange
                and not self.__vOldDirection
                and not self.__vOldLocation
                and IsNotNull(hTarget) then
                self:ApplyAndRecordCleaveRange(hAttacker, hTarget)
            end
        end
        --print("9", "GetModifierProcAttack_Feedback", keys.ranged_attack, keys.process_procs, keys.record, hAttacker:HasModifier("modifier_item_anime_dark_repulser_cooldown"))
        return self.__fFeedbackDamage
    end
end
function modifier_anime_mechanic_perform_attack:OnProcessCleave1(keys) --THERE MAKING A CLEAVE ATTACK
    if IsServer()
        and self.__iPERFORM_ATTACK_RECORD == keys.record then
        --print("10", "OnProcessCleave")
    end
end
function modifier_anime_mechanic_perform_attack:OnAttackRecordDestroy(keys)
    if IsServer()
        and self.__iPERFORM_ATTACK_RECORD == keys.record then
        local hAttacker = keys.attacker
        local hTarget   = keys.target
        if IsNotNull(hAttacker) then
            if self.__bSupressCleave then
                if IsNotNull(self.__hSupressCleaveModifier) then
                    self.__hSupressCleaveModifier:Destroy()
                end
            end
            if self.__bCleaveRange
                and self.__vOldDirection
                and self.__vOldLocation then
                hAttacker:SetForwardVector(self.__vOldDirection, true)
                hAttacker:SetAbsOrigin(self.__vOldLocation)
                --print("WTF", self.__vOldLocation, keys.record)
            end
        end
        --print("11", "OnAttackRecordDestroy", keys.record, keys.fail_type)
        return self:Destroy()
    end
end
function modifier_anime_mechanic_perform_attack:OnCreated(hTable)
    self.__hCaster  = self:GetCaster()
    self.__hParent  = self:GetParent()
    self.__hAbility = self:GetAbility()

    if IsServer() then
        self.__iPERFORM_ATTACK_RECORD = self.__iPERFORM_ATTACK_RECORD or nil

        self.__sProjectileName = hTable.__sProjectileName
        self.__fOverrideDamage = hTable.__fOverrideDamage
        self.__fPostCritDamage = hTable.__fPostCritDamage
        self.__fCritDamage     = hTable.__fCritDamage
        self.__sAttackSound    = hTable.__sAttackSound
        self.__fPhysicalDamage = hTable.__fPhysicalDamage
        self.__fMagicalDamage  = hTable.__fMagicalDamage
        self.__fPureDamage     = hTable.__fPureDamage
        self.__fFeedbackDamage = hTable.__fFeedbackDamage

        self.__bSupressCleave = ( hTable.__bSupressCleave or 0 ) > 0
        self.__bCleaveRange   = ( hTable.__bCleaveRange   or 0 ) > 0

        --[[print(  self.__sProjectileName,
                self.__fOverrideDamage,
                self.__fPostCritDamage,
                self.__fCritDamage,
                self.__sAttackSound,
                self.__fPhysicalDamage,
                self.__fMagicalDamage,
                self.__fPureDamage,
                self.__fFeedbackDamage,
                self.__bSupressCleave,
                self.__bCleaveRange
            )]]
    end
end
function modifier_anime_mechanic_perform_attack:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_mechanic_perform_attack:ApplyAndRecordCleaveRange(hAttacker, hTarget)
    if IsServer() then
        self.__vOldDirection = hAttacker:GetForwardVector()
        self.__vOldLocation  = GetGroundPosition(hAttacker:GetAbsOrigin(), hAttacker)

        local vTargetLoc = hTarget:GetAbsOrigin()
        local vDirection = GetDirection(vTargetLoc, self.__vOldLocation)
                
        local fBoundSize = ( hTarget:BoundingRadius2D() + hAttacker:BoundingRadius2D() ) * 2

        hAttacker:SetForwardVector(vDirection, true)
        hAttacker:SetAbsOrigin(vTargetLoc + vDirection * -fBoundSize) --BOUNDING BECAUSE SHOULD BE VERY SMALL VALUE LIKE INDENTICAL RANGE

        --FindClearSpaceForUnit(self, vLoc_hTarget, false) --NOT WORK WHILE MOTION CONTROLLED????, ALSO SOMEHOW AFFECT TO TRIGGERS ON GRIDNAV IF THEY TOUCHED
    end
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
_G.hAnimeKVLore = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")

LinkLuaModifier("modifier_anime_mechanic_backtrack", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_backtrack = modifier_anime_mechanic_backtrack or class({})

function modifier_anime_mechanic_backtrack:IsHidden()                                                                               return true end
function modifier_anime_mechanic_backtrack:IsDebuff()                                                                               return false end
function modifier_anime_mechanic_backtrack:IsPurgable()                                                                             return false end
function modifier_anime_mechanic_backtrack:IsPurgeException()                                                                       return false end
function modifier_anime_mechanic_backtrack:RemoveOnDeath()                                                                          return false end
function modifier_anime_mechanic_backtrack:GetAttributes()                                                                          return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_backtrack:GetPriority()                                                                            return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_mechanic_backtrack:AllowIllusionDuplicate()                                                                 return true end
function modifier_anime_mechanic_backtrack:IsMarbleException()                                                                      return true end
function modifier_anime_mechanic_backtrack:DeclareFunctions()
    local hFunc =   {
                        --+123 MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR,   --129 = GetModifierPhysical_ConstantBlockUnavoidablePreArmor --DUBLICATES 3 TIMES ??? WTF
                        --+123 MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,                      --127 = GetModifierPhysical_ConstantBlock
                        --+123 MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK_SPECIAL,              --128 = GetModifierPhysical_ConstantBlockSpecial

                        --+123 MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK,                       --126 = GetModifierMagical_ConstantBlock
                        --+123 MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT,               --60 = GetModifierIncomingSpellDamageConstant

                        --+123 MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,          --58 = GetModifierIncomingPhysicalDamage_Percentage
                        --+123 MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT,            --59 = GetModifierIncomingPhysicalDamageConstant

                        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,                          --144 = GetAbsoluteNoDamagePhysical --Marble Damage Prevent Realisation
                        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,                           --145 = GetAbsoluteNoDamageMagical --Marble Damage Prevent Realisation
                        MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,                              --146 = GetAbsoluteNoDamagePure --Marble Damage Prevent Realisation

                        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,                           --57 = GetModifierIncomingDamage_Percentage --USING FOR TARGET SPELL CRITICAL STRIKE

                        MODIFIER_PROPERTY_AVOID_DAMAGE,                                         --66 = GetModifierAvoidDamage

                        MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,                                 --130 = GetModifierTotal_ConstantBlock

                        --+123 MODIFIER_EVENT_ON_DAMAGE_CALCULATED,                            --191 = OnDamageCalculated --WORK ONLY FOR RBM, --WORK FOR ANYONE EXCEPT OWNER
                        --+123 MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,                        --201 = OnTakeDamageKillCredit, --WORK FOR ANYONE EXCEPT OWNER

                        --ON DAMAGE FILTER THERE BEFORE TAKE DAMAGE, --WORK FOR ANYONE EXCEPT OWNER

                        --+123 MODIFIER_EVENT_ON_TAKEDAMAGE,                                   --186 = OnTakeDamage, --WORK FOR ANYONE EXCEPT OWNER 

                        --MODIFIER_PROPERTY_MIN_HEALTH,                                   --143 = GetMinHealth --WORK EACH FRAME
                        --MODIFIER_PROPERTY_DISABLE_HEALING,                              --155 = GetDisableHealing --WORK EACH FRAME
                        --MODIFIER_EVENT_ON_DEATH_PREVENTED,                              --187 = OnDamagePrevented --Not Work!!!

                        --MODIFIER_EVENT_ON_PROCESS_CLEAVE,                               --190 = OnProcessCleave --WORK FOR ANYONE EXCEPT OWNER, WORK BEFORE EVERYTHING THERE????
                        --MODIFIER_PROPERTY_SUPPRESS_CLEAVE,                              --239 = GetSuppressCleave --Not Work!!!

                        --MODIFIER_PROPERTY_HEALTH_BONUS,
                        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
                        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
                        
                        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
                    }
                    
    local sMapName = GetMapName()
    if ( IsServer() and sMapName == "anime_3x4_lore" )
        or ( IsClient() and sMapName == "maps/anime_3x4_lore.vpk" ) then
        table.insert(hFunc, MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL)
        table.insert(hFunc, MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE)

        table.insert(hFunc, MODIFIER_PROPERTY_HEALTH_BONUS)
        table.insert(hFunc, MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
    end
    return hFunc
end
function modifier_anime_mechanic_backtrack:GetModifierPhysical_ConstantBlockUnavoidablePreArmor(keys)
    if IsServer() then
        print("GetModifierPhysical_ConstantBlockUnavoidablePreArmor: 1!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type, IsServer())
    end
end
function modifier_anime_mechanic_backtrack:GetModifierPhysical_ConstantBlock(keys)
    if IsServer() then
        print("GetModifierPhysical_ConstantBlock: 2!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
    end
end
function modifier_anime_mechanic_backtrack:GetModifierPhysical_ConstantBlockSpecial(keys)
    if IsServer() then
        print("GetModifierPhysical_ConstantBlockSpecial: 3!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
    end
end
function modifier_anime_mechanic_backtrack:GetModifierMagical_ConstantBlock(keys)
    if IsServer() then
        print("GetModifierMagical_ConstantBlock: 4!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
    end
end
function modifier_anime_mechanic_backtrack:GetModifierIncomingSpellDamageConstant(keys)
    if IsServer() then
        print("GetModifierIncomingSpellDamageConstant: 5!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
    end
end
function modifier_anime_mechanic_backtrack:GetModifierIncomingPhysicalDamage_Percentage(keys)
    if IsServer() then
        print("GetModifierIncomingPhysicalDamage_Percentage: 6!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
    end
end
function modifier_anime_mechanic_backtrack:GetModifierIncomingPhysicalDamageConstant(keys)
    if IsServer() then
        print("GetModifierIncomingPhysicalDamageConstant: 7!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
    end
end
function modifier_anime_mechanic_backtrack:GetAbsoluteNoDamagePhysical(keys) --TODO: CHANGE TO RECORD EXCEPT SELF.B-VALUE
    if IsServer()
        and keys.damage_type ~= DAMAGE_TYPE_NONE then
        self.__iNullifyDamageType = ( ( not IsInMarbleSphere({keys.attacker}) and IsInMarbleSphere({keys.target}) ) or ( not IsInMarbleSphere({keys.target}) and IsInMarbleSphere({keys.attacker}) ) )
                                    and DAMAGE_TYPE_ALL
                                    or keys.target:GetTotalDamageNullify(keys)
                                    or DAMAGE_TYPE_NONE
        --print("GetAbsoluteNoDamagePhysical: 8!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
        if bit.band(DAMAGE_TYPE_PHYSICAL, self.__iNullifyDamageType) ~= 0 then
            return 1
        end
    end
end
function modifier_anime_mechanic_backtrack:GetAbsoluteNoDamageMagical(keys)
    if IsServer() then
        --print("GetAbsoluteNoDamageMagical: 9!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
        if bit.band(DAMAGE_TYPE_MAGICAL, self.__iNullifyDamageType) ~= 0 then
            return 1
        end
    end
end
function modifier_anime_mechanic_backtrack:GetAbsoluteNoDamagePure(keys)
    if IsServer() then
        --print("GetAbsoluteNoDamagePure: 10!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
        if bit.band(DAMAGE_TYPE_PURE, self.__iNullifyDamageType) ~= 0 then
            return 1
        end
    end
end
function modifier_anime_mechanic_backtrack:GetModifierIncomingDamage_Percentage(keys)
    if IsServer() then
        --print("GetModifierIncomingDamage_Percentage: 11!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
        local hAttacker = keys.attacker
        local hTarget   = keys.target
        if IsNotNull(hAttacker)
            and IsNotNull(hTarget)
            and keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL
            and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS)     ~= DOTA_DAMAGE_FLAG_HPLOSS
            and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
                local hCriticalTable =  {
                                            hAttacker:GetSpellCriticalStrike(keys),
                                            hTarget:GetSpellCriticalStrike_Target(keys)
                                        }
                table.sort(hCriticalTable, function(fA, fB) return (fA > fB) end)
                local fCriticalDamage = hCriticalTable[1]
                if fCriticalDamage > 100 then
                    --print(fCriticalDamage, "SPELL CRITICAL TARGET")
                    --USING DEADLY BLOW BECAUSE IT'S ORANGE CRIT VALUE SAS NICE
                    SendOverheadEventMessage(nil, OVERHEAD_ALERT_DEADLY_BLOW, hTarget, keys.original_damage * fCriticalDamage * 0.01, nil)

                    return fCriticalDamage - 100
                end
            --end
        end
    end
end
function modifier_anime_mechanic_backtrack:GetModifierAvoidDamage(keys)
    if IsServer() then
        --print("GetModifierAvoidDamage: 12!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
        local hCaster = keys.attacker
        local hParent = keys.target

        if IsNotNull(hCaster) 
            and IsNotNull(hParent) then
            local fTotalEvasion = hParent:GetTotalEvasion(keys)
            if fTotalEvasion > 0
                and RollPseudoRandom(fTotalEvasion, hParent) then
                local iBackTrackPFX =   ParticleManager:CreateParticle("particles/heroes/anime_hero_kc/kc_epitaph_backtrack.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
                                        ParticleManager:ReleaseParticleIndex(iBackTrackPFX)
        
                local hRollTable = {
                                        OVERHEAD_ALERT_LAST_HIT_EARLY,
                                        OVERHEAD_ALERT_LAST_HIT_CLOSE,
                                        OVERHEAD_ALERT_LAST_HIT_MISS
                                    }
                
                SendOverheadEventMessage(nil, hRollTable[RandomInt(1, TableLength(hRollTable))], hParent, fTotalEvasion, nil)

                return 1
            end

            return hParent:GetTotalDamageDeposit(keys)
        end
    end
end
function modifier_anime_mechanic_backtrack:GetModifierTotal_ConstantBlock(keys)
    if IsServer() then
        --print("GetModifierTotal_ConstantBlock: 13!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
        return keys.target:GetTotalDamageBlock_Stacking(keys)
    end
end
function modifier_anime_mechanic_backtrack:OnDamageCalculated1(keys)
    if IsServer()
        and keys.target == self.parent then
        print("OnDamageCalculated: 14!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
    end
end
function modifier_anime_mechanic_backtrack:OnTakeDamageKillCredit1(keys)
    if IsServer()
        and keys.target == self.parent then
        print("OnTakeDamageKillCredit: 15!", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
    end
end
function modifier_anime_mechanic_backtrack:OnTakeDamage1(keys)
    if IsServer()
        and keys.unit == self.parent then
        print("OnTakeDamage: 17! (16! IS FILTER)", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type, keys.record)
    end
end
--[[function modifier_anime_mechanic_backtrack:GetMinHealth(keys)
    print("GetMinHealth: ", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
end]]
--[[function modifier_anime_mechanic_backtrack:GetDisableHealing(keys)
    print("GetDisableHealing: ", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
end]]
--[[function modifier_anime_mechanic_backtrack:OnDamagePrevented(keys)
    print("OnDamagePrevented: ", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
end]]
--[[function modifier_anime_mechanic_backtrack:OnProcessCleave(keys)
    print("OnProcessCleave: -10000", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
end]]
--[[function modifier_anime_mechanic_backtrack:GetSuppressCleave(keys)
    print("GetSuppressCleave: ", keys.damage, keys.original_damage, keys.damage_category, keys.damage_type)
end]]
function modifier_anime_mechanic_backtrack:GetModifierOverrideAbilitySpecial(keys)
    --[[for k,v in pairs(keys) do 
        print(k,v, "SPECIAL", IsServer())
    end]]
    local hAbility = keys.ability
    local iLevel   = keys.ability_special_level
    local sKeyName = keys.ability_special_value
    if IsNotNull(hAbility)
        and IsNotNull(iLevel)
        and IsNotNull(sKeyName) then
        local hAbilityTable = hAnimeKVLore[hAbility:GetAbilityName()]
        if IsNotNull(hAbilityTable) then
            local hAbilitySpecial = hAbilityTable["AbilitySpecial"]
            if TableLength(hAbilitySpecial) > 0 then
                for _, hV in pairs(hAbilitySpecial) do
                    if IsNotNull(hV[sKeyName]) then
                        return 1
                    end
                end
            end
        end
    end
    --return 1
end
function modifier_anime_mechanic_backtrack:GetModifierOverrideAbilitySpecialValue(keys)
    --[[for k,v in pairs(keys) do 
        print(k,v, "SPECIAL VALUE", IsServer())
    end]]
    local hAbility = keys.ability
    local iLevel   = keys.ability_special_level
    local sKeyName = keys.ability_special_value
    if IsNotNull(hAbility)
        and IsNotNull(iLevel)
        and IsNotNull(sKeyName) then
        local hAbilityTable = hAnimeKVLore[hAbility:GetAbilityName()]
        if IsNotNull(hAbilityTable) then
            local hAbilitySpecial = hAbilityTable["AbilitySpecial"]
            if TableLength(hAbilitySpecial) > 0 then
                for _, hV in pairs(hAbilitySpecial) do
                    if IsNotNull(hV[sKeyName]) then
                        hV = string.split(hV[sKeyName], " ")
                        local iLength = TableLength(hV)
                        if iLength > 0 then
                            local liLevel = iLevel + 1
                            liLevel = iLength >= liLevel
                                      and liLevel
                                      or iLength
                            return tonumber(hV[liLevel])
                        end
                    end
                end
            end
        end
        return hAbility:GetLevelSpecialValueNoOverride(sKeyName, iLevel)
    end
    --return 1
end
function modifier_anime_mechanic_backtrack:GetModifierHealthBonus(keys)
    --if IsServer() then
        -- and IsNotNull(self.parent)
        -- and IsNotNull(PlayerResource) then
        -- local hMainContoller = PlayerResource:GetSelectedHeroEntity(self.parent:GetPlayerOwnerID())
        -- if IsNotNull(hMainContoller)
        --     and hMainContoller:IsRealHero() then
        --     return hMainContoller:GetDeaths() * hMainContoller:GetPrimaryStatValue()
        -- end
        --return self:GetStackCount() * 888
    --end
end
function modifier_anime_mechanic_backtrack:GetModifierExtraHealthBonus(keys)
    --if IsServer() then
        -- and IsNotNull(self.parent)
        -- and IsNotNull(PlayerResource) then
        -- local hMainContoller = PlayerResource:GetSelectedHeroEntity(self.parent:GetPlayerOwnerID())
        -- if IsNotNull(hMainContoller)
        --     and hMainContoller:IsRealHero() then
        --     return hMainContoller:GetDeaths() * hMainContoller:GetPrimaryStatValue()
        -- end
    if self:GetStackCount() > 0 then
        return self:GetStackCount() * 222
    end
end
function modifier_anime_mechanic_backtrack:GetModifierPercentageCooldown(keys)
    if self:GetStackCount() > 0 then
        return 50
    end
end
function modifier_anime_mechanic_backtrack:GetModifierTotalDamageOutgoing_Percentage(keys)
    --if IsServer() then
        -- and IsNotNull(self.parent)
        -- and IsNotNull(PlayerResource) then
        -- local hMainContoller = PlayerResource:GetSelectedHeroEntity(self.parent:GetPlayerOwnerID())
        -- if IsNotNull(hMainContoller)
        --     and hMainContoller:IsRealHero() then
        --     local iIncreasing = keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK
        --                         and 4
        --                         or 6
        --     return hMainContoller:GetDeaths() * iIncreasing
        -- end
    if self:GetStackCount() > 0 then
        return self:GetStackCount() * 13
    end
end
function modifier_anime_mechanic_backtrack:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    --self.__hWinratesPower = AnimeOverthrow.__hWinratesPower[self]
    --_G.CounterEnt111 = ( CounterEnt111 or 0 ) + 1
    --print(CounterEnt111, "PRINING ADDED COUNT MODIFIER BACKTRACK", self.parent:GetClassname(), self.parent:GetName(), self.parent:GetUnitName(), IsServer())
    if IsServer()
        and ( self.parent:IsRealHero()
        or self.parent:IsCreepHero()
        or self.parent:IsCourier() ) then
        --self:StartIntervalThink(1)
    end

    if IsServer() then
        self:OnIntervalThink()
        self:StartIntervalThink(1)
    end
end
--hEntity:HasModifier("modifier_fountain_aura_buff")
function modifier_anime_mechanic_backtrack:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_mechanic_backtrack:OnIntervalThink()
    if IsServer()
        and MAD_MODE_ENABLE then
        self:SetStackCount(math.floor( GameRules:GetDOTATime(false, false) / 60 ))

        --local nStacks = self:GetStackCount()

        --self.parent:SetMaxHealth(self.parent:GetMaxHealth() + 222)
        --self.parent:SetHealth(self.parent:GetHealth() + 222)
        if self.parent:IsRealHero() then
            self.parent:CalculateStatBonus(false)
        elseif self.parent:IsNPC() then
            self.parent:CalculateGenericBonuses()
        end
    end
end
function modifier_anime_mechanic_backtrack:OnIntervalThink1111() --COOLDOWN FREEZING ON BASE. -TEST IT'S FREEZING GAME A BIT? I think it's because tons of thinkers and marble or etc finders over all of them
    if IsServer() then
        local hParent = self:GetParent()
        local bFreeze = hParent:HasModifier("modifier_fountain_aura_buff")
            
        --if hParent:HasModifier("modifier_anime_mechanic_player_disconnected") then
            --return
        --end

        local iAC = hParent:GetAbilityCount() - 1
        for i = 0, iAC do
            local hAbility = hParent:GetAbilityByIndex(i)
            if IsNotNull(hAbility)
                and not hAbility:IsAttributeBonus()
                and hAbility:GetCooldown(-1) > 0
                and hAbility:IsTrained()
                and hAbility:IsUltimate() then
                hAbility:SetFrozenCooldown(bFreeze)
            end

            local hItem = hParent:GetItemInSlot(i)
            if IsNotNull(hItem)
                and not hItem:IsAttributeBonus()
                and hItem:GetAbilityName() ~= "item_tpscroll"
                and hItem:GetCooldown(-1) > 0 then
                hItem:SetFrozenCooldown(bFreeze)
            end
        end
    end
end
--[[function modifier_anime_mechanic_backtrack:GetEffectName()
    return "particles/generic_gameplay/screen_stun_indicator.vpcf"
end
function modifier_anime_mechanic_backtrack:GetEffectAttachType()
    return PATTACH_MAIN_VIEW
end]]
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_mechanic_accuracy", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_accuracy = modifier_anime_mechanic_accuracy or class({})

function modifier_anime_mechanic_accuracy:IsHidden()                                return true end
function modifier_anime_mechanic_accuracy:IsDebuff()                                return false end
function modifier_anime_mechanic_accuracy:IsPurgable()                              return false end
function modifier_anime_mechanic_accuracy:IsPurgeException()                        return false end
function modifier_anime_mechanic_accuracy:RemoveOnDeath()                           return false end
function modifier_anime_mechanic_accuracy:GetAttributes()                           return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_accuracy:GetPriority()                             return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_mechanic_accuracy:IsMarbleException()                       return true end
function modifier_anime_mechanic_accuracy:CheckState()
    local hState =  {
                        [MODIFIER_STATE_CANNOT_MISS] = true
                    }
    return hState
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
local PrintTable = function(hTable, sName)
    for k, v in pairs(hTable) do
        print(k, v, sName)
    end
end
]]

--[[
function CDOTABaseAbility:UniqueAttackProjectileName(keys)
end
function CDOTABaseAbility:UniqueAttackCheckState()
end
function CDOTABaseAbility:UniqueAttackTranslationModifiers(keys)
end
function CDOTABaseAbility:UniqueAttackStartIntervalThink(hModifier)
end
function CDOTABaseAbility:UniqueAttackOnIntervalThink(hModifier)
end
function CDOTABaseAbility:UniqueAttackOnStartOrRecord(keys, hModifier)
end
function CDOTABaseAbility:UniqueAttackOverrideAttackDamage(keys, hModifier)
end
function CDOTABaseAbility:UniqueAttackPreAttack_BonusDamagePostCrit(keys, hModifier)
end
function CDOTABaseAbility:UniqueAttackPreAttack_CriticalStrike(keys, hModifier)
end
function CDOTABaseAbility:UniqueAttackPreAttack(keys, hModifier)
end
function CDOTABaseAbility:UniqueAttackOnAttack(keys, hModifier)
end
function CDOTABaseAbility:UniqueAttackSound(keys, hModifier)
end
function CDOTABaseAbility:UniqueAttackOnAttackFail(keys, hModifier)
end
function CDOTABaseAbility:UniqueAttackProcAttack_BonusDamage_All(keys, hModifier, iDAMAGE_TYPE)
end
function CDOTABaseAbility:UniqueAttackProcAttack_Feedback(keys, hModifier)
end
function CDOTABaseAbility:UniqueAttackOnAttackLanded(keys, hModifier)
end
function CDOTABaseAbility:UniqueAttackOnAttacked(keys, hModifier)
end
function CDOTABaseAbility:UniqueAttackOnOrder(keys, hModifier)
end
UNIQUE_ATTACKS_RECORDS_EXCEPTIONS
]]

LinkLuaModifier("modifier_anime_mechanic_unique_attack", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_unique_attack = modifier_anime_mechanic_unique_attack or class({})

function modifier_anime_mechanic_unique_attack:IsHidden()                                       return true end
function modifier_anime_mechanic_unique_attack:IsDebuff()                                       return false end
function modifier_anime_mechanic_unique_attack:IsPurgable()                                     return false end
function modifier_anime_mechanic_unique_attack:IsPurgeException()                               return false end
function modifier_anime_mechanic_unique_attack:RemoveOnDeath()                                  return false end
function modifier_anime_mechanic_unique_attack:GetAttributes()                                  return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_unique_attack:GetPriority()                                    return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_mechanic_unique_attack:IsMarbleException()                              return true end
function modifier_anime_mechanic_unique_attack:DeclareFunctions()
--[[local func =    {
                        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,             -- = -- GetActivityTranslationModifiers

                        MODIFIER_EVENT_ON_ATTACK_START,                             -- = 159 -- OnAttackStart
                        MODIFIER_EVENT_ON_ATTACK_RECORD,                            -- = 158 -- OnAttackRecord
                        MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE,                   -- = 9 -- GetModifierOverrideAttackDamage
                        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT,         -- = 3 -- GetModifierPreAttack_BonusDamagePostCrit
                        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,                 -- = 117 -- GetModifierPreAttack_CriticalStrike
                        MODIFIER_PROPERTY_PRE_ATTACK,                               -- = 10 -- GetModifierPreAttack
                        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,                   -- = 201 -- GetAttackSound
                        MODIFIER_EVENT_ON_ATTACK,                                   -- = 160 -- OnAttack
                        MODIFIER_EVENT_ON_ATTACK_CANCELLED,                         -- = 225 -- OnAttackCancelled
                        MODIFIER_EVENT_ON_ATTACK_FINISHED,                          -- = 215 -- OnAttackFinished
                        MODIFIER_EVENT_ON_ATTACK_FAIL,                              -- = 162 -- OnAttackFail
                        
                        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,         -- = 5 -- GetModifierProcAttack_BonusDamage_Physical
                        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,          -- = 6 -- GetModifierProcAttack_BonusDamage_Magical
                        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,             -- = 7 -- GetModifierProcAttack_BonusDamage_Pure

                        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,                      -- = 8 -- GetModifierProcAttack_Feedback
                        MODIFIER_EVENT_ON_ATTACK_LANDED,                            -- = 161 -- OnAttackLanded

                        MODIFIER_EVENT_ON_PROCESS_CLEAVE,                           -- = 190 -- OnProcessCleave

                        MODIFIER_EVENT_ON_ATTACKED,                                 -- = 180 -- OnAttacked
                        MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,                    -- = 222 -- OnAttackRecordDestroy

                        MODIFIER_EVENT_ON_ORDER                                     -- = -- OnOrder

                        THERE U CAN ADD DAMAGE TAKE EVENT WITH RECORD CHECKING TOO, NOICE!
                    }]]

    self.ability = self.ability or self:GetAbility()
    
    local func = {}

    if type(self.ability.UniqueAttackTranslationModifiers) == "function" then
        func[1] = MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
    end
    if type(self.ability.UniqueAttackOnStartOrRecord) == "function" then
        func[2] = MODIFIER_EVENT_ON_ATTACK_START
    end
    if type(self.ability.UniqueAttackOnStartOrRecord) == "function" then
        func[3] = MODIFIER_EVENT_ON_ATTACK_RECORD
    end
    if type(self.ability.UniqueAttackOverrideAttackDamage) == "function" then
        func[4] = MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE
    end
    if type(self.ability.UniqueAttackPreAttack_BonusDamagePostCrit) == "function" then
        func[5] = MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT
    end
    if type(self.ability.UniqueAttackPreAttack_CriticalStrike) == "function" then
        func[6] = MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    end
    if type(self.ability.UniqueAttackPreAttack) == "function" then
        func[7] = MODIFIER_PROPERTY_PRE_ATTACK
    end
    if type(self.ability.UniqueAttackOnAttack) == "function" then
        func[8] = MODIFIER_EVENT_ON_ATTACK
    end
    if type(self.ability.UniqueAttackSound) == "function" then
        func[9] = MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
    end
    --[[if then
        func[10] = MODIFIER_EVENT_ON_ATTACK_CANCELLED
    end
    if then
        func[11] = MODIFIER_EVENT_ON_ATTACK_FINISHED
    end]]
    if type(self.ability.UniqueAttackOnAttackFail) == "function" then
        func[12] = MODIFIER_EVENT_ON_ATTACK_FAIL
    end
    if type(self.ability.UniqueAttackProcAttack_BonusDamage_All) == "function" then
        func[13] = MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL
    end
    if type(self.ability.UniqueAttackProcAttack_BonusDamage_All) == "function" then
        func[14] = MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
    end
    if type(self.ability.UniqueAttackProcAttack_BonusDamage_All) == "function" then
        func[15] = MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
    end
    if type(self.ability.UniqueAttackProcAttack_Feedback) == "function" then
        func[16] = MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    end
    if type(self.ability.UniqueAttackOnAttackLanded) == "function" then
        func[17] = MODIFIER_EVENT_ON_ATTACK_LANDED
    end

        --func[18] = MODIFIER_EVENT_ON_PROCESS_CLEAVE

    if type(self.ability.UniqueAttackOnAttacked) == "function" then
        func[19] = MODIFIER_EVENT_ON_ATTACKED
    end
    
    func[20] = MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY

    if type(self.ability.UniqueAttackOnOrder) == "function" then
        func[21] = MODIFIER_EVENT_ON_ORDER
    end

    return func
end
function modifier_anime_mechanic_unique_attack:GetActivityTranslationModifiers(keys)
    if IsServer() then
        if IsNotNull(self.ability) 
            and type(self.ability.UniqueAttackTranslationModifiers) == "function" then
            return self.ability:UniqueAttackTranslationModifiers(keys)
        end
    end
end
function modifier_anime_mechanic_unique_attack:OnAttackStart(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        local hTarget   = keys.target
        if self.parent == hAttacker 
            and IsNotNull(hAttacker)
            and IsNotNull(hTarget) 
            and IsNotNull(self.ability) then
            self.UNIQUE_ATTACKS_RECORDS_ACCESS = true
            if type(self.ability.UniqueAttackOnStartOrRecord) == "function"
                and self.ability:UniqueAttackOnStartOrRecord(keys, self) then
                local iIndex = tostring(hAttacker:entindex()..hTarget:entindex())
                self.UNIQUE_ATTACKS_RECORDS_STATE[iIndex] = hAttacker:AddNewModifier(hAttacker, self.ability, "modifier_anime_mechanic_unique_attack_state", {duration = 1})
            end
        end
        --PrintTable(keys, "OnAttackStart")
        --print(0, keys.record, "OnAttackStart")
    end
end
function modifier_anime_mechanic_unique_attack:OnAttackRecord(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        local hTarget   = keys.target
        if self.parent == hAttacker
            and IsNotNull(hAttacker)
            and IsNotNull(hTarget)
            and IsNotNull(self.ability) then
            if self.UNIQUE_ATTACKS_RECORDS_ACCESS then
                local iIndex    = tostring(hAttacker:entindex()..hTarget:entindex())
                local hModifier = self.UNIQUE_ATTACKS_RECORDS_STATE[iIndex]
                if IsNotNull(hModifier) then
                    hModifier:Destroy()
                    self.UNIQUE_ATTACKS_RECORDS_STATE[iIndex] = nil
                    self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)] = true
                end
            else
                if type(self.ability.UniqueAttackOnStartOrRecord) == "function" 
                    and self.ability:UniqueAttackOnStartOrRecord(keys, self) then
                    self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)] = true
                end
            end
            self.UNIQUE_ATTACKS_RECORDS_ACCESS = false
        end
        --PrintTable(keys, "OnAttackRecord")
        --print(1, keys.record, "OnAttackRecord")
    end
end
function modifier_anime_mechanic_unique_attack:GetModifierOverrideAttackDamage(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackOverrideAttackDamage) == "function" then
            return self.ability:UniqueAttackOverrideAttackDamage(keys, self)
        end
        --print(hAttacker:GetName())
        --print(2, keys.record, "GetModifierOverrideAttackDamage")
    end
end
function modifier_anime_mechanic_unique_attack:GetModifierPreAttack_BonusDamagePostCrit(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackPreAttack_BonusDamagePostCrit) == "function" then
            return self.ability:UniqueAttackPreAttack_BonusDamagePostCrit(keys, self)
        end
        --print(hAttacker:GetName())
        --print(3, keys.record, "GetModifierPreAttack_BonusDamagePostCrit")
    end
end
function modifier_anime_mechanic_unique_attack:GetModifierPreAttack_CriticalStrike(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackPreAttack_CriticalStrike) == "function" then
            --self.__fGetCritDamageValue = self.ability:UniqueAttackPreAttack_CriticalStrike(keys, self)
            --print("pepeg")
            return self.ability:UniqueAttackPreAttack_CriticalStrike(keys, self)
        end
        --print(hAttacker:GetName())
        --print(4, keys.record, "GetModifierPreAttack_CriticalStrike")
    end
end
--[[function modifier_anime_mechanic_unique_attack:GetCritDamage() --CAN'T GET KEYS, WHY THAT CALLS 2 TIMES????
    --print("WTF", IsServer(), self.__fGetCritDamageValue)
    return 101
end]]
--========================================================================================== NEW CRINGE WHICH ASSOSCIED WITH PRE_ATTACK CRIT STRIKE... 28.09.2021 I got that info????
function modifier_anime_mechanic_unique_attack:GetModifierPreAttack(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackPreAttack) == "function" then
            return self.ability:UniqueAttackPreAttack(keys, self)
        end
        --print(hAttacker:GetName())
        --print(5, keys.record, "GetModifierPreAttack")
    end
end
function modifier_anime_mechanic_unique_attack:OnAttack(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackOnAttack) == "function" then
            return self.ability:UniqueAttackOnAttack(keys, self)
        end
        --print(hAttacker:GetName())
        --PrintTable(keys, "OnAttack")
        --print(6, keys.record, "OnAttack")
    end
end
function modifier_anime_mechanic_unique_attack:GetAttackSound(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackSound) == "function" then
            return self.ability:UniqueAttackSound(keys, self)
        end
        --print(hAttacker:GetName())
        --print(7, keys.record, "GetAttackSound")
    end
end
function modifier_anime_mechanic_unique_attack:OnAttackCancelled(keys)
    --if IsServer() then
        --local hAttacker = keys.attacker
        --print(hAttacker:GetName())
        --PrintTable(keys, "OnAttackCancelled")
        --print("8 - 17", keys.record, "OnAttackCancelled")
    --end
end
function modifier_anime_mechanic_unique_attack:OnAttackFinished(keys)
    --if IsServer() then
        --local hAttacker = keys.attacker
        --print(hAttacker:GetName())
        --PrintTable(keys, "OnAttackFinished")
        --print(9, keys.record, "OnAttackFinished")
    --end
end
function modifier_anime_mechanic_unique_attack:OnAttackFail(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackOnAttackFail) == "function" then
            return self.ability:UniqueAttackOnAttackFail(keys, self)
        end
        --print(hAttacker:GetName())
        --PrintTable(keys, "OnAttackFail")
        --print("10 - 17", keys.record, "OnAttackFail")
    end
end
function modifier_anime_mechanic_unique_attack:GetModifierProcAttack_BonusDamage_Physical(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackProcAttack_BonusDamage_All) == "function" then
            return self.ability:UniqueAttackProcAttack_BonusDamage_All(keys, self, DAMAGE_TYPE_PHYSICAL)
        end
        --print(keys.damage_type == DAMAGE_TYPE_PHYSICAL, "GetModifierProcAttack_BonusDamage_Physical")
        --print(hAttacker:GetName())
        --print(11, keys.record, "GetModifierProcAttack_BonusDamage_Physical")
    end
end
function modifier_anime_mechanic_unique_attack:GetModifierProcAttack_BonusDamage_Magical(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackProcAttack_BonusDamage_All) == "function" then
            return self.ability:UniqueAttackProcAttack_BonusDamage_All(keys, self, DAMAGE_TYPE_MAGICAL)
        end
        --print(keys.damage_type == DAMAGE_TYPE_PHYSICAL, "GetModifierProcAttack_BonusDamage_Magical")
        --print(hAttacker:GetName())
        --print(12, keys.record, "GetModifierProcAttack_BonusDamage_Magical")
    end
end
function modifier_anime_mechanic_unique_attack:GetModifierProcAttack_BonusDamage_Pure(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackProcAttack_BonusDamage_All) == "function" then
            return self.ability:UniqueAttackProcAttack_BonusDamage_All(keys, self, DAMAGE_TYPE_PURE)
        end
        --print(keys.damage_type == DAMAGE_TYPE_PHYSICAL, "GetModifierProcAttack_BonusDamage_Pure")
        --print(hAttacker:GetName())
        --print(13, keys.record, "GetModifierProcAttack_BonusDamage_Pure")
    end
end
function modifier_anime_mechanic_unique_attack:GetModifierProcAttack_Feedback(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackProcAttack_Feedback) == "function" then
            return self.ability:UniqueAttackProcAttack_Feedback(keys, self)
        end
        --print(hAttacker:GetName())
        --print(14, keys.record, "GetModifierProcAttack_Feedback")
    end
end
function modifier_anime_mechanic_unique_attack:OnAttackLanded(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackOnAttackLanded) == "function" then
            return self.ability:UniqueAttackOnAttackLanded(keys, self)
        end
        --print(hAttacker:GetName())
        --PrintTable(keys, "OnAttackLanded")
        --print(15, keys.record, "OnAttackLanded")
    end
end
function modifier_anime_mechanic_unique_attack:OnProcessCleave1(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        --print(hAttacker:GetName())
        --PrintTable(keys, "OnProcessCleave")
        --print(15.5, keys.record, "OnProcessCleave")
    end
end
function modifier_anime_mechanic_unique_attack:OnAttacked(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)]
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackOnAttacked) == "function" then
            return self.ability:UniqueAttackOnAttacked(keys, self)
        end
        --print(hAttacker:GetName())
        --PrintTable(keys, "OnAttacked")
        --print(16, keys.record, "OnAttacked")
    end
end
function modifier_anime_mechanic_unique_attack:OnAttackRecordDestroy(keys)
    if IsServer() then
        local hAttacker = keys.attacker
        if self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)] then
            self.UNIQUE_ATTACKS_RECORDS[tostring(keys.record)] = nil
        end
        --print(hAttacker:GetName())
        --PrintTable(keys, "OnAttackRecordDestroy")
        --print(17, keys.record, "OnAttackRecordDestroy")
    end
end
function modifier_anime_mechanic_unique_attack:OnOrder(keys)
    if IsServer() then
        local hAttacker = keys.unit
        if hAttacker == self.parent
            and IsNotNull(hAttacker)
            and IsNotNull(self.ability)
            and type(self.ability.UniqueAttackOnOrder) == "function" then
            return self.ability:UniqueAttackOnOrder(keys, self)
        end
    end
end
function modifier_anime_mechanic_unique_attack:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
        self.UNIQUE_ATTACKS_RECORDS_ACCESS     = self.UNIQUE_ATTACKS_RECORDS_ACCESS     or false
        self.UNIQUE_ATTACKS_RECORDS            = self.UNIQUE_ATTACKS_RECORDS            or {}
        self.UNIQUE_ATTACKS_RECORDS_STATE      = self.UNIQUE_ATTACKS_RECORDS_STATE      or {}
        self.UNIQUE_ATTACKS_RECORDS_EXCEPTIONS = self.UNIQUE_ATTACKS_RECORDS_EXCEPTIONS or {}

        self.UNIQUE_ATTACKS_INTERVAL = type(self.ability.UniqueAttackStartIntervalThink) == "function" 
                                       and self.ability:UniqueAttackStartIntervalThink(self) 
                                       or -1

        self:StartIntervalThink(self.UNIQUE_ATTACKS_INTERVAL)
    end
end
function modifier_anime_mechanic_unique_attack:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_mechanic_unique_attack:OnIntervalThink()
    if IsServer() then
        if type(self.ability.UniqueAttackOnIntervalThink) == "function" then
            return self.ability:UniqueAttackOnIntervalThink(self)
        end
    end
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_mechanic_unique_attack_state", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_unique_attack_state = modifier_anime_mechanic_unique_attack_state or class({})

function modifier_anime_mechanic_unique_attack_state:IsHidden()                                                 return true end
function modifier_anime_mechanic_unique_attack_state:IsDebuff()                                                 return false end
function modifier_anime_mechanic_unique_attack_state:IsPurgable()                                               return false end
function modifier_anime_mechanic_unique_attack_state:IsPurgeException()                                         return false end
function modifier_anime_mechanic_unique_attack_state:RemoveOnDeath()                                            return false end
function modifier_anime_mechanic_unique_attack_state:GetAttributes()                                            return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_unique_attack_state:GetPriority()                                              return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_mechanic_unique_attack_state:IsMarbleException()                                        return true end
function modifier_anime_mechanic_unique_attack_state:DeclareFunctions()
    local hFunc =   {
                        MODIFIER_PROPERTY_PROJECTILE_NAME
                    }
    return hFunc
end
function modifier_anime_mechanic_unique_attack_state:GetModifierProjectileName(keys)
    if IsNotNull(self.__hAbility) 
        and type(self.__hAbility.UniqueAttackProjectileName) == "function" then
        return self.__hAbility:UniqueAttackProjectileName(keys)
    end
end
function modifier_anime_mechanic_unique_attack_state:CheckState()
    if IsNotNull(self.__hAbility) 
        and type(self.__hAbility.UniqueAttackCheckState) == "function" then
        return self.__hAbility:UniqueAttackCheckState()
    end
end
function modifier_anime_mechanic_unique_attack_state:OnCreated(hTable)
    self.__hCaster  = self:GetCaster()
    self.__hParent  = self:GetParent()
    self.__hAbility = self:GetAbility()
end
function modifier_anime_mechanic_unique_attack_state:OnRefresh(hTable)
    self:OnCreated(hTable)
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
BE CAREFULL MB WILL BE CRASH ON ITEMS IF U NOT USE MODIFIER_ATTRIBUTE_MULTIPLE ON ITEM'S MODIFIERS OR TRYING EDIT THAT CODE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
function CDOTABaseAbility:GetIntrinsicModifierNames()
    return {"modifier_name"}
end
]]

LinkLuaModifier("modifier_anime_mechanic_intrinsic_modifier_names", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_intrinsic_modifier_names = modifier_anime_mechanic_intrinsic_modifier_names or class({})

function modifier_anime_mechanic_intrinsic_modifier_names:IsHidden()                                                return true end
function modifier_anime_mechanic_intrinsic_modifier_names:IsDebuff()                                                return false end
function modifier_anime_mechanic_intrinsic_modifier_names:IsPurgable()                                              return false end
function modifier_anime_mechanic_intrinsic_modifier_names:IsPurgeException()                                        return false end
function modifier_anime_mechanic_intrinsic_modifier_names:RemoveOnDeath()                                           return false end
function modifier_anime_mechanic_intrinsic_modifier_names:GetAttributes()                                           return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_intrinsic_modifier_names:GetPriority()                                             return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_mechanic_intrinsic_modifier_names:IsMarbleException()                                       return true end
function modifier_anime_mechanic_intrinsic_modifier_names:DeclareFunctions()
    local hFunc =   {
                    }
    return hFunc
end
function modifier_anime_mechanic_intrinsic_modifier_names:OnRespawn(keys)
    if IsServer() 
        and keys.unit == self.__hParent then
        self:OnCreated(self.__hINTRINSIC_MODIFIER_hTable)
    end
end
function modifier_anime_mechanic_intrinsic_modifier_names:OnCreated(hTable)
    self.__hCaster  = self:GetCaster()
    self.__hParent  = self:GetParent()
    self.__hAbility = self:GetAbility()

    if IsServer() then
        self.__hINTRINSIC_MODIFIER_hTable = hTable
        self.__sINTRINSIC_MODIFIER_NAMES  = self.__hAbility:GetIntrinsicModifierNames()
        self.__hINTRINSIC_MODIFIER_NAMES  = self.__hINTRINSIC_MODIFIER_NAMES or {}

        for _, sModifierName in pairs(self.__sINTRINSIC_MODIFIER_NAMES) do
            if not IsNotNull(self.__hINTRINSIC_MODIFIER_NAMES[sModifierName]) then
                self.__hINTRINSIC_MODIFIER_NAMES[sModifierName] = self.__hParent:AddNewModifier(self.__hCaster, self.__hAbility, sModifierName, {})
            end
        end

        self.__iPREVIOUS_ABILITY_LEVEL = self.__hAbility:GetLevel()

        self:StartIntervalThink(0.1)
    end
end
function modifier_anime_mechanic_intrinsic_modifier_names:OnIntervalThink()
    if IsServer() then
        local iLevel = self.__hAbility:GetLevel()
        if iLevel ~= self.__iPREVIOUS_ABILITY_LEVEL then
            self.__iPREVIOUS_ABILITY_LEVEL = iLevel
            self:ForceRefresh()
        end
    end
end
function modifier_anime_mechanic_intrinsic_modifier_names:OnRefresh(hTable)
    if IsServer() then
        for sModifierName, hModifier in pairs(self.__hINTRINSIC_MODIFIER_NAMES) do
            if IsNotNull(hModifier) then
                hModifier:ForceRefresh()
            end
        end
    end
end
function modifier_anime_mechanic_intrinsic_modifier_names:OnDestroy()
    if IsServer() then
        for sModifierName, hModifier in pairs(self.__hINTRINSIC_MODIFIER_NAMES) do
            if IsNotNull(hModifier) then
                hModifier:Destroy()
            end
        end
    end
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_mechanic_player_disconnected", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_player_disconnected = modifier_anime_mechanic_player_disconnected or class({})

function modifier_anime_mechanic_player_disconnected:IsHidden()                                         return true end
function modifier_anime_mechanic_player_disconnected:IsDebuff()                                         return false end
function modifier_anime_mechanic_player_disconnected:IsPurgable()                                       return false end
function modifier_anime_mechanic_player_disconnected:IsPurgeException()                                 return false end
function modifier_anime_mechanic_player_disconnected:RemoveOnDeath()                                    return false end
function modifier_anime_mechanic_player_disconnected:GetAttributes()                                    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_player_disconnected:GetPriority()                                      return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_mechanic_player_disconnected:IsMarbleException()                                return true end
function modifier_anime_mechanic_player_disconnected:DeclareFunctions()
    local func =    {
                        MODIFIER_PROPERTY_MIN_HEALTH,
                        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
                        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
                    }
    return func
end
function modifier_anime_mechanic_player_disconnected:GetMinHealth(keys)
    return self.fMinHealth
end
function modifier_anime_mechanic_player_disconnected:GetModifierMoveSpeed_Absolute(keys)
    return 25
end
function modifier_anime_mechanic_player_disconnected:GetModifierTotalDamageOutgoing_Percentage(keys)
    return -999999
end
function modifier_anime_mechanic_player_disconnected:OnOrder(keys)
    if IsServer() and keys.unit == self.parent then
        --self:Destroy()
        return self:SetStackCount(1)
    end
end
function modifier_anime_mechanic_player_disconnected:CheckState()
    local state =   {
                        [MODIFIER_STATE_INVULNERABLE]       = true,
                        [MODIFIER_STATE_NO_HEALTH_BAR]      = true,
                        [MODIFIER_STATE_UNSELECTABLE]       = true,
                        [MODIFIER_STATE_UNTARGETABLE]       = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION]  = true,
                        [MODIFIER_STATE_OUT_OF_GAME]        = true,
                        [MODIFIER_STATE_SILENCED]           = true,
                        [MODIFIER_STATE_MUTED]              = true,
                        [MODIFIER_STATE_PASSIVES_DISABLED]  = true,
                        [MODIFIER_STATE_DISARMED]           = true,
                        [MODIFIER_STATE_ATTACK_IMMUNE]      = true,
                        [MODIFIER_STATE_MAGIC_IMMUNE]       = true,
                        [MODIFIER_STATE_ROOTED]             = true,
                        [MODIFIER_STATE_BLIND]              = true,
                        [MODIFIER_STATE_NO_TEAM_MOVE_TO]    = true,
                        [MODIFIER_STATE_NO_TEAM_SELECT]     = true,
                    }
    return state
end
function modifier_anime_mechanic_player_disconnected:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
        self.fMinHealth = self.parent:GetHealth()

        --self.parent:AddNoDraw()
        self:OnIntervalThink()
        self:StartIntervalThink(0.5)
    end
end
function modifier_anime_mechanic_player_disconnected:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_mechanic_player_disconnected:OnIntervalThink()
    if IsServer() then
        self.parent:AddNoDraw()
    end
end
function modifier_anime_mechanic_player_disconnected:OnDestroy()
    if IsServer()
        and IsNotNull(self.parent) then
        self.parent:RemoveNoDraw()
    end
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_mechanic_invulnerable", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_invulnerable = modifier_anime_mechanic_invulnerable or class({})

function modifier_anime_mechanic_invulnerable:IsHidden()                                    return true end
function modifier_anime_mechanic_invulnerable:IsDebuff()                                    return false end
function modifier_anime_mechanic_invulnerable:IsPurgable()                                  return false end
function modifier_anime_mechanic_invulnerable:IsPurgeException()                            return false end
function modifier_anime_mechanic_invulnerable:RemoveOnDeath()                               return self.bRemoveOnDeath end
function modifier_anime_mechanic_invulnerable:GetAttributes()                               return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_invulnerable:GetPriority()                                 return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_mechanic_invulnerable:IsMarbleException()                           return true end
function modifier_anime_mechanic_invulnerable:CheckState()
    local hState =  {
                        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                        [MODIFIER_STATE_OUT_OF_GAME]   = true,
                        [MODIFIER_STATE_UNSELECTABLE]  = true,
                        [MODIFIER_STATE_UNTARGETABLE]  = true
                    }

    if IsServer() then
        if self.bInvulnerable then
            hState[MODIFIER_STATE_INVULNERABLE] = true
        end
        if self.bNoCollision then
            hState[MODIFIER_STATE_NO_UNIT_COLLISION] = true
        end
        if self.bFlying then
            hState[MODIFIER_STATE_FLYING] = true
        end
        if self.bVision then
            hState[MODIFIER_STATE_PROVIDES_VISION] = true
        end
        if self.bRooted then
            hState[MODIFIER_STATE_ROOTED] = true
        end
        if self.bNoMap then
            hState[MODIFIER_STATE_NOT_ON_MINIMAP] = true
        end
        if self.bForceFlyVision then
            hState[MODIFIER_STATE_FORCED_FLYING_VISION] = true
        end
        if self.bDisarmed then
            hState[MODIFIER_STATE_DISARMED] = true
        end
    end
    
    return hState
end
function modifier_anime_mechanic_invulnerable:DeclareFunctions()
    return  {    
                MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
            }
end
function modifier_anime_mechanic_invulnerable:GetModifierProvidesFOWVision(keys)
    return 1
end
function modifier_anime_mechanic_invulnerable:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
        self.bInvulnerable  = ( hTable.bInvulnerable or 0 )  > 0
        self.bNoCollision   = ( hTable.bNoCollision or 0 )   > 0
        self.bFlying        = ( hTable.bFlying or 0 )        > 0
        self.bVision        = ( hTable.bVision or 0 )        > 0
        self.bRemoveOnDeath = ( hTable.bRemoveOnDeath or 0 ) > 0

        self.bRooted         = ( hTable.bRooted or 0 )         > 0
        self.bNoMap          = ( hTable.bNoMap or 0 )          > 0
        self.bForceFlyVision = ( hTable.bForceFlyVision or 0 ) > 0
        self.bDisarmed       = ( hTable.bDisarmed or 0 )       > 0
    end
end
function modifier_anime_mechanic_invulnerable:OnRefresh(hTable)
    self:OnCreated(hTable)
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_special_respawn", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_special_respawn = modifier_anime_special_respawn or class({})

function modifier_anime_special_respawn:IsHidden()                                                  return true end
function modifier_anime_special_respawn:IsDebuff()                                                  return false end
function modifier_anime_special_respawn:IsPurgable()                                                return false end
function modifier_anime_special_respawn:IsPurgeException()                                          return false end
function modifier_anime_special_respawn:RemoveOnDeath()                                             return true end
function modifier_anime_special_respawn:AllowIllusionDuplicate()                                    return false end
function modifier_anime_special_respawn:GetAttributes()                                             return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_special_respawn:GetPriority()                                               return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_special_respawn:IsMarbleException()                                         return true end
function modifier_anime_special_respawn:CheckState()
    local hState =  {
                        [MODIFIER_STATE_ATTACK_IMMUNE]     = true,
                        [MODIFIER_STATE_MAGIC_IMMUNE]      = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_NOT_ON_MINIMAP]    = true,
                        [MODIFIER_STATE_INVISIBLE]         = true,
                        [MODIFIER_STATE_TRUESIGHT_IMMUNE]  = true
                    }
    return hState
end
function modifier_anime_special_respawn:DeclareFunctions()
    local hFunc =    {
                        MODIFIER_EVENT_ON_ABILITY_START,
                        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
                        
                        MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
                        MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY
                    }
    return hFunc
end
function modifier_anime_special_respawn:OnAbilityStart(keys)
    if IsServer()
        and keys.unit == self.__hParent then
        return self:Destroy()
    end
end
function modifier_anime_special_respawn:OnAbilityFullyCast(keys)
    if IsServer()
        and keys.unit == self.__hParent then
        return self:Destroy()
    end
end
function modifier_anime_special_respawn:OnAttackStart(keys)
    if IsServer()
        and keys.attacker == self.__hParent then
        return self:Destroy()
    end
end
function modifier_anime_special_respawn:GetModifierInvisibilityLevel(keys)
    return 1
end
function modifier_anime_special_respawn:GetModifierPersistentInvisibility(keys)
    return 1
end
function modifier_anime_special_respawn:GetTotalDamageNullify(keys)
    return DAMAGE_TYPE_ALL
end
function modifier_anime_special_respawn:OnCreated(hTable)
    self.__hCaster  = self:GetCaster()
    self.__hParent  = self:GetParent()
    self.__hAbility = self:GetAbility()
end
function modifier_anime_special_respawn:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_special_respawn:GetEffectName()
    return "particles/units/heroes/hero_omniknight/omniknight_heavenly_grace_buff.vpcf"
end
function modifier_anime_special_respawn:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end








































































































------------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_mechanic_arcanas_model_projectile", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_arcanas_model_projectile = modifier_anime_mechanic_arcanas_model_projectile or class({})

function modifier_anime_mechanic_arcanas_model_projectile:IsHidden()                                                return true end
function modifier_anime_mechanic_arcanas_model_projectile:IsDebuff()                                                return false end
function modifier_anime_mechanic_arcanas_model_projectile:IsPurgable()                                              return false end
function modifier_anime_mechanic_arcanas_model_projectile:IsPurgeException()                                        return false end
function modifier_anime_mechanic_arcanas_model_projectile:RemoveOnDeath()                                           return false end
function modifier_anime_mechanic_arcanas_model_projectile:IsMarbleException()                                       return true end
function modifier_anime_mechanic_arcanas_model_projectile:AllowIllusionDuplicate()                                  return true end
function modifier_anime_mechanic_arcanas_model_projectile:GetPriority()                                             return MODIFIER_PRIORITY_LOW end
function modifier_anime_mechanic_arcanas_model_projectile:DeclareFunctions()
    local hFunc =   {
                        MODIFIER_PROPERTY_MODEL_CHANGE,
                        MODIFIER_PROPERTY_PROJECTILE_NAME
                    }
    return hFunc
end
function modifier_anime_mechanic_arcanas_model_projectile:GetModifierModelChange(keys)
    return self.__sModelName
end
function modifier_anime_mechanic_arcanas_model_projectile:GetModifierProjectileName(keys)
    return self.__sProjectileName
end
function modifier_anime_mechanic_arcanas_model_projectile:OnModelChanged(keys)
    if IsServer()
        and keys.attacker == self.__hParent
        and keys.attacker:GetUnitName() == "npc_dota_hero_juggernaut" then
        local iPID    = keys.attacker:GetMainControllingPlayer()
        local iID32   = PlayerResource:GetSteamAccountID(iPID)
        if iID32 == 460710592
            or iID32 == 81132975 then
            keys.attacker:SetMaterialGroup("hichigo")
        end
        --for k,v in pairs(keys) do print(k,v) end
        --print(keys.attacker:GetUnitName())
    end
end
function modifier_anime_mechanic_arcanas_model_projectile:OnCreated(hTable)
    self.__hCaster  = self:GetCaster()
    self.__hParent  = self:GetParent()
    self.__hAbility = self:GetAbility()

    if IsServer() then
        local iPlayerID = self.__hParent:GetPlayerOwnerID()
        local sHeroName = self.__hParent:GetUnitName()

        self.__sModelName      = AnimeArcanas:GetArcanaModel(iPlayerID, sHeroName)
                                 or self.__hParent:GetKeyValue("Model") 
                                 or self.__hParent:GetModelName()
        self.__sProjectileName = AnimeArcanas:GetArcanaProjectile(iPlayerID, sHeroName)
                                 or self.__hParent:GetKeyValue("ProjectileModel") 
                                 or self.__hParent:GetRangedProjectileName()
        --print(self.__sModelName, self.__sProjectileName)

        self:OnModelChanged({attacker = self.__hParent})
    end
end
function modifier_anime_mechanic_arcanas_model_projectile:OnRefresh(hTable)
    self:OnCreated(hTable)
end











------------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_patreon_menu_hparticles", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_patreon_menu_hparticles = modifier_anime_patreon_menu_hparticles or class({})

function modifier_anime_patreon_menu_hparticles:IsHidden()                                                  return true end
function modifier_anime_patreon_menu_hparticles:IsDebuff()                                                  return false end
function modifier_anime_patreon_menu_hparticles:IsPurgable()                                                return false end
function modifier_anime_patreon_menu_hparticles:IsPurgeException()                                          return false end
function modifier_anime_patreon_menu_hparticles:RemoveOnDeath()                                             return false end
function modifier_anime_patreon_menu_hparticles:AllowIllusionDuplicate()                                    return false end
function modifier_anime_patreon_menu_hparticles:GetPriority()                                               return MODIFIER_PRIORITY_LOW end
function modifier_anime_patreon_menu_hparticles:IsMarbleException()                                         return true end
function modifier_anime_patreon_menu_hparticles:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsServer() then
        if not self.caster 
            or not self.parent 
            or not self.ability 
            or self.parent:IsNull() 
            or self.ability:IsNull() 
            or not IsNotNull(AnimePatreonMenu) 
            or not self.ability.ANIME_MENU_SETTINGS 
            or ( self.parent:IsRealHero() and self.parent ~= PlayerResource:GetSelectedHeroEntity(self.parent:GetPlayerOwnerID()) ) then
            print("ERROR, FOCK U, WHERE SYSTEM ??? OR SETTINGS ???")
            self:Destroy()
            return nil
        end

        self:RemoveOldParticles()

        self.CURRENT_PARTICLES_INDEXES = {}

        self.CURRENT_PARTICLES = self.ability.ANIME_MENU_SETTINGS["ITEM_PARTICLES"] or {}

        local nParticleRepeat = -1
        for ParticleKey, ParticleTable in pairs(self.CURRENT_PARTICLES) do

            local nParticleAttach = AnimePatreonMenu:SelectParticleAttach(ParticleKey)
            nParticleRepeat = AnimePatreonMenu:GetParticleRepeatTime(ParticleKey)

            for nID, sParticleLink in pairs(ParticleTable) do
                local nParticleIndex  = ParticleManager:CreateParticle(sParticleLink, nParticleAttach, self.parent)
                                        ParticleManager:SetParticleControlEnt(nParticleIndex, 0 , self.parent, nParticleAttach, "attach_origin", self.parent:GetAbsOrigin(), true)
                            
                AnimePatreonMenu:SetParticleColor(ParticleKey, nParticleIndex)

                table.insert(self.CURRENT_PARTICLES_INDEXES, nParticleIndex)
            end
        end

        self:StartIntervalThink(nParticleRepeat)
    end
end
function modifier_anime_patreon_menu_hparticles:OnIntervalThink()
    if IsServer() then
        self:ForceRefresh()
        --print("FORCING")
    end
end
function modifier_anime_patreon_menu_hparticles:RemoveOldParticles()
    if IsServer() then
        self.CURRENT_PARTICLES_INDEXES = self.CURRENT_PARTICLES_INDEXES or {}
        for _, nParticleIndex in pairs(self.CURRENT_PARTICLES_INDEXES) do
            ParticleManager:DestroyParticle(nParticleIndex, true)
            ParticleManager:ReleaseParticleIndex(nParticleIndex)

            --print("REMOVING: ".. nParticleIndex .. " FROM CURRENT INDEXES AND PARTICLES")
        end
    end
end
function modifier_anime_patreon_menu_hparticles:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_patreon_menu_hparticles:OnDestroy()
    if IsServer() then
        self:RemoveOldParticles()
    end
end
























































--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_mechanic_ability_channeling", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_ability_channeling = modifier_anime_mechanic_ability_channeling or class({})

function modifier_anime_mechanic_ability_channeling:IsHidden()                                          return false end
function modifier_anime_mechanic_ability_channeling:IsDebuff()                                          return self.__bIS_OPPOSING end
function modifier_anime_mechanic_ability_channeling:IsPurgable()                                        return false end
function modifier_anime_mechanic_ability_channeling:IsPurgeException()                                  return false end
function modifier_anime_mechanic_ability_channeling:RemoveOnDeath()                                     return true end
function modifier_anime_mechanic_ability_channeling:IsMarbleException()                                 return self.__hCaster == self.__hParent end
--function modifier_anime_mechanic_ability_channeling:AllowIllusionDuplicate()                          return true end
function modifier_anime_mechanic_ability_channeling:GetPriority()                                       return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_mechanic_ability_channeling:GetAttributes()                                     return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_anime_mechanic_ability_channeling:OnCreated(hTable)
    self.__hCaster  = self:GetCaster()
    self.__hParent  = self:GetParent()
    self.__hAbility = self:GetAbility()

    self.__flDuration = self:GetDuration()

    self.__hAbility.___flGetChannelTime = self.__flDuration --WILL BE NEED CHECK AND MAKE AS IN DOTA WHEN U UPGRADE CHANNLING CURRENT ABILITY CHANNELING DURATION IS AUTOCONTINUES
    self.__hAbility.GetChannelTime = function(self) --REWRITES ANYTHING IF BAKA CHANGED SOMETHING IN CHANNELTIME
        return self.___flGetChannelTime or self.BaseClass.GetChannelTime(self)
    end

    self.__iCASTER_TEAM = self.__hCaster:GetTeamNumber()
    self.__bIS_OPPOSING = self.__iCASTER_TEAM ~= self.__hParent:GetTeamNumber()

    if IsServer() then
        --self:SetDuration(self.__flDuration + 3, true) --ЕБАЛА КАКАЯ ТО С МОДИФИКАТОРОМ КОГДА УДАЛЯЕТСЯ
        --self.__iCASTER_TEAM          = self.__hCaster:GetTeamNumber()
        self.__iABILITY_TARGET_TEAM  = self.__hAbility:GetAbilityTargetTeam()
        self.__iABILITY_TARGET_TYPE  = self.__hAbility:GetAbilityTargetType()
        self.__iABILITY_TARGET_FLAGS = self.__hAbility:GetAbilityTargetFlags()

        --self.__bTriggerSpellAbsorb = ( hTable.bTriggerSpellAbsorb or 0 ) > 0

        self.__hCursorTarget = self.__hAbility:GetCursorTarget() or ( type(hTable.iCursorTarget) == "number" 
                                                                      and EntIndexToHScript(hTable.iCursorTarget) 
                                                                      or nil )

        self.__fFrameTime = ( self.__flDuration > -1 and self.__flDuration <= 1 )
                            and 0.001
                            or 0.01
        
        --self.__hAbility:SetChanneling(true) --NEED FOR NEXT LINE
        --self:OnIntervalThink(true) --FOR THIS

        self.__bIsChannelingFirst    = false
        self.__bRefCountModifiers    = self.__hAbility:RefCountsModifiers() and not self.__hAbility:IsStolen() --LAST LINE IF I'LL WANNA MAKE SOMETHING WHICH STEAL ABILITITES LIKE MORPH PUCCI
        self.__bIsChanneledAbility   = ( bit.band(self.__hAbility:GetBehavior(), DOTA_ABILITY_BEHAVIOR_CHANNELLED) ~= 0 )
        self.__bIsLotusLikeReflected = self.__hAbility:GetAbilityIndex() == 0 --ZERO BECAUSE CHECKING ONLY FOR LOTUS, IF NOT LOTUSED REFLECT THEN CAN CHANNEL 
        --self.__bIsHogyokuLikeReflected = self.__hAbility:RefCountsModifiers() and not self.__hAbility:IsStolen() and self.__hAbility:GetAbilityIndex() < 0

        if self.__bRefCountModifiers
            and self.__bIsChanneledAbility
            and not self.__bIsLotusLikeReflected
            and not self.__hAbility:IsChanneling() then
            self.__hAbility:SetChanneling(true)
        end

        self:StartIntervalThink(self.__fFrameTime)
    end

    return self:OnCreatedChanneling(hTable)
--[[
    FireGameEvent("anime_cf_server_client", {
                                                sFunctionName = "___flGetChannelTime",
                                                iEntIndex     = self.__hAbility:entindex(),
                                                bValue        = false,
                                                fValue        = self:GetDuration(),
                                                iType         = ANIME_SC_TYPE_ENTINDEX
                                            })
    ]]
end
function modifier_anime_mechanic_ability_channeling:OnCreatedChanneling(hTable) --Just For If i'll be need handle something
end
function modifier_anime_mechanic_ability_channeling:IsChanneling(flDT)
    return true
end
function modifier_anime_mechanic_ability_channeling:IsChannelingFirst(flDT)
    return true
end
function modifier_anime_mechanic_ability_channeling:CheckFilterResult() --UNIT FILTER CHECKING IS NOT REQUIRED FOR BASICAL CHANNEL CAUSE IT'S AUTO TRIGGER CastFilterResultTarget
    --if IsNotNull(self.__hAbility) then
        if IsNotNull(self.__hCursorTarget)
            and self.__bRefCountModifiers --reflected instead BY Lotusorblike ABILITIES
            and self.__bIsChanneledAbility
            and not self.__bIsLotusLikeReflected then
            self.__hAbility:OnChannelThink(self.__fFrameTime) --SIMULATION AS LOTUS CHANNELTHING THINKING TO ABILITY INSTEAD
            return self.__hAbility:CastFilterResultTarget(self.__hCursorTarget)
                   and not self.__hCaster:IsMoving()
                   and not IsNotNull(self.__hCaster:GetCurrentActiveAbility())-- == self.__hAbility --CHANGED FROM (NOT ISNOTNULL TO EQUALITY) NEED OR NOT BECAUSE IT'S MEME, FOR HOGYOKU OFC, IT'S A MISTAKE BECAUSE EQUALITY CAN'T BE CHECKED???? (NO I JUST CLOWN FORGET FOR WHAT I DID THAT KEK)
                   and self:GetElapsedTime() < self.__flDuration
        end
        --return self.__hAbility:IsChanneling()
    --end
    return self.__hAbility:IsChanneling()--false
end
function modifier_anime_mechanic_ability_channeling:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_mechanic_ability_channeling:OnIntervalThink()
    if IsServer() then
        if IsNotNull(self.__hAbility) then
            if not self.__bIsChannelingFirst then
                self.__bIsChannelingFirst = self:IsChannelingFirst(self.__fFrameTime)
                return --REPEAT CHANNEL FIRST IF NOT RETURN TRUE
            end

            if self:CheckFilterResult()
                and self:IsChanneling(self.__fFrameTime) then
                return --WE ARE CHANNELING
            end
            
            if IsNotNull(self.__hCursorTarget)
                and not IsNotNull(self.__hAbility:GetCursorTarget()) then
                self.__hCaster:SetCursorCastTarget(self.__hCursorTarget)
            end

            self.__hAbility:EndChannel(self:GetElapsedTime() < self.__flDuration)

            --print(self.__hCaster:GetCurrentActiveAbility():GetAbilityName())
            local hActiveAbility  = self.__hCaster:GetCurrentActiveAbility()
            local hPossibleTarget = IsNotNull(hActiveAbility)
                                    and hActiveAbility:GetCursorTarget()
                                    or nil --LANCER COMBO FIX??? HOW INTERACT WITH HOGYOKU WHO KNOWS???

            self.__hCaster:SetCursorCastTarget(hPossibleTarget) --this requires for stop multicasting by hogyoku if some players decide cast channels in one target and it reflected --ERROR: LANCER CAN'T CAST COMBO AFTER W BY IMIDIATE STOP, WHY???

            --self:StartIntervalThink(-1) --FOR PREVENT POSTTHINKING WHEN ABILITY IS NULL OR NOT CHANNEL OR ETC.... CAUSING MEGABUGS WITH GETCURSORTARGET AND MODIFIER FIND IT'S SO COMPLEX MY MIND BLOEWED
            --mb will return stop interval but need check it more agign.......
            --self:StartIntervalThink(-1) --BREAKS LOTUS!!! FINDING TARGET AT ENT CHANNEL
        end
        return self:Destroy()
    end
end
function modifier_anime_mechanic_ability_channeling:OnRemoved() --NEEDS FOR CHANNELCHECK - DON'T OVERRIDE INSTEAD
    if IsNotNull(self.__hAbility) then
        self.__hAbility.___flGetChannelTime = nil
    end
end





















































--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--NOTE: REBUILD OF OLD CHARGES TO NON STACK BASICALY, BUT STACK FOR SHOWING CHARGES 30.11.2021

--[[
function CDOTABaseAbility:HasAnimeCharges()
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:IsActiveAC()
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:IsHiddenAC()
    return false
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetInitialAC()
    return 1
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetMaxAC()
    return self:GetInitialAC()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetCooldownAC()
    return self:GetCooldown(-1) * self:GetCaster():GetCooldownReduction()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
function CDOTABaseAbility:GetCurrentAC()
    return self.___GetCurrentAC or 0
end
]]
--TODO: MAKE A 1 CHARGE CAP OR STAY 0 CAP.... SO HARD
--TODO: Check CAP Charges, check refreshing functions, active state thinks about...
LinkLuaModifier("modifier_anime_mechanic_ability_charges_new", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_ability_charges_new = modifier_anime_mechanic_ability_charges_new or class({})
                                                             
function modifier_anime_mechanic_ability_charges_new:IsHidden()
    local bIsHidden = self.__hAbility:IsHiddenAC()
    if IsClient()-- then
        and not IsInToolsMode() then
        return bIsHidden or self.__hParent:GetTeamNumber() ~= GetLocalPlayerTeam(GetLocalPlayerID())
    end
    return bIsHidden
end
function modifier_anime_mechanic_ability_charges_new:IsDebuff()                                                                         return false end
function modifier_anime_mechanic_ability_charges_new:IsPurgable()                                                                       return false end
function modifier_anime_mechanic_ability_charges_new:IsPurgeException()                                                                 return false end
function modifier_anime_mechanic_ability_charges_new:RemoveOnDeath()                                                                    return false end
function modifier_anime_mechanic_ability_charges_new:DestroyOnExpire()                                                                  return false end
function modifier_anime_mechanic_ability_charges_new:GetAttributes()                                                                    return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_ability_charges_new:GetPriority()                                                                      return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_mechanic_ability_charges_new:IsMarbleException()                                                                return true end
function modifier_anime_mechanic_ability_charges_new:IsCharges()                                                                        return true end
function modifier_anime_mechanic_ability_charges_new:DeclareFunctions()
    local hFunc =   {   
                        --MODIFIER_EVENT_ON_ABILITY_EXECUTED, --CAN'T BE BECAUSE AT TIME OF EXECUTION REMAINING TIME IS PEPEG, AND CAN'T BE ENDED
                        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
                    }
    return hFunc
end
function modifier_anime_mechanic_ability_charges_new:OnAbilityFullyCast(keys)
    if IsServer() 
        and keys.unit == self.__hParent then
        local hAbility = keys.ability

        if IsNotNull(hAbility) then
            local bHasAnimeCharges = self.__hAbility:HasAnimeCharges()
            local bActiveAC        = self.__hAbility:IsActiveAC()
            if bActiveAC then
                local hRefreshTable =   {
                                            ["item_refresher"] = true,
                                        }

                local sAName = hAbility:GetAbilityName()
                local iMaxAC = self.__hAbility:GetMaxAC()
            
                if bHasAnimeCharges and hAbility == self.__hAbility then
                    self:SpendCharge()
                end

                if hRefreshTable[sAName]
                    and self.__hAbility:IsRefreshable() then
                    self:RefreshCharges(iMaxAC, false, true)
                end
            end
        end
    end
end
function modifier_anime_mechanic_ability_charges_new:OnStackCountChanged(iChargesOld) --UGH SOMEDAY WILL REBUILD AGAIN, BUT NOW IT'S ALSO SOLVE PROBLEM LIKE CHARGES ON ITEMS "CURRENT" (TODO: NOW SOLVING ITEMS.... CHARGES) it's reupdates because item recreate modifier
    if IsNotNull(self.__hAbility) then
        local iChargesCurrent = self:GetStackCount()
        
        self.__hAbility.___GetCurrentAC = iChargesCurrent

        if IsServer() then
            self.__hAbility:SetCurrentAbilityCharges(iChargesCurrent) --NOTE: This line need's just for Panorama handling if create panorama panel for abilities
        end
    end
end
function modifier_anime_mechanic_ability_charges_new:SpendCharge()
    local iMaxAC      = self.__hAbility:GetMaxAC()
    local iCurrentAC  = self.__hAbility:GetCurrentAC()
    local fCooldownAC = self.__hAbility:GetCooldownAC()

    if iCurrentAC >= iMaxAC
        and type(self.__fACCooldownTimeRemaining) == "number"
        and self.__fACCooldownTimeRemaining <= 0 then
        self.__fACCooldownTimeRemaining = fCooldownAC
        self:SetDuration(fCooldownAC, true)
    end

    if iCurrentAC > 0 then
        self.__hAbility:EndCooldown()
        if iCurrentAC < 2
            and type(self.__fACCooldownTimeRemaining) == "number" then
            self.__hAbility:EndCooldown()
            self.__hAbility:StartCooldown(self.__fACCooldownTimeRemaining)
        end
        return self:DecrementStackCount()
    end
end
function modifier_anime_mechanic_ability_charges_new:RefreshCharges(iSetTo, bIgnoreMax, bIgnoreCooldown) --IGNORE COOLDOWN BASICALY NOT NEEDS ANYWHERE BUT I ADDED BECAUSE NOT WANTED TO THINK MORE
    local iMaxAC      = self.__hAbility:GetMaxAC()
    local iCurrentAC  = self.__hAbility:GetCurrentAC()
    local fCooldownAC = self.__hAbility:GetCooldownAC()
    if iSetTo >= iMaxAC then
        if not bIgnoreMax then
            iSetTo = iMaxAC
        end
        self.__fACCooldownTimeRemaining = nil
        self:SetDuration(-1, true)
    elseif not bIgnoreCooldown 
        and type(self.__fACCooldownTimeRemaining) == "number"
        and self.__fACCooldownTimeRemaining <= 0 then
        self.__fACCooldownTimeRemaining = fCooldownAC
        self:SetDuration(fCooldownAC, true)
    end
    return self:SetStackCount(iSetTo)
end
function modifier_anime_mechanic_ability_charges_new:OnCreated(hTable)
    self.__hCaster  = self:GetCaster()
    self.__hParent  = self:GetParent()
    self.__hAbility = self:GetAbility()

    if IsServer() then
        self.__InitialACSaved = self.__InitialACSaved or 0

        self.__fFrameTime = 0.01

        self:OnIntervalThink()
        self:StartIntervalThink(self.__fFrameTime)
    end
end
function modifier_anime_mechanic_ability_charges_new:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_mechanic_ability_charges_new:OnIntervalThink()
    if IsServer() then
        local bHasAnimeCharges = self.__hAbility:HasAnimeCharges()
        local iInitialAC       = self.__hAbility:GetInitialAC()
              --iInitialAC       = iInitialAC < 1 --FIX FOR PREVENT 0 STACKS
                                 --and 1
                                 --or iInitialAC
        local iMaxAC           = self.__hAbility:GetMaxAC()
        local iCurrentAC       = self.__hAbility:GetCurrentAC()
        local fCooldownAC      = self.__hAbility:GetCooldownAC()

        local fDurationNow     = self:GetDuration()
        local bIsCooldownReady = self.__hAbility:IsCooldownReady()
        --print(iCurrentAC, iMaxAC)
        if bHasAnimeCharges then
            --!!!THERE ADDING MORE CHARGES ONCE IF SPECIAL VALUE MORE ONCE, NEVERMINDS ABOUT CURRENT COOLDOWN ABILITY OR CHARGES COOLDOWN!!!--
            if self.__InitialACSaved < iInitialAC then
                local iInitialDiff = iInitialAC - self.__InitialACSaved
                self.__InitialACSaved = iInitialAC
                return self:RefreshCharges(iCurrentAC + iInitialDiff, false, true)
            end
            --!!!THERE ADDING MORE CHARGES ONCE IF SPECIAL VALUE MORE ONCE, NEVERMINDS ABOUT CURRENT COOLDOWN ABILITY OR CHARGES COOLDOWN!!!--
            --print(self.__fACCooldownTimeRemaining)
            self.__fACCooldownTimeRemaining = self.__fACCooldownTimeRemaining or self.__hAbility:GetCooldownTimeRemaining()
            if self.__fACCooldownTimeRemaining > 0 then
                if self.__hAbility:IsFrozenCooldown() then --TEST FROZEN COOLDOWN, WORK BECAUSE COOLDOWN RESTARTS IN THINKER SPECIAL BY FROZEN CD
                    return self:SetDuration(self.__fACCooldownTimeRemaining, true)
                elseif fDurationNow <= 0 then
                    self:SetDuration(self.__fACCooldownTimeRemaining, true)
                end
                self.__fACCooldownTimeRemaining = self.__fACCooldownTimeRemaining - self.__fFrameTime

                if not bIsCooldownReady
                    and iCurrentAC > 0 then
                    self.__hAbility:EndCooldown()
                    --print(iCurrentAC, iMaxAC)
                    if iCurrentAC >= iMaxAC then
                        --print("pepeg")
                        return self:RefreshCharges(iCurrentAC - 1, false, false)
                    end
                end
            end

            local iAddAC = iCurrentAC + 1
            if self.__fACCooldownTimeRemaining <= 0
                and iAddAC <= iMaxAC then
                return self:RefreshCharges(iAddAC, false, false)
            end
        else
            if type(self.__fACCooldownTimeRemaining) == "number" then
                --and self.__fACCooldownTimeRemaining > 0 then
                --and fDurationNow > 0 then
                if bIsCooldownReady
                    and self.__fACCooldownTimeRemaining > 0 then
                    self.__hAbility:EndCooldown()
                    self.__hAbility:StartCooldown(self.__fACCooldownTimeRemaining)
                end
                self:SetDuration(-1, true)
                self.__fACCooldownTimeRemaining = nil
                --print("PEPEG NO HAS CHARGES")
            end
        end
    end
end
























































































--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--NOTE: Can't be usable as aura because will be bugs and non visible on client crashes and etc...
LinkLuaModifier("modifier_anime_mechanic_parent_new", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_parent_new = modifier_anime_mechanic_parent_new or class({})

function modifier_anime_mechanic_parent_new:IsHidden()                                                                          return true end
function modifier_anime_mechanic_parent_new:IsDebuff()                                                                          return false end
function modifier_anime_mechanic_parent_new:IsPurgable()                                                                        return false end
function modifier_anime_mechanic_parent_new:IsPurgeException()                                                                  return false end
function modifier_anime_mechanic_parent_new:RemoveOnDeath()                                                                     return false end
function modifier_anime_mechanic_parent_new:GetAttributes()                                                                     return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_parent_new:GetPriority()                                                                       return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_mechanic_parent_new:IsMarbleException()                                                                 return true end
function modifier_anime_mechanic_parent_new:CheckState()
    local hState =  {
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true
                    }
    return hState
end
function modifier_anime_mechanic_parent_new:DeclareFunctions() --NOTE: Sorted by name from script_help2
    local hFunc =   {
                        --MODIFIER_EVENT_ON_ABILITY_END_CHANNEL,          -- = 187 -- OnAbilityEndChannel
                        MODIFIER_EVENT_ON_ABILITY_EXECUTED,             -- = 184 -- OnAbilityExecuted
                        --MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,           -- = 185 -- OnAbilityFullyCast
                        MODIFIER_EVENT_ON_ABILITY_START,                -- = 183 -- OnAbilityStart
                        --MODIFIER_EVENT_ON_ASSIST,                       -- = 232 -- OnAssist
                        --NOTE: NOT CHANGED YET, TESTING IN PROGRESS
                        --MODIFIER_EVENT_ON_ATTACK,                       -- = 176 -- OnAttack
                        --MODIFIER_EVENT_ON_ATTACKED,                     -- = 197 -- OnAttacked
                        --MODIFIER_EVENT_ON_ATTACK_ALLIED,                -- = 179 -- OnAttackAllied
                        --MODIFIER_EVENT_ON_ATTACK_CANCELLED,             -- = 245 -- OnAttackCancelled
                        --MODIFIER_EVENT_ON_ATTACK_FAIL,                  -- = 178 -- OnAttackFail
                        --MODIFIER_EVENT_ON_ATTACK_FINISHED,              -- = 235 -- OnAttackFinished
                        --MODIFIER_EVENT_ON_ATTACK_LANDED,                -- = 177 -- OnAttackLanded
                        --MODIFIER_EVENT_ON_ATTACK_RECORD,                -- = 174 -- OnAttackRecord
                        --MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,        -- = 242 -- OnAttackRecordDestroy
                        --MODIFIER_EVENT_ON_ATTACK_START,                 -- = 175 -- OnAttackStart
                        --NOTE: NOT CHANGED YET, TESTING IN PROGRESS
                        --MODIFIER_EVENT_ON_ATTEMPT_PROJECTILE_DODGE,     -- = 252 -- OnAttemptProjectileDodge
                        --MODIFIER_EVENT_ON_BREAK_INVISIBILITY,           -- = 186 -- OnBreakInvisibility
                        --MODIFIER_EVENT_ON_BUILDING_KILLED,              -- = 209 -- OnBuildingKilled
                        MODIFIER_EVENT_ON_DAMAGE_CALCULATED,            -- = 195 -- OnDamageCalculated
                        MODIFIER_EVENT_ON_DEATH,                        -- = 198 -- OnDeath
                        --MODIFIER_EVENT_ON_DEATH_PREVENTED,              -- = 191 -- OnDamagePrevented
                        --MODIFIER_EVENT_ON_DOMINATED,                    -- = 230 -- OnDominated
                        --MODIFIER_EVENT_ON_HEALTH_GAINED,                -- = 204 -- OnHealthGained
                        MODIFIER_EVENT_ON_HEAL_RECEIVED,                -- = 208 -- OnHealReceived
                        --MODIFIER_EVENT_ON_HERO_KILLED,                  -- = 207 -- OnHeroKilled
                        --MODIFIER_EVENT_ON_KILL,                         -- = 231 -- OnKill
                        --MODIFIER_EVENT_ON_MAGIC_DAMAGE_CALCULATED,      -- = 196 -- OnMagicDamageCalculated
                        --MODIFIER_EVENT_ON_MANA_GAINED,                  -- = 205 -- OnManaGained
                        MODIFIER_EVENT_ON_MODEL_CHANGED,                -- = 210 -- OnModelChanged
                        --MODIFIER_EVENT_ON_MODIFIER_ADDED,               -- = 211 -- OnModifierAdded
                        --MODIFIER_EVENT_ON_ORB_EFFECT,                   -- = 193 -- Unused
                        MODIFIER_EVENT_ON_ORDER,                        -- = 181 -- OnOrder
                        --MODIFIER_EVENT_ON_PREDEBUFF_APPLIED,            -- = 253 -- OnPreDebuffApplied
                        MODIFIER_EVENT_ON_PROCESS_CLEAVE,               -- = 194 -- OnProcessCleave 
                        --MODIFIER_EVENT_ON_PROCESS_UPGRADE,              -- = 188 -- Unused
                        MODIFIER_EVENT_ON_PROJECTILE_DODGE,             -- = 180 -- OnProjectileDodge
                        --MODIFIER_EVENT_ON_PROJECTILE_OBSTRUCTION_HIT,   -- = 243 -- OnProjectileObstructionHit
                        --MODIFIER_EVENT_ON_REFRESH,                      -- = 189 -- Unused
                        MODIFIER_EVENT_ON_RESPAWN,                      -- = 199 -- OnRespawn
                        --MODIFIER_EVENT_ON_SET_LOCATION,                 -- = 203 -- OnSetLocation
                        --MODIFIER_EVENT_ON_SPELL_TARGET_READY,           -- = 173 -- OnSpellTargetReady
                        MODIFIER_EVENT_ON_SPENT_MANA,                   -- = 200 -- OnSpentMana
                        --MODIFIER_EVENT_ON_STATE_CHANGED,                -- = 192 -- OnStateChanged
                        MODIFIER_EVENT_ON_TAKEDAMAGE,                   -- = 190 -- OnTakeDamage
                        --MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT,        -- = 206 -- OnTakeDamageKillCredit
                        --MODIFIER_EVENT_ON_TELEPORTED,                   -- = 202 -- OnTeleported
                        --MODIFIER_EVENT_ON_TELEPORTING,                  -- = 201 -- OnTeleporting
                        MODIFIER_EVENT_ON_UNIT_MOVED,                   -- = 182 -- OnUnitMoved
                    }
    return hFunc
end
function modifier_anime_mechanic_parent_new:OnAbilityEndChannel(keys)
    --NOTE: Don't using but works
    --print("IsClient: ", IsClient(), "OnAbilityEndChannel(keys)")
end
function modifier_anime_mechanic_parent_new:OnAbilityExecuted(keys)
    if IsNotNull(keys.unit) then
        local tModifiers = keys.unit:FindAllModifiers()
        for _, hModifier in pairs(tModifiers) do
            if IsNotNull(hModifier)
                and type(hModifier.OnAbilityExecuted) == "function" then
                hModifier:OnAbilityExecuted(keys)
            end
        end
    end
    --for k, v in pairs(keys) do print(k, v, "OnAbilityExecuted") end
    --NOTE: Can be problems with KRUL, because should be called on unit except krul.. so cringe, not provides cost as fully cast
    --NOTE: Calls when ability executed before fully cast.
    --print("IsClient: ", IsClient(), "OnAbilityExecuted(keys)")
end
function modifier_anime_mechanic_parent_new:OnAbilityFullyCast(keys)
    --NOTE: Provides current ability cost when casted... very usefull basicaly. Not overrided event because idk how correctly do that
    --for k, v in pairs(keys) do print(k, v, "OnAbilityFullyCast") end
    --print("IsClient: ", IsClient(), "OnAbilityFullyCast(keys)")
end
function modifier_anime_mechanic_parent_new:OnAbilityStart(keys)
    --for k, v in pairs(keys) do print(k, v, "OnAbilityStart") end
    --NOTE: Same as fully cast, idk how catch who start ability for introduce in modifier
    --print("IsClient: ", IsClient(), "OnAbilityStart(keys)")
end
function modifier_anime_mechanic_parent_new:OnAssist(keys)
    --NOTE: Doesn't know when calls
    --print("IsClient: ", IsClient(), "OnAssist(keys)")
end
function modifier_anime_mechanic_parent_new:OnAttack(keys)
    print("IsClient: ", IsClient(), "OnAttack(keys)")
end
function modifier_anime_mechanic_parent_new:OnAttacked(keys)
    print("IsClient: ", IsClient(), "OnAttacked(keys)")
end
function modifier_anime_mechanic_parent_new:OnAttackAllied(keys)
    print("IsClient: ", IsClient(), "OnAttackAllied(keys)")
end
function modifier_anime_mechanic_parent_new:OnAttackCancelled(keys)
    print("IsClient: ", IsClient(), "OnAttackCancelled(keys)")
end
function modifier_anime_mechanic_parent_new:OnAttackFail(keys)
    print("IsClient: ", IsClient(), "OnAttackFail(keys)")
end
function modifier_anime_mechanic_parent_new:OnAttackFinished(keys)
    print("IsClient: ", IsClient(), "OnAttackFinished(keys)")
end
function modifier_anime_mechanic_parent_new:OnAttackLanded(keys)
    print("IsClient: ", IsClient(), "OnAttackLanded(keys)")
end
function modifier_anime_mechanic_parent_new:OnAttackRecord(keys)
    print("IsClient: ", IsClient(), "OnAttackRecord(keys)")
end
function modifier_anime_mechanic_parent_new:OnAttackRecordDestroy(keys)
    print("IsClient: ", IsClient(), "OnAttackRecordDestroy(keys)")
end
function modifier_anime_mechanic_parent_new:OnAttackStart(keys)
    print("IsClient: ", IsClient(), "OnAttackStart(keys)")
end
function modifier_anime_mechanic_parent_new:OnAttemptProjectileDodge(keys)
    --NOTE: Doesn't work?
    --print("IsClient: ", IsClient(), "OnAttemptProjectileDodge(keys)")
end
function modifier_anime_mechanic_parent_new:OnBreakInvisibility(keys)
    --NOTE: Doesn't work?
    --print("IsClient: ", IsClient(), "OnBreakInvisibility(keys)")
end
function modifier_anime_mechanic_parent_new:OnBuildingKilled(keys)
    --NOTE: Maybe calls when building destroyed... not checked, not using
    --print("IsClient: ", IsClient(), "OnBuildingKilled(keys)")
end
function modifier_anime_mechanic_parent_new:OnDamageCalculated(keys)
    if IsServer() then
        local hAttacker       = keys.attacker
        local hTarget         = keys.target
        local hAbility        = keys.inflictor
        local fOriginalDamage = keys.original_damage
        local fDamage         = keys.damage
        local iDamageType     = keys.damage_type
        local iDamageCategory = keys.damage_category
        local iDamageFlags    = keys.damage_flags

        if IsNotNull(hAttacker)
            and IsNotNull(hTarget)
            and fDamage > 0 then

            if iDamageCategory == DOTA_DAMAGE_CATEGORY_ATTACK then
                --local fHP_BEFORE = hAttacker:GetHealth()
                --local fMP_BEFORE = hAttacker:GetMana()

                local fGetLifesteal = hAttacker:GetLifesteal(keys) * fDamage * 0.01
                local fGetManasteal = hAttacker:GetManasteal(keys) * fDamage * 0.01

                if fGetLifesteal > 0 then
                    --GABEN CRINGEMAN RELEASED HEAL WITH FUNCTIONS FOR THIS BUT I STILL THINK USE MY FUNCTIONS INSTEAD
                    --=======HEAL FUNCTION AMPLIFICATION CALCULATIONS=======-- (CHANGED TO TRUE FOR TRUE VALUES??????????????????????)
                    local fGL_Amplified = fGetLifesteal + ( fGetLifesteal * hAttacker:GetLifestealAmplification(keys, false) ) --true for return without redcued by shiva/skadi
                    --=======HEAL FUNCTION AMPLIFICATION CALCULATIONS=======--

                    --=======HEAL FUNCTION AMPLIFICATION PREVENTION CALCULATIONS=======--
                    local fGetHealAmplification    = hAttacker:GetHealAmplification(keys, true) --true for return caster + target amplified
                    local fHealByHealAmplification = fGL_Amplified * fGetHealAmplification
                    local fGL_Amplified_ByHealToo  = fGL_Amplified + fHealByHealAmplification
                    
                    --AUTOCORRECTION FOR PREVENT -VALUES WHICH WILL DO REAL HEAL IS REALLY REAL
                    local f123 = fGL_Amplified
                    local bHealMoreAmp = fGL_Amplified <= fGL_Amplified_ByHealToo
                    if true then
                        local f1 = fGL_Amplified / fGL_Amplified_ByHealToo
                        local f2 = 1 - f1
                        local f3 = fGL_Amplified - ( fGL_Amplified * f2 )

                        f123 = f3
                    else
                        f123 = fGL_Amplified
                    end
                    --AFTER LAST VALUE IT'S GET AMP BY HEAL ALREADY IN HEAL FUNCTION INSTEAD
                    --100+(100*0.30) == 130 --IF HEAL IS 100 + AMP by heal amp then
                    --1 - (fGSL_Amplified / fGL_Amplified_ByHealToo) == % which should use for reduce fGL_Amplified, which will be amped by heal and value will be equal to real value
                    --=======HEAL FUNCTION PREVENTION CALCULATIONS=======--

                    --==================================================--

                    hAttacker:Heal(f123, hAbility)

                    local iLifestealPFX =   ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker)
                                            ParticleManager:ReleaseParticleIndex(iLifestealPFX)
                end

                if fGetManasteal > 0 then
                    hAttacker:GiveMana(fGetManasteal)

                    local iManastealPFX =   ParticleManager:CreateParticle("particles/generic_gameplay/generic_manasteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker)
                                            ParticleManager:ReleaseParticleIndex(iManastealPFX)
                end

                --print(hAttacker:GetHealth() - fHP_BEFORE, "HP HEAL")
                --print(hAttacker:GetMana() - fMP_BEFORE, "MP HEAL")
            end
        end
    end
    --Calls when damage calculates for right click attacks
    --print("IsClient: ", IsClient(), "OnDamageCalculated(keys)")
end
function modifier_anime_mechanic_parent_new:OnDeath(keys)
    if IsNotNull(keys.unit) then
        local tModifiers = keys.unit:FindAllModifiers()
        for _, hModifier in pairs(tModifiers) do
            if IsNotNull(hModifier)
                and type(hModifier.OnDeath) == "function" then
                hModifier:OnDeath(keys)
            end
        end
    end
    --NOTE: Calls when unit dies
    --print("IsClient: ", IsClient(), "OnDeath(keys)")
end
function modifier_anime_mechanic_parent_new:OnDamagePrevented(keys)
    --NOTE: Doesn't work properly
    --print("IsClient: ", IsClient(), "OnDamagePrevented(keys)")
end
function modifier_anime_mechanic_parent_new:OnDominated(keys)
    --NOTE: Doesn't know when calls
    --print("IsClient: ", IsClient(), "OnDominated(keys)")
end
function modifier_anime_mechanic_parent_new:OnHealthGained(keys)
    --NOTE: When Health reach 100% max event doesn't call's more on this unit.
    --NOTE: CALL'S CONTINUESLY BECASUE EACH FrameTime() on gain health. Note using basicaly.
    --print("IsClient: ", IsClient(), "OnHealthGained(keys)")
end
function modifier_anime_mechanic_parent_new:OnHealReceived(keys)
    --NOTE: Uses only by Kototi for E ability...
    --NOTE: CALL'S CONTINUESLY BECASUE EACH FrameTime() receive healing.
    --print("IsClient: ", IsClient(), "OnHealReceived(keys)")
end
function modifier_anime_mechanic_parent_new:OnHeroKilled(keys)
    --NOTE: Calls when hero killed
    --print("IsClient: ", IsClient(), "OnHeroKilled(keys)")
end
function modifier_anime_mechanic_parent_new:OnKill(keys)
    --NOTE: Doesn't know when calls
    --print("IsClient: ", IsClient(), "OnKill(keys)")
end
function modifier_anime_mechanic_parent_new:OnMagicDamageCalculated(keys)
    --NOTE: Idk where calls, basicaly never.
    --print("IsClient: ", IsClient(), "OnMagicDamageCalculated(keys)")
end
function modifier_anime_mechanic_parent_new:OnManaGained(keys)
    --NOTE: CALL'S CONTINUESLY BECASUE EACH FrameTime() gain mana, aka healing.
    --print("IsClient: ", IsClient(), "OnManaGained(keys)")
end
function modifier_anime_mechanic_parent_new:OnModelChanged(keys)
    if IsNotNull(keys.attacker) then
        local tModifiers = keys.attacker:FindAllModifiers()
        for _, hModifier in pairs(tModifiers) do
            if IsNotNull(hModifier)
                and type(hModifier.OnModelChanged) == "function" then
                hModifier:OnModelChanged(keys)
            end
        end
    end
    --NOTE: Calls when unit(attacker) get changed his model
    --print("IsClient: ", IsClient(), "OnModelChanged(keys)")
end
function modifier_anime_mechanic_parent_new:OnModifierAdded(keys)
    --NOTE: Calls when modifier added, after filter table, not using.
    --print("IsClient: ", IsClient(), "OnModifierAdded(keys)", keys.unit)
end
function modifier_anime_mechanic_parent_new:OnOrder(keys)
    if IsNotNull(keys.unit) then
        local tModifiers = keys.unit:FindAllModifiers()
        for _, hModifier in pairs(tModifiers) do
            if IsNotNull(hModifier)
                and type(hModifier.OnOrder) == "function" then
                hModifier:OnOrder(keys)
            end
        end
    end
    --NOTE: Calls when unit (player), execute the order
    --print("IsClient: ", IsClient(), "OnOrder(keys)")
end
function modifier_anime_mechanic_parent_new:OnPreDebuffApplied(keys)
    --NOTE: Basicaly not uses, never seen, not work
    --print("IsClient: ", IsClient(), "OnPreDebuffApplied(keys)")
end
function modifier_anime_mechanic_parent_new:OnProcessCleave(keys) --TODO: Someday rework cleave mech basicaly
    if IsNotNull(keys.attacker) then
        local tModifiers = keys.attacker:FindAllModifiers()
        for _, hModifier in pairs(tModifiers) do
            if IsNotNull(hModifier)
                and type(hModifier.OnProcessCleave) == "function" then
                hModifier:OnProcessCleave(keys)
            end
        end
    end
    --REQUIRES BECAUSE NORMAL CLEAVE WORKS BY THAT + SUPRESS CLEAVE STOPS ONLY THAT THING..., FROM OTHER SOURCES DOCLEAVEATTACK WILL DO NEVERMIND HAVE U SUPRESS OR NOT
    --NOTE: Procs as default attack event but stops by supress cleave. Aka battlefury and etc.
    --print("IsClient: ", IsClient(), "OnProcessCleave(keys)")
end
function modifier_anime_mechanic_parent_new:OnProjectileDodge(keys)
    if IsNotNull(keys.target) then
        local tModifiers = keys.target:FindAllModifiers()
        for _, hModifier in pairs(tModifiers) do
            if IsNotNull(hModifier)
                and type(hModifier.OnProjectileDodge) == "function" then
                hModifier:OnProjectileDodge(keys)
            end
        end
    end
    --NOTE: Uses in Vergil Trick Dash
    --NOTE: Calls when unit dodges projectile
    --print("IsClient: ", IsClient(), "OnProjectileDodge(keys)")
end
function modifier_anime_mechanic_parent_new:OnProjectileObstructionHit(keys)
    --NOTE: Idk where uses, mb only for Mars abilities in dota
    --print("IsClient: ", IsClient(), "OnProjectileObstructionHit(keys)")
end
function modifier_anime_mechanic_parent_new:OnRespawn(keys)
    if IsNotNull(keys.unit) then
        local tModifiers = keys.unit:FindAllModifiers()
        for _, hModifier in pairs(tModifiers) do
            if IsNotNull(hModifier)
                and type(hModifier.OnRespawn) == "function" then
                hModifier:OnRespawn(keys)
            end
        end
    end
    --NOTE: Uses in Phoenix stacks. And Intrinsic modifier names.
    --NOTE: Procs when unit respawns, not spawn
    --print("IsClient: ", IsClient(), "OnRespawn(keys)")
end
function modifier_anime_mechanic_parent_new:OnSetLocation(keys)
    --NOTE: Calls when seting location with FindClearSpace, looks like not works for motion controlles... very strange
    --print("IsClient: ", IsClient(), "OnSetLocation(keys)")
end
function modifier_anime_mechanic_parent_new:OnSpellTargetReady(keys)
    --NOTE: Calls when using targeted spell on target... don't know where to use basicaly
    --print("IsClient: ", IsClient(), "OnSpellTargetReady(keys)")
end
function modifier_anime_mechanic_parent_new:OnSpentMana(keys)
    if IsNotNull(keys.unit) then
        local tModifiers = keys.unit:FindAllModifiers()
        for _, hModifier in pairs(tModifiers) do
            if IsNotNull(hModifier)
                and type(hModifier.OnSpentMana) == "function" then
                hModifier:OnSpentMana(keys)
            end
        end
    end
    --NOTE: Using in Tanya [Q]
    --NOTE: Calls when unit spend mana for abilities, not triggers when ReduceMana or manaburn
    --print("IsClient: ", IsClient(), "OnSpentMana(keys)")
end
function modifier_anime_mechanic_parent_new:OnStateChanged(keys)
    --NOTE: Сalls when unit change self state by modifier state's
    --print("IsClient: ", IsClient(), "OnStateChanged(keys)")
end
function modifier_anime_mechanic_parent_new:OnTakeDamage(keys) --FUTURE HEAL FORMULA CALCULATION: ( (WILL HEAL) - (HEAL * HEAL AMP FLOAT) )
    if IsServer() then
        local hAttacker        = keys.attacker
        local hTarget          = keys.unit
        local hAbility         = keys.inflictor
        local fOriginalDamage  = keys.original_damage
        local fDamage          = keys.damage
        local iDamageType      = keys.damage_type
        local iDamageCategory  = keys.damage_category
        local iDamageFlags     = keys.damage_flags

        if IsNotNull(keys.attacker) then
            local tModifiers = keys.attacker:FindAllModifiers()
            for _, hModifier in pairs(tModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.OnTakeDamage) == "function" then
                    hModifier:OnTakeDamage(keys)
                end
            end
        end
        --NOTE: Fixer for ton's of events, maybe can cause bugs because not applied modifier priority...
        if IsNotNull(keys.unit) then
            local tModifiers = keys.unit:FindAllModifiers()
            for _, hModifier in pairs(tModifiers) do
                if IsNotNull(hModifier)
                    and type(hModifier.OnTakeDamage) == "function" then
                    hModifier:OnTakeDamage(keys)
                end
            end
        end

        if IsNotNull(hAttacker) 
            and IsNotNull(hTarget)
            and fDamage > 0 then

            if iDamageCategory == DOTA_DAMAGE_CATEGORY_SPELL then --STILL CAN'T SOLVE HEAL FROM DRAGONSLAYER OR BFURY
                if bit.band(iDamageFlags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL) == 0 then
                    --local fHP_BEFORE = hAttacker:GetHealth()
                    --local fMP_BEFORE = hAttacker:GetMana()

                    local fGetSpellLifesteal = hAttacker:GetSpellLifesteal(keys) * fDamage * 0.01
                    local fGetSpellManasteal = hAttacker:GetSpellManasteal(keys) * fDamage * 0.01

                    if fGetSpellLifesteal > 0 then
                        --=======HEAL FUNCTION AMPLIFICATION CALCULATIONS=======-- (CHANGED TO TRUE FOR TRUE VALUES??????????????????????)
                        local fGSL_Amplified = fGetSpellLifesteal + ( fGetSpellLifesteal * hAttacker:GetSpellLifestealAmplification(keys, false) ) --true for return without redcued by shiva/skadi
                        --=======HEAL FUNCTION AMPLIFICATION CALCULATIONS=======--

                        --=======HEAL FUNCTION AMPLIFICATION PREVENTION CALCULATIONS=======--
                        local fGetHealAmplification    = hAttacker:GetHealAmplification(keys, true) --true for return caster + target amplified
                        local fHealByHealAmplification = fGSL_Amplified * fGetHealAmplification
                        local fGSL_Amplified_ByHealToo = fGSL_Amplified + fHealByHealAmplification
                        --AUTOCORRECTION FOR PREVENT -VALUES WHICH WILL DO REAL HEAL IS REALLY REAL
                        local f123 = fGSL_Amplified
                        local bHealMoreAmp = fGSL_Amplified <= fGSL_Amplified_ByHealToo
                        if true then
                            local f1 = fGSL_Amplified / fGSL_Amplified_ByHealToo
                            local f2 = 1 - f1
                            local f3 = fGSL_Amplified - ( fGSL_Amplified * f2 )

                            f123 = f3
                        else
                            f123 = fGSL_Amplified
                        end
                        --AFTER LAST VALUE IT'S GET AMP BY HEAL ALREADY IN HEAL FUNCTION INSTEAD
                        --100+(100*0.30) == 130 --IF HEAL IS 100 + AMP by heal amp then
                        --1 - (fGSL_Amplified / fGSL_Amplified_ByHealToo) == % which should use for reduce fGSL_Amplified, which will be amped by heal and value will be equal to real value
                        --=======HEAL FUNCTION PREVENTION CALCULATIONS=======--

                        --==================================================--
                        hAttacker:Heal(f123, hAbility)

                        local iSpellLifestealPFX =  ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker)
                                                    ParticleManager:ReleaseParticleIndex(iSpellLifestealPFX)
                    end

                    if fGetSpellManasteal > 0 then
                        hAttacker:GiveMana(fGetSpellManasteal)

                        local iSpellManastealPFX =  ParticleManager:CreateParticle("particles/generic_gameplay/generic_spellmanasteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAttacker)
                                                    ParticleManager:ReleaseParticleIndex(iSpellManastealPFX)
                    end

                    --print(hAttacker:GetHealth() - fHP_BEFORE, "HP HEAL spell")
                    --print(hAttacker:GetMana() - fMP_BEFORE, "MP HEAL spell")
                end

                if IsNotNull(hAbility) then --this abilities can't be amped so not using for them spellamp property but reduce by heal amp prevention
                    local fSpecialHealDamage = fDamage --TODO: REWORK SOMEDAY
                    if hAbility.anime_special_lifesteal then
                        hAttacker:Heal(fSpecialHealDamage, hAbility)
                    end

                    if hAbility.anime_special_lifesteal_heal_clones then
                        local iAttackerTeam = hAttacker:GetTeamNumber()
                        local hClones = Entities:FindAllByClassname(hAttacker:GetClassname())
                        for _, hClone in pairs(hClones) do
                            if IsNotNull(hClone) 
                                and hClone:IsAlive()
                                and hClone:GetOwner() == hAttacker:GetOwner() then
                                hClone:Heal(fSpecialHealDamage, hAbility)
                            end
                        end
                    end

                    if type(hAbility.___iOVERHEAD_ALERT_ANIME) == "number" then
                        SendOverheadEventMessage(nil, hAbility.___iOVERHEAD_ALERT_ANIME, hTarget, fDamage, hAttacker:GetPlayerOwner())
                        return
                    end

                    if hAbility.anime_overhead_effect_damage then
                        SendOverheadEventMessage(nil, hAbility.anime_overhead_effect_damage, hTarget, fDamage, nil)
                        return 
                    end
                end
            end
        end
    end
    --NOTE: Calls when take damage. Uses in Stone and other modificators basicaly
    --print("IsClient: ", IsClient(), "OnTakeDamage(keys)")
end
function modifier_anime_mechanic_parent_new:OnTakeDamageKillCredit(keys)
    --NOTE: Calls when take damage, before OnTakeDamage(keys).
    --print("IsClient: ", IsClient(), "OnTakeDamageKillCredit(keys)")
end
function modifier_anime_mechanic_parent_new:OnTeleported(keys)
    --NOTE: Calls when teleported with base teleport. Not using
    --print("IsClient: ", IsClient(), "OnTeleported(keys)")
end
function modifier_anime_mechanic_parent_new:OnTeleporting(keys)
    --NOTE: Calls when teleporting with base teleport. Not using
    --print("IsClient: ", IsClient(), "OnTeleporting(keys)")
end
function modifier_anime_mechanic_parent_new:OnUnitMoved(keys)
    --Uses on Saitama Training [E], D4C [E]
    --print("IsClient: ", IsClient(), "OnUnitMoved(keys)")
    if IsNotNull(keys.unit) then
        local tModifiers = keys.unit:FindAllModifiers()
        for _, hModifier in pairs(tModifiers) do
            if IsNotNull(hModifier)
                and type(hModifier.OnUnitMoved) == "function" then
                hModifier:OnUnitMoved(keys)
            end
        end
    end
end
-- function modifier_anime_mechanic_parent_new:OnAttackStart(keys)
--     if IsServer() then
--         local hAttacker = keys.attacker
--         local hTarget   = keys.target
--         if IsNotNull(hAttacker) 
--             and IsNotNull(hTarget) then
--             local iIndex    = tostring(hAttacker:entindex()..hTarget:entindex())
--             local fAccuracy = hAttacker:GetAccuracy(keys)
--             if fAccuracy > 0 
--                 and RollPseudoRandom(fAccuracy, hAttacker) then
--                 self.ACCURACY_RECORDS[iIndex] = hAttacker:AddNewModifier(hAttacker, self.ability, "modifier_anime_mechanic_accuracy", {})
--             end
--         end
--     end
-- end
-- function modifier_anime_mechanic_parent_new:OnAttackRecord(keys)
--     if IsServer() then
--         local hAttacker = keys.attacker
--         local hTarget   = keys.target
--         if IsNotNull(hAttacker) 
--             and IsNotNull(hTarget) then
--             local iIndex = tostring(hAttacker:entindex()..hTarget:entindex())
--             local hModifier = self.ACCURACY_RECORDS[iIndex]
--             if IsNotNull(hModifier) then
--                 hModifier:Destroy()
--                 self.ACCURACY_RECORDS[iIndex] = nil
--             end
--         end
--     end
-- end
function modifier_anime_mechanic_parent_new:OnCreated(hTable)
    self.__hCaster  = self:GetCaster()
    self.__hParent  = self:GetParent()
    self.__hAbility = self:GetAbility()

    self.__fFIND_RADIUS = FIND_UNITS_EVERYWHERE

    self.__iCASTER_TEAM          = self.__hParent:GetTeamNumber()
    self.__vCASTER_LOC           = self.__hParent:GetAbsOrigin()

    self.__iABILITY_TARGET_TEAM  =  DOTA_UNIT_TARGET_TEAM_BOTH
    self.__iABILITY_TARGET_TYPE  =  DOTA_UNIT_TARGET_ALL
    self.__iABILITY_TARGET_FLAGS =  DOTA_UNIT_TARGET_FLAG_DEAD +
                                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + 
                                    DOTA_UNIT_TARGET_FLAG_INVULNERABLE + 
                                    DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + 
                                    DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS
    if IsServer() then
        --self.ACCURACY_RECORDS = self.ACCURACY_RECORDS or {}

        self:OnIntervalThink()
        self:StartIntervalThink(0.5)
    end
end
function modifier_anime_mechanic_parent_new:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_mechanic_parent_new:OnIntervalThink() --IF USE AURA, THEN MODIFIER COPY ON ILLUSIONS WILL BE POGCHAMPED.... IDK WHY BUT LOOKS LIKE INITIALIZE DOESN'T WORK
    if IsServer() then
        local hEntities = FindUnitsInRadius( 
                                                self.__iCASTER_TEAM,
                                                self.__vCASTER_LOC,
                                                nil,
                                                self.__fFIND_RADIUS,
                                                self.__iABILITY_TARGET_TEAM,
                                                self.__iABILITY_TARGET_TYPE,
                                                self.__iABILITY_TARGET_FLAGS,
                                                FIND_ANY_ORDER,
                                                false
                                            )

        for _, hEntity in pairs(hEntities) do
            if IsNotNull(hEntity)
                and not hEntity:HasModifier("modifier_anime_mechanic_backtrack") then
                hEntity:AddNewModifier(self.__hParent, self.__hAbility, "modifier_anime_mechanic_backtrack", {})
            end
        end
    end
end




































---------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_item_arcane_blink_buff_fixed", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_item_arcane_blink_buff_fixed = modifier_item_arcane_blink_buff_fixed or class({})

function modifier_item_arcane_blink_buff_fixed:IsHidden()                                                               return false end
function modifier_item_arcane_blink_buff_fixed:IsDebuff()                                                               return false end
function modifier_item_arcane_blink_buff_fixed:IsPurgable()                                                             return true end
function modifier_item_arcane_blink_buff_fixed:IsPurgeException()                                                       return true end
function modifier_item_arcane_blink_buff_fixed:RemoveOnDeath()                                                          return true end
function modifier_item_arcane_blink_buff_fixed:DeclareFunctions()
    local hFunc =   {
                        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
                        MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
                    }
    return hFunc
end
function modifier_item_arcane_blink_buff_fixed:GetModifierPercentageCooldownStacking(keys)
    if IsNotNull(keys.ability)
        and not keys.ability:IsItem()
        and not keys.ability:HasStaticCooldown() then
        return keys.ability:IsUltimate()
               and self.fUltimateCooldown
               or self.fBaseCooldown
    end
end
function modifier_item_arcane_blink_buff_fixed:GetModifierPercentageCasttime(keys)
    return self.fCastPctImprovement
end
function modifier_item_arcane_blink_buff_fixed:OnCreated(hTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()

    self.fBaseCooldown       = self.hAbility:GetSpecialValueFor("base_cooldown")
    self.fUltimateCooldown   = self.hAbility:GetSpecialValueFor("ultimate_cooldown")
    self.fCastPctImprovement = self.hAbility:GetSpecialValueFor("cast_pct_improvement")

    --print(self.fBaseCooldown, self.fUltimateCooldown, self.fCastPctImprovement)

    if IsServer()
        and not self.iArcanePFX then
        self.iArcanePFX = ParticleManager:CreateParticle("particles/generic_gameplay/rune_arcane_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hParent)

        self:AddParticle(self.iArcanePFX, false, false, -1, false, false)
    end
end
function modifier_item_arcane_blink_buff_fixed:OnRefresh(hTable)
    self:OnCreated(hTable)
end


































































--!!OVERTHROW SPECIAL MODIFIERS!!--
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_overthrow_gold_xp_aura", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_overthrow_gold_xp_aura = modifier_anime_overthrow_gold_xp_aura or class({})

function modifier_anime_overthrow_gold_xp_aura:IsHidden()                                           return true end
function modifier_anime_overthrow_gold_xp_aura:IsDebuff()                                           return false end
function modifier_anime_overthrow_gold_xp_aura:IsPurgable()                                         return false end
function modifier_anime_overthrow_gold_xp_aura:IsPurgeException()                                   return false end
function modifier_anime_overthrow_gold_xp_aura:RemoveOnDeath()                                      return true end
function modifier_anime_overthrow_gold_xp_aura:GetAttributes()                                      return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_overthrow_gold_xp_aura:GetPriority()                                        return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_overthrow_gold_xp_aura:IsMarbleException()                                  return true end
function modifier_anime_overthrow_gold_xp_aura:IsAura()                                             return true end
function modifier_anime_overthrow_gold_xp_aura:IsAuraActiveOnDeath()                                return true end
function modifier_anime_overthrow_gold_xp_aura:CheckState()
    local hState =  { 
                        [MODIFIER_STATE_INVULNERABLE]      = true,
                        [MODIFIER_STATE_NO_HEALTH_BAR]     = true,
                        [MODIFIER_STATE_STUNNED]           = true,
                        [MODIFIER_STATE_UNSELECTABLE]      = true,
                        [MODIFIER_STATE_UNTARGETABLE]      = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                        [MODIFIER_STATE_OUT_OF_GAME]       = true,
                        [MODIFIER_STATE_NOT_ON_MINIMAP]    = true
                    }
    return hState
end
function modifier_anime_overthrow_gold_xp_aura:GetAuraEntityReject(hEntity)
    if hEntity == self.__hParent
        or hEntity:HasModifier("modifier_fountain_aura_buff") then
        return true
    end
end
function modifier_anime_overthrow_gold_xp_aura:GetAuraRadius()
    return self.__fGlobalRadius
end
function modifier_anime_overthrow_gold_xp_aura:GetAuraSearchTeam()
    return self.__iABILITY_TARGET_TEAM
end
function modifier_anime_overthrow_gold_xp_aura:GetAuraSearchType()
    return self.__iABILITY_TARGET_TYPE
end
function modifier_anime_overthrow_gold_xp_aura:GetAuraSearchFlags()
    return self.__iABILITY_TARGET_FLAGS
end
function modifier_anime_overthrow_gold_xp_aura:GetModifierAura()
    return "modifier_anime_overthrow_gold_xp_buff"
end
function modifier_anime_overthrow_gold_xp_aura:OnCreated(hTable)
    self.__hCaster  = self:GetCaster()
    self.__hParent  = self:GetParent()
    self.__hAbility = self:GetAbility()

    if IsServer() then
        --====================================================================================================================--
        self.__iABILITY_TARGET_TEAM  = hTable.iABILITY_TARGET_TEAM  or DOTA_UNIT_TARGET_TEAM_NONE
        self.__iABILITY_TARGET_TYPE  = hTable.iABILITY_TARGET_TYPE  or DOTA_UNIT_TARGET_NONE
        self.__iABILITY_TARGET_FLAGS = hTable.iABILITY_TARGET_FLAGS or DOTA_UNIT_TARGET_FLAG_NONE
        --====================================================================================================================--
        self.__vParentLoc = self.__hParent:GetAbsOrigin()
        --====================================================================================================================--
        self.__bGamePoints   = hTable.bGamePoints > 0
        self.__iTeamsCount   = hTable.iTeamsCount
        self.__iTeamPlayers  = hTable.iTeamPlayers

        self.__fGlobalRadius = hTable.fGlobalRadius
        self.__fLocalRadius  = hTable.fLocalRadius

        self.__fGPS_TickTime  = hTable.fGPS_TickTime
        self.__fXPS_TickTime  = hTable.fXPS_TickTime
        self.__fGPPS_TickTime = hTable.fGPPS_TickTime

        self.__fGPS_Income    = hTable.fGPS_Income
        self.__fXPS_Income    = hTable.fXPS_Income
        self.__fGPPS_Income   = hTable.fGPPS_Income

        self.__fGlobalIncScale = hTable.fGlobalIncScale
        self.__fDeathIncScale  = hTable.fDeathIncScale
        --====================================================================================================================--
        --====================================================================================================================--
        self.__hViewersTable = self.__hViewersTable or {}

        self:OnDestroy()

        --[[for iTeamNumber = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX do
            self.__hViewersTable[iTeamNumber] = AddFOWViewer(iTeamNumber, self.__vParentLoc, self.__fLocalRadius, 99999, true)
        end]]
    end
end
function modifier_anime_overthrow_gold_xp_aura:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_overthrow_gold_xp_aura:OnDestroy()
    if IsServer() then
        for iTeamNumber, iViewer in pairs(self.__hViewersTable) do
            RemoveFOWViewer(iTeamNumber, iViewer)
        end
        self.__hViewersTable = {}
    end
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_overthrow_gold_xp_buff", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_overthrow_gold_xp_buff = modifier_anime_overthrow_gold_xp_buff or class({})

function modifier_anime_overthrow_gold_xp_buff:IsHidden()                                       --FIXED VISIBILITY FOR ENEMIES, SO ILLUSIONS WILL BE HARDER TO FIND
    if IsClient()
        and not IsInToolsMode() then
        --GABE ЕБАНУЛСЯ НА ГОЛОВУ NAHUYA BLYATB NAHUYA!!!!!
        --[[for i = -1, 30 do
            print(GetLocalPlayerTeam(i), i, "PIZDEC")
        end]]
        return self.__hParent:GetTeamNumber() ~= GetLocalPlayerTeam(GetLocalPlayerID())
    end
    return false
end
function modifier_anime_overthrow_gold_xp_buff:IsDebuff()                                       return false end
function modifier_anime_overthrow_gold_xp_buff:IsPurgable()                                     return false end
function modifier_anime_overthrow_gold_xp_buff:IsPurgeException()                               return false end
function modifier_anime_overthrow_gold_xp_buff:RemoveOnDeath()                                  return false end
function modifier_anime_overthrow_gold_xp_buff:GetAttributes()                                  return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_overthrow_gold_xp_buff:GetPriority()                                    return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_overthrow_gold_xp_buff:IsMarbleException()                              return true end
function modifier_anime_overthrow_gold_xp_buff:GetTexture()
    return self:GetStackCount() < 0 
           and "anime_items/anime_gold_exp"
           or "alchemist_goblins_greed"
end
function modifier_anime_overthrow_gold_xp_buff:OnCreated(hTable)
    self.__hCaster  = self:GetCaster()
    self.__hParent  = self:GetParent()
    self.__hAbility = self:GetAbility()

    if IsServer() then
        self.__hAuraOwner = self:GetAuraOwner()
        if not IsNotNull(self.__hAuraOwner) then
            return self:Destroy()
        end
        --====================================================================================================================--
        local hModifier = self.__hAuraOwner:FindModifierByName("modifier_anime_overthrow_gold_xp_aura")
        if not IsNotNull(hModifier) then
            return self:Destroy()
        end
        --====================================================================================================================--
        self.__vParentLoc  = self.__hAuraOwner:GetAbsOrigin()
        self.__iParentTeam = self.__hParent:GetTeamNumber()
        self.__iParentPID  = self.__hParent:GetMainControllingPlayer()
        --====================================================================================================================--
        self.__bGamePoints    = hModifier.__bGamePoints
        self.__iTeamsCount    = hModifier.__iTeamsCount
        self.__iTeamPlayers   = hModifier.__iTeamPlayers

        self.__fGlobalRadius  = hModifier.__fGlobalRadius
        self.__fLocalRadius   = hModifier.__fLocalRadius

        self.__fGPS_TickTime  = hModifier.__fGPS_TickTime
        self.__fXPS_TickTime  = hModifier.__fXPS_TickTime
        self.__fGPPS_TickTime = hModifier.__fGPPS_TickTime

        self.__fGPS_Income    = hModifier.__fGPS_Income
        self.__fXPS_Income    = hModifier.__fXPS_Income
        self.__fGPPS_Income   = hModifier.__fGPPS_Income

        self.__fGlobalIncScale = hModifier.__fGlobalIncScale
        self.__fDeathIncScale  = hModifier.__fDeathIncScale
        --====================================================================================================================--
        self.__fLocalTickTime = 0.1

        self.__fLocalGPS_Time  = 0
        self.__fLocalXPS_Time  = 0
        self.__fLocalGPPS_Time = 0

        self:StartIntervalThink(self.__fLocalTickTime)
    end
end
function modifier_anime_overthrow_gold_xp_buff:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_overthrow_gold_xp_buff:OnIntervalThink()
    if IsServer()
        and IsNotNull(self.__hAuraOwner) 
        and IsNotNull(self.__hParent) then
            
        local fTimeElapsedMinutes = ( ( AnimeOverthrow:GetAnimeOverthrowTime() - AnimeOverthrow:GetCurrentAnimeOverthrowTime() ) / 60 )

        local __fGPS_Income  = self.__fGPS_Income
        local __fXPS_Income  = self.__fXPS_Income
        local __fGPPS_Income = self.__fGPPS_Income

        if GetDistance(self.__hAuraOwner, self.__hParent) > self.__fLocalRadius then
            __fGPS_Income  = __fGPS_Income  * self.__fGlobalIncScale
            __fXPS_Income  = __fXPS_Income  * self.__fGlobalIncScale
            __fGPPS_Income = __fGPPS_Income * self.__fGlobalIncScale

            self:SetStackCount(0)
        else
            self:SetStackCount(-1)
        end

        if not self.__hParent:IsAlive() then
            __fGPS_Income  = __fGPS_Income  * self.__fDeathIncScale
            __fXPS_Income  = __fXPS_Income  * self.__fDeathIncScale
            __fGPPS_Income = __fGPPS_Income * self.__fDeathIncScale
        end

        local iTeamHeroKills = ( GetTeamHeroKills(self.__iParentTeam) * 0.5 ) + ( PlayerResource:GetDeaths(self.__iParentPID) * 2.0 )

        __fGPS_Income = __fGPS_Income + iTeamHeroKills
        __fXPS_Income = __fXPS_Income + iTeamHeroKills
        --__fGPPS_Income = __fGPPS_Income +

        local iActivePlayersInTeam = TableLength(ATP_GetPlayersInTeam(self.__iParentTeam, true, false))
        
        local iScaleByLeaversInTeam = ( 1 + ( self.__iTeamPlayers - iActivePlayersInTeam ) ) * 0.5

        __fGPS_Income  = __fGPS_Income * iScaleByLeaversInTeam
        __fXPS_Income  = __fXPS_Income * iScaleByLeaversInTeam
        __fGPPS_Income = __fGPPS_Income * iScaleByLeaversInTeam
        
        --[[if fTimeElapsedMinutes >= 0 then
            local hSortedTeams = AnimeOverthrow.hAnimeOverthrowScoreBoard or {}
            local hReSortedTeams = {}
            for iKey, hValue in pairs(hSortedTeams) do
                if IsNotNull(hValue) 
                    and IsNotNull(hValue.teamID) then
                    hReSortedTeams[tostring(hValue.teamID)] = iKey
                end
            end

            local iTeamsCount = self.__iTeamsCount + 1
            local iTeamValue  = hReSortedTeams[tostring(self.__iParentTeam)]
            if type(iTeamValue) == "number" then
                local iTeamsWithPlayers_Active = TableLength(ATP_GetTeamsWithPlayers(true, false))
                local fSecretBonusGold = ( __fGPS_Income * ( ( iTeamsCount - iTeamsWithPlayers_Active ) * ( iTeamValue / iTeamsCount ) ) )
                
                __fGPS_Income = __fGPS_Income + fSecretBonusGold
                --self.__hParent:ModifyGold(fSecretBonusGold, true, DOTA_ModifyGold_GameTick)
            end    
        end]]
        --====================================================================================================================--
        local hPlayer = self.__hParent:GetPlayerOwner()
        
        self.__fLocalGPS_Time = self.__fLocalGPS_Time + self.__fLocalTickTime
        if self.__fLocalGPS_Time >= self.__fGPS_TickTime then
            self.__fLocalGPS_Time = 0

            self.__hParent:ModifyGold(__fGPS_Income, true, DOTA_ModifyGold_GameTick)
            
            SendOverheadEventMessage(hPlayer, OVERHEAD_ALERT_MANA_ADD, self.__hParent, __fGPS_Income, hPlayer)
        end
        --====================================================================================================================--
        self.__fLocalXPS_Time = self.__fLocalXPS_Time + self.__fLocalTickTime
        if self.__fLocalXPS_Time >= self.__fXPS_TickTime then
            self.__fLocalXPS_Time = 0

            self.__hParent:AddExperience(__fXPS_Income, DOTA_ModifyXP_Outpost, false, false)

            SendOverheadEventMessage(hPlayer, OVERHEAD_ALERT_XP, self.__hParent, __fXPS_Income, hPlayer)
        end
        --====================================================================================================================--
        if self.__bGamePoints then
            self.__fLocalGPPS_Time = self.__fLocalGPPS_Time + self.__fLocalTickTime
            if self.__fLocalGPPS_Time >= self.__fGPPS_TickTime then
                self.__fLocalGPPS_Time = 0

                AnimeOverthrow:IncreaseGamePointsForPlayer(self.__iParentPID, __fGPPS_Income)

                SendOverheadEventMessage(hPlayer, OVERHEAD_ALERT_SHARD, self.__hParent, __fGPPS_Income, hPlayer)
            end
        end
    end
end
function modifier_anime_overthrow_gold_xp_buff:GetEffectName()
    return "particles/econ/courier/courier_greevil_yellow/courier_greevil_yellow_ambient_3_b.vpcf"
end
function modifier_anime_overthrow_gold_xp_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_overthrow_treasure_logic", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_overthrow_treasure_logic = modifier_anime_overthrow_treasure_logic or class({})

function modifier_anime_overthrow_treasure_logic:IsHidden()                                             return true end
function modifier_anime_overthrow_treasure_logic:IsDebuff()                                             return false end
function modifier_anime_overthrow_treasure_logic:IsPurgable()                                           return false end
function modifier_anime_overthrow_treasure_logic:IsPurgeException()                                     return false end
function modifier_anime_overthrow_treasure_logic:RemoveOnDeath()                                        return true end
function modifier_anime_overthrow_treasure_logic:GetAttributes()                                        return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_overthrow_treasure_logic:GetPriority()                                          return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_overthrow_treasure_logic:IsMarbleException()                                    return true end
function modifier_anime_overthrow_treasure_logic:DeclareFunctions()
    local hFunc =   {
                        --MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
                    }
    return hFunc
end
function modifier_anime_overthrow_treasure_logic:GetModifierMoveSpeed_Absolute(keys)
    return 900
end
function modifier_anime_overthrow_treasure_logic:OnCreated(hTable)
    self.__hCaster  = self:GetCaster()
    self.__hParent  = self:GetParent()
    self.__hAbility = self:GetAbility()

    if IsServer() then
        self:StartIntervalThink(0.1) --FRAME TIME NOT WORK IDK WHY, THINK TOO LOW INTERVAL FOR THINKERS
    end
end
function modifier_anime_overthrow_treasure_logic:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_overthrow_treasure_logic:OnIntervalThink()
    if IsServer() then
        if IsNotNull(self.__hParent)
            and self.__hParent:IsAlive()
            and IsNotNull(self.hAnimeChestDropGoalPathing) then
            if IsNotNull(self.hAnimeChestDropGoalPathing[1])
                and GetDistance(self.hAnimeChestDropGoalPathing[1], self.__hParent) > 0.05 then
                return self.__hParent:MoveToPosition(self.hAnimeChestDropGoalPathing[1]:GetAbsOrigin())
            elseif not IsNotNull(self.hAnimeChestDropGoalPathing[1])
                and IsNotNull(AnimeOverthrow)
                and AnimeOverthrow.___bAnimeOverthrowInited then
                return AnimeOverthrow:ThrowAnimeChestDrop(self.__hParent)
            else
                return table.remove(self.hAnimeChestDropGoalPathing, 1)
            end
        else
            return error("ERROR BAKA IN LOGIC TREASURE")
        end
    end
end



















































































--!!ANIME FATE SPECIAL MODIFIERS!!--
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_fate_pre_post_round_pause", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_fate_pre_post_round_pause = modifier_anime_fate_pre_post_round_pause or class({})

function modifier_anime_fate_pre_post_round_pause:IsHidden()                                         return false end
function modifier_anime_fate_pre_post_round_pause:IsDebuff()                                         return true end
function modifier_anime_fate_pre_post_round_pause:IsPurgable()                                       return false end
function modifier_anime_fate_pre_post_round_pause:IsPurgeException()                                 return false end
function modifier_anime_fate_pre_post_round_pause:RemoveOnDeath()                                    return false end
function modifier_anime_fate_pre_post_round_pause:GetAttributes()                                    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_fate_pre_post_round_pause:GetPriority()                                      return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_fate_pre_post_round_pause:IsMarbleException()                                return true end
function modifier_anime_fate_pre_post_round_pause:GetTexture()
    return "anime_fate/fate_revoke_active"
end
function modifier_anime_fate_pre_post_round_pause:CheckState()
    local hState =  {
                        [MODIFIER_STATE_INVULNERABLE]       = true,
                        --[MODIFIER_STATE_NO_HEALTH_BAR]      = true,
                        --[MODIFIER_STATE_UNSELECTABLE]       = true,
                        --[MODIFIER_STATE_UNTARGETABLE]       = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION]  = true,
                        --[MODIFIER_STATE_OUT_OF_GAME]        = true,
                        [MODIFIER_STATE_SILENCED]           = true,
                        [MODIFIER_STATE_MUTED]              = true,
                        [MODIFIER_STATE_HEXED]              = true,
                        [MODIFIER_STATE_PASSIVES_DISABLED]  = true,
                        [MODIFIER_STATE_DISARMED]           = true,
                        [MODIFIER_STATE_ATTACK_IMMUNE]      = true,
                        [MODIFIER_STATE_MAGIC_IMMUNE]       = true,
                        [MODIFIER_STATE_ROOTED]             = true,
                        [MODIFIER_STATE_BLIND]              = true,
                        [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
                        [MODIFIER_STATE_STUNNED]            = true,
                    }
    return hState
end
function modifier_anime_fate_pre_post_round_pause:DeclareFunctions()
    local hFunc =   {
                        MODIFIER_PROPERTY_MIN_HEALTH
                    }
    return hFunc
end
function modifier_anime_fate_pre_post_round_pause:GetMinHealth(keys)
    return self.fMinHealth
end
function modifier_anime_fate_pre_post_round_pause:OnCreated(hTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()

    if IsServer() then
        self.fMinHealth = self.hParent:GetHealth()
    end
end
function modifier_anime_fate_pre_post_round_pause:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_fate_pre_post_round_pause:OnDestroy()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_fate_main_master_invulnerable", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_fate_main_master_invulnerable = modifier_anime_fate_main_master_invulnerable or class({})

function modifier_anime_fate_main_master_invulnerable:IsHidden()                                         return true end
function modifier_anime_fate_main_master_invulnerable:IsDebuff()                                         return false end
function modifier_anime_fate_main_master_invulnerable:IsPurgable()                                       return false end
function modifier_anime_fate_main_master_invulnerable:IsPurgeException()                                 return false end
function modifier_anime_fate_main_master_invulnerable:RemoveOnDeath()                                    return false end
function modifier_anime_fate_main_master_invulnerable:GetAttributes()                                    return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_fate_main_master_invulnerable:GetPriority()                                      return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_fate_main_master_invulnerable:IsMarbleException()                                return true end
function modifier_anime_fate_main_master_invulnerable:CheckState()
    local hState =  {
                        [MODIFIER_STATE_INVULNERABLE]       = true,
                        --[MODIFIER_STATE_NO_HEALTH_BAR]      = true,
                        --[MODIFIER_STATE_UNSELECTABLE]       = true,
                        --[MODIFIER_STATE_UNTARGETABLE]       = true,
                        [MODIFIER_STATE_NO_UNIT_COLLISION]  = true,
                        --[MODIFIER_STATE_OUT_OF_GAME]        = true, --WILL RETURN IF WILL BE NEED
                        [MODIFIER_STATE_DISARMED]           = true,
                        [MODIFIER_STATE_ATTACK_IMMUNE]      = true,
                        [MODIFIER_STATE_MAGIC_IMMUNE]       = true,
                        [MODIFIER_STATE_ROOTED]             = true,
                        [MODIFIER_STATE_BLIND]              = true
                    }
    return hState
end
function modifier_anime_fate_main_master_invulnerable:DeclareFunctions()
    local hFunc =   {
                        --MODIFIER_PROPERTY_MIN_HEALTH
                    }
    return hFunc
end
function modifier_anime_fate_main_master_invulnerable:GetMinHealth(keys)
    return self.fMinHealth
end
function modifier_anime_fate_main_master_invulnerable:OnCreated(hTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()

    if IsServer() then
        self.fMinHealth = self.hParent:GetHealth()
    end
end
function modifier_anime_fate_main_master_invulnerable:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_fate_main_master_invulnerable:OnDestroy()
end
--!!----------------------------------------------------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_anime_fate_main_master_exchange_points", "anime_modifiers_server_client", LUA_MODIFIER_MOTION_NONE)

modifier_anime_fate_main_master_exchange_points = modifier_anime_fate_main_master_exchange_points or class({})

function modifier_anime_fate_main_master_exchange_points:IsHidden()                                             return false end
function modifier_anime_fate_main_master_exchange_points:IsDebuff()                                             return false end
function modifier_anime_fate_main_master_exchange_points:IsPurgable()                                           return false end
function modifier_anime_fate_main_master_exchange_points:IsPurgeException()                                     return false end
function modifier_anime_fate_main_master_exchange_points:RemoveOnDeath()                                        return false end
function modifier_anime_fate_main_master_exchange_points:GetAttributes()                                        return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_fate_main_master_exchange_points:GetPriority()                                          return MODIFIER_PRIORITY_ULTRA end
function modifier_anime_fate_main_master_exchange_points:IsMarbleException()                                    return true end
function modifier_anime_fate_main_master_exchange_points:GetTexture()
    return "anime_fate/fate_shard_scepter"
end
function modifier_anime_fate_main_master_exchange_points:OnCreated(hTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()
end
function modifier_anime_fate_main_master_exchange_points:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_anime_fate_main_master_exchange_points:OnDestroy()
end
























return true