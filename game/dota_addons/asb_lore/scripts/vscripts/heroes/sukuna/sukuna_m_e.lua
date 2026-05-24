require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_m_e = class({})

function sukuna_m_e:IsRecastState()
	local hCaster = self:GetCaster()
	return hCaster:HasModifier("modifier_sukuna_m_e_recast")
end
function sukuna_m_e:GetAbilityTextureName()
	if self:IsRecastState() then
		return "heroes/sukuna/sukuna_m_e_e"
	end
	return self.BaseClass.GetAbilityTextureName(self)
end
function sukuna_m_e:GetBehavior()
	local hCaster = self:GetCaster()
	if self:IsRecastState() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
	return self.BaseClass.GetBehavior(self)
end
function sukuna_m_e:GetPlaybackRateOverride()
	return GetAnimPlayRate(10, 9, 30, self:GetCastPoint())
end
function sukuna_m_e:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sukuna_animation_generic_activity", {duration = 0.1, activity = "mage"})
	return true
end
function sukuna_m_e:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
end
function sukuna_m_e:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	local tInfo =
	{
		target = hTarget,
		caster = hCaster,

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		stun_duration = self:GetSpecialValueFor("stun_duration"),

		ca_time = self:GetSpecialValueFor("ca_time"),
		ca_stunnable = 1,

		ca_act = ACT_DOTA_CAST_ABILITY_3_END,
		ca_act_mod = "mage",

		hits_delay = self:GetSpecialValueFor("hits_delay"),
		hits = self:GetSpecialValueFor("hits"),
		hits_tick = self:GetSpecialValueFor("hits_tick"),

		damage = self:GetSpecialValueFor("damage"),

		recast_time = self:GetSpecialValueFor("recast_time"),

		dash_duration = self:GetSpecialValueFor("dash_duration") + FindTalentValue(hCaster, "special_bonus_sukuna_25l"),
		dash_speed = self:GetSpecialValueFor("dash_speed"),
		dash_radius = self:GetSpecialValueFor("dash_radius"),
		dash_damage_interval = self:GetSpecialValueFor("dash_damage_interval"),
		dash_damage = self:GetSpecialValueFor("dash_damage"),
	}

	tInfo.ca_rate = GetAnimPlayRate(38, 37, 30, tInfo.ca_time)
	tInfo.ca_impact_time = GetAnimImpactTime(38, 10, 30, tInfo.ca_time)

	if self:IsRecastState() then
		tInfo.caster:RemoveModifierByNameAndCaster("modifier_sukuna_m_e_recast", tInfo.caster)
		tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_m_e_e_slashing_motion", {duration = tInfo.dash_duration})
	else
		if hTarget:TriggerSpellAbsorb(self) then
			return
		end

		tInfo.dir = GetDirection(hTarget, hCaster)

		self:CastAnimation(tInfo)

		tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_m_e_recast", {duration = tInfo.recast_time})
	end
end
function sukuna_m_e:CastAnimation(tInfo)
	local tAnim =
	{
		duration = tInfo.ca_time,
		pause = -1,
		pause_sync = 1,
		activity = tInfo.ca_act,
		activities = json.encode({tInfo.ca_act_mod}),
		rate = tInfo.ca_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	hAnim:AddCallbackThink(FrameTime(), function(hMod, _tTimer, nTime)
		if tInfo.ca_stunnable > 0 and tInfo.caster:IsStunned() then
			hMod:Destroy(true)
			return
		end
		return nTime
	end)

	hAnim:AddCallbackThink(tInfo.ca_impact_time, function(hMod)
		EmitSoundOn("sukuna_web.slash", tInfo.caster)

		local nPFX_Impact = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_impact/sukuna_impact.vpcf", PATTACH_CENTER_FOLLOW, tInfo.caster)
						ParticleManager:ReleaseParticleIndex(nPFX_Impact)

		FindClearSpaceForUnit(tInfo.caster, tInfo.target:GetAbsOrigin() + tInfo.dir * -128, true)

		tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_stunned", {duration = tInfo.stun_duration})

		Timers:CreateTimer(tInfo.hits_delay, function()
			local nSlashesPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_slashes_target/sukuna_slashes_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, tInfo.target)

			local nHits = 0
			Timers:CreateTimer(0, function()
				if nHits >= tInfo.hits then
					ParticleManager:DestroyParticle(nSlashesPFX, false)
					ParticleManager:ReleaseParticleIndex(nSlashesPFX)
					return
				end
				nHits = nHits + 1
				self:SlashTarget({
					target = tInfo.target,
					caster = tInfo.caster,
					damage = tInfo.damage,
				})
				return tInfo.hits_tick
			end)
		end)
	end)

	hAnim:AddCallbackEnd(function(hMod)
	end)
end
function sukuna_m_e:SlashTarget(tInfo)
	local vCasterPos = tInfo.caster:GetAbsOrigin()
	local vNeedPos = tInfo.target:GetAbsOrigin() + Vector(tInfo.dir_x, tInfo.dir_y, 0) * -64

	tInfo.caster:SetAbsOrigin(vNeedPos)

	tInfo.caster:PerformAttack(
		tInfo.target,
		true,
		true,
		true,
		true,
		false,
		false,
		true)

	tInfo.caster:SetAbsOrigin(vCasterPos)

	local tDamage =
	{
		victim = tInfo.target,
		attacker = tInfo.caster, 
		damage = tInfo.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self,
		-- damage_flags = keys.damage_flags,
	}

	ApplyDamage(tDamage)
end


--====================================================================================================--
LinkLuaModifier("modifier_sukuna_m_e_recast", "heroes/sukuna/sukuna_m_e", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_m_e_recast = class({})

function modifier_sukuna_m_e_recast:IsHidden()										return false end
function modifier_sukuna_m_e_recast:IsDebuff()										return false end
function modifier_sukuna_m_e_recast:IsPurgable()									return false end
function modifier_sukuna_m_e_recast:IsPurgeException()								return false end
function modifier_sukuna_m_e_recast:RemoveOnDeath()									return true end
function modifier_sukuna_m_e_recast:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_sukuna_m_e_recast:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_sukuna_m_e_recast:OnCreated(tInfo)
	self._hCaster  = self:GetCaster()
	self._hParent  = self:GetParent()
	self._hAbility = self:GetAbility()

	if not IsServer() then return end

	self._hAbility:RefundManaCost()
	self._hAbility:RefundHealthCost()
	self._hAbility:EndCooldown()
end
function modifier_sukuna_m_e_recast:OnDestroy()
	if not IsServer() then return end

	self._hAbility:UseResources(true, true, false, true)
end




--====================================================================================================--
LinkLuaModifier("modifier_sukuna_m_e_e_slashing_motion", "heroes/sukuna/sukuna_m_e", LUA_MODIFIER_MOTION_HORIZONTAL)

modifier_sukuna_m_e_e_slashing_motion = class({})

function modifier_sukuna_m_e_e_slashing_motion:IsHidden()										return false end
function modifier_sukuna_m_e_e_slashing_motion:IsDebuff()										return false end
function modifier_sukuna_m_e_e_slashing_motion:IsPurgable()										return false end
function modifier_sukuna_m_e_e_slashing_motion:IsPurgeException()								return false end
function modifier_sukuna_m_e_e_slashing_motion:RemoveOnDeath()									return true end
function modifier_sukuna_m_e_e_slashing_motion:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_sukuna_m_e_e_slashing_motion:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_sukuna_m_e_e_slashing_motion:CheckState()
	local t = {}
	t[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	t[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	t[MODIFIER_STATE_SILENCED] = true
	t[MODIFIER_STATE_MUTED]	= true
	return t
end
function modifier_sukuna_m_e_e_slashing_motion:DeclareFunctions()
	local t = 
	{
		MODIFIER_PROPERTY_TURN_RATE_OVERRIDE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
	return t
end
function modifier_sukuna_m_e_e_slashing_motion:GetModifierTurnRate_Override(keys)
	return 0.2
end
function modifier_sukuna_m_e_e_slashing_motion:GetOverrideAnimation()
	return ACT_DOTA_RUN
end
function modifier_sukuna_m_e_e_slashing_motion:GetActivityTranslationModifiers()
	return "haste"
end
function modifier_sukuna_m_e_e_slashing_motion:OnCreated(tInfo)
	self._hCaster  = self:GetCaster()
	self._hParent  = self:GetParent()
	self._hAbility = self:GetAbility()

	self._nTeamID = self._hCaster:GetTeamNumber()

	self._bIsDebuff = self._nTeamID ~= self._hParent:GetTeamNumber()

	if not IsServer() then return end

	self._nSpeed = self._hAbility:GetSpecialValueFor("dash_speed")

	self._bPathTrees = (tInfo.path_trees or 1) > 0
	self._bPathHG = (tInfo.path_hg or 1) > 0
	self._bPathBlocked = (tInfo.path_blocked or 1) > 0

	self._nBound2D = 32

	self.team_id = self._nTeamID
	self.target_team = self._hAbility:GetAbilityTargetTeam()
	self.target_type = self._hAbility:GetAbilityTargetType()
	self.target_flags = self._hAbility:GetAbilityTargetFlags()

	self.dash_radius = self._hAbility:GetSpecialValueFor("dash_radius")
	self.dash_damage_interval = self._hAbility:GetSpecialValueFor("dash_damage_interval")
	self.dash_damage = self._hAbility:GetSpecialValueFor("dash_damage")

	self:OnIntervalThink()
	self:StartIntervalThink(self.dash_damage_interval)

	local nSlashesPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_slashes_aoe/sukuna_slashes_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self._hParent)
						-- ParticleManager:SetParticleShouldCheckFoW(nSlashesPFX, false)
						-- ParticleManager:SetParticleControl(nSlashesPFX, 0, tInfo.point)
						ParticleManager:SetParticleControl(nSlashesPFX, 1, Vector(self.dash_radius, self.dash_radius, self.dash_radius))

	self:AddParticle(nSlashesPFX, false, false, -1, false, false)

	local nPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_dash/sukuna_dash_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self._hParent)

	self:AddParticle(nPFX, false, false, -1, false, false)

	EmitSoundOn("sukuna_slashes.laugh", self._hParent)
	--=================================--
	if not self:ApplyHorizontalMotionController() then
		self:Destroy(true)
	end
end
function modifier_sukuna_m_e_e_slashing_motion:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_sukuna_m_e_e_slashing_motion:OnHorizontalMotionInterrupted()
	self:Destroy(true)
end
function modifier_sukuna_m_e_e_slashing_motion:UpdateHorizontalMotion(hUnit, nDT)
	local nBound2D = self._nBound2D

	local nSpeed = self._nSpeed
	local nSpeedDT = nSpeed * nDT

	local vDirectionNow = hUnit:GetForwardVector()

	local vPosNowTrue = hUnit:GetAbsOrigin()
	local vPosNowSafe = vPosNowTrue

	local vPosNew = vPosNowSafe
	--=================================--
	local _bPath = true
	local _bStop = false
	local _nSpeedDT = 0
	--=================================--
	while true do
		_nSpeedDT = math.min(_nSpeedDT + nBound2D, nSpeedDT)
		vPosNew = vPosNowTrue + vDirectionNow * _nSpeedDT
		_bPath = self:IsNavPathable(vPosNowSafe, vPosNew, self._bPathTrees, self._bPathHG, self._bPathBlocked)
		if not (_nSpeedDT < nSpeedDT and vPosNew and not _bStop and _bPath) then
			break
		end
		vPosNowSafe = vPosNew
	end
	--=================================--
	local _bInterrupt = nil
	--=================================--
	if not vPosNew or _bStop then
		hUnit:SetAbsOrigin(vPosNowSafe)
		_bInterrupt = _bStop
	else
		--=================================--
		if not _bPath then
			hUnit:SetAbsOrigin(vPosNowSafe)
			_bInterrupt = true
		else
			hUnit:SetAbsOrigin(vPosNew)
		end
	end
	--=================================--
	if type(_bInterrupt) ~= "boolean" then return end
	self:Destroy(_bInterrupt)
end
function modifier_sukuna_m_e_e_slashing_motion:IsNavPathable(vPosNow, vPosNew, bTrees, bHG, bBlocked)
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
function modifier_sukuna_m_e_e_slashing_motion:OnIntervalThink()
	if not IsServer() then return end

	local tEntities = FindUnitsInRadius(
		self.team_id,
		self._hParent:GetAbsOrigin(),
		nil,
		self.dash_radius,
		self.target_team,
		self.target_type,
		self.target_flags,
		FIND_CLOSEST,
		false)

	for _, hEnt in ipairs(tEntities) do
		if hEnt ~= self._hParent then
			self:SlashTarget({
				target = hEnt,
				caster = self._hParent,
				damage = self.dash_damage,
			})
		end
	end

	EmitSoundOnLocationWithCaster(self._hParent:GetAbsOrigin(), "sukuna_slashes_aoe.slash", self._hParent)
end
function modifier_sukuna_m_e_e_slashing_motion:SlashTarget(tInfo)
	local tDamage =
	{
		victim = tInfo.target,
		attacker = tInfo.caster, 
		damage = tInfo.damage,
		damage_type = self._hAbility:GetAbilityDamageType(),
		ability = self._hAbility,
		-- damage_flags = keys.damage_flags,
	}

	ApplyDamage(tDamage)
end
function modifier_sukuna_m_e_e_slashing_motion:OnDestroy()
	StopSoundOn("sukuna_slashes.laugh", self._hParent)
end