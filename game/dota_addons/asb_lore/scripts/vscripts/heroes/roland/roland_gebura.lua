require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
roland_gebura_horizontal = class(roland_card)

function roland_gebura_horizontal:Spawn()
	if IsServer() then
		Timers:CreateTimer(0, function()
			self:SetLevel(1)
		end)
	end
end
function roland_gebura_horizontal:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPoint = self:GetCursorPosition()

	self:PreCastDashToTarget(hCaster, vPoint, GetDirection(vPoint, hCaster))
end
function roland_gebura_horizontal:OnCardDashImpact(hCaster, hTarget, vDir)
	if IsNull(hTarget) or hTarget:TriggerSpellAbsorb(self) then return end

	local tInfo =
	{
		target = hTarget,
		caster = hCaster,

		range = GetDistance(hTarget, hCaster),

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),
		
		radius = self:GetSpecialValueFor("radius"),

		sa_stunnable = self:GetSpecialValueFor("sa_stunnable"),

		sa_time = self:GetSpecialValueFor("sa_time"),

		sa_act = ACT_DOTA_CAST_ABILITY_1,
		sa_act_mod = "",

		damage = self:GetSpecialValueFor("damage"),

		stun_time = self:GetSpecialValueFor("stun_time"),
		vision_time = self:GetSpecialValueFor("vision_time"),

		sound = "roland_durandal.slash_3",
	}

	tInfo.sa_rate = GetAnimPlayRate(51, 51, 50, tInfo.sa_time)

	tInfo.sa_impact_time = GetAnimImpactTime(51, 25, 50, tInfo.sa_time)

	self:SlashCast(tInfo)
end
function roland_gebura_horizontal:SlashCast(tInfo)
	local tAnim =
	{
		duration = tInfo.sa_time,
		pause = -1,
		pause_sync = 1,
		activity = tInfo.sa_act,
		activities = json.encode({tInfo.sa_act_mod}),
		rate = tInfo.sa_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	hAnim:AddCallbackThink(tInfo.sa_impact_time,function(hMod)
		if hMod:IsInterrupted() then return end
		tInfo.point = tInfo.caster:GetAbsOrigin() + tInfo.caster:GetForwardVector() * tInfo.range
		local tEntities = FindUnitsInRadius(
			tInfo.team_id,
			tInfo.point,
			nil,
			tInfo.radius,
			tInfo.target_team,
			tInfo.target_type,
			tInfo.target_flags,
			FIND_CLOSEST,
			false
		)
		for _, hEnt in ipairs(tEntities) do
			if IsNotNull(hEnt) and hEnt ~= tInfo.caster then
				hEnt:AddNewModifier(tInfo.caster, self, "modifier_roland_mimicry_vision_debuff", {duration = tInfo.vision_time})

				self:AddStun({
					target = hEnt,
					caster = tInfo.caster,
					stun_time = tInfo.stun_time
				})

				self:DoDamage({
					target = hEnt,
					caster = tInfo.caster,
					damage = tInfo.damage - 1000,
				})

				
			end
		end
		
		-- EmitSoundOn(tInfo.sound, tInfo.caster)
		EmitSoundOnLocationWithCaster(tInfo.point, "roland_durandal.slash_3", tInfo.caster)

		self:SlashPFX_Red(tInfo.caster, Vector(0, 0, 128),  tInfo.radius, -1, Vector(90, -35, 45))
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
	end)
end












--====================================================================================================--
--====================================================================================================--
roland_gebura_vertical = class(roland_card)

function roland_gebura_vertical:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPoint = self:GetCursorPosition()

	self:PreCastDashToTarget(hCaster, vPoint, GetDirection(vPoint, hCaster))
end
function roland_gebura_vertical:OnCardDashImpact(hCaster, hTarget, vDir)
	if IsNull(hTarget) or hTarget:TriggerSpellAbsorb(self) then return end

	local tInfo =
	{
		target = hTarget,
		caster = hCaster,

		range = GetDistance(hTarget, hCaster),

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),
		
		radius = self:GetSpecialValueFor("radius"),

		sa_stunnable = self:GetSpecialValueFor("sa_stunnable"),

		sa_time = self:GetSpecialValueFor("sa_time"),

		sa_act = ACT_DOTA_CAST_ABILITY_2,
		sa_act_mod = "",

		damage = self:GetSpecialValueFor("damage"),

		stun_time = self:GetSpecialValueFor("stun_time"),
		vision_time = self:GetSpecialValueFor("vision_time"),

		sound = "roland_durandal.slash_3",
	}

	tInfo.sa_rate = GetAnimPlayRate(70, 70, 70, tInfo.sa_time)

	tInfo.sa_impact_time = GetAnimImpactTime(70, 37, 74, tInfo.sa_time)

	self:SlashCast(tInfo)
end
function roland_gebura_vertical:SlashCast(tInfo)
	local tAnim =
	{
		duration = tInfo.sa_time,
		pause = -1,
		pause_sync = 1,
		activity = tInfo.sa_act,
		activities = json.encode({tInfo.sa_act_mod}),
		rate = tInfo.sa_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	hAnim:AddCallbackThink(tInfo.sa_impact_time,function(hMod)
		if hMod:IsInterrupted() then return end
		tInfo.point = tInfo.caster:GetAbsOrigin() + tInfo.caster:GetForwardVector() * tInfo.range
		local tEntities = FindUnitsInRadius(
			tInfo.team_id,
			tInfo.point,
			nil,
			tInfo.radius,
			tInfo.target_team,
			tInfo.target_type,
			tInfo.target_flags,
			FIND_CLOSEST,
			false
		)
		for _, hEnt in ipairs(tEntities) do
			if IsNotNull(hEnt) and hEnt ~= tInfo.caster then
				hEnt:AddNewModifier(tInfo.caster, self, "modifier_roland_mimicry_vision_debuff", {duration = tInfo.vision_time})

				self:AddStun({
					target = hEnt,
					caster = tInfo.caster,
					stun_time = tInfo.stun_time
				})

				self:DoDamage({
					target = hEnt,
					caster = tInfo.caster,
					damage = tInfo.damage
				})
			end
		end
		
		-- EmitSoundOn(tInfo.sound, tInfo.caster)
		EmitSoundOnLocationWithCaster(tInfo.point, "roland_durandal.slash_3", tInfo.caster)

		self:SlashPFX_Red(tInfo.caster, Vector(0, 0, 128), tInfo.radius, -1, Vector(0, 0, 0))
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
	end)
end









--====================================================================================================--
--====================================================================================================--
roland_gebura_dash = class(roland_card)

function roland_gebura_dash:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPoint = self:GetCursorPosition()

	self:PreCastDashToTarget(hCaster, vPoint, GetDirection(vPoint, hCaster))
end


























--====================================================================================================--
LinkLuaModifier("modifier_roland_mimicry_vision_debuff", "heroes/roland/roland_mimicry", LUA_MODIFIER_MOTION_NONE)

modifier_roland_mimicry_vision_debuff = class({})

function modifier_roland_mimicry_vision_debuff:IsHidden()										return false end
function modifier_roland_mimicry_vision_debuff:IsDebuff()										return true end
function modifier_roland_mimicry_vision_debuff:IsPurgable()										return true end
function modifier_roland_mimicry_vision_debuff:IsPurgeException()								return true end
function modifier_roland_mimicry_vision_debuff:RemoveOnDeath()									return true end
function modifier_roland_mimicry_vision_debuff:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_mimicry_vision_debuff:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_roland_mimicry_vision_debuff:CheckState()
	local t = 
	{
		[MODIFIER_STATE_PROVIDES_VISION] = true
	}
	return t
end


--====================================================================================================--
--====================================================================================================--