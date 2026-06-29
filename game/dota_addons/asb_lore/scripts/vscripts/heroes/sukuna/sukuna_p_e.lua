require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_p_e = class({})

function sukuna_p_e:CastFilterResultTarget(hTarget)
	return self.BaseClass.CastFilterResultTarget(self, hTarget)
end
function sukuna_p_e:GetPlaybackRateOverride()
	return GetAnimPlayRate(10, 9, 30, self:GetCastPoint())
end
function sukuna_p_e:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	
	local vTargetPos = hTarget:GetAbsOrigin()
	local nTargetGround = GetGroundHeight(vTargetPos, hTarget)

	local sActivity = (vTargetPos.z - 64) >= nTargetGround and "phys2" or "phys"

	hCaster:AddNewModifier(hCaster, self, "modifier_sukuna_animation_generic_activity", {duration = 0.1, activity = sActivity})

	return true
end
function sukuna_p_e:GetCastRange(vLocation, hTarget)
	if IsServer() and IsNotNull(hTarget) then
		local vTargetPos = hTarget:GetAbsOrigin()
		local nTargetGround = GetGroundHeight(vTargetPos, hTarget)

		local nRange = (vTargetPos.z - 64) >= nTargetGround and 600 or self.BaseClass.GetCastRange(self, vLocation, hTarget)
		return nRange
	end
	return self.BaseClass.GetCastRange(self, vLocation, hTarget)
end
function sukuna_p_e:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
end
function sukuna_p_e:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	if hTarget:TriggerSpellAbsorb(self) then
		return
	end

	local vDir = GetDirection(hTarget, hCaster)

	local vTargetPos = hTarget:GetAbsOrigin()
	local nTargetGround = GetGroundHeight(vTargetPos, hTarget)

	local bInAir = (vTargetPos.z - 64) >= nTargetGround

	local tInfo =
	{
		target = hTarget,
		caster = hCaster,

		dir = vDir,

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		da_time = self:GetSpecialValueFor("da_time"),
		da_range = self:GetSpecialValueFor("da_range"),

		da_damage_tick = self:GetSpecialValueFor("da_damage_tick"),
		da_damage = self:GetSpecialValueFor("da_damage"),

		da_stunnable = 1,

		da_act = ACT_DOTA_CAST_ABILITY_3_END,
		da_act_mod = "phys",

		ca_time = self:GetSpecialValueFor("ca_time"),
		ca_damage = self:GetSpecialValueFor("ca_damage"),

		ca_stunnable = 1,

		ca_act = ACT_DOTA_CAST_ABILITY_3_END,
		ca_act_mod = "phys2",

		knock_time = self:GetSpecialValueFor("knock_time"),
		knock_range = self:GetSpecialValueFor("knock_range"),
		knock_height = self:GetSpecialValueFor("knock_height"),

		slow_duration = self:GetSpecialValueFor("slow_duration"),
		silence_duration = self:GetSpecialValueFor("silence_duration"),

		in_air = bInAir,
	}

	tInfo.da_damage = tInfo.da_damage + (self:GetSpecialValueFor("da_damage_attack_pct") * 0.01 * tInfo.caster:GetAverageTrueAttackDamage(tInfo.target))
	tInfo.ca_damage = tInfo.ca_damage + (self:GetSpecialValueFor("ca_damage_attack_pct") * 0.01 * tInfo.caster:GetAverageTrueAttackDamage(tInfo.target))

	tInfo.da_rate = GetAnimPlayRate(60, 59, 30, tInfo.da_time)
	-- tInfo.da_impact_time = GetAnimImpactTime(80, 41, 30, tInfo.da_time)
	-- tInfo.da_rate_time = 
	tInfo.ca_rate = GetAnimPlayRate(22, 21, 30, tInfo.ca_time)
	tInfo.ca_impact_time = GetAnimImpactTime(22, 11, 30, tInfo.ca_time)


	if tInfo.in_air then
		self:CastAnimation(tInfo)
	else
		self:CastDash(tInfo)
	end
end
function sukuna_p_e:CastAnimation(tInfo)
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

	tInfo.caster:SetAbsOrigin(tInfo.target:GetAbsOrigin())

	hAnim:AddCallbackThink(FrameTime(), function(hMod, _tTimer, nTime)
		if tInfo.ca_stunnable > 0 and tInfo.caster:IsStunned() then
			hMod:Destroy(true)
			return
		end
		return nTime
	end)

	hAnim:AddCallbackThink(tInfo.ca_impact_time, function(hMod)
		EmitSoundOn("sukuna_dash.smash", tInfo.caster)
		
		local nPFX_Impact = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_impact/sukuna_impact.vpcf", PATTACH_CENTER_FOLLOW, tInfo.caster)
						ParticleManager:ReleaseParticleIndex(nPFX_Impact)

		FindClearSpaceForUnit(tInfo.target, tInfo.target:GetAbsOrigin(), true)
		FindClearSpaceForUnit(tInfo.caster, tInfo.caster:GetAbsOrigin(), true)

		tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_sukuna_p_e_slow_ms", {duration = tInfo.slow_duration})
		tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_silence", {duration = tInfo.silence_duration})

		self:SlashTarget({
			target = tInfo.target,
			caster = tInfo.caster,
			damage = tInfo.ca_damage,
		})
	end)

	hAnim:AddCallbackEnd(function(hMod)
	end)
end
function sukuna_p_e:CastDash(tInfo)
	local tMotion =
	{
		duration = tInfo.da_time,

		dir_x = tInfo.dir.x,
		dir_y = tInfo.dir.y,

		distance = tInfo.da_range,
		-- speed = 1000,
		-- height = tInfo.dash_height,

		facing = 1,

		path_trees = 1,
		path_hg = 1,
		path_blocked = 1,
	}

	local hMotion = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_motion_generic", tMotion)

	if IsNull(hMotion) or hMotion:IsInterrupted() then return end

	EmitSoundOn("sukuna_dash.cast", tInfo.caster)

	local tAnim =
	{
		duration = tInfo.da_time,
		pause = -1,
		pause_sync = 1,
		activity = tInfo.da_act,
		activities = json.encode({tInfo.da_act_mod}),
		rate = tInfo.da_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	local nPFX_Impact = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_impact/sukuna_impact.vpcf", PATTACH_CENTER_FOLLOW, tInfo.caster)
						ParticleManager:ReleaseParticleIndex(nPFX_Impact)
						
	local nPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_dash/sukuna_dash_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, tInfo.caster)

	local hDisable = tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_sukuna_p_e_full_disable", {duration = tInfo.da_time})

	hMotion:AddCallbackEnd(function(hMod)
		ParticleManager:DestroyParticle(nPFX, false)
		ParticleManager:ReleaseParticleIndex(nPFX)
		if hMod:IsInterrupted() then return end
		self:KnockTarget(tInfo)
	end)

	hAnim:AddCallbackThink(FrameTime(), function(hMod, _tTimer, nTime)
		if tInfo.da_stunnable > 0 and tInfo.caster:IsStunned() then
			hMod:Destroy(true)
			return
		end
		if IsNotNull(hDisable) then
			tInfo.target:SetAbsOrigin(tInfo.caster:GetAbsOrigin() + tInfo.dir * 164)
		end
		return nTime
	end)

	hAnim:AddCallbackThink(tInfo.da_damage_tick, function(hMod, _tTimer, nTime)
		self:SlashTarget({
			target = tInfo.target,
			caster = tInfo.caster,
			damage = tInfo.da_damage,
		})
		return nTime
	end)

	-- hAnim:AddCallbackThink(tInfo.da_impact_time, function(hMod)
	-- 	self:KnockTarget(tInfo)
	-- end)

	hAnim:AddCallbackEnd(function(hMod)
		if IsNull(hMotion) then return end
		hMotion:Destroy(hMod:IsInterrupted())
	end)
end
function sukuna_p_e:KnockTarget(tInfo)
	local tMotion =
	{
		duration = tInfo.knock_time,

		dir_x = tInfo.dir.x,
		dir_y = tInfo.dir.y,

		distance = tInfo.knock_range,
		-- speed = 1000,
		height = tInfo.knock_height,

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

	hMotion:AddCallbackEnd(function(hMod)
		ParticleManager:DestroyParticle(nPFX, false)
		ParticleManager:ReleaseParticleIndex(nPFX)
	end)

	tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_sukuna_p_e_full_disable", {duration = tInfo.knock_time})
end
function sukuna_p_e:SlashTarget(tInfo)
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
LinkLuaModifier("modifier_sukuna_p_e_slow_ms", "heroes/sukuna/sukuna_p_e", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_p_e_slow_ms = class({})

function modifier_sukuna_p_e_slow_ms:IsHidden()										return false end
function modifier_sukuna_p_e_slow_ms:IsDebuff()										return true end
function modifier_sukuna_p_e_slow_ms:IsPurgable()									return true end
function modifier_sukuna_p_e_slow_ms:IsPurgeException()								return true end
function modifier_sukuna_p_e_slow_ms:RemoveOnDeath()								return true end
function modifier_sukuna_p_e_slow_ms:GetAttributes()								return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_sukuna_p_e_slow_ms:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_sukuna_p_e_slow_ms:DeclareFunctions()
	local t = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return t
end
function modifier_sukuna_p_e_slow_ms:GetModifierMoveSpeedBonus_Percentage(keys)
	return self:GetAbility():GetSpecialValueFor("slow_ms_pct")
end






--====================================================================================================--
LinkLuaModifier("modifier_sukuna_p_e_full_disable", "heroes/sukuna/sukuna_p_e", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_p_e_full_disable = class({})

function modifier_sukuna_p_e_full_disable:IsHidden()										return false end
function modifier_sukuna_p_e_full_disable:IsDebuff()										return true end
function modifier_sukuna_p_e_full_disable:IsPurgable()										return true end
function modifier_sukuna_p_e_full_disable:IsPurgeException()								return true end
function modifier_sukuna_p_e_full_disable:RemoveOnDeath()									return true end
function modifier_sukuna_p_e_full_disable:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_sukuna_p_e_full_disable:GetPriority()										return MODIFIER_PRIORITY_NORMAL end
function modifier_sukuna_p_e_full_disable:CheckState()
	local t = 
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	return t
end
