require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
roland_durandal = class(roland_card)

function roland_durandal:OnCardDashImpact(hCaster, hTarget, vDir)
	if IsNull(hTarget) or hTarget:TriggerSpellAbsorb(self) then return end

	local tInfo =
	{
		target = hTarget,
		caster = hCaster,

		ca_stunnable = self:GetSpecialValueFor("ca_stunnable"),

		ca_time = self:GetSpecialValueFor("ca_time"),

		da_range = self:GetSpecialValueFor("da_range"),

		ca_act = ACT_DOTA_CAST_ABILITY_1,
		ca_act_mod = "durandal_slash_12",

		damage_1 = self:GetSpecialValueFor("damage_1"),
		damage_2 = self:GetSpecialValueFor("damage_2"),

		slow_duration = self:GetSpecialValueFor("slow_duration"),

		sound = "roland_durandal.slash_",
	}

	local nAttackScale = self:GetSpecialValueFor("damage_attack_pct") * 0.01 * tInfo.caster:GetAverageTrueAttackDamage(tInfo.caster)
	
	tInfo.damage_1 = tInfo.damage_1 + nAttackScale
	tInfo.damage_2 = tInfo.damage_2 + nAttackScale

	tInfo.ca_rate = GetAnimPlayRate(36, 36, 30, tInfo.ca_time)

	tInfo.ca_impact_time_1 = GetAnimImpactTime(36, 8, 30, tInfo.ca_time)
	tInfo.ca_impact_time_2 = GetAnimImpactTime(36, 23, 30, tInfo.ca_time)

	tInfo.da_start_time = GetAnimImpactTime(36, 20, 30, tInfo.ca_time)
	tInfo.da_time = tInfo.ca_time - tInfo.da_start_time

	self:DurandalCast(tInfo)
end
function roland_durandal:DurandalCast(tInfo)
	local tAnim =
	{
		duration = tInfo.ca_time,
		pause = -1,
		pause_sync = 1,
		activity = tInfo.ca_act,
		activities = json.encode({tInfo.ca_act_mod}),
		rate = tInfo.ca_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, tInfo.ca_impact_time_1, 300, tInfo.ca_stunnable > 0)

	hAnim:AddCallbackThink(tInfo.ca_impact_time_1, function(hMod, _tTimer, nTime)
		if hMod:IsInterrupted() then return end
		self:AddSlow({
			target = tInfo.target,
			caster = tInfo.caster,
			slow_time = tInfo.slow_duration,
		})
		self:DoDamage({
			target = tInfo.target,
			caster = tInfo.caster,
			damage = tInfo.damage_1
		})
		EmitSoundOn(tInfo.sound..1, tInfo.caster)
		self:SlashPFX1(tInfo)
	end)

	hAnim:AddCallbackThink(tInfo.da_start_time, function(hMod, _tTimer, nTime)
		if hMod:IsInterrupted() then return end
		tInfo.dir = tInfo.caster:GetForwardVector()
		self:DurandalDash(tInfo)
	end)

	hAnim:AddCallbackThink(tInfo.ca_impact_time_2, function(hMod, _tTimer, nTime)
		if hMod:IsInterrupted() or GetDistance(tInfo.target, tInfo.caster) > 300 then return end
		self:AddSlow({
			target = tInfo.target,
			caster = tInfo.caster,
			slow_time = tInfo.slow_duration,
		})
		self:DoDamage({
			target = tInfo.target,
			caster = tInfo.caster,
			damage = tInfo.damage_2
		})
		EmitSoundOn(tInfo.sound..2, tInfo.caster)
		self:SlashPFX2(tInfo)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:TurnPlayNext(tInfo.caster, tInfo.target, GetDirection(tInfo.target, tInfo.caster))
	end)
end
function roland_durandal:DurandalDash(tInfo)
	local tDash =
	{
		caster = tInfo.caster,
		stunnable = tInfo.ca_stunnable,

		sound = "roland_turn.end",

		particle_dash = 1,
	}

	local tMotion =
	{
		facing = 1,
		facing_cast = 1,
		duration = tInfo.da_time,
		dir_x = tInfo.dir.x,
		dir_y = tInfo.dir.y,
		distance = tInfo.da_range,
	}

	local tAnim = {}

	self:DashToWithCallback(tDash, tMotion, tAnim)
end
function roland_durandal:AddSlow(tInfo)
	local nSlowTime = tInfo.slow_time
	if not nSlowTime or nSlowTime == 0 then return end
	tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_roland_durandal_slow", {duration = nSlowTime})
end
function roland_durandal:SlashPFX1(tInfo)
	self:SlashPFX(tInfo.caster, Vector(0, 0, 128), 125, 1, nil)

	local vStart = tInfo.target:GetAbsOrigin() + Vector(-100, -100, 300)
	local vEnd = tInfo.target:GetAbsOrigin() + Vector(100, 100, -100)

	local nSlashPFX =	ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_big.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleShouldCheckFoW(nSlashPFX, false)
						ParticleManager:SetParticleControl(nSlashPFX, 0, vStart)
						ParticleManager:SetParticleControl(nSlashPFX, 2, vEnd)
						ParticleManager:ReleaseParticleIndex(nSlashPFX)
end
function roland_durandal:SlashPFX2(tInfo)
	self:SlashPFX(tInfo.caster, Vector(0, 0, 128), 125, 1, Vector(0, 180, 200))

	local vStart = tInfo.target:GetAbsOrigin() + Vector(100, 100, 300)
	local vEnd = tInfo.target:GetAbsOrigin() + Vector(-100, -100, -100)

	local nSlashPFX =	ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_big.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleShouldCheckFoW(nSlashPFX, false)
						ParticleManager:SetParticleControl(nSlashPFX, 0, vStart)
						ParticleManager:SetParticleControl(nSlashPFX, 2, vEnd)
						ParticleManager:ReleaseParticleIndex(nSlashPFX)
end



--====================================================================================================--
LinkLuaModifier("modifier_roland_durandal_slow", "heroes/roland/roland_durandal", LUA_MODIFIER_MOTION_NONE)

modifier_roland_durandal_slow = class({})

function modifier_roland_durandal_slow:IsHidden()										return false end
function modifier_roland_durandal_slow:IsDebuff()										return true end
function modifier_roland_durandal_slow:IsPurgable()										return true end
function modifier_roland_durandal_slow:IsPurgeException()								return true end
function modifier_roland_durandal_slow:RemoveOnDeath()									return true end
function modifier_roland_durandal_slow:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_durandal_slow:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_roland_durandal_slow:DeclareFunctions()
	local t = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return t
end
function modifier_roland_durandal_slow:GetModifierMoveSpeedBonus_Percentage(keys)
	return self:GetAbility():GetSpecialValueFor("slow_ms_value")
end


--====================================================================================================--
--====================================================================================================--
roland_durandal_ex = class(roland_durandal)