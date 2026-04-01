require("heroes/roland/roland_init")

local ROLAND_CARD_SLOTS =
{
	"roland_slot_1",
	"roland_slot_2",
	"roland_slot_3",
	"roland_slot_4",
	"roland_slot_5",
}

local ROLAND_CARD_POOL =
{
	"roland_zelkova",
	"roland_zelkova_ex",

	"roland_boys",
	"roland_boys_ex",

	"roland_ranga",
	"roland_ranga_ex",

	"roland_durandal",
	"roland_durandal_ex",

	"roland_mook",
	"roland_mook_ex",

	"roland_crystal",
	"roland_crystal_ex",

	"roland_logic",
	"roland_logic_ex",

	"roland_allas",
	"roland_allas_ex",

	"roland_wheel",
	"roland_wheel_ex",

	"roland_mimicry",
	"roland_furioso",
}

local ROLAND_FURIOSO_ABILITIES_SEQ =
{
	"roland_zelkova",
	"roland_boys",
	"roland_ranga",
	"roland_durandal",
	"roland_mook",
	"roland_crystal",
	"roland_logic",
	"roland_allas",
	"roland_wheel",
}

local sLIGHT_MAX = "modifier_roland_turn_light_max"
local sLIGHT_NOW = "modifier_roland_turn_light_now"

function ROLAND_GetLightCost(hUnit, hCard, nLevel)
	return hCard:GetLevelSpecialValueFor("cost_light", nLevel or -1)
end
function ROLAND_IsLightEnough(hUnit, hCard)
	return ROLAND_GetLightNow(hUnit) >= ROLAND_GetLightCost(hUnit, hCard, hCard:GetLevel())
end

function ROLAND_GetLightMax(hUnit)
	return hUnit:GetModifierStackCount(sLIGHT_MAX, hUnit)
end
function ROLAND_LightSetMax(hUnit, nCount)
	if not hUnit:HasModifier("modifier_roland_turn_card_pool") then return end
	hUnit:SetModifierStackCount(sLIGHT_MAX, hUnit, nCount)
	hUnit:SetMaxMana(nCount)
end

function ROLAND_GetLightNow(hUnit)
	return hUnit:GetModifierStackCount(sLIGHT_NOW, hUnit)
end
function ROLAND_LightSetNow(hUnit, nCount)
	if not hUnit:HasModifier("modifier_roland_turn_card_pool") then return end
	hUnit:SetModifierStackCount(sLIGHT_NOW, hUnit, nCount)
	hUnit:SetMana(nCount)
end
function ROLAND_LightSpend(hUnit, nCount)
	nCount = math.max(0, ROLAND_GetLightNow(hUnit) - nCount)
	ROLAND_LightSetNow(hUnit, nCount)
end
function ROLAND_LightAdd(hUnit, nCount)
	nCount = math.min(ROLAND_GetLightMax(hUnit), ROLAND_GetLightNow(hUnit) + nCount)
	ROLAND_LightSetNow(hUnit, nCount)
end






function ROLAND_InitCards(hUnit)
	if not ROLAND_CARD_POOL or #ROLAND_CARD_POOL == 0 or IsNull(hUnit) or hUnit._tROLAND_CARD_POOL then return false end
	hUnit._tROLAND_CARD_POOL = {}
	hUnit._tROLAND_CARD_SLOTS = {}
	hUnit._tROLAND_CARD_HAND = {}

	local sPTName = "roland_cards_active"
	if not PlayerTables:TableExists(sPTName) then
		PlayerTables:CreateTable(sPTName, {}, {hUnit:GetPlayerOwnerID()})
	else
		PlayerTables:AddPlayerSubscription(sPTName, hUnit:GetPlayerOwnerID())
	end

	for _, sCardName in ipairs(ROLAND_CARD_POOL) do
		local hCard = hUnit:FindAbilityByName(sCardName) or hUnit:AddAbility(sCardName)
		if IsNotNull(hCard) then
			hUnit:RemoveAbilityFromIndexByName(sCardName)
			hCard:SetAbilityIndex(-1)
			hCard:SetLevel(1)
			hCard:SetHidden(true)
			table.insert(hUnit._tROLAND_CARD_POOL, hCard)
		end
	end
	for _, sSlotName in ipairs(ROLAND_CARD_SLOTS) do
		local hSlot = hUnit:FindAbilityByName(sSlotName) or hUnit:AddAbility(sSlotName)
		hUnit._tROLAND_CARD_SLOTS[_] = hSlot
	end
	return true
end
function ROLAND_GetSlotRandom(hUnit, fCallback)
	if IsNull(hUnit) then return -1 end
	local k, v = RandomKVFromTableSafe(hUnit._tROLAND_CARD_SLOTS, nil, fCallback)
	return k or -1
end
function ROLAND_IsSlotValid(hUnit, nSlot)
	if IsNull(hUnit) or not hUnit._tROLAND_CARD_SLOTS then return false end
	local hSlot = hUnit._tROLAND_CARD_SLOTS[nSlot]
	return IsNotNull(hSlot)
end
function ROLAND_IsSlotFree(hUnit, nSlot)
	return ROLAND_IsSlotValid(hUnit, nSlot) and not hUnit._tROLAND_CARD_HAND[nSlot]
end
function ROLAND_GetSlotFree(hUnit)
	for nSlot, sSlotName in ipairs(hUnit._tROLAND_CARD_SLOTS) do
		if ROLAND_IsSlotFree(hUnit, nSlot) then return nSlot end
	end
	return -1
end
function ROLAND_CardDraw(hUnit, sTargetDrawWithIgnore) --NOTE: Returns V, K
	local k, v = RandomKVFromTableSafe(hUnit._tROLAND_CARD_POOL,
		function(_k, _v)
			return _v:IsCooldownReady()
		end,
		function(_k, _v)
			return IsNotNull(_v) and _v:GetAbilityIndex() == -1 and ((not sTargetDrawWithIgnore and _v:GetSpecialValueFor("drawable") > 0) or sTargetDrawWithIgnore == _v:GetAbilityName())
		end)
	return v, k
end
function ROLAND_CardGet(hUnit, nSlot)
	if not ROLAND_IsSlotValid(hUnit, nSlot) then return end
	return hUnit:GetAbilityByIndex(nSlot - 1)
end
function ROLAND_CardAdd(hUnit, hCard, nSlot)
	nSlot = nSlot or ROLAND_GetSlotFree(hUnit)
	local bValid = ROLAND_IsSlotValid(hUnit, nSlot)
	if not bValid or IsNull(hCard) then return end
	local hSlot = hUnit._tROLAND_CARD_SLOTS[nSlot]
	if IsNull(hSlot) then return end

	hUnit._tROLAND_CARD_HAND[nSlot] = hCard

	hUnit:RemoveAbilityFromIndexByName(hSlot:GetAbilityName())
	hSlot:SetAbilityIndex(-1)
	hSlot:SetHidden(true)

	hUnit:SetAbilityByIndex(hCard, nSlot - 1)
	hCard:SetLevel(hSlot:GetLevel())
	hCard:SetHidden(false)

	return hCard
end
function ROLAND_CardDiscard(hUnit, nSlot, bIgnoreDiscardable)
	local hCard = ROLAND_CardGet(hUnit, nSlot)
	if IsNull(hCard) or (hCard:GetSpecialValueFor("discardable") <= 0 and not bIgnoreDiscardable) then return end
	local hSlot = hUnit._tROLAND_CARD_SLOTS[nSlot]
	if IsNull(hSlot) then return end

	hUnit._tROLAND_CARD_HAND[nSlot] = nil

	hUnit:RemoveAbilityFromIndexByName(hCard:GetAbilityName())
	hCard:SetAbilityIndex(-1)
	hCard:SetHidden(true)

	hUnit:SetAbilityByIndex(hSlot, nSlot - 1)
	hSlot:SetLevel(hCard:GetLevel())
	hSlot:SetHidden(false)

	return hCard
end






function ROLAND_CardDiscardUsed(hUnit)
	if IsNull(hUnit) or not hUnit._tROLAND_CARD_SLOTS then return end
	for nSlot, _ in ipairs(hUnit._tROLAND_CARD_SLOTS) do
		local hCard = ROLAND_CardGet(hUnit, nSlot)
		if IsNotNull(hCard) and not hCard:IsCooldownReady() then
			hCard = ROLAND_CardDiscard(hUnit, nSlot)
		end
	end
end
function ROLAND_CardDiscardSome(hUnit, nCount)
	if nCount <= 0 then return end
	for i = 1, nCount do
		local nSlot = ROLAND_GetSlotRandom(hUnit, function(k, v)
			return not ROLAND_IsSlotFree(hUnit, k)
		end)
		local hCard = ROLAND_CardDiscard(hUnit, nSlot)
	end
end
function ROLAND_CardDrawSome(hUnit, nCount)
	if nCount <= 0 then return end
	for i = 1, nCount do
		local hCard = ROLAND_CardAdd(hUnit, ROLAND_CardDraw(hUnit), nil)
	end
end
















local sROLAND_PT_NAME = "roland_cards_active"

local function SortCards(tTurnCards)
	local _tSort = {}
	for k, v in pairs(tTurnCards) do
		_tSort[#_tSort + 1] = v
	end
	table.sort(_tSort, function(a, b)
		if a.order == b.order then
			return a.order_id < b.order_id
		end
		return a.order < b.order
	end)
	return _tSort
end
function ROLAND_TurnCardAdd(hUnit, hCard, nRarity, nCost, nType)
	if IsNull(hUnit) or IsNull(hCard) then return end

	local sEntIndex = tostring(hUnit:entindex())
	local tTurnCards = PlayerTables:GetTableValue(sROLAND_PT_NAME, sEntIndex) or {}

	local sUID = DoUniqueString("card")

	tTurnCards[sUID] =
	{
		uid = sUID,
		order = GameRules:GetGameTime(),
		order_id = TableCount(tTurnCards) + 1,
		card_id = hCard:entindex(),
		card_rarity = nRarity or 1,
		card_cost = nCost or 0,
		card_type = nType or 1,
	}

	PlayerTables:SetTableValue(sROLAND_PT_NAME, sEntIndex, tTurnCards)
end
function ROLAND_TurnCardGet(hUnit, nIndex)
	if IsNull(hUnit) then return end
	local sEntIndex = tostring(hUnit:entindex())
	local tTurnCards = PlayerTables:GetTableValue(sROLAND_PT_NAME, sEntIndex) or {}
	local _tSort = SortCards(tTurnCards)
	if _tSort[nIndex] and _tSort[nIndex].card_id then
		return EntIndexToHScript(_tSort[nIndex].card_id)
	end
end
function ROLAND_TurnCardRemove(hUnit, nIndex)
	if IsNull(hUnit) then return end
	local sEntIndex = tostring(hUnit:entindex())
	local tTurnCards = PlayerTables:GetTableValue(sROLAND_PT_NAME, sEntIndex) or {}
	local _tSort = SortCards(tTurnCards)
	if _tSort[nIndex] and _tSort[nIndex].uid then
		tTurnCards[_tSort[nIndex].uid] = nil
	end
	PlayerTables:SetTableValue(sROLAND_PT_NAME, sEntIndex, tTurnCards)
end
function ROLAND_TurnCardClear(hUnit)
	if IsNull(hUnit) then return end
	local sEntIndex = tostring(hUnit:entindex())
	PlayerTables:SetTableValue(sROLAND_PT_NAME, sEntIndex, {})
end











function ROLAND_CastFilterResult(hUnit, hCard, hTarget, vLocation)
	if Convars:GetBool("dota_ability_debug") then return UF_SUCCESS end
	local sFilterError
	if not sFilterError and not ROLAND_IsTurnPhase(hUnit) then
		local hChangeAbility = hUnit:FindAbilityByName("roland_change")
		if IsNotNull(hChangeAbility) and hChangeAbility:GetToggleState() then
			sFilterError = "custom_error_roland_not_turn_phase"
		end
	end
	if not sFilterError and not ROLAND_IsLightEnough(hUnit, hCard) then
		sFilterError = "custom_error_roland_not_enough_light"
	end
	if sFilterError then
		hCard._sFilterError = sFilterError
		return UF_FAIL_CUSTOM
	end
	local nError = hCard.BaseClass.CastFilterResult(hCard)
	return nError
end











function ROLAND_TurnStart(hUnit, hCard, nDuration, vStart)
	hUnit:AddNewModifier(hUnit, hCard, "modifier_roland_turn_phase", {duration = nDuration, start_x = vStart.x, start_y = vStart.y, start_z = vStart.z})
end
function ROLAND_TurnEnd(hUnit)
	hUnit:RemoveModifierByNameAndCaster("modifier_roland_turn_phase", hUnit)
end
function ROLAND_IsTurnPhase(hUnit)
	return hUnit:HasModifier("modifier_roland_turn_phase")
end






function ROLAND_AddBleeds(tInfo)
	if IsNull(tInfo.caster) or IsNull(tInfo.target) then return end
	local hBleed = tInfo.caster:FindAbilityByName("roland_bleed")
	if IsNull(hBleed) then return end
	local tBleed =
	{
		duration = -1,
		bleeds = tInfo.bleeds,
	}
	tInfo.target:AddNewModifier(tInfo.caster, hBleed, "modifier_roland_bleed_debuff", tBleed)
end











function ROLAND_FacingUniversal(hAnim, vhTarget, nTimeEnd, nRangeDestroy, bStunnable)
	if IsNull(hAnim) or not hAnim.AddCallbackThink then return end

	local hCaster = hAnim:GetCaster()
	local bFacing = vhTarget ~= nil
	local bIsUnit = IsNotNull(vhTarget) and vhTarget.GetAbsOrigin
	local bDestroy = false
	local vPoint = vhTarget

	local function fFacing()
		if (hAnim:GetDuration() > 0 and hAnim:GetElapsedTime() > nTimeEnd) then return false end
		vPoint = (bIsUnit and IsNotNull(vhTarget)) and vhTarget:GetAbsOrigin() or vPoint
		if bStunnable and hCaster:IsStunned() then
			bDestroy = true
		end
		if not bDestroy and bFacing then
			if GetDistance(vPoint, hCaster) > nRangeDestroy then
				bDestroy = true
			end

			local _vDir = GetDirection(vPoint, hCaster)
			hCaster:FaceTowards(vPoint + _vDir * 300)
			SetForwardVector(hCaster, _vDir, true)
		end
		if bDestroy then
			hAnim:Destroy(true)
			return false
		end
		return true
	end

	fFacing()

	hAnim:AddCallbackThink(FrameTime(), function(hMod, _tTimer, nTime)
		if not fFacing() then return end
		return nTime
	end)
end

function ROLAND_DashUniversal(tInfo, tMotion, tAnim)
	local tDash =
	{
		caster = tInfo.caster,

		team_id = tInfo.team_id or DOTA_TEAM_NOTEAM,
		target_team = tInfo.target_team or DOTA_UNIT_TARGET_TEAM_NONE,
		target_type = tInfo.target_type or DOTA_UNIT_TARGET_NONE,
		target_flags = tInfo.target_flags or DOTA_UNIT_TARGET_FLAG_NONE,

		radius = tInfo.radius or 0,

		stunnable = tInfo.stunnable or 0,

		sound = tInfo.sound or "",

		on_hit = tInfo.on_hit,
		on_end = tInfo.on_end,

		special_targets = tInfo.special_targets,

		hit_once = tInfo.hit_once or 1,
		hit = {},

		particle_seq = tInfo.particle_seq,
		particle_dash = 0,--tInfo.particle_dash or 0,
	}

	if not tMotion then return end

	local hMotion = tDash.caster:AddNewModifier(tDash.caster, self, "modifier_roland_motion_generic", tMotion)
	if IsNull(hMotion) or hMotion:IsInterrupted() then
		if hMotion._nAfterImagePFX then
			ParticleManager:DestroyParticle(hMotion._nAfterImagePFX, true)
			ParticleManager:ReleaseParticleIndex(hMotion._nAfterImagePFX)
			hMotion._nAfterImagePFX = nil
		end
		if hMotion._nDashPFX then
			ParticleManager:DestroyParticle(hMotion._nDashPFX, true)
			ParticleManager:ReleaseParticleIndex(hMotion._nDashPFX)
			hMotion._nDashPFX = nil
		end
		return
	end

	local nExpectDuration = hMotion:GetDistance(false) / hMotion:GetSpeed()
	if hMotion:GetDuration() < 0 then
		if tAnim.rate_time and tAnim.rate_time > 0 then
			tAnim.rate = (tAnim.rate * tAnim.rate_time) / nExpectDuration
		end
	end

	EmitSoundOn(tDash.sound, tDash.caster)

	if tDash.particle_seq then
		if not hMotion._nAfterImagePFX then
			local nPFX =	ParticleManager:CreateParticle("particles/heroes/roland/roland_dash/roland_dash_afterimage_activity.vpcf", PATTACH_ABSORIGIN_FOLLOW, tDash.caster)
							ParticleManager:SetParticleControl(nPFX, 1, Vector(tDash.particle_seq, 1, tAnim.rate))
			hMotion:AddParticle(nPFX, false, false, -1, false, false)
			hMotion._nAfterImagePFX = nPFX
		end
	end

	if tDash.particle_dash > 0 then
		if not hMotion._nDashPFX then
			local nPFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_das/roland_dash.vpcf", PATTACH_ABSORIGIN_FOLLOW, tDash.caster)
						ParticleManager:SetParticleControl(nPFX, 60, Vector(0, 0, 0))
						ParticleManager:SetParticleControl(nPFX, 61, Vector(0, 0, 0))
						ParticleManager:SetParticleControl(nPFX, 62, Vector(0, 0, 0))
			hMotion:AddParticle(nPFX, false, false, -1, false, false)
			hMotion._nDashPFX = nPFX
		end
	end

	local hAnim = nil
	if tAnim then
		hAnim = tDash.caster:AddNewModifier(tDash.caster, self, "modifier_roland_animation_generic", tAnim)
	end

	hMotion:AddCallbackThink(function(hMod, vPosNew, _bPath, _nSpeedDT)
		if tDash.stunnable > 0 and tDash.caster:IsStunned() then
			return nil, true
		end
		local tEntities = FindUnitsInRadius(
			tDash.team_id,
			vPosNew,
			nil,
			tDash.radius,
			tDash.target_team,
			tDash.target_type,
			tDash.target_flags,
			FIND_CLOSEST,
			false)
		for _, hEnt in ipairs(tEntities) do
			-- hit_once == 1: skip entity if already hit this dash
			-- hit_once == 0: always process, no tracking
			if tDash.hit_once == 0 or not tDash.hit[hEnt] then
				if tDash.hit_once > 0 then
					tDash.hit[hEnt] = true
				end
				hMod._hLastHitTarget = hEnt
				if tDash.on_hit and tDash.on_hit(hEnt, _) then
					return nil, false
				end
			end
		end
		hMod._hLastHitTarget = nil
		return vPosNew, false
	end)

	hMotion:AddCallbackEnd(function(hMod)
		local bInterrupted = hMod:IsInterrupted()
		if IsNotNull(hAnim) then hAnim:Destroy(bInterrupted) end
		if tDash.on_end then
			tDash.on_end(hMod._hLastHitTarget, bInterrupted)
		end
	end)

	return hMotion, hAnim
end















--====================================================================================================--
--====================================================================================================--
roland_turn_start = class({})

function roland_turn_start:GetPlaybackRateOverride()
	return GetAnimPlayRate(6, 6, 30, self:GetCastPoint())
end
function roland_turn_start:OnHeroLevelUp()
	self:RefreshIntrinsicModifier()
end
function roland_turn_start:GetIntrinsicModifierName()
	return "modifier_roland_turn_card_pool"
end
function roland_turn_start:GetBehavior()
	local nBehavior = self.BaseClass.GetBehavior(self)
	if IsServer() and self:GetAutoCastState() then
		return bit.bxor(nBehavior, DOTA_ABILITY_BEHAVIOR_AUTOCAST)
	end
	return nBehavior
end
function roland_turn_start:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition()

	local hChangeAbility = hCaster:FindAbilityByName("roland_change")

	local vPosCaster = hCaster:GetAbsOrigin()

	local nDistance = GetDistance(vPoint, vPosCaster)

	local vDir = GetDirection(vPoint, vPosCaster)
	vDir = nDistance <= 32 and hCaster:GetForwardVector() or vDir

	local tDash =
	{
		caster = hCaster,

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		radius = self:GetSpecialValueFor("cast_hit_radius"),

		stunnable = 0,

		sound = "roland_turn.end",

		-- on_hit
		-- on_end

		particle_seq = 3,
	}

	local tMotion =
	{
		duration = self:GetSpecialValueFor("turn_dash_time"),
		dir_x = vDir.x,
		dir_y = vDir.y,
		distance = nDistance,
	}

	local tAnim =
	{
		pause = -1,
		pause_sync = 1,
		activity = ACT_DOTA_CAST_ABILITY_1_END,
		-- activities = json.encode({_tInfo.da_act_mod}),
		rate = GetAnimPlayRate(15, 15, 30, tMotion.duration),
		rate_time = tMotion.duration,
	}

	local function OnHit(hTarget, _nIndex)
		if hTarget == tDash.caster then return end
		return true
	end

	local function OnEnd(hTarget, bInterrupted)
		if bInterrupted then return end
		if IsNotNull(hChangeAbility) and hChangeAbility:GetToggleState() then
			ROLAND_TurnStart(hCaster, self, self:GetSpecialValueFor("turn_time"), vPosCaster)
			return
		end
		if IsNull(hTarget) then return end

		local hCardNext = ROLAND_TurnCardGet(hCaster, 1)
		if IsNull(hCardNext) then
			ROLAND_TurnEnd(hCaster)
			return
		end

		hCardNext:TurnPlayNext(hCaster, hTarget, vDir)

		ROLAND_TurnStart(hCaster, self, self:GetSpecialValueFor("turn_time"), vPosCaster)
	end

	tDash.on_hit = OnHit
	tDash.on_end = OnEnd

	ROLAND_DashUniversal(tDash, tMotion, tAnim)
end



--====================================================================================================--
--====================================================================================================--
roland_turn_end = class({})

function roland_turn_end:CastFilterResult()
	return ROLAND_CastFilterResult(self:GetCaster(), self, nil, nil)
end
function roland_turn_end:GetCustomCastError()
	return self._sFilterError
end
function roland_turn_end:GetBehavior()
	local hCaster = self:GetCaster()
	local nBehavior = self.BaseClass.GetBehavior(self)
	if not hCaster:IsStunned() and hCaster:HasModifier("modifier_roland_animation_generic_self_paused") then
		nBehavior = bit.bor(nBehavior, DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE)
	end
	return nBehavior
end
function roland_turn_end:OnSpellStart()
	local hCaster = self:GetCaster()

	ROLAND_TurnEnd(hCaster)
end




--====================================================================================================--
LinkLuaModifier("modifier_roland_turn_phase", "heroes/roland/roland_card", LUA_MODIFIER_MOTION_NONE)

modifier_roland_turn_phase = class({})

function modifier_roland_turn_phase:IsHidden()															return false end
function modifier_roland_turn_phase:IsDebuff()															return false end
function modifier_roland_turn_phase:IsPurgable()														return false end
function modifier_roland_turn_phase:IsPurgeException()													return false end
function modifier_roland_turn_phase:RemoveOnDeath()														return true end
function modifier_roland_turn_phase:GetAttributes()														return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_turn_phase:GetPriority()														return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_roland_turn_phase:OnCreated(tInfo)
	self._hCaster  = self:GetCaster()
	self._hParent  = self:GetParent()
	self._hAbility = self:GetAbility()

	self._nCardsDrawPerTurn = self._hAbility:GetSpecialValueFor("cards_draw_per_turn")
	self._nCardsDiscardPerTurn = self._hAbility:GetSpecialValueFor("cards_discard_per_turn")
	self._nLightPerTurn = self._hAbility:GetSpecialValueFor("light_per_turn")

	if not IsServer() then return end

	self._hParent:SwapAbilities("roland_turn_start", "roland_turn_end", false, true)

	self._vStartPos = Vector(tInfo.start_x or 0, tInfo.start_y or 0, tInfo.start_z or 0)
end
function modifier_roland_turn_phase:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_roland_turn_phase:OnDestroy()
	if not IsServer() then return end

	self._hParent:SwapAbilities("roland_turn_start", "roland_turn_end", true, false)

	ROLAND_CardDiscardUsed(self._hParent)
	ROLAND_CardDiscardSome(self._hParent, self._nCardsDiscardPerTurn)
	ROLAND_CardDrawSome(self._hParent, self._nCardsDrawPerTurn)

	ROLAND_LightAdd(self._hParent, self._nLightPerTurn)

	RemoveSpecialAnimations(self._hParent, true)

	ROLAND_TurnCardClear(self._hParent)

	self:DashBack()
end
function modifier_roland_turn_phase:DashBack()
	local hCaster = self._hParent
	local vPoint = self._vStartPos

	local nDistance = GetDistance(vPoint, hCaster)

	local vDir = GetDirection(vPoint, hCaster)
	vDir = nDistance <= 32 and -hCaster:GetForwardVector() or vDir

	local tDash =
	{
		caster = hCaster,

		-- team_id = tInfo.team_id,
		-- target_team = tInfo.target_team,
		-- target_type = tInfo.target_type,
		-- target_flags = tInfo.target_flags,

		radius = 0,

		stunnable = 0,

		sound = "roland_turn.end",

		-- on_hit
		-- on_end

		particle_seq = 6,
		particle_dash = 0,
	}

	local tMotion =
	{
		facing = -1,
		duration = self._hAbility:GetSpecialValueFor("turn_dash_time"),
		dir_x = vDir.x,
		dir_y = vDir.y,
		distance = nDistance,
	}

	local tAnim =
	{
		pause = -1,
		pause_sync = 1,
		activity = ACT_DOTA_CAST_ABILITY_2_END,
		-- activities = json.encode({_tInfo.da_act_mod}),
		rate = GetAnimPlayRate(15, 15, 30, tMotion.duration),
		rate_time = tMotion.duration,
	}

	local function OnHit(hTarget, _nIndex)
	end

	local function OnEnd(hTarget, bInterrupted)
		if bInterrupted then return end
	end

	tDash.on_hit = OnHit
	tDash.on_end = OnEnd

	ROLAND_DashUniversal(tDash, tMotion, tAnim)
end










--====================================================================================================--
LinkLuaModifier("modifier_roland_turn_card_pool", "heroes/roland/roland_card", LUA_MODIFIER_MOTION_NONE)

modifier_roland_turn_card_pool = class({})

function modifier_roland_turn_card_pool:IsHidden()															return true end
function modifier_roland_turn_card_pool:IsDebuff()															return false end
function modifier_roland_turn_card_pool:IsPurgable()														return false end
function modifier_roland_turn_card_pool:IsPurgeException()													return false end
function modifier_roland_turn_card_pool:RemoveOnDeath()														return false end
function modifier_roland_turn_card_pool:GetAttributes()														return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_turn_card_pool:GetPriority()														return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_roland_turn_card_pool:DeclareFunctions()
	local t =
	{
		MODIFIER_PROPERTY_FIXED_MANA_REGEN,
		MODIFIER_PROPERTY_CONVERT_MANA_COST_TO_HEALTH_COST,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
	return t
end
function modifier_roland_turn_card_pool:GetModifierFixedManaRegen(keys)
	return -1
end
function modifier_roland_turn_card_pool:GetModifierConvertManaCostToHealthCost(keys)
	return 1
end
function modifier_roland_turn_card_pool:OnAbilityExecuted(keys)
	if self._hParent ~= keys.unit or IsNull(keys.ability) or keys.ability:IsItem() then return end
	local _nTimeNow = GameRules:GetGameTime()
	if (_nTimeNow - (self._nAbilityCastCCImmuneCD * self._hParent:GetCooldownReduction())) >= self._nLastImmuneTime then
		self._nLastImmuneTime = _nTimeNow
		self._hParent:AddNewModifier(self._hCaster, self._hAbility, "modifier_roland_cc_immune", {duration = self._nAbilityCastCCImmuneTime})
	end
end
function modifier_roland_turn_card_pool:OnCreated(tInfo)
	self._hCaster  = self:GetCaster()
	self._hParent  = self:GetParent()
	self._hAbility = self:GetAbility()

	self._nCardsStart = self._hAbility:GetSpecialValueFor("cards_start")
	self._nLightStartMax = self._hAbility:GetSpecialValueFor("light_start_max")
	self._nLightStartNow = self._hAbility:GetSpecialValueFor("light_start_now")

	self._nLightMaxPerHeroLvl = self._hAbility:GetSpecialValueFor("light_max_per_hero_lvl")

	self._nLightRegenDelay = self._hAbility:GetSpecialValueFor("light_regen_delay")
	self._nLightRegenCount = self._hAbility:GetSpecialValueFor("light_regen_count")

	self._nAbilityCastCCImmuneCD = self._hAbility:GetSpecialValueFor("ability_cast_cc_immune_cd")
	self._nAbilityCastCCImmuneTime = self._hAbility:GetSpecialValueFor("ability_cast_cc_immune_time")

	if not IsServer() then return end

	self._hLightMax = IsNotNull(self._hLightMax) and self._hLightMax or self._hParent:AddNewModifier(self._hCaster, self._hAbility, sLIGHT_MAX, {})
	self._hLightNow = IsNotNull(self._hLightNow) and self._hLightNow or self._hParent:AddNewModifier(self._hCaster, self._hAbility, sLIGHT_NOW, {})

	self._hFuriosoController = IsNotNull(self._hFuriosoController) and self._hFuriosoController or self._hParent:AddNewModifier(self._hCaster, self._hAbility, "modifier_roland_furioso_controller", {})

	self._hStreakControllerSounds = IsNotNull(self._hStreakControllerSounds) and self._hStreakControllerSounds or self._hParent:AddNewModifier(self._hCaster, self._hAbility, "modifier_roland_streak_controller_sounds", {})
	
	local bInited = ROLAND_InitCards(self._hParent)

	if not bInited then return end

	ROLAND_LightSetMax(self._hParent, self._nLightStartMax)
	ROLAND_LightSetNow(self._hParent, self._nLightStartNow)

	if self._nCardsStart > 0 then
		for i = 1, self._nCardsStart do
			ROLAND_CardAdd(self._hParent, ROLAND_CardDraw(self._hParent), ROLAND_GetSlotFree(self._hParent))
		end
	end

	self._nThinkTime = FrameTime()
	self._nLastRegenTime = GameRules:GetGameTime()
	self._nLastImmuneTime = 0

	self:OnIntervalThink()
	self:StartIntervalThink(self._nThinkTime)
end
function modifier_roland_turn_card_pool:OnRefresh(tInfo)
	self:OnCreated(tInfo)

	if not IsServer() then return end

	ROLAND_LightSetMax(self._hParent, self._nLightStartMax + self._nLightMaxPerHeroLvl * self._hParent:GetLevel())
end
function modifier_roland_turn_card_pool:OnIntervalThink()
	if not IsServer() then return end

	local _nTimeNow = GameRules:GetGameTime()
	if (_nTimeNow - self._nLightRegenDelay) >= self._nLastRegenTime then
		self._nLastRegenTime = _nTimeNow
		ROLAND_LightAdd(self._hParent, self._nLightRegenCount)
	end

	local nLightMax = ROLAND_GetLightMax(self._hParent)
	local nLightNow = ROLAND_GetLightNow(self._hParent)

	if nLightMax ~= self._hParent:GetMaxMana() then
		self._hParent:SetMaxMana(nLightMax)
	end

	if nLightNow ~= self._hParent:GetMana() then
		self._hParent:SetMana(nLightNow)
	end
end
function modifier_roland_turn_card_pool:OnDestroy()
	if not IsServer() then return end

	if IsNotNull(self._hLightMax) then
		self._hLightMax:Destroy()
	end

	if IsNotNull(self._hLightNow) then
		self._hLightNow:Destroy()
	end

	if IsNotNull(self._hFuriosoController) then
		self._hFuriosoController:Destroy()
	end

	if IsNotNull(self._hStreakControllerSounds) then
		self._hStreakControllerSounds:Destroy()
	end
end

--====================================================================================================--
LinkLuaModifier("modifier_roland_turn_light_max", "heroes/roland/roland_card", LUA_MODIFIER_MOTION_NONE)

modifier_roland_turn_light_max = class({})

function modifier_roland_turn_light_max:IsHidden()															return false end
function modifier_roland_turn_light_max:IsDebuff()															return false end
function modifier_roland_turn_light_max:IsPurgable()														return false end
function modifier_roland_turn_light_max:IsPurgeException()													return false end
function modifier_roland_turn_light_max:RemoveOnDeath()														return false end
function modifier_roland_turn_light_max:GetAttributes()														return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_turn_light_max:GetPriority()														return MODIFIER_PRIORITY_SUPER_ULTRA end


--====================================================================================================--
LinkLuaModifier("modifier_roland_turn_light_now", "heroes/roland/roland_card", LUA_MODIFIER_MOTION_NONE)

modifier_roland_turn_light_now = class({})

function modifier_roland_turn_light_now:IsHidden()															return false end
function modifier_roland_turn_light_now:IsDebuff()															return false end
function modifier_roland_turn_light_now:IsPurgable()														return false end
function modifier_roland_turn_light_now:IsPurgeException()													return false end
function modifier_roland_turn_light_now:RemoveOnDeath()														return false end
function modifier_roland_turn_light_now:GetAttributes()														return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_turn_light_now:GetPriority()														return MODIFIER_PRIORITY_SUPER_ULTRA end




--====================================================================================================--
LinkLuaModifier("modifier_roland_cc_immune", "heroes/roland/roland_card", LUA_MODIFIER_MOTION_NONE)

modifier_roland_cc_immune = class({})

function modifier_roland_cc_immune:IsHidden()															return false end
function modifier_roland_cc_immune:IsDebuff()															return false end
function modifier_roland_cc_immune:IsPurgable()															return false end
function modifier_roland_cc_immune:IsPurgeException()													return false end
function modifier_roland_cc_immune:RemoveOnDeath()														return true end
function modifier_roland_cc_immune:GetAttributes()														return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_cc_immune:GetPriority()														return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_roland_cc_immune:CheckState()
	local t =
	{
		[MODIFIER_STATE_DEBUFF_IMMUNE] = true
	}
	return t
end









--====================================================================================================--
LinkLuaModifier("modifier_roland_furioso_controller", "heroes/roland/roland_card", LUA_MODIFIER_MOTION_NONE)

modifier_roland_furioso_controller = class({})

function modifier_roland_furioso_controller:IsHidden()															return false end
function modifier_roland_furioso_controller:IsDebuff()															return false end
function modifier_roland_furioso_controller:IsPurgable()														return false end
function modifier_roland_furioso_controller:IsPurgeException()													return false end
function modifier_roland_furioso_controller:RemoveOnDeath()														return false end
function modifier_roland_furioso_controller:DestroyOnExpire()													return false end
function modifier_roland_furioso_controller:GetAttributes()														return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_furioso_controller:GetPriority()														return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_roland_furioso_controller:DeclareFunctions()
	local t =
	{
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
	return t
end
function modifier_roland_furioso_controller:OnAbilityExecuted(keys)
	if self._hParent ~= keys.unit or IsNull(keys.ability) or keys.ability:IsItem() then return end
	self:CheckFuriosoActivate(keys.ability)
end
function modifier_roland_furioso_controller:OnCreated(tInfo)
	self._hCaster = self:GetCaster()
	self._hParent = self:GetParent()
	self._hAbility = self:GetAbility()

	if not IsServer() then return end

	self.nSlotToDraw = self._hAbility:GetSpecialValueFor("furioso_slot_to_draw")

	self:ResetProgress()
end
function modifier_roland_furioso_controller:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_roland_furioso_controller:ResetProgress()
	self._tProgress = {}
	for _, sAbilityName in ipairs(ROLAND_FURIOSO_ABILITIES_SEQ) do
		self._tProgress[sAbilityName] = false
	end
	self:SetStackCount(0)
	self:SetDuration(-1, true)
	self:StartIntervalThink(-1)
end
function modifier_roland_furioso_controller:GetBaseName(sName)
	if string.sub(sName, -3) == "_ex" then
		return string.sub(sName, 1, #sName - 3)
	end
	return sName
end
function modifier_roland_furioso_controller:CheckFuriosoActivate(hAbility)
	local sName = hAbility:GetAbilityName()
	local sBase = self:GetBaseName(sName)

	if sBase == "roland_furioso" then
		self:ResetProgress()
		ROLAND_CardDiscard(self._hParent, self.nSlotToDraw, true)
		return
	end

	if not TableContains(ROLAND_FURIOSO_ABILITIES_SEQ, sBase) then return end
	if self._tProgress[sBase] then return end
	self._tProgress[sBase] = true

	local nStacks = self:GetStackCount() + 1
	self:SetStackCount(nStacks)
	
	local nAddTime = self._hAbility:GetSpecialValueFor("furioso_stack_duration")

	local nRemaining = self:GetRemainingTime()
	if nRemaining < 0 then
		nRemaining = 0
	end

	self:SetDuration(nAddTime, true)
	self:StartIntervalThink(0.01)

	for _, name in ipairs(ROLAND_FURIOSO_ABILITIES_SEQ) do
		if not self._tProgress[name] then
			return
		end
	end

	self:GiveFurioso()
	self:SetDuration(-1, true)
	self:StartIntervalThink(-1)
end
function modifier_roland_furioso_controller:OnIntervalThink()
	if not IsServer() then return end
	if self:GetRemainingTime() <= 0 then
		self:ResetProgress()
	end
end
function modifier_roland_furioso_controller:GiveFurioso()
	if not ROLAND_IsSlotValid(self._hParent, self.nSlotToDraw) then return end
	local hAbility = ROLAND_CardDraw(self._hParent, "roland_furioso")
	ROLAND_CardDiscard(self._hParent, self.nSlotToDraw, true)
	ROLAND_CardAdd(self._hParent, hAbility, self.nSlotToDraw)
end












--====================================================================================================--
LinkLuaModifier("modifier_roland_streak_controller_sounds", "heroes/roland/roland_card", LUA_MODIFIER_MOTION_NONE)

modifier_roland_streak_controller_sounds = class({})

function modifier_roland_streak_controller_sounds:IsHidden()															return true end
function modifier_roland_streak_controller_sounds:IsDebuff()															return false end
function modifier_roland_streak_controller_sounds:IsPurgable()															return false end
function modifier_roland_streak_controller_sounds:IsPurgeException()													return false end
function modifier_roland_streak_controller_sounds:RemoveOnDeath()														return false end
-- function modifier_roland_streak_controller_sounds:DestroyOnExpire()														return false end
function modifier_roland_streak_controller_sounds:GetAttributes()														return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_streak_controller_sounds:GetPriority()															return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_roland_streak_controller_sounds:DeclareFunctions()
	local t =
	{
		MODIFIER_EVENT_ON_HERO_KILLED
	}
	return t
end
function modifier_roland_streak_controller_sounds:OnHeroKilled(keys)
	if not IsServer() then return end
	if keys.attacker:GetOwner() == keys.target:GetOwner() then return end
	if keys.target:GetOwner() == self._hParent:GetOwner() then
		self._bKillStreak10 = false
		self._bKillStreak5 = false
		self._nKillStreak = 0
		self._nDeathStreak = self._nDeathStreak + 1
		if self._nDeathStreak >= 5 and not self._bDeathStreak5 then
			self._bDeathStreak5 = true
			StopSoundOn("roland_streak.lose_5", self._hParent)
			StopSoundOn("roland_streak.win_5", self._hParent)
			StopSoundOn("roland_streak.win_10", self._hParent)
			EmitSoundOn("roland_streak.lose_5", self._hParent)
			return
		end
	end
	if keys.attacker:GetOwner() == self._hParent:GetOwner() then
		self._bDeathStreak5 = false
		self._nDeathStreak = 0
		self._nKillStreak = self._nKillStreak + 1
		if self._nKillStreak >= 10 and not self._bKillStreak10 then
			self._bKillStreak10 = true
			StopSoundOn("roland_streak.lose_5", self._hParent)
			StopSoundOn("roland_streak.win_5", self._hParent)
			StopSoundOn("roland_streak.win_10", self._hParent)
			EmitSoundOn("roland_streak.win_10", self._hParent)
			self._hParent:AddNewModifier(self._hCaster, self._hAbility, "modifier_roland_invul_reading", {duration = self._hAbility:GetSpecialValueFor("streak_10_cast_duration")})
			return
		end
		if self._nKillStreak >= 5 and not self._bKillStreak5 then
			self._bKillStreak5 = true
			StopSoundOn("roland_streak.lose_5", self._hParent)
			StopSoundOn("roland_streak.win_5", self._hParent)
			StopSoundOn("roland_streak.win_10", self._hParent)

			EmitSoundOn("roland_streak.win_5", self._hParent)
			return
		end
	end
end
function modifier_roland_streak_controller_sounds:OnCreated(tInfo)
	self._hCaster = self:GetCaster()
	self._hParent = self:GetParent()
	self._hAbility = self:GetAbility()

	if not IsServer() then return end

	self._nDeathStreak = self._nDeathStreak or 0
	self._nKillStreak = self._nKillStreak or 0
end
function modifier_roland_streak_controller_sounds:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end















--====================================================================================================--
LinkLuaModifier("modifier_roland_invul_reading", "heroes/roland/roland_card", LUA_MODIFIER_MOTION_NONE)

modifier_roland_invul_reading = class({})

function modifier_roland_invul_reading:IsHidden()															return false end
function modifier_roland_invul_reading:IsDebuff()															return false end
function modifier_roland_invul_reading:IsPurgable()															return false end
function modifier_roland_invul_reading:IsPurgeException()													return false end
function modifier_roland_invul_reading:RemoveOnDeath()														return false end
-- function modifier_roland_invul_reading:DestroyOnExpire()													return false end
function modifier_roland_invul_reading:GetAttributes()														return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_invul_reading:GetPriority()														return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_roland_invul_reading:CheckState()
	local t =
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	return t
end
function modifier_roland_invul_reading:OnCreated(tInfo)
	self._hCaster = self:GetCaster()
	self._hParent = self:GetParent()
	self._hAbility = self:GetAbility()

	if not IsServer() then return end

	local tAnim =
	{
		duration = self:GetDuration(),
		pause = 0,
		pause_sync = 1,
		activity = ACT_DOTA_CHANNEL_ABILITY_1,
	}

	local hAnim = self._hParent:AddNewModifier(self._hParent, self._hAbility, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	local hPlayer = PlayerResource:GetPlayer(self._hParent:GetPlayerOwnerID())
	local nScreenParticle = ParticleManager:CreateParticleForPlayer("particles/heroes/roland/roland_streak/roland_streak_screen.vpcf", PATTACH_ABSORIGIN_FOLLOW, self._hParent, hPlayer)
							ParticleManager:SetParticleControl(nScreenParticle, 9, Vector(self:GetDuration(), 0, 0))
							ParticleManager:ReleaseParticleIndex(nScreenParticle)
end
function modifier_roland_invul_reading:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_roland_invul_reading:OnDestroy()
	if not IsServer() then return end

	self._hParent:AddNewModifier(self._hCaster, self._hAbility, "modifier_roland_invul_reading_buff", {duration = self._hAbility:GetSpecialValueFor("streak_10_buff_duration")})
end







--====================================================================================================--
LinkLuaModifier("modifier_roland_invul_reading_buff", "heroes/roland/roland_card", LUA_MODIFIER_MOTION_NONE)

modifier_roland_invul_reading_buff = class({})

function modifier_roland_invul_reading_buff:IsHidden()															return false end
function modifier_roland_invul_reading_buff:IsDebuff()															return false end
function modifier_roland_invul_reading_buff:IsPurgable()														return false end
function modifier_roland_invul_reading_buff:IsPurgeException()													return false end
function modifier_roland_invul_reading_buff:RemoveOnDeath()														return false end
-- function modifier_roland_invul_reading_buff:DestroyOnExpire()													return false end
function modifier_roland_invul_reading_buff:GetAttributes()														return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_invul_reading_buff:GetPriority()														return MODIFIER_PRIORITY_SUPER_ULTRA end
function modifier_roland_invul_reading_buff:DeclareFunctions()
	local t =
	{
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return t
end
function modifier_roland_invul_reading_buff:GetModifierMoveSpeed_Absolute(keys)
	return self._streak_10_buff_abs_ms
end
function modifier_roland_invul_reading_buff:GetModifierPercentageCooldown(keys)
	return self._streak_10_buff_cdr
end
function modifier_roland_invul_reading_buff:GetModifierSpellAmplify_Percentage(keys)
	return self._streak_10_buff_amp
end
function modifier_roland_invul_reading_buff:OnCreated(tInfo)
	self._hCaster = self:GetCaster()
	self._hParent = self:GetParent()
	self._hAbility = self:GetAbility()

	if not IsServer() then return end

	self._streak_10_buff_abs_ms = self._hAbility:GetSpecialValueFor("streak_10_buff_abs_ms")
	self._streak_10_buff_cdr = self._hAbility:GetSpecialValueFor("streak_10_buff_cdr")
	self._streak_10_buff_amp = self._hAbility:GetSpecialValueFor("streak_10_buff_amp")

	local tAnim =
	{
		duration = 0.2,
		pause = 0,
		pause_sync = 1,
		activity = ACT_DOTA_CAST_ABILITY_4,
		rate = GetAnimPlayRate(29, 29, 30, 0.2),
		rate_time = 0.2,
	}

	local hAnim = self._hParent:AddNewModifier(self._hParent, self._hAbility, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	local nPFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_streak/roland_streak_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self._hParent)

	self:AddParticle(nPFX, false, false, -1, false, false)
end
function modifier_roland_invul_reading_buff:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_roland_invul_reading_buff:OnDestroy()
	if not IsServer() then return end

	local tAnim =
	{
		duration = 0.2,
		pause = 0,
		pause_sync = 1,
		activity = ACT_DOTA_CAST_ABILITY_4_END,
		rate = GetAnimPlayRate(17, 17, 30, 0.2),
		rate_time = 0.2,
	}

	local hAnim = self._hParent:AddNewModifier(self._hParent, self._hAbility, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end
end


























--====================================================================================================--
--====================================================================================================--
roland_card = class({})

-- function roland_card:OnUpgrade()
-- end
function roland_card:GetPlaybackRateOverride()
	return GetAnimPlayRate(6, 6, 30, self:GetCastPoint())
end
function roland_card:GetCooldown(nLevel)
	if string.match(self:GetAbilityName(), "_ex") then return self:GetSpecialValueFor("cd_ex") end
	return self.BaseClass.GetCooldown(self, nLevel)
end
function roland_card:GetHealthCost(nLevel)
	if not IsClient() then return 0 end
	return ROLAND_GetLightCost(self:GetCaster(), self, nLevel)
end
function roland_card:CastFilterResult()
	return ROLAND_CastFilterResult(self:GetCaster(), self, nil, nil)
end
function roland_card:CastFilterResultTarget(hTarget)
	return ROLAND_CastFilterResult(self:GetCaster(), self, hTarget, nil)
end
function roland_card:CastFilterResultLocation(vLocation)
	return ROLAND_CastFilterResult(self:GetCaster(), self, nil, vLocation)
end
function roland_card:GetCustomCastError()
	return self._sFilterError
end
function roland_card:GetCustomCastErrorTarget(hTarget)
	return self._sFilterError
end
function roland_card:GetCustomCastErrorLocation(vLocation)
	return self._sFilterError
end
function roland_card:GetBehavior()
	local hCaster = self:GetCaster()
	local nBehavior = self.BaseClass.GetBehavior(self)
	local hChangeAbility = hCaster:FindAbilityByName("roland_change")
	if IsNotNull(hChangeAbility) and hChangeAbility:GetToggleState() and not string.match(self:GetAbilityName(), "roland_slot_") then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_DIRECTIONAL + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	end
	return nBehavior
end
function roland_card:OnSpellStart()
	local hCaster = self:GetCaster()

	local nCost = ROLAND_GetLightCost(self:GetCaster(), self, self:GetLevel())

	if not Convars:GetBool("dota_ability_debug") then
		ROLAND_LightSpend(hCaster, nCost)
	end

	local bCardMode = true
	local hChangeAbility = hCaster:FindAbilityByName("roland_change")
	if IsNotNull(hChangeAbility) then
		bCardMode = not hChangeAbility:GetToggleState()
	end

	local hTurnAbility = hCaster:FindAbilityByName("roland_turn_start")
	if IsNotNull(hTurnAbility) then
		local nCD = math.max(0, hTurnAbility:GetCooldownTimeRemaining() + self:GetSpecialValueFor("turn_cd_reduce")) * hCaster:GetCooldownReduction()
		hTurnAbility:EndCooldown()
		hTurnAbility:StartCooldown(nCD)
	end

	if not bCardMode then
		local vPoint = self:GetCursorPosition()
		self:PreCastDashToTarget(hCaster, vPoint, GetDirection(vPoint, hCaster))
		return
	end

	ROLAND_TurnCardAdd(hCaster, self, self:GetSpecialValueFor("rarity"), nCost, self:GetSpecialValueFor("type"))
end
function roland_card:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("dash_cast_range")
end
function roland_card:DashToWithCallback(tDash, tMotion, tAnim)
	return ROLAND_DashUniversal(tDash, tMotion, tAnim)
end
-- function roland_card:OnCardDashCast(hCaster)
-- 	local vPoint = self:GetCursorPosition()
-- 	local nDistance = self:GetCastRange(vPoint, hCaster)
-- 	local vDir = GetDirection(vPoint, hCaster)
-- 	vDir = GetDistance(vPoint, hCaster) <= 32 and hCaster:GetForwardVector() or vDir

-- 	local tDash =
-- 	{
-- 		caster = hCaster,

-- 		team_id = hCaster:GetTeamNumber(),
-- 		target_team = self:GetAbilityTargetTeam(),
-- 		target_type = self:GetAbilityTargetType(),
-- 		target_flags = self:GetAbilityTargetFlags(),

-- 		radius = self:GetSpecialValueFor("dash_cast_hit_radius"),

-- 		stunnable = self:GetSpecialValueFor("dash_cast_stunnable"),

-- 		sound = "roland_turn.end",

-- 		-- on_hit
-- 		-- on_end

-- 		particle_seq = 4,
-- 		particle_dash = 0,
-- 	}

-- 	local tMotion =
-- 	{
-- 		dir_x = vDir.x,
-- 		dir_y = vDir.y,
-- 		distance = nDistance,
-- 		speed = self:GetSpecialValueFor("dash_cast_speed"),
-- 	}

-- 	local tAnim =
-- 	{
-- 		pause = -1,
-- 		pause_sync = 1,
-- 		activity = ACT_DOTA_CAST_ABILITY_1_END,
-- 		-- activities = json.encode({""}),
-- 		rate = GetAnimPlayRate(20, 15, 30, 1),
-- 		rate_time = 1,
-- 	}

-- 	local function OnHit(hTarget, _nIndex)
-- 		return true
-- 	end

-- 	local function OnEnd(hTarget, bInterrupted)
-- 		if bInterrupted or IsNull(hTarget) then return end
-- 		self:OnCardDashImpact(hCaster, hTarget, vDir)
-- 		EmitSoundOn("roland_card.cast", hCaster)
-- 	end

-- 	tDash.on_hit = OnHit
-- 	tDash.on_end = OnEnd

-- 	self:DashToWithCallback(tDash, tMotion, tAnim)
-- end
function roland_card:OnCardDashImpact(hCaster, hTarget, vDir)

end
function roland_card:SetInterruptAndFacing(hAnim, vhTarget, nTimeEnd, nRangeDestroy, bStunnable)
	ROLAND_FacingUniversal(hAnim, vhTarget, nTimeEnd, nRangeDestroy, bStunnable)
end
function roland_card:DoDamage(tInfo)
	local tDamage = 
	{
		victim		= tInfo.target,
		attacker	= tInfo.caster, 
		damage		= tInfo.damage,
		damage_type = self:GetAbilityDamageType(),
		ability 	= self,
		-- damage_flags = keys.damage_flags,
	}
	ApplyDamage(tDamage)
end
function roland_card:AddKnock(tInfo)
	local tMotion =
	{
		facing = 0,
		facing_cast = 0,
		duration = tInfo.knock_time,
		dir_x = tInfo.dir.x,
		dir_y = tInfo.dir.y,
		distance = tInfo.knock_range,
		path_trees = tInfo.path_trees,
		path_hg = tInfo.path_hg,
		path_blocked = tInfo.path_blocked,
	}
	local hMotion = tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_roland_motion_generic", tMotion)
	if IsNull(hMotion) or hMotion:IsInterrupted() then return end
	return hMotion
end
function roland_card:AddStun(tInfo)
	local nStunTime = tInfo.stun_time
	if not nStunTime or nStunTime == 0 then return end

	local hStun = tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_stunned", {duration = nStunTime})

	local tAnim =
	{
		duration = nStunTime,
		pause = 0,
		pause_sync = 1,
		activity = ACT_DOTA_DISABLED,
	}

	local hAnim = tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	hAnim:AddCallbackThink(FrameTime(), function(hMod, _tTimer, nTime)
		if IsNull(hStun) and IsNotNull(hAnim) then hAnim:Destroy() end
		return nTime
	end)

	return hStun
end
function roland_card:AddRoot(tInfo)
	local nRootTime = tInfo.root_time
	if not nRootTime or nRootTime == 0 then return end
	return tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_rooted", {duration = nRootTime})
end
function roland_card:AddInvul(tInfo)
	local nInvulTime = tInfo.invul_time
	if not nInvulTime or nInvulTime == 0 then return end
	return tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_roland_card_invul", {duration = nInvulTime})
end














function roland_card:SlashPFX(hCaster, vOffset, nRadius, nScale, vRotate)
	local nSlashPFX =   ParticleManager:CreateParticle("particles/heroes/roland/roland_slash/roland_slash_universal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
						ParticleManager:SetParticleShouldCheckFoW(nSlashPFX, false)
						ParticleManager:SetParticleControl(nSlashPFX, 1, hCaster:GetAbsOrigin() + vOffset)
						ParticleManager:SetParticleControl(nSlashPFX, 2, Vector(nRadius or 0, nScale or 0, 0))
						ParticleManager:SetParticleControl(nSlashPFX, 3, vRotate or Vector(0, 0, 0))
						ParticleManager:ReleaseParticleIndex(nSlashPFX)
	return nSlashPFX
end
function roland_card:SlashPFX_Red(hCaster, vOffset, nRadius, nScale, vRotate)
	local nSlashPFX =   ParticleManager:CreateParticle("particles/heroes/roland/roland_slash/roland_slash_universal_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
						ParticleManager:SetParticleShouldCheckFoW(nSlashPFX, false)
						ParticleManager:SetParticleControl(nSlashPFX, 1, hCaster:GetAbsOrigin() + vOffset)
						ParticleManager:SetParticleControl(nSlashPFX, 2, Vector(nRadius or 0, nScale or 0, 0))
						ParticleManager:SetParticleControl(nSlashPFX, 3, vRotate or Vector(0, 0, 0))
						ParticleManager:ReleaseParticleIndex(nSlashPFX)
	return nSlashPFX
end














function roland_card:TurnPlayNext(hCaster, hTarget, vDir)
	local hChangeAbility = hCaster:FindAbilityByName("roland_change")
	if IsNotNull(hChangeAbility) and hChangeAbility:GetToggleState() then
		return
	end

	local hCardNext = ROLAND_TurnCardGet(hCaster, 1)
	if IsNull(hCardNext) then
		ROLAND_TurnEnd(hCaster)
		return
	end

	ROLAND_TurnCardRemove(hCaster, 1)

	hCardNext:PreCastDashToTarget(hCaster, hTarget, vDir)

	EmitSoundOn("roland_card.cast", hCaster)
end
function roland_card:PreCastDashToTarget(hCaster, hTarget, vDir)
	local tDash =
	{
		caster = hCaster,

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		radius = self:GetSpecialValueFor("dash_cast_hit_radius"),

		stunnable = self:GetSpecialValueFor("dash_cast_stunnable"),

		sound = "roland_turn.end",

		-- on_hit
		-- on_end

		particle_seq = 4,
		particle_dash = 0,
	}

	local tMotion =
	{
		dir_x = vDir.x,
		dir_y = vDir.y,
		distance = GetDistance(hTarget, hCaster) + tDash.radius,
		speed = self:GetSpecialValueFor("dash_cast_speed"),
	}

	local tAnim =
	{
		pause = -1,
		pause_sync = 1,
		activity = ACT_DOTA_CAST_ABILITY_1_END,
		-- activities = json.encode({""}),
		rate = GetAnimPlayRate(20, 15, 30, 1),
		rate_time = 1,
	}

	local function OnHit(hTarget, _nIndex)
		return true
	end

	local function OnEnd(hTarget, bInterrupted)
		if bInterrupted or IsNull(hTarget) then return end
		self:OnCardDashImpact(hCaster, hTarget, vDir)
		EmitSoundOn("roland_card.cast", hCaster)
	end

	tDash.on_hit = OnHit
	tDash.on_end = OnEnd

	self:DashToWithCallback(tDash, tMotion, tAnim)
end





--====================================================================================================--
LinkLuaModifier("modifier_roland_card_invul", "heroes/roland/roland_card", LUA_MODIFIER_MOTION_NONE)

modifier_roland_card_invul = class({})

function modifier_roland_card_invul:IsHidden()										return false end
function modifier_roland_card_invul:IsDebuff()										return false end
function modifier_roland_card_invul:IsPurgable()									return false end
function modifier_roland_card_invul:IsPurgeException()								return false end
function modifier_roland_card_invul:RemoveOnDeath()									return true end
function modifier_roland_card_invul:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_card_invul:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_roland_card_invul:CheckState()
	local t = 
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
	return t
end




--====================================================================================================--
--====================================================================================================--
roland_slot_1 = class(roland_card)
--====================================================================================================--
--====================================================================================================--
roland_slot_2 = class(roland_card)
--====================================================================================================--
--====================================================================================================--
roland_slot_3 = class(roland_card)
--====================================================================================================--
--====================================================================================================--
roland_slot_4 = class(roland_card)
--====================================================================================================--
--====================================================================================================--
roland_slot_5 = class(roland_card)




















roland_change = class({})

function roland_change:ResetToggleOnRespawn()							return false end
function roland_change:OnOwnerDied()									end
function roland_change:OnOwnerSpawned()									end
function roland_change:OnOwnerSpawned()
	if self._bToggleState and self._bToggleState ~= self:GetToggleState() then
		self:ToggleAbility()
	end
end
function roland_change:GetAbilityTextureName()
	return self:GetToggleState() and "heroes/roland/roland_change_2" or "heroes/roland/roland_change_1"
end
function roland_change:OnToggle()
	local hCaster = self:GetCaster()
	local bAlive = hCaster:IsAlive()
	local bToggle = bAlive and self:GetToggleState()

	if bAlive then
		self._bToggleState = bToggle
	end

	self:SetActivated(false)
end