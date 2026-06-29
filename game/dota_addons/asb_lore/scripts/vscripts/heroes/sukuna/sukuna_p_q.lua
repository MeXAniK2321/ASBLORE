require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_p_q = class({})

function sukuna_p_q:GetPlaybackRateOverride()
	return GetAnimPlayRate(10, 5, 30, self:GetCastPoint())
end
function sukuna_p_q:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sukuna_animation_generic_activity", {duration = 0.1, activity = "phys"})
	return true
end
function sukuna_p_q:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
end
function sukuna_p_q:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	local vDir = GetDirection(hTarget, hCaster)

	local tInfo =
	{
		target = hTarget,
		caster = hCaster,

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		ca_time = self:GetSpecialValueFor("ca_time"),
		ca_stunnable = 1,

		ca_act = ACT_DOTA_CAST_ABILITY_1_END,
		ca_act_mod = "phys",

		damage = self:GetSpecialValueFor("damage"),

		stun_duration = self:GetSpecialValueFor("stun_duration"),

		knock_time = self:GetSpecialValueFor("knock_time"),
		knock_range = self:GetSpecialValueFor("knock_range"),
		knock_height = self:GetSpecialValueFor("knock_height"),

		knock_dir = vDir,
	}

	tInfo.damage = tInfo.damage + (self:GetSpecialValueFor("damage_attack_pct") * 0.01 * tInfo.caster:GetAverageTrueAttackDamage(tInfo.target))
	
	tInfo.ca_rate = GetAnimPlayRate(42, 41, 30, tInfo.ca_time)
	tInfo.ca_impact_time = GetAnimImpactTime(42, 5, 30, tInfo.ca_time)

	self:CastAnimation(tInfo)
end
function sukuna_p_q:CastAnimation(tInfo)
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

	EmitSoundOn("sukuna_dash.cast", tInfo.caster)

	local nPFX_Impact = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_impact/sukuna_impact.vpcf", PATTACH_CENTER_FOLLOW, tInfo.caster)
						ParticleManager:ReleaseParticleIndex(nPFX_Impact)

	FindClearSpaceForUnit(tInfo.caster, tInfo.target:GetAbsOrigin() + tInfo.knock_dir * -128, true)
	
	hAnim:AddCallbackThink(FrameTime(), function(hMod, _tTimer, nTime)
		if tInfo.ca_stunnable > 0 and tInfo.caster:IsStunned() then
			hMod:Destroy(true)
			return
		end
		return nTime
	end)

	hAnim:AddCallbackThink(tInfo.ca_impact_time, function(hMod)
		self:KnockTarget(tInfo)

		self:DamageTarget({
			target = tInfo.target,
			caster = tInfo.caster,
			damage = tInfo.damage,
		})
	end)

	hAnim:AddCallbackEnd(function(hMod)
	end)
end
function sukuna_p_q:DamageTarget(tInfo)
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
function sukuna_p_q:KnockTarget(tInfo)
	local tMotion =
	{
		duration = tInfo.knock_time,

		dir_x = tInfo.knock_dir.x,
		dir_y = tInfo.knock_dir.y,

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

	local nPFX_Impact = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_impact/sukuna_impact.vpcf", PATTACH_CENTER_FOLLOW, tInfo.target)
						ParticleManager:ReleaseParticleIndex(nPFX_Impact)
						
	local nPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_dash/sukuna_dash_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, tInfo.target)

	tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_stunned", {duration = tInfo.stun_duration})

	EmitSoundOn("sukuna_dash.smash", tInfo.target)
	
	hMotion:AddCallbackEnd(function(hMod)
		ParticleManager:DestroyParticle(nPFX, false)
		ParticleManager:ReleaseParticleIndex(nPFX)
	end)
end