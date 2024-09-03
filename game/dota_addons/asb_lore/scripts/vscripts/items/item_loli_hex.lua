item_loli_hex = item_loli_hex or class({})
LinkLuaModifier("modifier_item_loli_hex", "items/item_loli_hex", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_loli_hex_debuff", "items/item_loli_hex", LUA_MODIFIER_MOTION_NONE)

--==================================================--
local __iProjectiles = {}
--==================================================--

-- Tests for properly clearing table
--[[if IsServer() then
    Timers:CreateTimer(1.0,function()
        if TableLength(__iProjectiles) > 0 then
            for iProjectID, nBounces in pairs(__iProjectiles) do
                print("Loli Hex: TEST PROJ IN TABLE ID: " .. iProjectID)
            end
        else
            print("Loli Hex: NO PROJECTILES IN TABLE.")
        end
        return 1.0
    end)
end]]--

function item_loli_hex:GetIntrinsicModifierName()
    return "modifier_item_loli_hex"
end
function item_loli_hex:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function item_loli_hex:CastFilterResultTarget(hTarget)
    if hTarget == self:GetCaster() then
        return UF_FAIL_DISABLE_HELP
    else
        return self.BaseClass.CastFilterResultTarget(self, hTarget)
    end
end
function item_loli_hex:OnSpellStart()
    local hCaster = self:GetCaster()
    local hTarget = self:GetCursorTarget()
	
    --hCaster:EmitSound("loli_hex.launch")
    
    --if not self.hAbility then
        --self.hAbility = self:RegisterAbilityHandle(hCaster)
    --end
	
    self:CreateLoliProjectile(hCaster, hTarget)
end
function item_loli_hex:OnProjectileHit(hTarget, vLocation)
    -------------------------!! IMPORTANT !!-------------------------------
    -- I am doing this because Items don't have OnProjectileHitHandle 
    -- or any other useful function for recording Projectile IDs.
    -- ++ Don't want to add a spell to everyone just to handle this logic.
    
    -- This is purely experimental and probably can break somewhere !
    -- Using table with not ProjectileManager:IsValidProjectile as tracking.
    -----------------------------------------------------------------------
    
    -- Delay because projectile is not instantly destroyed.
    -- Can use OnIntervalThink too maybe if this breaks ?
    Timers:CreateTimer(0.01,function()
        if IsNotNull(self) then
            local iProjectileThatHit = GetProjectileThatHit(self.__iLatestProjectile)
            local nDynamicValue      = self:GetSpecialValueFor("loli_duration")
            
            -- If no projectile id has been provided then just return TRUE (destroys this projectile)
            -- It will cause the projectile to do nothing, but if it's not in the table then makes sense ?
            if not iProjectileThatHit then
                --print("Loli Hex: Did not find Projectile or Projectile in Table")
                return nil
            end
            
            if not IsNotNull(hTarget) then
                --print("Loli Hex: Projectile NOT HIT TEST ?????")
                goto clear_projectile
            end
            
            -- Gachi men deflect projectiles to different targets
            if IsGachiMan(hTarget) then
                -- If no bounces left then just destroy the projectile
                if __iProjectiles[tostring(iProjectileThatHit)] <= 0 then
                    --print("Loli Hex: NO BOUNCES")
                    goto clear_projectile
                end
                
                -- Find the closest target(Ally, Enemy) and bounce to it
                local hClosestTarget = FindClosestTarget(hTarget)   
                if IsNotNull(hClosestTarget) then
                    local nRecordBounces = __iProjectiles[tostring(iProjectileThatHit)] - 1
                    local iNewProjectile = self:CreateLoliProjectile(hTarget, hClosestTarget, nRecordBounces, true)
                    --print("Loli Hex Bounces: " .. nRecordBounces)
                    goto clear_projectile
                end
                
                --print("Loli Hex: NOTHING????")
                goto clear_projectile
            end
            
            -- Lolis get stronger from this item
            if IsLoli(hTarget) then
                hTarget:AddNewModifier(hTarget, self, "modifier_item_loli_hex_debuff", { duration = nDynamicValue, bModelChange = false })
                goto clear_projectile
            end
            
            -- If it didn't hit a GachiMan or a Loli then just do standard Loli Hex
            hTarget:AddNewModifier(hTarget, self, "modifier_item_loli_hex_debuff", { duration = nDynamicValue })
            
            nDynamicValue =  ParticleManager:CreateParticle("particles/item/loli_hex/kanna_transform.vpcf", PATTACH_WORLDORIGIN, nil)
                             ParticleManager:SetParticleControl(nDynamicValue, 0, hTarget:GetAbsOrigin()) 
                             ParticleManager:ReleaseParticleIndex(nDynamicValue)
            
            StopSoundOn("loli_hex.launch", self:GetCaster())
            hTarget:EmitSound("loli_hex.land" .. RandomInt(1, 4))
            
            ::clear_projectile::
            
            __iProjectiles[tostring(iProjectileThatHit)] = nil

            --print("Loli Hex: Projectile Hit Test")
        end
    end)
    
    --return true -- HMMMMM?????
end
function item_loli_hex:CreateLoliProjectile(hCaster, hTarget, nBounces, bGachi)
    if not IsNotNull(hCaster) or not IsNotNull(hTarget) then return end
	
    if bGachi then
        hCaster:EmitSound("loli_hex.fyou" .. RandomInt(1, 2))
    else
        hCaster:EmitSound("loli_hex.launch")
    end
	
	local info = {	Target = hTarget,
    				Source = hCaster,
   					Ability = self,    
    
    				EffectName = "particles/item/loli_hex/kanna_projectile.vpcf",
    				iMoveSpeed = 1100,
    				bDodgeable = true,

    				--iSourceAttachmet = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
    				--vSourceLoc = hCaster:GetAbsOrigin(),
    				--bIsAttack = false,
    				bReplaceExisting = false,
    				flExpireTime = GameRules:GetGameTime() + 10,
    
    				bDrawsOnMinimap = true,
    				bVisibleToEnemies = true,
    				bProvidesVision = true,
    				iVisionRadius = 400,
    				iVisionTeamNumber = hCaster:GetTeamNumber()
				}
	
	local nBounces    = nBounces or 3
    local iProjectile = ProjectileManager:CreateTrackingProjectile(info)
    __iProjectiles[tostring(iProjectile)] = nBounces
    self.__iLatestProjectile = iProjectile
    
    return iProjectile
end
-- KEEEEEEEEEEEEK Almost works but no
--[[
function item_loli_hex:RegisterAbilityHandle(hCaster)
    if IsNotNull(hCaster) then
        local hAbility      = nil
        local nAbilities    = 0
        local hViableSpells = {}
        
        while not hAbility and nAbilities <= 10 do
            local hTryThisAbility = hCaster:GetAbilityByIndex(nAbilities)
            if IsNotNull(hTryThisAbility) then
                if type(hTryThisAbility.LoliReady) == "function" then
                    hAbility = hTryThisAbility
                    break
                end
                if SpellIsViable(hTryThisAbility) then 
                    table.insert(hViableSpells, hTryThisAbility)
                    print("Loli Hex, INSERTING SPELL")
                end
            end
            nAbilities = nAbilities + 1
            print("Loli Hex, TESTING")
        end
        
        if IsNotNull(hAbility) then 
            return hAbility 
        end
        
        hAbility = hViableSpells[1]
        
        if not IsNotNull(hAbility) then
            return error("This hero has no viable spells for this item")
        end
        
        local fOnProjectileHitHandle = nil
        if type(hAbility.OnProjectileHitHandle) == "function" then
            fOnProjectileHitHandle = hAbility.OnProjectileHitHandle
        end
            
        hAbility.OnProjectileHitHandle = function(self, hTarget, vLocation, iProjectID)
            if type(hAbility.LoliReady) == "function" and __iProjectiles[tostring(iProjectID)] then
                local thisItem = self:LoliReady()
                return thisItem:OnLoliHandle(hTarget, vLocation, iProjectID)
            end
            
            if fOnProjectileHitHandle then
                print("WTF")
                return fOnProjectileHitHandle(self, hTarget, vLocation, iProjectID)
            end
        end
        
        -- Super PEPE testing
        hAbility.LoliReady = function(self)
            local hCaster  = self:GetCaster()
            local thisItem = hCaster:FindItemInInventory("item_loli_hex")
            return thisItem
        end
        
        return hAbility
    end
end
function SpellIsViable(hAbility)
    return type(hAbility.OnProjectileHit) ~= "function"
           and type(hAbility.OnProjectileHit_ExtraData) ~= "function"
           and type(hAbility.OnProjectileHitHandle) ~= "function"
           and type(hAbility.OnProjectileThink) ~= "function"
           and type(hAbility.OnProjectileThink_ExtraData) ~= "function"
           and type(hAbility.OnProjectileThinkHandle) ~= "function"
end
]]--

function GetProjectileThatHit(iLatestProjectile)
    local tProjectilesThatHit = {}
    
    -- Store all projectiles that aren't valid (indicates that they hit something or were removed/dodged)
    for iProjectID, nBounces in pairs(__iProjectiles) do
        if not ProjectileManager:IsValidProjectile(tonumber(iProjectID)) then
            --print("Loli Hex: INSERTING PROJECTILE")
            table.insert(tProjectilesThatHit, iProjectID)
        end
    end
    
    -- Sort the table so that the newest projectile index is first (This way the newest Projectile will take priority)
    table.sort(tProjectilesThatHit, function(a, b)
        if a == iLatestProjectile then
            return true
        elseif b == iLatestProjectile then
            return false
        else
            return a > b
        end
    end)
    
    --DeepPrintTable(__iProjectiles)
    --print(iLatestProjectile)
    
    --Timers:CreateTimer(3.0,function()
        --DeepPrintTable(__iProjectiles)
    --end)
    
    -- If more than 1 projectile is returned on Hit, then possibly multiple hit/dodged/removed at the same time, so just clean the table
    if #tProjectilesThatHit > 1 then
        for _ = 2, #tProjectilesThatHit do
            __iProjectiles[tostring(tProjectilesThatHit[_])] = nil
            --print("AHAAAAAA")
        end
    end
    
    -- NOTE: If just return tProjectilesThatHit[1] works, but do this because it's safer ? (VALVE also does this)
    return #tProjectilesThatHit > 0 and tProjectilesThatHit[1] or nil
end

function FindClosestTarget(hCaster, iRadius)
    iRadius = iRadius or 1000
    local hEnemies = FindUnitsInRadius( hCaster:GetTeamNumber(),  -- int, your team number
                                        hCaster:GetOrigin(),  -- point, center point
                                        nil,  -- handle, cacheUnit. (not known)
                                        iRadius,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                        DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY,  -- int, team filter
                                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  -- int, type filter
                                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  -- int, flag filter
                                        FIND_CLOSEST,  -- int, order filter
                                        false  -- bool, can grow cache
                                    )
    if #hEnemies > 0 then
        -- The caster should not be the enemy
        if hCaster == hEnemies[1] then
            -- Return the actual closest unit or nil 
            return #hEnemies > 1 and hEnemies[2] or nil
        end
        
        -- Return the closest enemy if it's not the caster
        return hEnemies[1]
    end
    
    return nil
    -- Return the closest enemy if it exists
    -- NOTE: If just return hEnemies[1] works, but do this because it's safer ? (VALVE also does this)
    --return #hEnemies > 0 and hEnemies[1] or nil
end

function IsGachiMan(hCaster)
    local tGachiModels = {
                             -- Base Gachi Models
                             ["models/pikapika/billy.vmdl"] = true,
                             ["models/bogdan/bodgan1.vmdl"] = true,
                             ["models/pikapika/pika1.vmdl"] = true,
                             ["models/pikapika/gachichu.vmdl"] = true,
                             ["models/heroes/ringmaster/ringmaster_base.vmdl"] = true,
                             
                             -- Arcanas
                             ["models/bogdan/hurk.vmdl"] = true,
                         }
    return tGachiModels[hCaster:GetModelName()]
end

function IsLoli(hCaster)
    local tLoliModels = {
                             -- Main Loli Hex Model
                             ["models/heroes/kanna/kanna.vmdl"] = true,
                             
                             -- Base Loli Models
                             ["models/heroes/chaos_knight/chaos_knight.vmdl"] = true,
                             ["models/reinforce/reinforce.vmdl"] = true,
                             ["models/tohka/main/tohka.vmdl"] = true,
                             ["models/heroes/tuskarr/tuskarr.vmdl"] = true,
                             ["models/ikaros/ikaros_watermelon_max.vmdl"] = true,
                             ["models/heroes/ember_spirit/ember_spirit.vmdl"] = true,
                             ["models/thd2/rumia/rumia_mmd.vmdl"] = true,
                             ["models/hatsune_miku/small/s2.vmdl"] = true,
                             ["models/kanade/kanade.vmdl"] = true,
                             ["models/yoshinon/yoshino.vmdl"] = true,
                             ["models/pandora/fix/pandora.vmdl"] = true,
                             ["models/thd2/yukari/yukari_mmd.vmdl"] = true,
                             ["models/jibril/jibril.vmdl"] = true,
                             ["models/vocaloid_rin/rin/rin1.vmdl"] = true,
                             ["models/heroes/queenofpain/queenofpain.vmdl"] = true,
                             
                             -- Upgrade Models (from abilities)
                             ["models/rumia_ex/rumia_ex.vmdl"] = true,
                             ["models/yoshinon/yoshino_angel.vmdl"] = true,
                             ["models/yoshinon/yoshino_inverse.vmdl"] = true,
                             ["models/zayac/zayac.vmdl"] = true,
                             ["models/hatsune_miku/chibi2.vmdl"] = true,
                             
                             -- Arcanas
                             ["models/tohka/arcana/tohka_arcana.vmdl"] = true,
                             ["models/kizuna_ai/kizuna_ai.vmdl"] = true,
                        }
    return tLoliModels[hCaster:GetModelName()]
end


function numtobool(n)
    return n ~= 0
end

--[[
function numtobool(n)
    local b = false
    if n ~= 0 then
        b = true
    end
    return b
end]]--

--[[
function numtoboolspecial(v)
    if type(v) ~= "number" then
        return v
    end
    local b = false
    if v ~= 0 then
        b = true
    end
    return b
end]]--


modifier_item_loli_hex = modifier_item_loli_hex or class({})

function modifier_item_loli_hex:IsHidden() return true end
function modifier_item_loli_hex:IsDebuff() return false end
function modifier_item_loli_hex:IsPurgable() return false end
function modifier_item_loli_hex:IsPurgeException() return false end
function modifier_item_loli_hex:RemoveOnDeath() return false end
function modifier_item_loli_hex:DeclareFunctions()
    local func = { 
                     MODIFIER_PROPERTY_HEALTH_BONUS,
                     MODIFIER_PROPERTY_MANA_BONUS,
                     MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                     MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                     MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                     MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                 }
    return func
end
function modifier_item_loli_hex:OnCreated(hTable)
    self.caster   = self:GetCaster()
    self.parent   = self:GetParent()
    self.ability  = self:GetAbility()
    
    self.nHPBonus = self.ability:GetSpecialValueFor("health_bonus")
    self.nMPBonus = self.ability:GetSpecialValueFor("mana_bonus")
    self.nASBonus = self.ability:GetSpecialValueFor("attack_speed_bonus")
    self.nMRBonus = self.ability:GetSpecialValueFor("magic_resist_bonus")
    self.nSABonus = self.ability:GetSpecialValueFor("spell_amp_bonus")
    self.nADBonus = self.ability:GetSpecialValueFor("attack_damage_bonus")
end
function modifier_item_loli_hex:GetModifierHealthBonus(keys)
    return self.nHPBonus
end
function modifier_item_loli_hex:GetModifierManaBonus(keys)
    return self.nMPBonus
end
function modifier_item_loli_hex:GetModifierAttackSpeedBonus_Constant(keys)
    return self.nASBonus
end
function modifier_item_loli_hex:GetModifierMagicalResistanceBonus(keys)
    return self.nMRBonus
end
function modifier_item_loli_hex:GetModifierSpellAmplify_Percentage(keys)
    return self.nSABonus
end
function modifier_item_loli_hex:GetModifierPreAttack_BonusDamage(keys)
    return self.nADBonus
end



modifier_item_loli_hex_debuff = modifier_item_loli_hex_debuff or class({})

function modifier_item_loli_hex_debuff:IsHidden() return false end
function modifier_item_loli_hex_debuff:IsDebuff() return self.bIsHexed end
function modifier_item_loli_hex_debuff:IsPurgable() return false end
function modifier_item_loli_hex_debuff:IsPurgeException() return false end
function modifier_item_loli_hex_debuff:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_item_loli_hex_debuff:RemoveOnDeath() return false end
function modifier_item_loli_hex_debuff:CheckState()
    local hState =  {
                        [MODIFIER_STATE_HEXED]    = true, 
                        [MODIFIER_STATE_SILENCED] = true,
                        [MODIFIER_STATE_MUTED]    = true,
                        [MODIFIER_STATE_DISARMED] = true,
                    }
    return self.bIsHexed and hState
end
function modifier_item_loli_hex_debuff:DeclareFunctions()
    local hFunc =   {
                        MODIFIER_PROPERTY_MODEL_CHANGE, 
                        --MODIFIER_PROPERTY_MODEL_SCALE,
                        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
                        MODIFIER_EVENT_ON_TAKEDAMAGE,
                        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
                        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
                        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
                    }
    return hFunc
end
function modifier_item_loli_hex_debuff:GetModifierModelChange(keys)
    -- Do this or it can crash the game
    if not self.__sModelName then
        self.__sModelName = "models/heroes/kanna/kanna.vmdl" 
    end
    return self.bIsHexed 
           and "models/heroes/kanna/kanna.vmdl" 
           or self.__sModelName
end
--[[
function modifier_item_loli_hex_debuff:GetModifierModelScale(keys)
    return 30
end]]--
function modifier_item_loli_hex_debuff:GetModifierMoveSpeedBonus_Percentage(keys)
    return self.bIsHexed and 10 or 500
end
function modifier_item_loli_hex_debuff:OnTakeDamage(keys)
    if IsServer() then
        if keys.unit == self.parent and keys.attacker ~= self.parent and keys.inflictor ~= self.ability then 
            local Emit = self:RollChance(35) 
                         and EmitSoundOn("loli_hex.hit"..RandomInt(1, 4), self.parent)
                         or nil
        end
    end
end
function modifier_item_loli_hex_debuff:GetModifierIgnoreMovespeedLimit(keys)
    return self.bIsPowerup and 1
end
function modifier_item_loli_hex_debuff:GetModifierMoveSpeed_Limit(keys)
    return self.bIsPowerup and 800
end
function modifier_item_loli_hex_debuff:GetModifierMoveSpeed_Absolute(keys)
    if IsClient()
        and self.bIsPowerup then
        --print("NOM")
        return 800
    end
end
function modifier_item_loli_hex_debuff:GetModifierIncomingDamage_Percentage(keys)
    return self.bIsHexed and self.nDMGAMP
end
function modifier_item_loli_hex_debuff:AddCustomTransmitterData()
    return
    {
        bIsHexed        = self.bIsHexed,
        bIsPowerup      = self.bIsPowerup,
        __sModelName    = self.__sModelName,
    }
end
function modifier_item_loli_hex_debuff:HandleCustomTransmitterData(hTable)
    for sKey, hValue in pairs(hTable) do
        -- NOTE: IF USING TERNARY OPERATOR, if numtobool(hValue) == false,
        -- then it will return hValue instead, so made numtoboolspecial function
        -- self[sKey] = type(hValue) == "number"
        --              and numtobool(hValue) or hValue
        --self[sKey] = numtoboolspecial(hValue)
        -- FIXED TERNARY BY REVERSING INSTEAD
        self[sKey] = type(hValue) ~= "number"
                     and hValue or numtobool(hValue)
        --print(self[sKey])
    end
end
function modifier_item_loli_hex_debuff:RollChance(chance)
    local rand = math.random()
    if rand<chance/100 then
        return true
    end
    return false
end
function modifier_item_loli_hex_debuff:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    self:SetHasCustomTransmitterData(true)
    
    self.nDMGAMP = self.ability:GetSpecialValueFor("damage_amplify")
    
    if IsServer() then
        -- Handle the modifier's data and give it to the client through HandleCustomTransmitterData(hTable)
        local bModelChange  = type(hTable.bModelChange) == "boolean" and tonumber(hTable.bModelChange) or hTable.bModelChange
        self.__bModelChange = bModelChange or 1
        self.__sModelName   = self.parent:GetModelName()
        
        -- Set Flags for Loli Hex or Loli Powerup states
        self.bIsHexed       = self.__bModelChange == 1
        self.bIsPowerup     = self.__bModelChange ~= 1
        
        -- Recalculate stat bonuses for no reason ? PEPE
        self.parent:CalculateStatBonus(true)
        
        -- Resend data to Client(Server Only) or it will not work correctly on refresh
        self:SendBuffRefreshToClients()
        
        self:Effects()
        
        print("HERE: " .. self.__bModelChange)
    end
end
function modifier_item_loli_hex_debuff:Effects()
    if self.bIsHexed then
        -- Create Loli Hex effect
        if not self.nLoliHexEffect then  
            --self.nLoliHexEffect = ParticleManager:CreateParticle("particles/item/loli_hex/kanna_overhead_question_mark.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
            self.nLoliHexEffect = ParticleManager:CreateParticle("particles/item/loli_hex/kanna_overhead_silly.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
        end
    
        -- Destroy Loli Powerup effect if Hexed
        if self.nLoliPowerupEffect then
            ParticleManager:DestroyParticle(self.nLoliPowerupEffect, false)
            ParticleManager:ReleaseParticleIndex(self.nLoliPowerupEffect)
            StopSoundOn("loli_hex.powerup", self.parent)
            self.nLoliPowerupEffect = nil
        end
    end
    
    if self.bIsPowerup then
        -- Create Loli Powerup effect
        if not self.nLoliPowerupEffect then
            self.nLoliPowerupEffect = ParticleManager:CreateParticle("particles/item/loli_hex/loli_powerup_sparks.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
            self.parent:EmitSound("loli_hex.powerup")
        end
        
        -- Destroy Hex effect if Loli Powerup
        if self.nLoliHexEffect then
            ParticleManager:DestroyParticle(self.nLoliHexEffect, false)
            ParticleManager:ReleaseParticleIndex(self.nLoliHexEffect)
            self.nLoliHexEffect = nil
        end
    end
end
function modifier_item_loli_hex_debuff:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_item_loli_hex_debuff:OnDestroy()
    if self.nLoliPowerupEffect then
        ParticleManager:DestroyParticle(self.nLoliPowerupEffect, false)
        ParticleManager:ReleaseParticleIndex(self.nLoliPowerupEffect)
        StopSoundOn("loli_hex.powerup", self.parent)        
    end
    if self.nLoliHexEffect then
        ParticleManager:DestroyParticle(self.nLoliHexEffect, false)
        ParticleManager:ReleaseParticleIndex(self.nLoliHexEffect)
    end
end