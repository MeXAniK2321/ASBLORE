require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_p_d = class({})

function sukuna_p_d:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition() + hCaster:GetForwardVector()

	local vDir = GetDirection(vPoint, hCaster)--hCaster:GetForwardVector()

	local tInfo =
	{
		-- point = vPoint,
		caster = hCaster,

		dir = vDir,

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		ca_time = self:GetSpecialValueFor("ca_time"),
		ca_stunnable = 1,

		ca_act = ACT_DOTA_CAST_ABILITY_4,
		ca_act_mod = "phys",

		ca_dash_range = self:GetSpecialValueFor("ca_dash_range"),
		ca_dash_height = self:GetSpecialValueFor("ca_dash_height"),

		alt_ca_time = self:GetSpecialValueFor("alt_ca_time"),
		alt_ca_stunnable = 1,

		alt_ca_act = ACT_DOTA_CAST_ABILITY_4,
		alt_ca_act_mod = "phys",

		alt_da_time = self:GetSpecialValueFor("alt_da_time"),
		alt_da_stunnable = 1,

		alt_da_act = ACT_DOTA_CAST_ABILITY_4_END,
		alt_da_act_mod = "phys",

		alt_da_dash_range = self:GetSpecialValueFor("alt_da_dash_range"),
		alt_da_dash_width = self:GetSpecialValueFor("alt_da_dash_width"),

		alt_knock_time = self:GetSpecialValueFor("alt_knock_time"),
		alt_knock_range = self:GetSpecialValueFor("alt_knock_range"),
		alt_knock_height = self:GetSpecialValueFor("alt_knock_height"),

		mage_mode_duration = self:GetSpecialValueFor("mage_mode_duration"),
		mage_mode_hp_cost_pct = self:GetSpecialValueFor("mage_mode_hp_cost_pct"),
	}

	tInfo.ca_rate = GetAnimPlayRate(15, 14, 30, tInfo.ca_time)
	tInfo.ca_impact_time = GetAnimImpactTime(15, 10, 30, tInfo.ca_time)

	tInfo.alt_ca_rate = GetAnimPlayRate(15, 14, 30, tInfo.alt_ca_time)
	tInfo.alt_ca_impact_time = GetAnimImpactTime(15, 10, 30, tInfo.alt_ca_time)

	tInfo.alt_da_rate = GetAnimPlayRate(60, 59, 30, tInfo.alt_da_time)

	local bIsAltCast = self:GetAltCastState()

	if bIsAltCast then
		self:CastRushStart(tInfo)
	else
		self:CastJump(tInfo)
		tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_p_d_mage_mode", {duration = tInfo.mage_mode_duration})
	end
end
function sukuna_p_d:CastJump(tInfo)
	local vDir = -tInfo.dir

	local tMotion =
	{
		duration = tInfo.ca_time,

		dir_x = vDir.x,
		dir_y = vDir.y,

		distance = tInfo.ca_dash_range,
		-- speed = 1000,
		height = tInfo.ca_dash_height,

		facing = -1,

		path_trees = 1,
		path_hg = 1,
		path_blocked = 1,
	}

	local hMotion = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_motion_generic", tMotion)
	if (IsNull(hMotion) or hMotion:IsInterrupted()) then return end

	EmitSoundOn("sukuna_dash.cast", tInfo.caster)
	
	local nPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_dash/sukuna_dash_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, tInfo.caster)

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
	end)

	hAnim:AddCallbackEnd(function(hMod)
		ParticleManager:DestroyParticle(nPFX, false)
		ParticleManager:ReleaseParticleIndex(nPFX)

		if not hMod:IsInterrupted() then
			
		end

		if IsNull(hMotion) then return end
		hMotion:Destroy(hMod:IsInterrupted())
	end)
end
--====================================================================================================--
function sukuna_p_d:CastRushStart(tInfo)
	local tAnim =
	{
		duration = tInfo.alt_ca_time,
		pause = -1,
		pause_sync = 1,
		activity = tInfo.alt_ca_act,
		activities = json.encode({tInfo.alt_ca_act_mod}),
		rate = tInfo.alt_ca_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	hAnim:AddCallbackThink(FrameTime(), function(hMod, _tTimer, nTime)
		if tInfo.alt_ca_stunnable > 0 and tInfo.caster:IsStunned() then
			hMod:Destroy(true)
			return
		end
		return nTime
	end)

	hAnim:AddCallbackThink(tInfo.ca_impact_time, function(hMod)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if not hMod:IsInterrupted() then
			self:CastRushEnd(tInfo)
		end
	end)
end
--====================================================================================================--
function sukuna_p_d:CastRushEnd(tInfo)
	local vDir = tInfo.dir

	local tMotion =
	{
		duration = tInfo.alt_da_time,

		dir_x = vDir.x,
		dir_y = vDir.y,

		distance = tInfo.alt_da_dash_range,
		-- speed = 1000,
		height = tInfo.alt_da_dash_height,

		facing = 1,

		path_trees = 1,
		path_hg = 1,
		path_blocked = 1,
	}

	local hMotion = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_motion_generic", tMotion)
	if (IsNull(hMotion) or hMotion:IsInterrupted()) then return end
		
	EmitSoundOn("sukuna_dash.cast", tInfo.caster)

	local nPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_dash/sukuna_dash_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, tInfo.caster)

	local tAnim =
	{
		duration = tInfo.alt_da_time,
		pause = -1,
		pause_sync = 1,
		activity = tInfo.alt_da_act,
		activities = json.encode({tInfo.alt_da_act_mod}),
		rate = tInfo.alt_da_rate,
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

	hMotion:AddCallbackThink(function(hMod, vPosNew, _bPath, _nSpeedDT)
		local tUnits = FindUnitsInRadius(
			tInfo.team_id,
			tInfo.caster:GetAbsOrigin(),
			nil,
			tInfo.alt_da_dash_width,
			tInfo.target_team,
			tInfo.target_type,
			tInfo.target_flags,
			FIND_CLOSEST,
			false)

		for _, hUnit in ipairs(tUnits) do
			tInfo.target = hUnit
			return nil, false
		end

		return vPosNew, false
	end)

	hMotion:AddCallbackEnd(function(hMod)
		ParticleManager:DestroyParticle(nPFX, false)
		ParticleManager:ReleaseParticleIndex(nPFX)
		
		local bInterrupted = hMod:IsInterrupted()
		if IsNotNull(hAnim) then
			hAnim:Destroy(bInterrupted)
		end
		if not bInterrupted and IsNotNull(tInfo.target) then
			self:KnockTarget(tInfo)
		end
	end)

	hAnim:AddCallbackEnd(function(hMod)
		local bInterrupted = hMod:IsInterrupted()
		if IsNotNull(hMotion) then
			hMotion:Destroy(bInterrupted)
		end
	end)
end
function sukuna_p_d:KnockTarget(tInfo)
	local vDir = tInfo.dir

	local tMotion =
	{
		duration = tInfo.alt_knock_time,

		dir_x = vDir.x,
		dir_y = vDir.y,

		distance = tInfo.alt_knock_range,
		-- speed = 1000,
		height = tInfo.alt_knock_height,

		facing = -1,

		path_trees = 1,
		path_hg = 1,
		path_blocked = 1,
	}

	local hMotion = tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_sukuna_motion_generic", tMotion)
	if IsNull(hMotion) or hMotion:IsInterrupted() then return end
	
	EmitSoundOn("sukuna_dash.throw", tInfo.target)

	local nPFX_Impact = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_impact/sukuna_impact.vpcf", PATTACH_CENTER_FOLLOW, tInfo.target)
						ParticleManager:ReleaseParticleIndex(nPFX_Impact)
						
	local nPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_dash/sukuna_dash_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, tInfo.target)

	tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_stunned", {duration = tInfo.alt_knock_time})

	hMotion:AddCallbackEnd(function(hMod)
		ParticleManager:DestroyParticle(nPFX, false)
		ParticleManager:ReleaseParticleIndex(nPFX)

		tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_p_d_mage_mode", {duration = tInfo.mage_mode_duration})
	end)
end
















--====================================================================================================--
LinkLuaModifier("modifier_sukuna_p_d_mage_mode", "heroes/sukuna/sukuna_p_d", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_p_d_mage_mode = class({})

function modifier_sukuna_p_d_mage_mode:IsHidden()											return false end
function modifier_sukuna_p_d_mage_mode:IsDebuff()											return false end
function modifier_sukuna_p_d_mage_mode:IsPurgable()											return false end
function modifier_sukuna_p_d_mage_mode:IsPurgeException()									return false end
function modifier_sukuna_p_d_mage_mode:RemoveOnDeath()										return true end
function modifier_sukuna_p_d_mage_mode:GetAttributes()										return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_sukuna_p_d_mage_mode:GetPriority()										return MODIFIER_PRIORITY_NORMAL end
function modifier_sukuna_p_d_mage_mode:DeclareFunctions()
	local t = 
	{
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
	return t
end
function modifier_sukuna_p_d_mage_mode:OnAbilityExecuted(keys)
	if keys.unit ~= self._hParent or IsNull(keys.ability) then return end
	if TableContains(self.tAbilitiesInterrupt, keys.ability:GetAbilityName()) then
		self:Destroy()
	end
end
function modifier_sukuna_p_d_mage_mode:OnCreated(tInfo)
	self._hCaster  = self:GetCaster()
	self._hParent  = self:GetParent()
	self._hAbility = self:GetAbility()

	self.tAbilitiesInterrupt =
	{
		"sukuna_m_q",
		"sukuna_m_w",
		"sukuna_m_e",
		"sukuna_m_d",
	}

	if not IsServer() then return end

	self.nHealthCost = self._hAbility:GetSpecialValueFor("mage_mode_hp_cost_pct") * 0.01

	self:RememberCD()
	self:Swap(false)
end
function modifier_sukuna_p_d_mage_mode:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_sukuna_p_d_mage_mode:OnDestroy()
	if not IsServer() then return end

	self:ReleaseCD()
	self:Swap(true)

	local nMaxHP = self._hParent:GetMaxHealth()
	local nNeedHP = self._hParent:GetHealth() - (nMaxHP * self.nHealthCost)
	self._hParent:ModifyHealth(nNeedHP, self._hAbility, false, DOTA_DAMAGE_FLAG_NONE)
end
function modifier_sukuna_p_d_mage_mode:Swap(bEnable)
	local hBook = self._hParent:FindAbilityByName("sukuna_switch_book")
	local hMP = self._hParent:FindItemInInventory("item_sukuna_switch_mp")
	if IsNull(hMP) then return end
	if not bEnable then
		hMP:ToggleAbility()
		hBook:SetActivated(false)
		hMP:SetActivated(false)
	else
		hBook:SetActivated(true)
		hMP:SetActivated(true)
		hMP:ToggleAbility()
	end
end
function modifier_sukuna_p_d_mage_mode:RememberCD()
	self.tRememberedCD = self.tRememberedCD or {}
	for _, sAbilityName in ipairs(self.tAbilitiesInterrupt) do
		local hAbility = self._hParent:FindAbilityByName(sAbilityName)
		if IsNotNull(hAbility) then
			self.tRememberedCD[hAbility] = hAbility:GetCooldownTimeRemaining()
			hAbility:EndCooldown()
		end
	end
end
function modifier_sukuna_p_d_mage_mode:ReleaseCD()
	self.tRememberedCD = self.tRememberedCD or {}
	for hAbility, nCooldown in pairs(self.tRememberedCD) do
		if IsNotNull(hAbility) then
			hAbility:EndCooldown()
			hAbility:StartCooldown(nCooldown)
		end
	end
end