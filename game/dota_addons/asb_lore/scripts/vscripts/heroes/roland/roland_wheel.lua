require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
roland_wheel = class(roland_card)

function roland_wheel:OnCardDashImpact(hCaster, hTarget, vDir)
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

		part_1 =
		{
			ca_time = self:GetSpecialValueFor("ca_time_1"),
			ca_stunnable = self:GetSpecialValueFor("ca_stunnable_1"),

			act = ACT_DOTA_OVERRIDE_ABILITY_1,
			act_mod = "wheel_slash",

			damage = self:GetSpecialValueFor("ca_damage_1"),
			stun_time = self:GetSpecialValueFor("ca_stun_time_1"),
			radius = self:GetSpecialValueFor("ca_radius_1"),

			sound = "roland_wheel.slash",
		},
	}

	local nCATime = self:GetSpecialValueFor("ca_time")

	tInfo.cast =
	{
		ca_time = nCATime,

		act = ACT_DOTA_CAST_ABILITY_1,
		act_mod = "wheel_cast",

		ca_rate = GetAnimPlayRate(13, 13, 30, nCATime),

		ca_stunnable = self:GetSpecialValueFor("ca_stunnable"),
	}

	local p = tInfo.part_1

	p.ca_rate = GetAnimPlayRate(25, 25, 30, p.ca_time)
	p.ca_impact_time = GetAnimImpactTime(25, 9, 30, p.ca_time)

	self:WheelCast(tInfo)
end
function roland_wheel:WheelCast(tInfo)
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

	self:SetInterruptAndFacing(hAnim, tInfo.target, tInfo.cast.ca_time, 300, tInfo.cast.ca_stunnable > 0)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:WheelSlash(tInfo)
	end)
end
function roland_wheel:WheelSlash(tInfo)
	local p = tInfo.part_1

	local tAnim =
	{
		duration = p.ca_time,
		pause = -1,
		pause_sync = 1,
		activity = p.act,
		activities = json.encode({p.act_mod}),
		rate = p.ca_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	hAnim:AddCallbackThink(p.ca_impact_time,function(hMod)
		if hMod:IsInterrupted() then return end
		tInfo.point = tInfo.caster:GetAbsOrigin() + tInfo.caster:GetForwardVector() * tInfo.range
		local tEntities = FindUnitsInRadius(
			tInfo.team_id,
			tInfo.point,
			nil,
			p.radius,
			tInfo.target_team,
			tInfo.target_type,
			tInfo.target_flags,
			FIND_CLOSEST,
			false
		)
		for _, hEnt in ipairs(tEntities) do
			if IsNotNull(hEnt) and hEnt ~= tInfo.caster then
				self:AddStun({
					target = hEnt,
					caster = tInfo.caster,
					stun_time = p.stun_time
				})

				self:DoDamage({
					target = hEnt,
					caster = tInfo.caster,
					damage = p.damage
				})
			end
		end
		self:CreateBigSlashPFX(tInfo.caster, tInfo.point, p.radius)
		EmitSoundOn(p.sound, tInfo.caster)
		if HasTalent(tInfo.caster, "special_bonus_roland_20l") then
			tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_wheel_shield_buff",
				{
					duration = FindTalentValue(tInfo.caster, "special_bonus_roland_20l", "duration", 0),
					block = FindTalentValue(tInfo.caster, "special_bonus_roland_20l", "block", 0),
				})
		end
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:TurnPlayNext(tInfo.caster, tInfo.target, GetDirection(tInfo.target, tInfo.caster))
	end)
end
function roland_wheel:CreateBigSlashPFX(hCaster, vPoint, nRadius)
	self:SlashPFX(hCaster, Vector(0, 0, 128), 200, 0, Vector(0, 0, 0))
	local nExplodePFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_wheel/roland_wheel_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleShouldCheckFoW(nExplodePFX, false)
					ParticleManager:SetParticleControl(nExplodePFX, 0, vPoint)
					ParticleManager:SetParticleControl(nExplodePFX, 1, Vector(nRadius, nRadius, nRadius))
					ParticleManager:ReleaseParticleIndex(nExplodePFX)
end

--====================================================================================================--
--====================================================================================================--
roland_wheel_ex = class(roland_wheel)













--====================================================================================================--
LinkLuaModifier("modifier_roland_wheel_shield_buff", "heroes/roland/roland_wheel", LUA_MODIFIER_MOTION_NONE)

modifier_roland_wheel_shield_buff = class({})

function modifier_roland_wheel_shield_buff:IsHidden()										return false end
function modifier_roland_wheel_shield_buff:IsDebuff()										return false end
function modifier_roland_wheel_shield_buff:IsPurgable()										return false end
function modifier_roland_wheel_shield_buff:IsPurgeException()								return false end
function modifier_roland_wheel_shield_buff:RemoveOnDeath()									return true end
function modifier_roland_wheel_shield_buff:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_wheel_shield_buff:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_roland_wheel_shield_buff:DeclareFunctions()
	local t =
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT
	}
	return t
end
function modifier_roland_wheel_shield_buff:GetModifierIncomingDamageConstant(keys)
	if IsClient() then
		return self:GetStackCount()
	end
	if bit.band(keys.damage_type, DAMAGE_TYPE_ALL) == 0 or bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_BYPASSES_ALL_BLOCK) ~= 0 then return end
	local nDamage = keys.original_damage
	local nBlock = self:GetStackCount()
	local nCalc = math.ceil(nBlock - nDamage)
	if nCalc > 0 then
		self:SetStackCount(nCalc)
	else
		self:Destroy()
	end
	return -math.min(nDamage, nBlock)
end
function modifier_roland_wheel_shield_buff:OnCreated(tInfo)
	self.hCaster = self:GetCaster()
	self.hParent = self:GetParent()
	self.hAbility = self:GetAbility()

	if IsServer() and tInfo.block then
		self:SetStackCount(tInfo.block or 0)
		print(tInfo.block, self:GetStackCount())
	end
end
function modifier_roland_wheel_shield_buff:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end