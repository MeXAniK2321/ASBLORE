require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_b_w = class({})

function sukuna_b_w:GetManaCost(nLevel)
	return self.BaseClass.GetManaCost(self, nLevel) * self:GetCaster():GetMaxMana() * 0.01
end
function sukuna_b_w:GetAOERadius()
	return self:GetSpecialValueFor("proj_range")
end
function sukuna_b_w:GetPlaybackRateOverride()
	return GetAnimPlayRate(11, 10, 30, self:GetCastPoint())
end
function sukuna_b_w:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sukuna_animation_generic_activity", {duration = 0.1, activity = "book"})
	return true
end
function sukuna_b_w:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
end
function sukuna_b_w:OnSpellStart()
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

		ca_time = self:GetSpecialValueFor("ca_time"),
		ca_stunnable = 1,

		ca_act = ACT_DOTA_CAST_ABILITY_2_END,
		ca_act_mod = "book",

		projectile =
		{
			speed = self:GetSpecialValueFor("proj_speed"),
			range = self:GetSpecialValueFor("proj_range"),
			width = self:GetSpecialValueFor("proj_width"),

			projectile_name = "particles/heroes/sukuna/sukuna_wcs_horizontal/sukuna_wcs_horizontal_projectile.vpcf",

			extra_data =
			{
				caster_id = hCaster:entindex(),

				dir_x = vDir.x,
				dir_y = vDir.y,

				damage = self:GetSpecialValueFor("damage"),
			}
		}
	}

	tInfo.ca_rate = GetAnimPlayRate(40, 39, 30, tInfo.ca_time)
	tInfo.ca_impact_time = GetAnimImpactTime(40, 8, 30, tInfo.ca_time)

	self:CastAnimation(tInfo)
end
function sukuna_b_w:CastAnimation(tInfo)
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
		EmitSoundOn("sukuna_web_slash.slash", tInfo.caster)
		self.nProjectile = self:ProjectileLaunch(tInfo)
	end)

	hAnim:AddCallbackEnd(function(hMod)

	end)
end
function sukuna_b_w:ProjectileLaunch(tInfo)
	local tProj =
	{
		vSpawnOrigin = (tInfo.caster:GetAbsOrigin()),
		vVelocity = tInfo.dir * tInfo.projectile.speed,

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

	return ProjectileManager:CreateLinearProjectile(tProj)
end
function sukuna_b_w:OnProjectileHit_ExtraData(hTarget, vLocation, tInfo)
	if IsNull(hTarget) then return end

	tInfo.caster = EntIndexToHScript(tInfo.caster_id)
	tInfo.target = hTarget
	
	self:SlashTarget(tInfo)

	if not self:GetAltCastState() and self.nProjectile then
		local proj = self.nProjectile
		self.nProjectile = nil
		Timers:CreateTimer(0.1, function()
			ProjectileManager:DestroyLinearProjectile(proj)
		end)
	end
	return false 
end
function sukuna_b_w:SlashTarget(tInfo)
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
end
--====================================================================================================--