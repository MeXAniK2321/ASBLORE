require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
roland_boys = class(roland_card)

function roland_boys:OnCardDashImpact(hCaster, hTarget, vDir)
	if IsNull(hTarget) or hTarget:TriggerSpellAbsorb(self) then return end
	
	local tInfo =
	{
		target = hTarget,
		caster = hCaster,

		ca_stunnable = FindTalentValue(hCaster, "special_bonus_roland_10l", nil, self:GetSpecialValueFor("ca_stunnable")),
		ca_time = self:GetSpecialValueFor("ca_time"),

		ca_act = ACT_DOTA_CAST_ABILITY_1,
		ca_act_mod = "boys_cast",

		gain_light = self:GetSpecialValueFor("gain_light"),
		damage = self:GetSpecialValueFor("damage"),

		knock_time = self:GetSpecialValueFor("knock_time"),
		knock_range = self:GetSpecialValueFor("knock_range"),
		knock_stun_time = self:GetSpecialValueFor("knock_stun_time"),
	}

	tInfo.ca_rate = GetAnimPlayRate(34, 34, 30, tInfo.ca_time)
	tInfo.ca_impact_time = GetAnimImpactTime(34, 19, 30, tInfo.ca_time)

	self:BoysCast(tInfo)
end
function roland_boys:AddDamageReduction(hCaster)
	hCaster:AddNewModifier(hCaster, self, "modifier_roland_boys_damage_reduction", {duration = self:GetSpecialValueFor("dr_duration")})
end
function roland_boys:BoysCast(tInfo)
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

	self:SetInterruptAndFacing(hAnim, tInfo.target, tInfo.ca_impact_time, 300, tInfo.ca_stunnable > 0)

	hAnim:AddCallbackThink(tInfo.ca_impact_time, function(hMod, _tTimer, nTime)
		if hMod:IsInterrupted() then return end
		self:AddStun({
			target = tInfo.target,
			caster = tInfo.caster,
			stun_time = tInfo.knock_stun_time
		})
		self:AddKnock({
			target = tInfo.target,
			caster = tInfo.caster,
			dir = tInfo.caster:GetForwardVector(),
			knock_time = tInfo.knock_time,
			knock_range = tInfo.knock_range
		})
		self:DoDamage({
			target = tInfo.target,
			caster = tInfo.caster,
			damage = tInfo.damage
		})
		self:AddDamageReduction(tInfo.caster)
		ROLAND_LightAdd(tInfo.caster, tInfo.gain_light)
		EmitSoundOn("roland_mimicry.slash_guard", tInfo.caster)
		self:CreatePFX(tInfo)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:TurnPlayNext(tInfo.caster, tInfo.target, GetDirection(tInfo.target, tInfo.caster))
	end)
end
function roland_boys:CreatePFX(tInfo)
	self:SlashPFX(tInfo.caster, Vector(0, 0, 128), 75, 2, Vector(-90, 0, 25))
	local nHitPFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_logic/roland_logic_shot_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleShouldCheckFoW(nHitPFX, false)
					ParticleManager:SetParticleControl(nHitPFX, 0, tInfo.target:GetAbsOrigin() + Vector(0, 0, 50))
					ParticleManager:SetParticleControl(nHitPFX, 3, tInfo.target:GetAbsOrigin() + Vector(0, 0, 50))
					ParticleManager:ReleaseParticleIndex(nHitPFX)
end
--====================================================================================================--
LinkLuaModifier("modifier_roland_boys_damage_reduction", "heroes/roland/roland_boys", LUA_MODIFIER_MOTION_NONE)

modifier_roland_boys_damage_reduction = class({})

function modifier_roland_boys_damage_reduction:IsHidden()										return false end
function modifier_roland_boys_damage_reduction:IsDebuff()										return false end
function modifier_roland_boys_damage_reduction:IsPurgable()										return true end
function modifier_roland_boys_damage_reduction:IsPurgeException()								return true end
function modifier_roland_boys_damage_reduction:RemoveOnDeath()									return true end
function modifier_roland_boys_damage_reduction:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_boys_damage_reduction:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_roland_boys_damage_reduction:DeclareFunctions()
	local t = 
	{
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return t
end
function modifier_roland_boys_damage_reduction:GetModifierIncomingDamage_Percentage(keys)
	return self:GetAbility():GetSpecialValueFor("dr_value")
end


--====================================================================================================--
--====================================================================================================--
roland_boys_ex = class(roland_boys)