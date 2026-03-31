--====================================================================================================--
function TableCopy(orig, deep, seen)
	if type(orig) ~= "table" then
		return orig
	end
	if not deep then
		local copy = {}
		for k, v in pairs(orig) do
			copy[k] = v
		end
		return copy
	end
	seen = seen or {}
	if seen[orig] then
		return seen[orig]
	end
	local copy = {}
	seen[orig] = copy
	for k, v in pairs(orig) do
		local newKey = TableCopy(k, true, seen)
		local newVal = TableCopy(v, true, seen)
		copy[newKey] = newVal
	end
	setmetatable(copy, getmetatable(orig))
	return copy
end
--===============================================================--
function TableCount(t)
	local n = 0
	for _, v in pairs(t) do
		n = n + 1
	end
	return n
end
--===============================================================--
function TableContains(t, value)
	for _, v in pairs(t) do
		if v == value then
			return true
		end
	end
	return false
end
--====================================================================================================--
function IsNotNull(hScript)
	local t = type(hScript)
	if t == "table" then
		return (type(hScript.IsNull) ~= "function" or not hScript:IsNull())
	end
	return false
end
--====================================================================================================--
function IsNull(hScript)
	return not IsNotNull(hScript)
end
--====================================================================================================--
function GetDistance(vPos1, vPos2, b3D)
	local _vPos1 = type(vPos1.GetAbsOrigin) == "function" and vPos1:GetAbsOrigin() or vPos1
	local _vPos2 = type(vPos2.GetAbsOrigin) == "function" and vPos2:GetAbsOrigin() or vPos2
	local _vPos3 = (_vPos1 - _vPos2)
	return b3D and _vPos3:Length() or _vPos3:Length2D()
end
--====================================================================================================--
function GetDirection(vPos1, vPos2, b3D)
	local _vPos1 = type(vPos1.GetAbsOrigin) == "function" and vPos1:GetAbsOrigin() or vPos1
	local _vPos2 = type(vPos2.GetAbsOrigin) == "function" and vPos2:GetAbsOrigin() or vPos2
	local _vPos3 = (_vPos1 - _vPos2)
	if not b3D then _vPos3.z = 0 end
	return _vPos3:Normalized()
end
--====================================================================================================--
function SetForwardVector(hUnit, vDirection, bUseAngles)
	if IsNull(hUnit) then return end
	if not bUseAngles then hUnit:SetForwardVector(vDirection) end
	vDirection = VectorToAngles(vDirection)
	return hUnit:SetAbsAngles(vDirection[1], vDirection[2], vDirection[3])
end
--====================================================================================================--
function RotateVector2D(vVector, nAngle, bIsDegreeNotRad)
	nAngle = bIsDegreeNotRad and math.rad(nAngle) or nAngle
	local nSinA = math.sin(nAngle)
	local nCosA = math.cos(nAngle)
	local vXP = ( vVector.x * nCosA ) - ( vVector.y * nSinA )
	local vYP = ( vVector.x * nSinA ) + ( vVector.y * nCosA )
	return Vector(vXP, vYP, vVector.z):Normalized()
end
--===============================================================--
function math.clamp(nValue, nMin, nMax)
	return math.max(nMin, math.min(nValue, nMax))
end
--====================================================================================================--
function CalcPosToLineSegment(vPos, vPosA, vPosB, b3D)
	local vSeg = vPosB - vPosA
	local nLen = vSeg:Dot(vSeg)

	local vClosest, nDist, nTime

	if nLen == 0 then
		vClosest = vPosA
		local vDelta = vPosA - vPos
		nDist = b3D and vDelta:Length() or vDelta:Length2D()
		nTime = 0
	else
		local t = (vPos - vPosA):Dot(vSeg) / nLen
		-- t = math.max(0, math.min(1, t))
		t = math.clamp(t, 0, 1)
		vClosest = vPosA + vSeg * t
		local vDelta = vClosest - vPos
		nDist = b3D and vDelta:Length() or vDelta:Length2D()
		nTime = t
	end

	return
	{
		pos = vClosest,
		dist = nDist,
		time = nTime
	}
end
--====================================================================================================--
function GetAnimImpactTime(nLength, nFrame, nFPS, nTimeNeed)
	nLength = math.max(1, nLength)
	nFrame = math.min(nFrame or nLength, nLength)
	nFPS = nFPS or 30
	local nTimeBase = nLength / nFPS
	local nFTCalced = nFrame / nFPS
	local nProgress = nFTCalced / nTimeBase
	return nProgress * nTimeNeed
end
--====================================================================================================--
function GetAnimPlayRate(nLength, nFrame, nFPS, nTimeNeed)
	nLength = math.max(1, nLength or 1)
	nFrame = math.min(nFrame or nLength, nLength)
	nFPS = math.max(1, nFPS or 30)
	nTimeNeed = math.max(FrameTime(), nTimeNeed or 0)
	local nFTCalced = nFrame / nFPS
	return nFTCalced / nTimeNeed
end
--====================================================================================================--
function HasTalent(hUnit, sTalentName)
	if IsNull(hUnit) then return false end
	sTalentName = string.lower(sTalentName)
	local hTalent = hUnit:FindAbilityByName(sTalentName)
	return IsNotNull(hTalent) and hTalent:GetLevel() > 0
end
--====================================================================================================--
function FindTalentValue(hUnit, sTalentName, sKey, nBaseValue)
	if not hUnit:HasTalent(sTalentName) then return nBaseValue or 0 end
	sTalentName = string.lower(sTalentName)
	local sKey = sKey or "value"
	return hUnit:FindAbilityByName(sTalentName):GetSpecialValueFor(sKey)
end










--====================================================================================================--
function RandomKVFromTableSafe(t, fAllow, fBlock)
	if not t then return nil end
	local tAllow = {}
	local tSafe  = {}
	for k, v in pairs(t) do
		if not fBlock or fBlock(k, v) then
			if not fAllow or fAllow(k, v) then
				tAllow[#tAllow + 1] = {key = k, value = v}
			else
				tSafe[#tSafe + 1] = {key = k, value = v}
			end
		end
	end
	if #tAllow > 0 then
		local pick = tAllow[RandomInt(1, #tAllow)]
		return pick.key, pick.value
	end
	if #tSafe > 0 then
		local pick = tSafe[RandomInt(1, #tSafe)]
		return pick.key, pick.value
	end
	return nil
end





	-- local tMotion =
	-- {
	-- 	duration = 5,

	-- 	facing = 1,
	-- 	facing_cast = 1,

	-- 	target = hTarget:entindex(),

	-- 	dir_x = vDir.x,
	-- 	dir_y = vDir.y,

	-- 	distance = 1000,

	-- 	speed = 1000,

	-- 	path_trees = 1,
	-- 	path_hg = 1,
	-- 	path_blocked = 1,
	-- }

	-- local tAnim =
	-- {
	-- 	duration = 5,

	-- 	pause = 1,
	-- 	pause_sync = 1,

	-- 	facing = 1,
	-- 	facing_cast = 1,

	-- 	activity = ACT_DOTA_RUN,

	-- 	rate = 1,

	-- 	activities = json.encode({"string", "string"})
	-- }















function RemoveSpecialAnimations(hUnit, bInterrupted)
	if IsNull(hUnit) then return end
	local tMods = hUnit:FindAllModifiers()
	for _, hMod in ipairs(tMods) do
		if hMod.IsSpecialAnimation and hMod:IsSpecialAnimation() then
			hMod:Destroy(bInterrupted)
		end
	end
end



















--====================================================================================================--
LinkLuaModifier("modifier_roland_motion_generic", "heroes/roland/roland_init", LUA_MODIFIER_MOTION_HORIZONTAL)

modifier_roland_motion_generic = class({})

function modifier_roland_motion_generic:IsHidden()										return true end
function modifier_roland_motion_generic:IsDebuff()										return self._bIsDebuff end
function modifier_roland_motion_generic:IsPurgable()									return self._bIsDebuff end
function modifier_roland_motion_generic:IsPurgeException()								return self._bIsDebuff end
function modifier_roland_motion_generic:RemoveOnDeath()									return false end
function modifier_roland_motion_generic:GetAttributes()									return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_motion_generic:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_roland_motion_generic:CheckState()
	local t = {}
	t[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	return t
end
function modifier_roland_motion_generic:DeclareFunctions()
	local t = 
	{
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	}
	return t
end
function modifier_roland_motion_generic:GetModifierDisableTurning(keys)
	return (self._nFacing ~= 0) and 1 or 0
end
function modifier_roland_motion_generic:GetModifierIgnoreCastAngle(keys)
	return self._nFacingCast
end
function modifier_roland_motion_generic:OnCreated(tInfo)
	self._hCaster  = self:GetCaster()
	self._hParent  = self:GetParent()
	self._hAbility = self:GetAbility()

	self._nTeamID = self._hCaster:GetTeamNumber()

	self._bIsDebuff = self._nTeamID ~= self._hParent:GetTeamNumber()

	if not IsServer() then return end

	self._nFacing = tInfo.facing or 1
	self._nFacingCast = tInfo.facing_cast or 1

	self._hTarget = EntIndexToHScript(tInfo.target or -1)
	self._bIsTracking = IsNotNull(self._hTarget)

	self._vDir = Vector(tInfo.dir_x, tInfo.dir_y, 0)
	self._nDistance = tInfo.distance or 0
	self._nSpeed = tInfo.speed or 0

	self._bPathTrees = (tInfo.path_trees or 1) > 0
	self._bPathHG = (tInfo.path_hg or 1) > 0
	self._bPathBlocked = (tInfo.path_blocked or 1) > 0

	self._nBound2D = 32
	--=================================--
	self._fCB_Think = nil
	self._tCB_End = {}
	--=================================--
	self.__vPosSpawn = self._hParent:GetAbsOrigin()

	self.__vDirNow = self._bIsTracking and GetDirection(self._hTarget, self.__vPosSpawn, false) or self._vDir
	self.__nDistancePassed = 0

	self.__vPosTarget = self._bIsTracking and self._hTarget:GetAbsOrigin() or (self.__vPosSpawn + self.__vDirNow * self._nDistance)
	--=================================--
	if not self:ApplyHorizontalMotionController() then
		self:Destroy(true)
	end
end
function modifier_roland_motion_generic:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_roland_motion_generic:OnHorizontalMotionInterrupted()
	self:Destroy(true)
end
function modifier_roland_motion_generic:UpdateHorizontalMotion(hUnit, nDT)
	local nFacing = self._nFacing
	local nBound2D = self._nBound2D

	local nSpeed = self:GetSpeed()
	local nSpeedDT = nSpeed * nDT

	local vDirectionNow = self.__vDirNow

	local vPosNowTrue = hUnit:GetAbsOrigin()
	local vPosNowSafe = vPosNowTrue

	local vPosNew = vPosNowSafe

	local hTarget = self._hTarget
	if IsNotNull(hTarget) then
		self.__vPosTarget = hTarget:GetAbsOrigin()
		vDirectionNow = GetDirection(self.__vPosTarget, vPosNowTrue, false)
		self.__vDirNow = vDirectionNow
	end
	--=================================--
	local _bPath = true
	local _bStop = false
	local _nSpeedDT = 0
	--=================================--
	local _fCallback = self._fCB_Think
	--=================================--
	while true do
		_nSpeedDT = math.min(_nSpeedDT + nBound2D, nSpeedDT)
		vPosNew = vPosNowTrue + vDirectionNow * _nSpeedDT
		_bPath = self:IsNavPathable(vPosNowSafe, vPosNew, self._bPathTrees, self._bPathHG, self._bPathBlocked)
		if _fCallback then
			vPosNew, _bStop = _fCallback(self, vPosNew, _bPath, _nSpeedDT)
		end
		if not (_nSpeedDT < nSpeedDT and vPosNew and not _bStop and _bPath) then
			break
		end
		vPosNowSafe = vPosNew
	end
	--=================================--
	self.__nDistancePassed = self.__nDistancePassed + _nSpeedDT
	--=================================--
	local _bInterrupt = nil
	--=================================--
	if not vPosNew or _bStop then
		hUnit:SetAbsOrigin(vPosNowSafe)
		_bInterrupt = _bStop
	else
		--=================================--
		if nFacing ~= 0 then
			local _vDir = Vector(vDirectionNow.x, vDirectionNow.y, 0)
			local _vFacing = _vDir * nFacing
			hUnit:FaceTowards(vPosNowSafe + _vFacing * nBound2D * 100)
			SetForwardVector(hUnit, _vFacing, true)
		end
		--=================================--
		if not _bPath then
			hUnit:SetAbsOrigin(vPosNowSafe)
			_bInterrupt = true
		else
			--=================================--
			local tCalcPos = CalcPosToLineSegment(self.__vPosTarget, vPosNowTrue, vPosNew, false)
			hUnit:SetAbsOrigin(tCalcPos.pos)
			if tCalcPos.dist <= _nSpeedDT then
				hUnit:SetAbsOrigin(self.__vPosTarget)
				_bInterrupt = false
			end
		end
	end
	--=================================--
	if type(_bInterrupt) ~= "boolean" then return end
	self:Destroy(_bInterrupt)
end
function modifier_roland_motion_generic:GetDistance(bRemaining)
	local vPT = self.__vPosTarget
	local vPN = self._hParent:GetAbsOrigin()
	local nD_PT_PN = GetDistance(vPT, vPN, false)
	local nD = self._nDistance or 0
	local nDP = self.__nDistancePassed or 0
	local bT = self._bIsTracking
	if bRemaining then
		if bT then return nD_PT_PN end
		return math.max(0, nD - nDP)
	end
	if bT then
		return nDP + nD_PT_PN
	end
	return nD
end
function modifier_roland_motion_generic:GetSpeed()
	local nSpeed = self._nSpeed
	if self:GetDuration() > 0 then
		local nDR = self:GetDistance(true)
		nSpeed = nDR / math.max(FrameTime(), self:GetRemainingTime())
	end
	return nSpeed
end
function modifier_roland_motion_generic:IsNavPathable(vPosNow, vPosNew, bTrees, bHG, bBlocked)
	if not bTrees and GridNav:IsNearbyTree(vPosNew, self._nBound2D, true) then
		return false
	end
	if not bHG then
		local nNow = GetGroundHeight(vPosNow, self._hParent)
		local nNew = GetGroundHeight(vPosNew, self._hParent)
		if nNew > nNow then return false end
	end
	if not bBlocked then
		if not GridNav:IsTraversable(vPosNew) or GridNav:IsBlocked(vPosNew) then
			return false
		end
	end
	return true
end
function modifier_roland_motion_generic:IsInterrupted()
	return self._bIsInterrupted or false
end
function modifier_roland_motion_generic:OnRemoved(bDeath)
	if not IsServer() then return end
end
function modifier_roland_motion_generic:OnRemoved(bDeath)
	if type(self._bIsInterrupted) == "boolean" then return end
	self._bIsInterrupted = bDeath or (self:GetDuration() > 0 and self:GetRemainingTime() > 0)
end
function modifier_roland_motion_generic:OnDestroy()
	if not IsServer() or IsNull(self._hParent) then return end
	--=================================--
	for _, fCallback in ipairs(self._tCB_End) do fCallback(self) end
end
function modifier_roland_motion_generic:Destroy(bInterrupted)
	self._bIsInterrupted = bInterrupted
	return self.BaseClass.Destroy(self)
end
function modifier_roland_motion_generic:AddCallbackThink(fCallback)
	if type(fCallback) ~= "function" then return end
	self._fCB_Think = fCallback
end
function modifier_roland_motion_generic:AddCallbackEnd(fCallback)
	if type(fCallback) ~= "function" then return end
	table.insert(self._tCB_End, fCallback)
end





























--====================================================================================================--
LinkLuaModifier("modifier_roland_animation_generic_self_paused", "heroes/roland/roland_init", LUA_MODIFIER_MOTION_NONE)

modifier_roland_animation_generic_self_paused = class({})

function modifier_roland_animation_generic_self_paused:IsHidden()															return true end
function modifier_roland_animation_generic_self_paused:IsDebuff()															return false end
function modifier_roland_animation_generic_self_paused:IsPurgable()															return false end
function modifier_roland_animation_generic_self_paused:IsPurgeException()													return false end
function modifier_roland_animation_generic_self_paused:RemoveOnDeath()														return false end
function modifier_roland_animation_generic_self_paused:GetAttributes()														return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_animation_generic_self_paused:GetPriority()														return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_roland_animation_generic_self_paused:CheckState()
	local t = {}
	-- t[MODIFIER_STATE_STUNNED] = true
	-- t[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	return t
end
function modifier_roland_animation_generic_self_paused:OnCreated(tInfo)
	self._hCaster  = self:GetCaster()
	self._hParent  = self:GetParent()
	self._hAbility = self:GetAbility()

	if not IsServer() then return end

	self._hParent:SetForceAttackTargetAlly(self._hParent)
end
function modifier_roland_animation_generic_self_paused:OnRemoved(bDeath)
	if not IsServer() then return end

	if IsNull(self._hParent) or self._hParent:HasModifier("modifier_roland_animation_generic_self_paused") then return end
	
	self._hParent:SetForceAttackTargetAlly(nil)
end

--====================================================================================================--
LinkLuaModifier("modifier_roland_animation_generic_activity", "heroes/roland/roland_init", LUA_MODIFIER_MOTION_NONE)

modifier_roland_animation_generic_activity = class({})

function modifier_roland_animation_generic_activity:IsHidden()															return true end
function modifier_roland_animation_generic_activity:IsDebuff()															return false end
function modifier_roland_animation_generic_activity:IsPurgable()														return false end
function modifier_roland_animation_generic_activity:IsPurgeException()													return false end
function modifier_roland_animation_generic_activity:RemoveOnDeath()														return false end
function modifier_roland_animation_generic_activity:GetAttributes()														return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_animation_generic_activity:GetPriority()														return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_roland_animation_generic_activity:DeclareFunctions()
	local t =
	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return t
end
function modifier_roland_animation_generic_activity:GetActivityTranslationModifiers(keys)
	return self._sAct
end
function modifier_roland_animation_generic_activity:OnCreated(tInfo)
	self._hCaster  = self:GetCaster()
	self._hParent  = self:GetParent()
	self._hAbility = self:GetAbility()

	if not IsServer() then return end

	self._sAct = tInfo.activity
end
function modifier_roland_animation_generic_activity:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
--====================================================================================================--
LinkLuaModifier("modifier_roland_animation_generic", "heroes/roland/roland_init", LUA_MODIFIER_MOTION_NONE)

modifier_roland_animation_generic = class({})

function modifier_roland_animation_generic:IsHidden()																return true end
function modifier_roland_animation_generic:IsDebuff()																return false end
function modifier_roland_animation_generic:IsPurgable()																return false end
function modifier_roland_animation_generic:IsPurgeException()														return false end
function modifier_roland_animation_generic:RemoveOnDeath()															return false end
function modifier_roland_animation_generic:GetAttributes()															return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_animation_generic:GetPriority()															return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_roland_animation_generic:DeclareFunctions()
	local t = 
	{
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
	return t
end
function modifier_roland_animation_generic:GetModifierDisableTurning(keys)
	return (self._nFacing ~= 0) and 1 or 0
end
function modifier_roland_animation_generic:GetModifierIgnoreCastAngle(keys)
	return self._nFacingCast
end
-- function modifier_roland_animation_generic:GetOverrideAnimation(keys)
-- 	return self:GetStackCount()
-- end
-- function modifier_roland_animation_generic:GetOverrideAnimationRate(keys)
-- 	return 1
-- end
function modifier_roland_animation_generic:OnCreated(tInfo)
	self._hCaster  = self:GetCaster()
	self._hParent  = self:GetParent()
	self._hAbility = self:GetAbility()

	if not IsServer() then return end
	--=================================--
	self._nPause = tInfo.pause or 0
	self._bPauseSync = (tInfo.pause_sync or 1) > 0
	if self._nPause ~= 0 then
		self._hParent:Stop()
		self._hPause = self._hParent:AddNewModifier(self._hParent, self._hAbility, "modifier_roland_animation_generic_self_paused", {duration = self._nPause})
	end
	--=================================--
	self._nFacing = tInfo.facing or 0
	self._nFacingCast = tInfo.facing_cast or 0
	--=================================--
	self._nActivity = tInfo.activity
	self._nRate = tInfo.rate or 1
	self._sActivities = tInfo.activities or ""
	--=================================--
	self._tCB_Think = {}
	self._tCB_End = {}
	--=================================--
	if type(self._nActivity) ~= "number" then
		self:Destroy(true)
		return
	end
	--=================================--
	local _tActivities = self:AddActivities(self._sActivities)
	-- self._hParent:StartGestureWithPlaybackRate(self._nActivity, self._nRate)
	self._hParent:StartGestureWithFadeAndPlaybackRate(self._nActivity, 0, 0, self._nRate)
	self:RemoveActivities(_tActivities)
	--=================================--
	self:SendBuffRefreshToClients()
end
function modifier_roland_animation_generic:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_roland_animation_generic:OnRemoved(bDeath)
	if type(self._bIsInterrupted) == "boolean" then return end
	self._bIsInterrupted = bDeath or (self:GetDuration() > 0 and self:GetRemainingTime() > 0)
end
function modifier_roland_animation_generic:OnDestroy()
	if not IsServer() or IsNull(self._hParent) then return end
	--=================================--
	if not self._hParent:HasModifier(self:GetName()) and type(self._nActivity) == "number" then
		-- self._hParent:RemoveGesture(self._nActivity)
		self._hParent:FadeGesture(self._nActivity)
	end
	--=================================--
	for _, sTimerName in ipairs(self._tCB_Think) do Timers:RemoveTimer(sTimerName) end
	--=================================--
	for _, fCallback in ipairs(self._tCB_End) do fCallback(self) end
	--=================================--
	if IsNull(self._hPause) or not self._bPauseSync then return end
	self._hPause:Destroy()
end
function modifier_roland_animation_generic:Destroy(bInterrupted)
	self._bIsInterrupted = bInterrupted
	return self.BaseClass.Destroy(self)
end
--========================================--
function modifier_roland_animation_generic:AddActivities(sActs)
	local _tActs1 = json.decode(sActs) or {}
	local _tActs2 = {}
	for _, sActivity in ipairs(_tActs1) do
		table.insert(_tActs2, self._hParent:AddNewModifier(self._hCaster, self._hAbility, "modifier_roland_animation_generic_activity", {duration = 0.1, activity = sActivity}))
	end
	return _tActs2
end
function modifier_roland_animation_generic:RemoveActivities(tActs)
	for _, hActivity in ipairs(tActs or {}) do
		if IsNotNull(hActivity) then
			hActivity:Destroy()
		end
	end
end
--========================================--
function modifier_roland_animation_generic:IsSpecialAnimation()
	return true
end
function modifier_roland_animation_generic:IsInterrupted()
	return self._bIsInterrupted or false
end
function modifier_roland_animation_generic:AddCallbackThink(nTime, fCallback)
	if type(fCallback) ~= "function" then return end
	local _sTimer = Timers:CreateTimer(nTime,
		function(_hModifier, _tTimer)
			if IsNull(_hModifier) then return end
			return fCallback(_hModifier, _tTimer, nTime)
		end, self)
	table.insert(self._tCB_Think, _sTimer)
end
function modifier_roland_animation_generic:AddCallbackEnd(fCallback)
	if type(fCallback) ~= "function" then return end
	table.insert(self._tCB_End, fCallback)
end
--========================================--














--====================================================================================================--
function CDOTABaseAbility:IsLearned()
	if IsNull(self) then return false end
	return tonumber(GetAbilityKeyValuesByName(self:GetAbilityName())["IsLearned"]) or false
	--NOTE: Returning false because false equal zero in main checker and we no need recheck boolean in other lua IsLearned overridens
end



--====================================================================================================--
function CDOTA_BaseNPC:UpgradeIsLearnedAbilities()
	if IsNull(self) or self.___bUpgradeIsLearnedAbilities then return false end
	self.___bUpgradeIsLearnedAbilities = true
	local nAbilityCount = self:GetAbilityCount() - 1
	for nID = 0, nAbilityCount do
		local hAbility = self:GetAbilityByIndex(nID)
		if IsNotNull(hAbility) and not hAbility:IsTrained() then
			local nIsLearned = hAbility:IsLearned()
			local bIsLearned = type(nIsLearned) == "number" and nIsLearned > 0 or nIsLearned
			if bIsLearned then
				nIsLearned = type(nIsLearned) == "number" and nIsLearned or hAbility:GetMaxLevel()
				if hAbility:GetLevel() ~= nIsLearned then --CHANGED FROM < TO ~= 19.09.2021
					hAbility:SetLevel(nIsLearned)
				end
			end
		end
	end
	return true
end










if not _G.ROLAND_IsLearned and IsServer() then
	_G.ROLAND_IsLearned = true
	ListenToGameEvent("npc_spawned", function(tEventData)
		local hEntity = EntIndexToHScript(tEventData.entindex)
		local bRespawn = tEventData.is_respawn > 0
		if IsNull(hEntity) or hEntity:GetClassname() == "npc_dota_thinker" or not hEntity:IsBaseNPC() then return end

		hEntity:UpgradeIsLearnedAbilities()
	end, nil)
end