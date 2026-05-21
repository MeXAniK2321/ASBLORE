require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_m_q = class({})

function sukuna_m_q:GetAOERadius()
	return self:GetSpecialValueFor("proj_range")
end
-- function sukuna_m_q:GetPlaybackRateOverride()
-- 	return GetAnimPlayRate(47, 7, 30, self:GetCastPoint())
-- end
function sukuna_m_q:OnSpellStart()
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

		ca_act = ACT_DOTA_CAST_ABILITY_1,
		ca_act_mod = "mage",

		dash_dir = -vDir,
		dash_range = self:GetSpecialValueFor("dash_range"),
		dash_height = self:GetSpecialValueFor("dash_height"),

		projectile =
		{
			speed = self:GetSpecialValueFor("proj_speed"),
			range = self:GetSpecialValueFor("proj_range"),
			width = self:GetSpecialValueFor("proj_width"),

			projectile_name = "particles/heroes/sukuna/sukuna_slash/sukuna_slash_projectile.vpcf",

			extra_data =
			{
				caster_id = hCaster:entindex(),

				dir_x = vDir.x,
				dir_y = vDir.y,

				hits = self:GetSpecialValueFor("hits"),
				hits_tick = self:GetSpecialValueFor("hits_tick"),

				damage = self:GetSpecialValueFor("damage"),
			}
		}
	}

	-- tInfo.ca_rate = GetAnimPlayRate(47, 46, 30, tInfo.ca_time)
	-- tInfo.ca_impact_time = GetAnimImpactTime(47, 7, 30, tInfo.ca_time)

	tInfo.ca_rate = GetAnimPlayRate(24, 23, 30, tInfo.ca_time)
	tInfo.ca_impact_time = GetAnimImpactTime(24, 5, 30, tInfo.ca_time)

	self:CastAnimation(tInfo)
end
function sukuna_m_q:CastAnimation(tInfo)
	local bIsAltCast = self:GetAltCastState()

	local tMotion =
	{
		duration = tInfo.ca_time,

		dir_x = tInfo.dash_dir.x,
		dir_y = tInfo.dash_dir.y,

		distance = tInfo.dash_range,
		-- speed = 1000,
		height = tInfo.dash_height,

		facing = -1,

		path_trees = 1,
		path_hg = 1,
		path_blocked = 1,
	}

	local nPFX = nil
	local hMotion = nil
	if bIsAltCast then
		hMotion = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_motion_generic", tMotion)
		EmitSoundOn("sukuna_dash.cast", tInfo.caster)
		nPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_dash/sukuna_dash_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, tInfo.caster)
	end

	if bIsAltCast and (IsNull(hMotion) or hMotion:IsInterrupted()) then return end

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
		self.nProjectile = self:ProjectileLaunch(tInfo)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if nPFX then
			ParticleManager:DestroyParticle(nPFX, false)
			ParticleManager:ReleaseParticleIndex(nPFX)
		end
		if IsNull(hMotion) then return end

		hMotion:Destroy(hMod:IsInterrupted())
	end)
end
function sukuna_m_q:ProjectileLaunch(tInfo)
	self.hitted = false
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
function sukuna_m_q:OnProjectileHit_ExtraData(hTarget, vLocation, tInfo)
	if self.hitted then return end
	if IsNull(hTarget) then return end

	tInfo.caster = EntIndexToHScript(tInfo.caster_id)
	tInfo.target = hTarget

	local nSlashesPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_slashes_target/sukuna_slashes_target.vpcf", PATTACH_ABSORIGIN_FOLLOW, tInfo.target)

	local nHits = 0
	Timers:CreateTimer(0, function()
		if nHits >= tInfo.hits then 
			ParticleManager:DestroyParticle(nSlashesPFX, false)
			ParticleManager:ReleaseParticleIndex(nSlashesPFX)
			return
		end
		nHits = nHits + 1
		self:SlashTarget(tInfo)
		return tInfo.hits_tick
	end)

	self.hitted = true

	if self.nProjectile then
		local nProj = self.nProjectile
		self.nProjectile = nil
		Timers:CreateTimer(0.1, function()
			ProjectileManager:DestroyLinearProjectile(nProj)
		end)
	end
	return false
end
function sukuna_m_q:SlashTarget(tInfo)
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