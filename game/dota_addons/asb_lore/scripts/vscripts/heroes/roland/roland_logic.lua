require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
roland_logic = class(roland_card)

function roland_logic:OnCardDashImpact(hCaster, hTarget, vDir)
	if IsNull(hTarget) or hTarget:TriggerSpellAbsorb(self) then return end

	local tInfo =
	{
		target = hTarget,
		caster = hCaster,

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		part_1 =
		{
			ca_time = self:GetSpecialValueFor("ca_time_1"),
			ca_stunnable = self:GetSpecialValueFor("ca_stunnable_1"),

			act = ACT_DOTA_OVERRIDE_ABILITY_1,
			act_mod = "logic_shot_1",

			sound = "roland_logic.shot_1",
		},

		part_2 =
		{
			ca_time = self:GetSpecialValueFor("ca_time_2"),
			ca_stunnable = self:GetSpecialValueFor("ca_stunnable_2"),

			act = ACT_DOTA_OVERRIDE_ABILITY_1,
			act_mod = "logic_shot_1",

			sound = "roland_logic.shot_1",
		},

		part_3 =
		{
			ca_time = self:GetSpecialValueFor("ca_time_3"),
			ca_stunnable = self:GetSpecialValueFor("ca_stunnable_3"),

			act = ACT_DOTA_OVERRIDE_ABILITY_2,
			act_mod = "logic_shot_2",

			sound = "roland_logic.shot_2",
		},

		projectile =
		{
			speed = self:GetSpecialValueFor("proj_speed"),
			distance = self:GetSpecialValueFor("proj_distance"),
			width = self:GetSpecialValueFor("proj_width"),

			projectile_name = "particles/heroes/roland/roland_logic/roland_logic_shot_linear.vpcf",

			knock_stun_time = self:GetSpecialValueFor("proj_knock_stun_time"),
			knock_time = self:GetSpecialValueFor("proj_knock_time"),
			knock_range = self:GetSpecialValueFor("proj_knock_range"),

			knock_damage = self:GetSpecialValueFor("proj_knock_damage"),
		}
	}

	for i = 1, 3 do
		local p = tInfo["part_"..i]

		p.ca_rate = GetAnimPlayRate(
			i == 3 and 16 or 6,
			i == 3 and 16 or 6,
			30,
			p.ca_time
		)

		p.ca_impact_time = GetAnimImpactTime(
			i == 3 and 16 or 6,
			i == 3 and 6 or 3,
			30,
			p.ca_time
		)
	end

	local nCATime = self:GetSpecialValueFor("ca_time")

	tInfo.cast =
	{
		ca_time = nCATime,

		act = ACT_DOTA_CAST_ABILITY_1,
		act_mod = "logic_cast",

		ca_rate = GetAnimPlayRate(10, 5, 30, nCATime),

		ca_stunnable = self:GetSpecialValueFor("ca_stunnable"),
	}

	self:LogicCast(tInfo)
end
function roland_logic:LogicCast(tInfo)
	local tAnim =
	{
		duration = tInfo.cast.ca_time,
		pause = -1,
		pause_sync = 1,
		activity = tInfo.cast.act,
		activities = json.encode({tInfo.cast.act_mod}),
		rate = tInfo.cast.ca_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, tInfo.cast.ca_time, tInfo.projectile.distance + 300, tInfo.cast.ca_stunnable > 0)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		for i = 1, 3 do
			local vDir = tInfo.caster:GetForwardVector()
			tInfo["proj_dir_"..i] = vDir
		end
		self:LogicShot(tInfo, 1)
	end)
end
function roland_logic:LogicShot(tInfo, nIndex)
	local _tInfo = tInfo["part_"..nIndex]
	if not _tInfo then
		self:TurnPlayNext(tInfo.caster, tInfo.target, GetDirection(tInfo.target, tInfo.caster))
		return
	end

	local tAnim =
	{
		duration = _tInfo.ca_time,
		pause = -1,
		pause_sync = 1,
		activity = _tInfo.act,
		activities = json.encode({_tInfo.act_mod}),
		rate = _tInfo.ca_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	hAnim:AddCallbackThink(FrameTime(), function(hMod)
		if _tInfo.ca_stunnable > 0 and tInfo.caster:IsStunned() then
			hMod:Destroy(true)
			return
		end
	end)

	hAnim:AddCallbackThink(_tInfo.ca_impact_time, function(hMod)
		if hMod:IsInterrupted() then return end

		local vDir = tInfo["proj_dir_"..nIndex]

		self:ProjectileShot(
		{
			caster = tInfo.caster,
			ability = self,

			dir = vDir,

			team_id = tInfo.team_id,
			target_team = tInfo.target_team,
			target_type = tInfo.target_type,
			target_flags = tInfo.target_flags,

			speed = tInfo.projectile.speed,
			distance = tInfo.projectile.distance,
			width = tInfo.projectile.width,

			projectile_name = tInfo.projectile.projectile_name,

			extra_data =
			{
				caster_id = tInfo.caster:entindex(),

				dir_x = vDir.x,
				dir_y = vDir.y,

				knock_stun_time = tInfo.projectile.knock_stun_time,
				knock_time = tInfo.projectile.knock_time,
				knock_range = tInfo.projectile.knock_range,

				knock_damage = tInfo.projectile.knock_damage,
			}
		})

		EmitSoundOn(_tInfo.sound, tInfo.caster)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:LogicShot(tInfo, nIndex + 1)
	end)
end
function roland_logic:ProjectileShot(tInfo)
	local tProj =
	{
		vSpawnOrigin = (tInfo.caster:GetAbsOrigin()) + Vector(0, 0, 175), -- + tInfo.dir * 150)
		vVelocity = tInfo.dir * tInfo.speed,

		fDistance = tInfo.distance,
		fStartRadius = tInfo.width,
		fEndRadius = tInfo.width,

		iUnitTargetTeam = tInfo.target_team,
		iUnitTargetType = tInfo.target_type,
		iUnitTargetFlags = tInfo.target_flags,

		EffectName = tInfo.projectile_name,

		Ability = tInfo.ability,
		Source = tInfo.caster,

		bProvidesVision = true,
		iVisionRadius = tInfo.width,
		iVisionTeamNumber = tInfo.caster:GetTeamNumber(),

		ExtraData = tInfo.extra_data,
	}

	-- Dota2API.ProjectileManager.CreateLinearProjectile(ProjectileManager, tProj)
	ProjectileManager:CreateLinearProjectile(tProj)
end
function roland_logic:OnProjectileHit_ExtraData(hTarget, vLocation, tInfo)
	if IsNull(hTarget) then return end

	local hCaster = EntIndexToHScript(tInfo.caster_id)

	self:AddStun({
		target = hTarget,
		caster = hCaster,
		stun_time = tInfo.knock_stun_time
	})

	self:AddKnock({
		target = hTarget,
		caster = hCaster,
		dir = Vector(tInfo.dir_x, tInfo.dir_y, 0),
		knock_time = tInfo.knock_time,
		knock_range = tInfo.knock_range
	})

	self:DoDamage({
		target = hTarget,
		caster = hCaster,
		damage = tInfo.knock_damage
	})

	self:CreateHitPFX(hTarget)

	if HasTalent(hCaster, "special_bonus_roland_15l") then
		hTarget:AddNewModifier(hCaster, self, "modifier_roland_logic_vision_debuff", {duration = FindTalentValue(hCaster, "special_bonus_roland_15l", "duration", 0)})
	end

	return false
end
function roland_logic:CreateHitPFX(hTarget)
	local nHitPFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_logic/roland_logic_shot_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleShouldCheckFoW(nHitPFX, false)
					ParticleManager:SetParticleControl(nHitPFX, 0, hTarget:GetAbsOrigin() + Vector(0,0,50))
					ParticleManager:SetParticleControl(nHitPFX, 3, hTarget:GetAbsOrigin() + Vector(0,0,50))
					ParticleManager:ReleaseParticleIndex(nHitPFX)
end






























--====================================================================================================--
--====================================================================================================--
roland_logic_ex = class(roland_logic)
































--====================================================================================================--
LinkLuaModifier("modifier_roland_logic_vision_debuff", "heroes/roland/roland_logic", LUA_MODIFIER_MOTION_NONE)

modifier_roland_logic_vision_debuff = class({})

function modifier_roland_logic_vision_debuff:IsHidden()										return false end
function modifier_roland_logic_vision_debuff:IsDebuff()										return true end
function modifier_roland_logic_vision_debuff:IsPurgable()									return true end
function modifier_roland_logic_vision_debuff:IsPurgeException()								return true end
function modifier_roland_logic_vision_debuff:RemoveOnDeath()								return true end
function modifier_roland_logic_vision_debuff:GetAttributes()								return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_logic_vision_debuff:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_roland_logic_vision_debuff:CheckState()
	local t = 
	{
		[MODIFIER_STATE_PROVIDES_VISION] = true
	}
	return t
end