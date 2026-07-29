
local nPlay      = 1
local nStop      = 2
local nStopAll   = 3
local nPlayWorld = 4

item_divine_rapier2 = class({})

LinkLuaModifier("modifier_item_divine_rapier_suction", "items/item_divine_rapier2", LUA_MODIFIER_MOTION_NONE)

function item_divine_rapier2:GetIntrinsicModifierName()
	return "modifier_item_divine_set"
end
function item_divine_rapier2:CastFilterResultTarget(hTarget)
	return UF_SUCCESS
end
function item_divine_rapier2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	
	hTarget:AddNewModifier(hCaster, self, "modifier_item_divine_rapier_suction", { duration = 11.0 } )
end
function item_divine_rapier2:OnProjectileHit(hTarget, vLocation)
	return true
end
function item_divine_rapier2:OnProjectileThink(vLocation)
	--[[for iTeamNumber = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX do
		AddFOWViewer(iTeamNumber, vLocation, 55, 0.1, false)
	end]]--
end


---------------------------------------------------------------------------------------------------------------------

modifier_item_divine_rapier_suction = class({})

function modifier_item_divine_rapier_suction:IsHidden() return false end
function modifier_item_divine_rapier_suction:IsDebuff() return true end
function modifier_item_divine_rapier_suction:IsPurgable() return false end
function modifier_item_divine_rapier_suction:IsPurgeException() return false end
function modifier_item_divine_rapier_suction:RemoveOnDeath() return false end
function modifier_item_divine_rapier_suction:CheckState()
	local hState =  { 
						[MODIFIER_STATE_STUNNED] = true, 
					}
	return self.bStunned and hState or nil
end

function modifier_item_divine_rapier_suction:OnCreated(hTable)
	self.caster  = self:GetCaster()
	self.parent  = self:GetParent()
	self.ability = self:GetAbility()
		
	if IsServer() then
	    self.nPullSpeed    = self.ability:GetSpecialValueFor("pull_speed")
		self.vInitialPos   = self.caster:GetOrigin()
		self.nTimeElapsed  = self.nTimeElapsed or 0
		self.nTickRate     = 0.01
		self.fRapierLength = 200.0
		self.fImpaleLength = self.fRapierLength * 0.5
		self.bStunned      = self.bStunned or false
		
		self.bPhaseTwo    = self.bPhaseTwo or false
		
		self.nPulses      = self.nPulses or self.ability:GetSpecialValueFor("shockwave_pulses")
		
        self.hSource  = CreateModifierThinker(self.caster, self.ability, "modifier_divine_rapier2_vision_dummy", {}, self.caster:GetOrigin(), self.caster:GetTeamNumber(), false)
		self.hTarget  = CreateModifierThinker(self.caster, self.ability, "modifier_divine_rapier2_vision_dummy", {}, self.parent:GetOrigin(), self.caster:GetTeamNumber(), false)
		--self.hSource:AddNoDraw()
		--self.hTarget:AddNoDraw()
		
		local info = {	Target = self.hTarget,
						Source = self.hSource,
						Ability = self.ability,    

						EffectName = "particles/item/divine_rapier2/divine_rapier2_main.vpcf",
						iMoveSpeed = 1,
						bDodgeable = false,                           			-- Optional

						--iSourceAttachmet = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,  -- Optional
						vSourceLoc = self.vInitialPos,                -- Optional (HOW)
						--bIsAttack = false,                                -- Optional
						bReplaceExisting = true,                         -- Optional
						--flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended

						bDrawsOnMinimap = false,                          -- Optional
						bVisibleToEnemies = true,                         -- Optional
						bProvidesVision = true,                           -- Optional
						iVisionRadius = 1000,                              -- Optional
						iVisionTeamNumber = self.caster:GetTeamNumber()        -- Optional
					}

		self.iProjectile = ProjectileManager:CreateTrackingProjectile(info)
		
		if not self.iProjectile then self:Destroy() return end
		
		self:SFX( 1, nPlay )
		self:StartIntervalThink(self.nTickRate)
	end
end
function modifier_item_divine_rapier_suction:OnIntervalThink()
    if not self.hTarget or self.hTarget:IsNull() then
	    self:StartIntervalThink(-1)
		return self:Destroy()
	end
	
	if self.parent:IsMagicImmune() or self.parent:IsInvulnerable() then
		if self.bStunned then
			self.bStunned = false
			FindClearSpaceForUnit(self.parent, self.parent:GetOrigin(), true)
		end
	end
	
	if self.bFinalPhase then
	    self:DivineShockwaves()
    elseif self.bSecondPhase then
		self:DivineImpale()
    else
	    self:Pull()
	end
end
function modifier_item_divine_rapier_suction:Pull()
    local vOrigin    = self.parent:GetOrigin()
    local vDirection = GetDirection(self.vInitialPos, vOrigin)
	local nPullSpeed = self.nPullSpeed * self.nTickRate
	local vPullDir   = vOrigin + vDirection * nPullSpeed * self.nTimeElapsed
	local nDistance  = GetDistance(self.vInitialPos, vOrigin)
	
	self.hTarget:SetOrigin(vOrigin + Vector(0, 0, 150) - vDirection * 400)
	
	if nDistance <= self.fRapierLength then
	    --
	end
	
	if nDistance <= self.fImpaleLength then
	    self.bSecondPhase       = true
		self.vSecondPhaseOrigin = vOrigin
		self.vSecondPhaseDir    = vDirection
		self.nSecondPhaseDist   = self.ability:GetSpecialValueFor("distance_pushed")
		self.vFinalDestination  = self.vInitialPos - vDirection * self.nSecondPhaseDist
		self.nStartGroundHeight = GetGroundHeight(self.vSecondPhaseOrigin, nil)
		self.nEndGroundHeight   = GetGroundHeight(self.vFinalDestination, nil)
		self.nMaximumHeight     = self.ability:GetSpecialValueFor("maximum_height")
		self.nTimeElapsed       = 0
		self.hTarget:SetOrigin(self.vSecondPhaseOrigin)
		self.bStunned           = true
		self:SetDuration(7.0, true)
		self:SFX( 1, nStop)
		self:SFX( 2, nPlayWorld, vOrigin )
		return
	end
	
	self.parent:SetOrigin(vPullDir)
	
	self.nTimeElapsed = self.nTimeElapsed + self.nTickRate
end
function modifier_item_divine_rapier_suction:DivineImpale()
	local fDummySpeed  = self.ability:GetSpecialValueFor("push_speed")
	local nTravelTime  = self.nSecondPhaseDist / fDummySpeed
	local nSineElapsed = math.min( (self.nTimeElapsed / nTravelTime), 1 )
	
	local nGroundElapsed   = self.nStartGroundHeight + (self.nEndGroundHeight - self.nStartGroundHeight) * nSineElapsed
	local nArcHeight       = self.nMaximumHeight * math.sin(math.pi * nSineElapsed)
    
	--local vOriginDummy = self.hTarget:GetOrigin()
	--local vDirection   = GetDirection(self.vFinalDestination, vOriginDummy)
	--local fTolerance   = 20.0
	local vThrustLocation   = self.vSecondPhaseOrigin + (self.vFinalDestination - self.vSecondPhaseOrigin) * nSineElapsed
		  vThrustLocation.z = nGroundElapsed + nArcHeight
	
	if nSineElapsed < 1 then
		self.hTarget:SetOrigin(vThrustLocation)
		if self.bStunned then
			self.parent:SetOrigin(vThrustLocation - Vector(0, 0, 100))
		end
	else
	    self.bFinalPhase = true
		self.hTarget:SetOrigin(self.vFinalDestination - Vector(0,0,100))
		--self.parent:SetOrigin(vThrustLocation)
		self.nTimeElapsed    = 0
		--self.nPulses         = 3
		self.nThrustDistance = 25
		self.fPulseInterval  = 3 / math.max(self.nPulses, 3)
		self:StartIntervalThink(-1)
		self:StartIntervalThink(self.fPulseInterval)
		self:DivineShockwaves(true)
		--self:SFX( 2, nStop)
		print("NANI")
		return
	end
	

	self.nTimeElapsed = self.nTimeElapsed + self.nTickRate
end
function modifier_item_divine_rapier_suction:DivineShockwaves(bDoNotSubtract)
	if self.nPulses <= 0 then
	    --return self:StartIntervalThink(-1)
		return
	end
	
	if self.bStunned then
		self.bStunned = false
		FindClearSpaceForUnit(self.parent, self.parent:GetOrigin(), true)
	end
	
	local vOrigin   = self.hTarget:GetOrigin()
	      vOrigin.z = vOrigin.z - self.nThrustDistance
	local vGround   = GetGroundPosition(vOrigin, nil)

	local nGroundFX = ParticleManager:CreateParticle("particles/item/divine_rapier2/divine_rapier2_kek_kez_wave_main.vpcf", PATTACH_WORLDORIGIN, nil)
					  ParticleManager:SetParticleControl(nGroundFX, 0, vGround)
					  
	self:DoAoeDamage(vOrigin)
	self:SFX( 3, nPlayWorld, vOrigin)
					  
	if bDoNotSubtract then 
		self.nGroundFX = self.nGroundFX or ParticleManager:CreateParticle("particles/item/divine_rapier2/divine_rapier2_kek.vpcf", PATTACH_WORLDORIGIN, nil)
						 ParticleManager:SetParticleControl(self.nGroundFX, 3, vGround)
		return 
	end
	self.hTarget:SetOrigin(vOrigin)
	
	self.nPulses = self.nPulses - 1
end
function modifier_item_divine_rapier_suction:DoAoeDamage(vOrigin)
    local hUnitsHit       = {}
	local fCurrentRadius  = 0
	local fRingMaxRadius  = 1250.0
	local fTimerInterval  = 0.05
	local fRingWidth      = 125.0
	local fRadiusPerTick  = fRingMaxRadius * fTimerInterval
	
	Timers:CreateTimer(0, function()
		local hUnits = FindUnitsInRing(self.caster:GetTeamNumber(), vOrigin, nil, fCurrentRadius, self.ability:GetAbilityTargetTeam(), self.ability:GetAbilityTargetType(), self.ability:GetAbilityTargetFlags(), FIND_CLOSEST, false, fRingWidth)
		for _, hUnit in pairs(hUnits) do
			if IsNotNull(hUnit) and IsNotNull(self.caster) and not hUnitsHit[hUnit:entindex()] then
				hUnit:AddNewModifier(self.caster, self.ability, "modifier_stunned", { duration = 0.35 } )
				ApplyDamage({
					victim = hUnit,
					attacker = self.caster,
					damage = self.ability:GetSpecialValueFor("shockwave_damage"),
					damage_type = self.ability:GetAbilityDamageType(),
					ability = self.ability,
				})
				hUnitsHit[hUnit:entindex()] = true
				--print("MEME")
			end
		end
		if fCurrentRadius < fRingMaxRadius then
			fCurrentRadius = fCurrentRadius + fRadiusPerTick
			return fTimerInterval
		else
			hUnitsHit = nil
			return nil
		end
	end)
end
function modifier_item_divine_rapier_suction:OnRefresh()
	if IsServer() then
		self.nPulses = self.nPulses + self.ability:GetSpecialValueFor("shockwave_pulses")
		if self.bFinalPhase then
		    local fTickAmount = 3 / math.max(self.nPulses, 3)
			self:StartIntervalThink(-1)
			self:StartIntervalThink(fTickAmount)
			self:OnIntervalThink()
			self:SetDuration(7.0, true)
		end
	end
end
function modifier_item_divine_rapier_suction:OnDestroy()
	if IsServer() then
		self:DestroyProjectile()
	end
end
local tSFX = {
	{ "divine_rapier2_suction1",
	"divine_rapier2_suction2",
	"divine_rapier2_suction3" },
	
	{ "divine_rapier2_impale1",
	"divine_rapier2_impale2",
	"loli_hex.fyou1" },
	
	{ "divine_rapier2_lightning1",
	"divine_rapier2_lightning2",
	"divine_rapier2_lightning3",
    "ember.circle", 
	"AE86.Theme.Arcana.Thunder" }
}
function modifier_item_divine_rapier_suction:SFX(nBatch, nCommand, vLocation)
	if not nCommand or nCommand == nStopAll then
		for _, tChosenSFX in ipairs(tSFX) do
		    for _, sSound in ipairs(tChosenSFX) do
				self.hTarget:StopSound(sSound)
			end
		end
		return
	end
	
	if not nBatch then return end

	local tChosenSFX = tSFX[nBatch]
	
	if not tChosenSFX then return end
	
	if nCommand == nPlay then
		for _, sSound in ipairs(tChosenSFX) do
			self.hTarget:EmitSound(sSound)
		end
	elseif nCommand == nPlayWorld then
		if not vLocation then return end
		for _, sSound in ipairs(tChosenSFX) do
			EmitSoundOnLocationWithCaster(vLocation, sSound, self.hTarget)
		end
		
	elseif nCommand == nStop then
		for _, sSound in ipairs(tChosenSFX) do
			self.hTarget:StopSound(sSound)
		end
	end
end
function modifier_item_divine_rapier_suction:DestroyProjectile()
	if self.iProjectile and ProjectileManager:IsValidProjectile(self.iProjectile) then
		ProjectileManager:DestroyTrackingProjectile(self.iProjectile)
	end	
	if self.hTarget and not self.hTarget:IsNull() then
		self:SFX(0, nStopAll)
		UTIL_Remove(self.hTarget)
	end
	if self.hSource and not self.hSource:IsNull() then
		UTIL_Remove(self.hSource)
	end
	if self.nGroundFX then
		ParticleManager:DestroyParticle(self.nGroundFX, false)
	end
	if self.bStunned then
		FindClearSpaceForUnit(self.parent, self.parent:GetOrigin(), true)
	end
end

-----------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_item_divine_set", "items/item_divine_rapier2", LUA_MODIFIER_MOTION_NONE)

modifier_item_divine_set = class({})

function modifier_item_divine_set:IsHidden() return true end
function modifier_item_divine_set:IsDebuff() return false end
function modifier_item_divine_set:IsStunDebuff() return false end
function modifier_item_divine_set:IsPurgable() return false end
function modifier_item_divine_set:DeclareFunctions()
	local tFuncs = {
						MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,		
				   }

	return tFuncs
end
function modifier_item_divine_set:OnCreated()
	self.parent  = self:GetParent()
	self.caster  = self:GetCaster()
	self.abiltiy = self:GetAbility()
	self.sDivineRapier = "item_divine_rapier2"
end
function modifier_item_divine_set:GetModifierProcAttack_BonusDamage_Pure()
	if self.parent:HasItemInInventory(self.sDivineRapier) then
		return 200
	end
end
    

-----------------------------------------------------------------------------------------------------
LinkLuaModifier("modifier_divine_rapier2_vision_dummy", "items/item_divine_rapier2", LUA_MODIFIER_MOTION_NONE)

modifier_divine_rapier2_vision_dummy = class({})

function modifier_divine_rapier2_vision_dummy:IsHidden() return true end
function modifier_divine_rapier2_vision_dummy:IsDebuff() return false end
function modifier_divine_rapier2_vision_dummy:IsStunDebuff() return false end
function modifier_divine_rapier2_vision_dummy:IsPurgable() return false end
function modifier_divine_rapier2_vision_dummy:CheckState()
    local hState = {
                      [MODIFIER_STATE_STUNNED] = true,
					  [MODIFIER_STATE_PROVIDES_VISION] = true,
                  }
    return hState
end