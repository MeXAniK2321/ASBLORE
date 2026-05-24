require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_m_d = class({})

function sukuna_m_d:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sukuna_m_d:GetPlaybackRateOverride()
	return GetAnimPlayRate(11, 6, 30, self:GetCastPoint())
end
function sukuna_m_d:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sukuna_animation_generic_activity", {duration = 0.1, activity = "mage"})
	return true
end
function sukuna_m_d:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
end
function sukuna_m_d:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = hCaster:GetAbsOrigin()

	local tInfo =
	{
		point = vPoint,
		caster = hCaster,

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		ca_time = self:GetSpecialValueFor("ca_time"),
		ca_stunnable = 1,

		ca_act = ACT_DOTA_CAST_ABILITY_4_END,
		ca_act_mod = "mage",

		radius = self:GetSpecialValueFor("radius"),
		damage = self:GetSpecialValueFor("damage"),

		stun_duration = self:GetSpecialValueFor("stun_duration"),

		knock_time = self:GetSpecialValueFor("stun_duration"),
		knock_range = 0,
		knock_height = 300,
	}

	tInfo.ca_rate = GetAnimPlayRate(16, 15, 30, tInfo.ca_time)
	tInfo.ca_impact_time = GetAnimImpactTime(16, 3, 30, tInfo.ca_time)

	self:CastAnimation(tInfo)
end
function sukuna_m_d:CastAnimation(tInfo)
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

	EmitSoundOn("sukuna_web.cast", tInfo.caster)

	local nWEB_PFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_web/sukuna_web_spider.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleShouldCheckFoW(nWEB_PFX, false)
					ParticleManager:SetParticleControl(nWEB_PFX, 0, tInfo.caster:GetAbsOrigin())
					ParticleManager:SetParticleControl(nWEB_PFX, 1, Vector(tInfo.radius, 0, 0))

	local hImmun = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_m_d_magic_immun", {duration = tInfo.ca_time})

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
		ParticleManager:DestroyParticle(nWEB_PFX, not hMod:IsInterrupted())
		ParticleManager:ReleaseParticleIndex(nWEB_PFX)

		if not hMod:IsInterrupted() then
			self:SlashEnemies(tInfo)
		end

		if IsNull(hImmun) then return end
		hImmun:Destroy()
	end)
end
function sukuna_m_d:SlashEnemies(tInfo)
	local tEntities = FindUnitsInRadius(
		tInfo.team_id,
		tInfo.point,
		nil,
		tInfo.radius,
		tInfo.target_team,
		tInfo.target_type,
		tInfo.target_flags,
		FIND_CLOSEST,
		false)

	for _, hEnt in ipairs(tEntities) do
		if hEnt ~= tInfo.caster then
			tInfo.target = hEnt
			tInfo.dir = GetDirection(hEnt, tInfo.caster)
			self:KnockTarget(tInfo)

			self:SlashTarget({
				target = hEnt,
				caster = tInfo.caster,
				damage = tInfo.damage,
			})
		end
	end

	EmitSoundOnLocationWithCaster(tInfo.point, "sukuna_web.slash", tInfo.caster)
end
function sukuna_m_d:SlashTarget(tInfo)
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
function sukuna_m_d:KnockTarget(tInfo)
	local tMotion =
	{
		duration = tInfo.knock_time,

		dir_x = tInfo.dir.x,
		dir_y = tInfo.dir.y,

		distance = tInfo.knock_range + 100,
		-- speed = 1000,
		height = tInfo.knock_height,

		facing = 0,

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


--====================================================================================================--
LinkLuaModifier("modifier_sukuna_m_d_magic_immun", "heroes/sukuna/sukuna_m_d", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_m_d_magic_immun = class({})

function modifier_sukuna_m_d_magic_immun:IsHidden()											return false end
function modifier_sukuna_m_d_magic_immun:IsDebuff()											return false end
function modifier_sukuna_m_d_magic_immun:IsPurgable()										return false end
function modifier_sukuna_m_d_magic_immun:IsPurgeException()									return false end
function modifier_sukuna_m_d_magic_immun:RemoveOnDeath()									return true end
function modifier_sukuna_m_d_magic_immun:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_sukuna_m_d_magic_immun:GetPriority()										return MODIFIER_PRIORITY_NORMAL end
function modifier_sukuna_m_d_magic_immun:CheckState()
	local t = {}
	t[MODIFIER_STATE_MAGIC_IMMUNE] = true
	return t
end