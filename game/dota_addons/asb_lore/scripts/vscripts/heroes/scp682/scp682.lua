LinkLuaModifier( "modifier_scp682_bite_debuff", "heroes/scp682/scp682.lua", LUA_MODIFIER_MOTION_NONE )

---------------------------------------------------------------------------------------------------------------
-- SCP682 Bite (Q)
---------------------------------------------------------------------------------------------------------------
scp682_bite = scp682_bite or class({}) 

function scp682_bite:CastFilterResultLocation(vLocation)
    NPAN_INDICATOR:RegisterAbility(self, NPAN_INDICATOR_TYPE_AIM_SKILLSHOT, "particles/test/custom/range_finder_cone_no_panorama/range_finder_cone.vpcf")
    NPAN_INDICATOR:CreateUIIndicator(self:GetCaster(), self, vLocation)
end
function scp682_bite:Spawn()
    if IsServer() then
		self:ToggleAutoCast()
	end
end
function scp682_bite:GetCooldown(level)
    local bHasUltimate = self:GetCaster():HasModifier("modifier_scp682_ultimate")
    return self.BaseClass.GetCooldown( self, level ) * (bHasUltimate and 0.5 or 1)
end
function scp682_bite:GetManaCost(level)
    return self.BaseClass.GetManaCost(self, level)
end
function scp682_bite:GetAOERadius()
    return 600 + self:GetCaster():GetCastRangeBonus()
end
function scp682_bite:GetCastRange(location, target)
    local bHasUltimate = self:GetCaster():HasModifier("modifier_scp682_ultimate")
    return self.BaseClass.GetCastRange(self, location, target) + (bHasUltimate and 150 or 0)
end
function scp682_bite:GetCastPoint()
    local bHasRage = self:GetCaster():HasModifier("modifier_scp682_rage")
    return self.BaseClass.GetCastPoint(self) * (bHasRage and 0 or 1)
end
function scp682_bite:OnSpellStart()
    local hCaster    = self:GetCaster()
    local vOrigin    = hCaster:GetOrigin()
    local vCursorPos = self:GetCursorPosition()
    local vDirection = GetDirection(vCursorPos, vOrigin)
    local vFinalPos  = vOrigin + vDirection * 600
	
	local bToggled   = self:GetAutoCastState()
    
	local hEnemies   = FindUnitsInLine(hCaster:GetTeam(), vOrigin, vFinalPos, hCaster, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	-- Get closest target because Valve's function doesn't provide it like FindUnitsInRadius ???
	table.sort(hEnemies, function(a, b)
		return GetDistance(a, vOrigin) < GetDistance(b, vOrigin)
	end)
	
	for _, hTarget in pairs(hEnemies) do
        local vLocation   = hTarget:GetOrigin()

        local nPointBlank = self:GetSpecialValueFor( "point_blank_range" ) * hCaster:GetModelScale()

        --if self:GetCaster():HasModifier("modifier_scp682_ultimate") then
            --nPointBlank  = nPointBlank  + 150
        --end

        local nMultiplier = self:GetSpecialValueFor( "dmg_bonus_pct" ) / 100
        local nDuration   = self:GetSpecialValueFor( "duration" )
        local fDamage     = self:GetSpecialValueFor( "damage" ) + hCaster:FindTalentValue("special_bonus_birzha_scp683_1")

        if hCaster:HasTalent("special_bonus_birzha_scp683_7") then
            fDamage = fDamage + hCaster:GetAverageTrueAttackDamage(nil)
        end

        local nDistance   = GetDistance(vLocation, vOrigin)
        local bPointBlank = (nDistance <= nPointBlank)
              fDamage     = bPointBlank and fDamage + ( nMultiplier* fDamage ) or fDamage

        ApplyDamage({
            victim = hTarget,
            attacker = hCaster,
            damage = fDamage,
            damage_type = self:GetAbilityDamageType(),
            ability = self,
        })

        if hCaster:HasShard() then
            hTarget:AddNewModifier(hCaster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("shard_stun_duration") * (1 - hTarget:GetStatusResistance()) })
        end

        self:PlayEffects(hCaster, hTarget)
        hTarget:AddNewModifier(hCaster, self, "modifier_scp682_bite_debuff", {duration = nDuration* (1 - hTarget:GetStatusResistance()) })
		
		if bToggled and bPointBlank then
			hCaster:AddNewModifier(hCaster, self, "modifier_scp682_no_attack", { duration = 1.5 })
			hTarget:AddNewModifier(hCaster, self, "modifier_scp682_fetch", { duration = 1.5 })
			bToggled = false
		end
    end

    hCaster:EmitSound("Scp682bite")
end
function scp682_bite:PlayEffects(hCaster, hTarget)
    local vForward = GetDirection(hTarget, hCaster)
    local nBiteFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
					ParticleManager:SetParticleControl(nBiteFX, 0, hCaster:GetOrigin())
					ParticleManager:SetParticleControl(nBiteFX, 1, hTarget:GetOrigin())
					ParticleManager:SetParticleControl(nBiteFX, 5, hTarget:GetOrigin())
    hTarget:EmitSound("Hero_LifeStealer.Consume")
end

-------------------------------------------------------------------------------------------------
modifier_scp682_bite_debuff = modifier_scp682_bite_debuff or class({})

function modifier_scp682_bite_debuff:IsPurgable() return true end
function modifier_scp682_bite_debuff:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
                  }

    return funcs
end
function modifier_scp682_bite_debuff:OnCreated()
    self.nMovespeed = self:GetAbility():GetSpecialValueFor("movespeed")
end
function modifier_scp682_bite_debuff:GetModifierMoveSpeedBonus_Percentage()
    return self.nMovespeed
end


-------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_scp682_fetch", "heroes/scp682/scp682.lua", LUA_MODIFIER_MOTION_NONE)

modifier_scp682_fetch = modifier_scp682_fetch or class({})

function modifier_scp682_fetch:IsHidden() return false end
function modifier_scp682_fetch:IsDebuff() return false end
function modifier_scp682_fetch:IsPurgable() return false end
function modifier_scp682_fetch:IsPurgeException() return false end
function modifier_scp682_fetch:RemoveOnDeath() return true end
function modifier_scp682_fetch:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_scp682_fetch:GetPriority() return MODIFIER_PRIORITY_ULTRA end
function modifier_scp682_fetch:CheckState()
    local state = 
    {
        [MODIFIER_STATE_STUNNED] = true,
        --[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true, 
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
    return state
end
function modifier_scp682_fetch:OnCreated(hTable)
    self.parent  = self:GetParent()
	self.caster  = self:GetCaster()
	self.ability = self:GetAbility()
	
	--self.vAngles = self.parent:GetAngles()
	self.fLength = 107.5
	self.fHeight = 45.0
	
	-- Units that are not upright basically
	self.tExceptions = {
	                       npc_dota_hero_skywrath_mage = true,
						   npc_dota_hero_slardar       = true
					   }
					   
	self.bUpright    = not self.tExceptions[self.parent:GetUnitName()]

	
	if IsServer() then
	    self:StartIntervalThink(0.01)
	end
end
function modifier_scp682_fetch:OnIntervalThink()
    if not IsNotNull(self.caster) or not self.caster:IsAlive() then
		self:StartIntervalThink(-1)
		return self:Destroy()
	end
	
	local fScale    = self.caster:GetModelScale()
	local vOrigin   = self.caster:GetOrigin()
	      vOrigin.z = vOrigin.z + self.fHeight * fScale
	local vForward  = self.caster:GetForwardVector()
	local vRight    = self.caster:GetRightVector()
	local vAngles   = self.caster:GetAnglesAsVector()
	      vAngles.x = self.bUpright
		              and vAngles.x - 90 or 0
		  vAngles.y = vAngles.y - 90
	self.parent:SetOrigin( (vOrigin + vForward * self.fLength * fScale ) + vRight * self.fLength * ( self.bUpright and 1 or 0 ) )
	self.parent:SetAngles(vAngles.x, vAngles.y, vAngles.z)
end
function modifier_scp682_fetch:OnRefresh(hTable)
    if IsServer() then
	
	end
end
function modifier_scp682_fetch:OnDestroy()
    if IsServer() then
	    FindClearSpaceForUnit(self.parent, self.parent:GetOrigin(), true)
		self.parent:SetAngles(0, 0, 0)
	end
end

-------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_scp682_no_attack", "heroes/scp682/scp682.lua", LUA_MODIFIER_MOTION_NONE)

modifier_scp682_no_attack = modifier_scp682_no_attack or class({})

function modifier_scp682_no_attack:IsHidden() return false end
function modifier_scp682_no_attack:IsDebuff() return true end
function modifier_scp682_no_attack:IsPurgable() return false end
function modifier_scp682_no_attack:IsPurgeException() return false end
function modifier_scp682_no_attack:RemoveOnDeath() return true end
function modifier_scp682_no_attack:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_scp682_no_attack:CheckState()
    local state = 
    {
		[MODIFIER_STATE_DISARMED] = true
    }
    return state
end

---------------------------------------------------------------------------------------------------------------
-- SCP682 Rage (W)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_scp682_rage", "heroes/scp682/scp682.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_scp682_rage_magic_immune", "heroes/scp682/scp682.lua", LUA_MODIFIER_MOTION_NONE )

scp682_rage = scp682_rage or class({}) 

function scp682_rage:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end
function scp682_rage:GetManaCost(level)
    return self.BaseClass.GetManaCost(self, level)
end
function scp682_rage:GetCastRange(location, target)
    return self.BaseClass.GetCastRange(self, location, target)
end
function scp682_rage:GetBehavior()
	return self:GetCaster():HasModifier("modifier_scp682_rage") 
		   and DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_UNRESTRICTED
		   or DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING
end
function scp682_rage:OnSpellStart()
    local hCaster = self:GetCaster()
    if hCaster:HasModifier("modifier_scp682_rage") then
		return hCaster:RemoveModifierByName("modifier_scp682_rage")
    end
    local nDuration = self:GetSpecialValueFor( "duration" ) + hCaster:FindTalentValue("special_bonus_birzha_scp683_2")
    self.hTarget    = self:GetCursorTarget()
    --==========================================================--
	if self.hTarget:TriggerSpellAbsorb(self) then return nil end
    --==========================================================--
    hCaster:AddNewModifier(hCaster, self, "modifier_scp682_rage", {duration = nDuration})
    hCaster:EmitSound("Scp682scream")
	if hCaster:HasScepter() then
		hCaster:EmitSound("Scp682dmf")
	end
    self:EndCooldown()
end

-------------------------------------------------------------------------------------------------
modifier_scp682_rage = modifier_scp682_rage or class({}) 

function modifier_scp682_rage:IsHidden() return false end
function modifier_scp682_rage:IsPurgable() return false end
function modifier_scp682_rage:CheckState()
    local state = 
    {
        [MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS] = true,
        [MODIFIER_STATE_FAKE_ALLY] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_MUTED] = true
    }
    return state
end
function modifier_scp682_rage:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_BONUS_DAY_VISION,
        MODIFIER_PROPERTY_BONUS_NIGHT_VISION
    }
    return funcs
end
function modifier_scp682_rage:OnCreated()
    if not IsServer() then return end
	
	self.parent  = self:GetParent()
	self.caster  = self:GetCaster()
	self.ability = self:GetAbility()
	
	self.nBonusAttkSpeed    = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.nMoveSpeedAbsolute = self.ability:GetSpecialValueFor("movespeed")
    
	self.hTarget = self:GetAbility().hTarget
    self.caster:SetRenderColor(255, 0, 0)
    ExecuteOrderFromTable({
        UnitIndex = self.parent:entindex(),
        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
        TargetIndex = self.hTarget:entindex()
    })
    
	self.parent:MoveToTargetToAttack(self.hTarget)
    
	self:StartIntervalThink(FrameTime())
    if self.caster:HasTalent("special_bonus_birzha_scp683_5") then
        self.caster:AddNewModifier(self.caster, self.ability, "modifier_scp682_rage_magic_immune", {duration = self:GetDuration()})
    end
end

function modifier_scp682_rage:OnDestroy()
   if not IsServer() then return end
    self.parent:Interrupt()
    self.parent:SetForceAttackTarget(nil)
    self.parent:SetForceAttackTargetAlly(nil)
    self.parent:Stop()
    self.parent:SetRenderColor(255, 255, 255)
    self.ability:UseResources(false, false, false, true)
    self.parent:RemoveModifierByName("modifier_scp682_rage_magic_immune")
	self.parent:StopSound("Scp682dmf")
end
function modifier_scp682_rage:OnIntervalThink()
    AddFOWViewer(self.caster:GetTeamNumber(), self.hTarget:GetAbsOrigin(), 100, 0.1, false)
    if self.hTarget == nil or not self.hTarget:IsAlive() or self.hTarget:HasModifier("modifier_fountain_passive_invul") or ( self.hTarget:IsInvisible() and not self.parent:CanEntityBeSeenByMyTeam(self.hTarget) ) then
        self:Destroy()
    else
        self.parent:MoveToTargetToAttack(self.hTarget)
    end
end
function modifier_scp682_rage:GetBonusDayVision( params )
    return -9999999
end
function modifier_scp682_rage:GetBonusNightVision( params )
    return -9999999
end
function modifier_scp682_rage:GetModifierAttackSpeedBonus_Constant( params )
    return self.nBonusAttkSpeed
end
function modifier_scp682_rage:GetModifierMoveSpeed_Absolute( params )
    return self.nMoveSpeedAbsolute
end

-------------------------------------------------------------------------------------------------
modifier_scp682_rage_magic_immune = modifier_scp682_rage_magic_immune or class({})

function modifier_scp682_rage_magic_immune:IsPurgable() return false end
function modifier_scp682_rage_magic_immune:IsHidden() return true end
function modifier_scp682_rage_magic_immune:CheckState()
    return {
               [MODIFIER_STATE_MAGIC_IMMUNE] = true
           }
end
function modifier_scp682_rage_magic_immune:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end
function modifier_scp682_rage_magic_immune:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_scp682_rage_magic_immune:GetStatusEffectName()
    return "particles/status_fx/status_effect_avatar.vpcf"
end
function modifier_scp682_rage_magic_immune:StatusEffectPriority()
    return 99999
end

---------------------------------------------------------------------------------------------------------------
-- SCP682 Plot (E)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_scp682_plot", "heroes/scp682/scp682.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_scp682_plot_debuff", "heroes/scp682/scp682.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_scp682_plot_thinker", "heroes/scp682/scp682.lua", LUA_MODIFIER_MOTION_NONE)

scp682_plot = scp682_plot or class({}) 

function scp682_plot:GetIntrinsicModifierName()
    return "modifier_scp682_plot"
end

-------------------------------------------------------------------------------------------------
modifier_scp682_plot = modifier_scp682_plot or class({}) 

function modifier_scp682_plot:IsHidden() return true end
function modifier_scp682_plot:IsPurgable() return false end
function modifier_scp682_plot:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end
function modifier_scp682_plot:OnCreated(hTable)
    if not IsServer() then return end

    self.parent  = self.parent or self:GetParent()
	self.caster  = self.caster or self:GetCaster()
	self.ability = self.ability or self:GetAbility()
	
    self.nDuration = self.ability:GetSpecialValueFor('duration') + self.caster:FindTalentValue("special_bonus_birzha_scp683_3")
    self.fDamage   = self.ability:GetSpecialValueFor('damage')   
    self.nMaxStack = self.ability:GetSpecialValueFor('max_stack')
end
function modifier_scp682_plot:OnAttackLanded( params )
    if not IsServer() then return end
    
	-- Refresh the ability values on level ups and talents
	self:OnCreated()
	
	local hAttacker = params.attacker
	local hTarget   = params.target
	
	if self.parent ~= hAttacker or self.parent == hTarget
		or hTarget:IsBuilding() or hTarget:IsWard()
		or hAttacker:IsIllusion() or hAttacker:PassivesDisabled()
		or hTarget:IsBoss() then
		return
    end

    local hModifier = hTarget:FindModifierByNameAndCaster("modifier_scp682_plot_debuff", self.ability:GetCaster())
	hTarget:AddNewModifier(hAttacker, self.ability, "modifier_scp682_plot_debuff", {duration = self.nDuration * (1 - hTarget:GetStatusResistance()) })
	if hModifier and hModifier:GetStackCount() < self.nMaxStack then
        hModifier:IncrementStackCount()
    end
end

-------------------------------------------------------------------------------------------------
modifier_scp682_plot_debuff = modifier_scp682_plot_debuff or class({})

function modifier_scp682_plot_debuff:IsPurgable()
    return not self:GetCaster():HasTalent("special_bonus_birzha_scp683_8")
end
function modifier_scp682_plot_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_DEATH
    }
end
function modifier_scp682_plot_debuff:OnCreated(hTable)
    if not IsServer() then return end
	
	self.parent  = self:GetParent()
	self.caster  = self:GetCaster()
	self.ability = self:GetAbility()
    
	self:SetStackCount(1)
    self:StartIntervalThink(0.5)          
end
function modifier_scp682_plot_debuff:OnIntervalThink()
    local nBaseDmg = self.ability:GetSpecialValueFor("damage") * self:GetStackCount()
    local nDamage  = (self.parent:GetMaxHealth() / 100 * nBaseDmg) * 0.5
    ApplyDamage({victim = self.parent, attacker = self.caster, damage = nDamage, ability = self.ability, damage_type = DAMAGE_TYPE_PURE})
    local nFX = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
                ParticleManager:ReleaseParticleIndex(nFX)
end
function modifier_scp682_plot_debuff:OnDeath(params)
    if not IsServer() or params.unit ~= self.parent then return end
    if self.caster:HasScepter() then
        CreateModifierThinker(self.caster, self.ability, "modifier_scp682_plot_thinker", { duration = self.ability:GetSpecialValueFor("scepter_duration") }, self.parent:GetOrigin(), self.caster:GetTeamNumber(), false)
    end
end

-------------------------------------------------------------------------------------------------
modifier_scp682_plot_thinker = modifier_scp682_plot_thinker or class({})

function modifier_scp682_plot_thinker:IsPurgable() return false end
function modifier_scp682_plot_thinker:OnCreated(hTable)
    
	self.parent  = self:GetParent()
	self.caster  = self:GetCaster()
	self.ability = self:GetAbility()
    
	local nRadius = self.ability:GetSpecialValueFor( "scepter_radius" )
    if not IsServer() then return end
    local nFX = ParticleManager:CreateParticle( "particles/scp_plot_thinker.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
				ParticleManager:SetParticleControl( nFX, 0, self.parent:GetOrigin() )
				ParticleManager:SetParticleControl( nFX, 1, Vector( nRadius, 1, 1 ) )
    self:AddParticle(nFX, false, false, -1, false, false )
    self.parent:EmitSound("Hero_Alchemist.AcidSpray")
    self:StartIntervalThink(FrameTime())
end
function modifier_scp682_plot_thinker:OnIntervalThink()
    if not self.caster:IsAlive() then return end
    local nRadius = self.ability:GetSpecialValueFor( "scepter_radius" )
    local nDistance = GetDistance(self.caster, self.parent)
    if nDistance <= nRadius then
        local fHeal = self.caster:GetMaxHealth() / 100 * self.ability:GetSpecialValueFor("damage")
        fHeal = fHeal * FrameTime()
        self.caster:Heal(fHeal, self.ability)
    end
end

---------------------------------------------------------------------------------------------------------------
-- SCP682 Grow (D)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_scp682_grow", "heroes/scp682/scp682.lua", LUA_MODIFIER_MOTION_NONE)

scp682_grow = scp682_grow or class({}) 

function scp682_grow:Spawn()
    if IsServer() and self:GetLevel() <= 0 then
	    self:SetLevel(1)
	end
end
function scp682_grow:GetIntrinsicModifierName()
    return "modifier_scp682_grow"
end

-------------------------------------------------------------------------------------------------
modifier_scp682_grow = modifier_scp682_grow or class({})

function modifier_scp682_grow:IsHidden() return false end
function modifier_scp682_grow:IsDebuff() return false end
function modifier_scp682_grow:IsPurgable() return false end
function modifier_scp682_grow:IsPurgeException() return false end
function modifier_scp682_grow:RemoveOnDeath() return false end
function modifier_scp682_grow:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_scp682_grow:GetPriority() return MODIFIER_PRIORITY_ULTRA end
function modifier_scp682_grow:CheckState()
    local state = {
                    --[MODIFIER_STATE_FLYING] = self.bIsFlying
					[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = self.bIsFlying,
					[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = self.bIsFlying,
					[MODIFIER_STATE_ALLOW_PATHING_THROUGH_CLIFFS] =	self.bIsFlying			
                  }
    return state
end
function modifier_scp682_grow:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_HERO_KILLED
    }
    return funcs
end
function modifier_scp682_grow:AddCustomTransmitterData()
    return
    {
        nAttackRange = self.fLength * self.parent:GetModelScale()
    }
end
function modifier_scp682_grow:HandleCustomTransmitterData(hTable)
    for sKey, hValue in pairs(hTable) do
        self[sKey] = hValue
    end
end
function modifier_scp682_grow:OnCreated(hTable)
	self.parent  = self.parent or self:GetParent()
	self.caster  = self.caster or self:GetCaster()
	self.ability = self.ability or self:GetAbility()
	
	self.fLength     = 107.5
	self.fBaseScale  = 2.0 -- Base scale for client attack range
	self.fScaleLimit = 2.75
	self.nScale      = 5
	
	self.vPreviousPos    = self.vPreviousPos or nil
	self.vNewPosFix      = vNewPosFix or nil
	self.nDistanceMoved  = self.nDistanceMoved or 0
	
	self.bIsFlying       = self.bIsFlying or false
	
    self:SetHasCustomTransmitterData(true)
	
	if IsServer() then
		self.nMaxStacks = self.nMaxStacks or self.ability:GetSpecialValueFor("max_stacks")
		self.nCurStacks = self.parent:GetKills() or 0
		
		self:SetStackCount( math.min(self.nCurStacks, self.nMaxStacks) )
	end
end
function modifier_scp682_grow:GetModifierModelScale(keys)
	self:SendBuffRefreshToClients()
	self.vNewPosFix   = self.parent:GetOrigin()
	self.vPreviousPos = self.vPreviousPos and self.vPreviousPos or self.parent:GetOrigin()
	-- Cringe fix for preventing stuck from hull size.
	if self.vPreviousPos and self.vNewPosFix then
	    if GetDistance(self.vNewPosFix, self.vPreviousPos) < 1 then
		    self.nDistanceMoved = math.max(-10, self.nDistanceMoved - 3)
		else 
		    self.nDistanceMoved = math.min(1, self.nDistanceMoved + 1)
		end
		if self.nDistanceMoved < -5 then
		    self.bIsFlying = true
		else
		    self.bIsFlying = false
		end
		self.vPreviousPos = self.parent:GetOrigin()
		--print(self.nDistanceMoved)
	end
    self.parent:SetHullRadius(24 + self:GetStackCount())
	local fModelScale = self.parent:GetModelScale()
	--print(fModelScale)
	if fModelScale > self.fScaleLimit then
		return (self.fScaleLimit - fModelScale) * 100
	else
	    local nStackValue   = self:GetStackCount() * self.nScale
		local nValueClamped = math.max(0, math.min( (self.fScaleLimit - fModelScale) * 100, nStackValue) )
	    return nValueClamped
	end
end
function modifier_scp682_grow:GetModifierAttackRangeBonus(keys)
    return IsServer()
	       and self.fLength * self.parent:GetModelScale()
		   or ( self.nAttackRange or 0 )
end
function modifier_scp682_grow:OnHeroKilled(keys)
	if not IsServer() or not keys.attacker then
		return
	end
	if keys.attacker == self.parent then
		self:OnCreated()
	end
end
function modifier_scp682_grow:GetEffectName()
    return "particles/heroes/scp682/scp682_toxic.vpcf"
end

---------------------------------------------------------------------------------------------------------------
-- SCP682 Ultimate (R)
---------------------------------------------------------------------------------------------------------------
LinkLuaModifier( "modifier_scp682_ultimate", "heroes/scp682/scp682.lua", LUA_MODIFIER_MOTION_NONE )

scp682_ultimate = scp682_ultimate or class({}) 

function scp682_ultimate:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level ) + self:GetCaster():FindTalentValue("special_bonus_birzha_scp683_4")
end
function scp682_ultimate:GetManaCost(level)
    return self.BaseClass.GetManaCost(self, level)
end
function scp682_ultimate:OnSpellStart()
    local hCaster   = self:GetCaster()
    local nDuration = self:GetSpecialValueFor( "duration" )
    
	hCaster:AddNewModifier( hCaster, self, "modifier_scp682_ultimate", {duration = nDuration})
    hCaster:EmitSound("Scp682ultimate")
    hCaster:Purge(false, true, false, true, true)
end

-------------------------------------------------------------------------------------------------------
modifier_scp682_ultimate = modifier_scp682_ultimate or class({})

function modifier_scp682_ultimate:IsPurgable() return false end
function modifier_scp682_ultimate:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_MIN_HEALTH,
        MODIFIER_PROPERTY_MODEL_SCALE,
        MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end
function modifier_scp682_ultimate:OnCreated(hTable)
	self.parent  = self:GetParent()
	self.caster  = self:GetCaster()
	self.ability = self:GetAbility()
end
function modifier_scp682_ultimate:GetModifierModelScale( params )
    return 45
end
function modifier_scp682_ultimate:GetMinHealth()
    return 1
end
function modifier_scp682_ultimate:GetModifierStatusResistanceStacking()
    return self.caster:FindTalentValue("special_bonus_birzha_scp683_6")
end
function modifier_scp682_ultimate:OnTakeDamage(params)
    if not IsServer() then return end
    if self.parent ~= params.attacker or self.parent == params.unit
		or params.unit:IsBuilding() or params.unit:IsWard() then 
		return 
	end
    if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then 
        local nHeal = self.ability:GetSpecialValueFor("lifesteal") / 100 * params.damage
        self.parent:Heal(nHeal, self.ability)
        local nFX = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_bloodbath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
					ParticleManager:ReleaseParticleIndex(nFX)
    end
end