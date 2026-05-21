require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_b_e = class({})

function sukuna_b_e:GetManaCost(nLevel)
	return self.BaseClass.GetManaCost(self, nLevel) * self:GetCaster():GetMaxMana() * 0.01
end
function sukuna_b_e:GetAOERadius()
	return self:GetSpecialValueFor("proj_range")
end
function sukuna_b_e:GetPlaybackRateOverride()
	return GetAnimPlayRate(11, 10, 30, self:GetCastPoint())
end
function sukuna_b_e:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sukuna_animation_generic_activity", {duration = 0.1, activity = "book"})
	return true
end
function sukuna_b_e:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
end
function sukuna_b_e:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition() + hCaster:GetForwardVector()

	local vDir = GetDirection(vPoint, hCaster)

	local tInfo =
	{
		point = vPoint,
		caster = hCaster,

		dir = vDir,

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		casts =
		{
			{
				ca_time = self:GetSpecialValueFor("ca_time"),
				ca_stunnable = 1,

				ca_act = ACT_DOTA_CAST_ABILITY_3_END,
				ca_act_mod = "book",

				dash_dir = -RotateVector2D(vDir, 45, true),
				dash_range = self:GetSpecialValueFor("dash_range"),
				dash_height = self:GetSpecialValueFor("dash_height"),
			},
			{
				ca_time = self:GetSpecialValueFor("ca_time"),
				ca_stunnable = 1,

				ca_act = ACT_DOTA_CAST_ABILITY_2_END,
				ca_act_mod = "book",

				dash_dir = -RotateVector2D(vDir, -45, true),
				dash_range = self:GetSpecialValueFor("dash_range"),
				dash_height = self:GetSpecialValueFor("dash_height"),
			},
		},

		projectile =
		{
			speed = self:GetSpecialValueFor("proj_speed"),
			range = self:GetSpecialValueFor("proj_range"),
			width = self:GetSpecialValueFor("proj_width"),

			projectile_name = "particles/heroes/sukuna/sukuna_dismantle_net/sukuna_dismantle_net_launch_linear.vpcf",

			extra_data =
			{
				caster_id = hCaster:entindex(),

				dir_x = vDir.x,
				dir_y = vDir.y,

				damage = self:GetSpecialValueFor("damage"),
			}
		},

		casts_num = self:GetSpecialValueFor("casts"),
	}

	tInfo.casts[1].ca_rate = GetAnimPlayRate(47, 20, 30, tInfo.casts[1].ca_time)
	tInfo.casts[1].ca_impact_time = GetAnimImpactTime(47, 8, 30, tInfo.casts[1].ca_time)

	tInfo.casts[2].ca_rate = GetAnimPlayRate(40, 20, 30, tInfo.casts[2].ca_time)
	tInfo.casts[2].ca_impact_time = GetAnimImpactTime(40, 8, 30, tInfo.casts[2].ca_time)

	self:CastAnimation(tInfo, 1)
end
function sukuna_b_e:CastAnimation(tInfo, nCast)
	if nCast > tInfo.casts_num then return end
	local _nCast = (nCast % #tInfo.casts) + 1

	local t = (tInfo.casts or {})[_nCast]

	local tMotion =
	{
		duration = t.ca_time,

		dir_x = t.dash_dir.x,
		dir_y = t.dash_dir.y,

		distance = t.dash_range,
		-- speed = 1000,
		height = t.dash_height,

		facing = -1,

		path_trees = 1,
		path_hg = 1,
		path_blocked = 1,
	}

	local hMotion = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_motion_generic", tMotion)

	if (IsNull(hMotion) or hMotion:IsInterrupted()) then return end

	local nPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_dash/sukuna_dash_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, tInfo.caster)

	EmitSoundOn("sukuna_dash.cast", tInfo.caster)
	
	local tAnim =
	{
		duration = t.ca_time,
		pause = -1,
		pause_sync = 1,
		activity = t.ca_act,
		activities = json.encode({t.ca_act_mod}),
		rate = t.ca_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	hAnim:AddCallbackThink(FrameTime(), function(hMod, _tTimer, nTime)
		if t.ca_stunnable > 0 and tInfo.caster:IsStunned() then
			hMod:Destroy(true)
			return
		end
		return nTime
	end)

	hAnim:AddCallbackThink(t.ca_impact_time, function(hMod)
		EmitSoundOn("sukuna_web_slash.slash", tInfo.caster)

		local nPFX_Impact = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_impact/sukuna_impact.vpcf", PATTACH_CENTER_FOLLOW, tInfo.caster)
						ParticleManager:ReleaseParticleIndex(nPFX_Impact)

		self:ProjectileLaunch(tInfo)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		ParticleManager:DestroyParticle(nPFX, false)
		ParticleManager:ReleaseParticleIndex(nPFX)
		if hMod:IsInterrupted() then return end
		self:CastAnimation(tInfo, nCast + 1)
	end)
end
function sukuna_b_e:ProjectileLaunch(tInfo)
	local tProj =
	{
		vSpawnOrigin = (tInfo.caster:GetAbsOrigin()),
		vVelocity = tInfo.dir * tInfo.projectile.speed, --GetDirection(tInfo.point, tInfo.caster)

		fDistance = tInfo.projectile.range,
		fStartRadius = tInfo.projectile.width,
		fEndRadius = tInfo.projectile.width,

		iUnitTargetTeam = tInfo.target_team,
		iUnitTargetType = tInfo.target_type,
		iUnitTargetFlags = tInfo.target_flags,

		EffectName = tInfo.projectile.projectile_name,

		Ability = self,
		Source = tInfo.caster,

		bProvidesVision = true,
		iVisionRadius = tInfo.projectile.width,
		iVisionTeamNumber = tInfo.caster:GetTeamNumber(),

		ExtraData = tInfo.projectile.extra_data,
	}

	ProjectileManager:CreateLinearProjectile(tProj)
end
function sukuna_b_e:OnProjectileHit_ExtraData(hTarget, vLocation, tInfo)
	if IsNull(hTarget) then return end

	tInfo.caster = EntIndexToHScript(tInfo.caster_id)
	tInfo.target = hTarget
	
	self:SlashTarget(tInfo)

	return false
end
function sukuna_b_e:SlashTarget(tInfo)
	-- local vCasterPos = tInfo.caster:GetAbsOrigin()
	-- local vNeedPos = tInfo.target:GetAbsOrigin() + Vector(tInfo.dir_x, tInfo.dir_y, 0) * -64

	-- tInfo.caster:SetAbsOrigin(vNeedPos)

	-- tInfo.caster:PerformAttack(
	-- 	tInfo.target,
	-- 	true,
	-- 	true,
	-- 	true,
	-- 	true,
	-- 	false,
	-- 	false,
	-- 	true)	

	-- tInfo.caster:SetAbsOrigin(vCasterPos)

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

	EmitSoundOn("sukuna_web.slash", tInfo.target)
end
--====================================================================================================--
