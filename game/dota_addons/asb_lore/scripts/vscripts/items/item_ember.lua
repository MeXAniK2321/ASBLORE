LinkLuaModifier( "modifier_ember_buff", "items/item_ember", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ember_burn", "items/item_ember", LUA_MODIFIER_MOTION_NONE )

item_ember = item_ember or class({})

function item_ember:CastFilterResult()
    if IsServer() then
        return ( self:GetCaster():HasModifier("modifier_ember_buff") )
               and UF_FAIL_CUSTOM
               or UF_SUCCESS
    end
end
function item_ember:GetCustomCastError()
	return "#item_ember_cast_error"
end
function item_ember:OnAbilityPhaseStart() 
    local hCaster = self:GetCaster()
    EmitSoundOn("ember.activate", hCaster)    
   
    return true 
end
function item_ember:OnAbilityPhaseInterrupted() 
    StopSoundOn("ember.activate", self:GetCaster())
end
function item_ember:OnSpellStart()
    if not IsServer() then return end
    
    local hCaster = self:GetCaster()
    
    local tGetValues = { 
                           iBonusHealthPercent   = self:GetSpecialValueFor("bonus_hp_percent"),
                           iBonusMoveSpeedConst  = self:GetSpecialValueFor("bonus_ms_constant"),
    
                           fFireCircleDamage     = self:GetSpecialValueFor("circle_damage"),
                           fFireCircleChance     = self:GetSpecialValueFor("circle_chance"),
                           fBurnDamageInterval   = self:GetSpecialValueFor("burn_damage_interval"),
    
                           iABILITY_TARGET_TEAM  = self:GetAbilityTargetTeam(),
                           iABILITY_TARGET_TYPE  = self:GetAbilityTargetType(),
                           iABILITY_TARGET_FLAGS = self:GetAbilityTargetFlags(),
                       }
	
    hCaster:AddNewModifier(hCaster, self, "modifier_ember_buff", tGetValues)
    
    self:SpendCharge()
end


modifier_ember_buff = modifier_ember_buff or class({})

--------------------------------------------------------------------------------

function modifier_ember_buff:IsHidden() return false end
function modifier_ember_buff:RemoveOnDeath() return true end
function modifier_ember_buff:IsDebuff() return false end
function modifier_ember_buff:IsStunDebuff() return false end
function modifier_ember_buff:IsPurgable() return false end
function modifier_ember_buff:GetTexture() 
    return "ember"
end
function modifier_ember_buff:DeclareFunctions()
	local funcs = {
		              MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		              MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
                      MODIFIER_EVENT_ON_ATTACK_FINISHED,
                      MODIFIER_EVENT_ON_TAKEDAMAGE,
                      MODIFIER_PROPERTY_PROJECTILE_NAME,
			      }
	return funcs
end
function modifier_ember_buff:GetModifierExtraHealthPercentage()
    return self.iBonusHP
end
function modifier_ember_buff:GetModifierMoveSpeedBonus_Constant()
    return self.iBonusMS
end
function modifier_ember_buff:GetModifierProjectileName()
    return self.sRangeEffect
end
function modifier_ember_buff:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
	self.ability = self:GetAbility() -- KEK
    
    for Key, nValue in pairs(hTable) do
        self[Key] = nValue
        --print("self." .. Key .. " Value: " .. nValue)
    end
    
    self.sMeleeEffect = "particles/ember/fire_circle.vpcf"
    self.sRangeEffect = "particles/ember/ranged_attack_projectile.vpcf"
    
    self.tRollAngles  = {0, 50, -50}
    
    self.hDamageTable =  {  
                             victim       = nil,
                             attacker     = self.parent,
                             damage       = self.fFireCircleDamage or 0,
                             damage_type  = DAMAGE_TYPE_PHYSICAL,
                             ability      = nil,
                            --damage_flags = 0
                         }
    
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end
function modifier_ember_buff:OnIntervalThink()
    if IsNotNull(self.parent) and self.parent:IsAlive() then
        self.parent:Heal(99999.99, self.ability)
        self.iBonusHP = self.iBonusHealthPercent
        self.iBonusMS = self.iBonusMoveSpeedConst
    end
        
    if not self.AuraEffect then
        self.AuraEffect =  ParticleManager:CreateParticle("particles/ember/fire_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent) 
                           ParticleManager:SetParticleControl(self.AuraEffect, 0, self.parent:GetAbsOrigin())
                           ParticleManager:SetParticleControl(self.AuraEffect, 1, self.parent:GetAbsOrigin())
        self:AddParticle(self.AuraEffect, false, false, -1, false, false)
    end
    
    self.parent:CalculateStatBonus(true)
    
    self:StartIntervalThink(-1)
end
function modifier_ember_buff:OnRefresh(hTable)
    self:OnCreated(hTable)
end
function modifier_ember_buff:OnAttackFinished(keys)
    if IsServer() then
        if self:CheckConditions(keys) then
            local fChance = self.fFireCircleChance or 10
            local bRNG    = RandomFloat(0, 1) <= fChance / 100
            
            if not bRNG then return end
            
            self:CreateRingOrBall(self.parent:IsRangedAttacker(), keys.target)
        end
    end
end
function modifier_ember_buff:OnTakeDamage(keys)	
    if IsServer() then 
        if self:CheckConditions(keys) and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_PROPERTY_FIRE) == 0 then
            keys.target:AddNewModifier(self.parent, self, "modifier_ember_burn", {duration = 2.64, burn_interval = self.fBurnDamageInterval})
        end
    end
end
function modifier_ember_buff:CreateRingOrBall(bIsRanged, hTarget)
    if type(bIsRanged) ~= "boolean" then return end
    
    if bIsRanged then
        if not IsNotNull(hTarget) then return end
        
        self.parent:PerformAttack(hTarget, true, true, true, true, true, false, false)
    else
        self.iRollIndex    = self.iRollIndex or 1
        local iRollAngle   = self.tRollAngles[self.iRollIndex]
        local iEffectMelee = ParticleManager:CreateParticle(self.sMeleeEffect, PATTACH_WORLDORIGIN, nil )
                             ParticleManager:SetParticleControl(iEffectMelee, 0, self.parent:GetAbsOrigin())
                             ParticleManager:SetParticleControl(iEffectMelee, 1, Vector(iRollAngle, 0, 0))
                             --ParticleManager:DestroyParticle(iEffectMelee, false)
                             ParticleManager:ReleaseParticleIndex(iEffectMelee)
                             
        --=============--
        self:DealAOEDmg()
        --=============--
                             
        self.iRollIndex    = (self.iRollIndex % #self.tRollAngles) + 1
    end
end
function modifier_ember_buff:DealAOEDmg()
    local enemies = FindUnitsInRadius( self.parent:GetTeamNumber(),  -- int, your team number
                                   self.parent:GetOrigin(),  -- point, center point
                                   nil,  -- handle, cacheUnit. (not known)
                                   350,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                   self.iABILITY_TARGET_TEAM,  -- int, team filter
                                   self.iABILITY_TARGET_TYPE,  -- int, type filter
                                   self.iABILITY_TARGET_FLAGS,  -- int, flag filter
                                   FIND_ANY_ORDER,  -- int, order filter
                                   false  -- bool, can grow cache
                                )
    for _, hEnemy in pairs(enemies) do
        if IsNotNull(hEnemy) and hEnemy ~= self.parent then
            self.hDamageTable.victim = hEnemy
            ApplyDamage(self.hDamageTable)
        end
    end
    
    self.parent:EmitSound("ember.circle")
end
function modifier_ember_buff:CheckConditions(keys)
    if not keys then
        return false
    end
    
    keys.target = keys.target or keys.unit
    
    return self.parent and keys.attacker and keys.target 
           and self.parent == keys.attacker and self.parent ~= keys.target 
           and keys.target:IsAlive() and keys.target:IsOpposingTeam(self.parent:GetTeamNumber())
end







modifier_ember_burn = modifier_ember_burn or class({})

function modifier_ember_burn:IsHidden() return false end
function modifier_ember_burn:IsDebuff() return true end
function modifier_ember_burn:IsStunDebuff() return false end
function modifier_ember_burn:IsPurgable() return true end
function modifier_ember_burn:GetEffectName()
    return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end
function modifier_ember_burn:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_ember_burn:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
	
    if not IsServer() then return end
    
    self.fElapsedTime = self.fElapsedTime or 0
	
    self.hDamageTable = {
                            victim = self.parent,
                            attacker = self.caster,
                            damage = (self.caster:GetIntellect() * 0.5) + (self.parent:GetStrength() * 0.35),
                            damage_type = DAMAGE_TYPE_PHYSICAL,
                            damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE,
                            ability = nil
                        }
    
    self.fBurnDamageInterval = hTable.burn_interval or 0.44
                        
    self:StartIntervalThink(self.fBurnDamageInterval)
end
function modifier_ember_burn:OnRefresh(hTable)
    if not IsServer() then return end
end
function modifier_ember_burn:OnIntervalThink()
    local fPercentPerSec     = 5 / 100 -- Extra 5% Per Second
    local fPercentCap        = fPercentPerSec * 20 -- 100% Cap
    local fExtraDamage       = 1 + math.min(self.fElapsedTime * fPercentPerSec, fPercentCap)
    self.hDamageTable.damage = (self.caster:GetIntellect() * 0.5 + self.parent:GetStrength() * 0.35) * fExtraDamage
    
    --===========================--
    ApplyDamage(self.hDamageTable)
    --===========================--
    
    self.fElapsedTime = self.fElapsedTime + self.fBurnDamageInterval
end
function modifier_ember_burn:OnDestroy()
end
