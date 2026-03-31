require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
roland_zelkova = class(roland_card)

function roland_zelkova:OnCardDashImpact(hCaster, hTarget, vDir)
	if IsNull(hTarget) or hTarget:TriggerSpellAbsorb(self) then return end

	local tInfo =
	{
		target = hTarget,
		caster = hCaster,

		sa_act = ACT_DOTA_OVERRIDE_ABILITY_1,
		sa_act_mod = "zelkova_slash_12",

		sa_stunnable = self:GetSpecialValueFor("sa_stunnable"),

		sa_time_1 = self:GetSpecialValueFor("sa_time_1"),
		sa_time_2 = self:GetSpecialValueFor("sa_time_2"),

		root_duration = self:GetSpecialValueFor("root_duration"),

		damage_1 = self:GetSpecialValueFor("damage_1"),
		damage_2 = self:GetSpecialValueFor("damage_2"),
	}
	
	tInfo.sa_time_12 = tInfo.sa_time_1 + tInfo.sa_time_2

	tInfo.sa_impact_time_1 = GetAnimImpactTime(33, 8, 30, tInfo.sa_time_12)
	tInfo.sa_impact_time_2 = GetAnimImpactTime(33, 23, 30, tInfo.sa_time_12)

	tInfo.sa_rate = GetAnimPlayRate(33, 33, 30, tInfo.sa_time_12)

	local bSecondary = RollPercentage(51)
	if bSecondary then
		tInfo.sa_act = ACT_DOTA_OVERRIDE_ABILITY_2
		tInfo.sa_rate = GetAnimPlayRate(45, 45, 30, tInfo.sa_time_12)
		tInfo.sa_impact_time_1 = GetAnimImpactTime(45, 13, 30, tInfo.sa_time_12)
		tInfo.sa_impact_time_2 = GetAnimImpactTime(45, 26, 30, tInfo.sa_time_12)
	end

	local tAnim =
	{
		duration = tInfo.sa_time_12,
		pause = -1,
		pause_sync = 1,
		activity = tInfo.sa_act,
		activities = json.encode({tInfo.sa_act_mod}),
		rate = tInfo.sa_rate
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, tInfo.sa_time_12, 300, tInfo.sa_stunnable > 0)

	hAnim:AddCallbackThink(tInfo.sa_impact_time_1, function(hMod, _tTimer, nTime)
		if hMod:IsInterrupted() then return end
		self:AddRoot({target = tInfo.target, caster = tInfo.caster, root_time = tInfo.root_duration})
		self:DoDamage({target = tInfo.target, caster = tInfo.caster, damage = tInfo.damage_1})
		EmitSoundOn("roland_zelkova.slash_1", tInfo.caster)
		if bSecondary then
			self:CreatePFX21(tInfo.caster, tInfo.target)
		else
			self:CreatePFX11(tInfo.caster, tInfo.target)
		end
	end)

	hAnim:AddCallbackThink(tInfo.sa_impact_time_2, function(hMod, _tTimer, nTime)
		if hMod:IsInterrupted() then return end
		self:AddRoot({target = tInfo.target, caster = tInfo.caster, root_time = tInfo.root_duration})
		self:DoDamage({target = tInfo.target, caster = tInfo.caster, damage = tInfo.damage_2})
		EmitSoundOn("roland_zelkova.slash_2", tInfo.caster)
		if bSecondary then
			self:CreatePFX22(tInfo.caster, tInfo.target)
		else
			self:CreatePFX12(tInfo.caster, tInfo.target)
		end
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:TurnPlayNext(tInfo.caster, tInfo.target, GetDirection(tInfo.target, tInfo.caster))
	end)
end
function roland_zelkova:CreatePFX11(hCaster, hTarget)
	self:SlashPFX(hCaster, Vector(0, 0, 128), 100, 1, Vector(-15, 0, 0))
	self:CreateHitPFX(hTarget)
end
function roland_zelkova:CreatePFX12(hCaster, hTarget)
	self:SlashPFX(hCaster, Vector(0, 0, 128), 100, 1, Vector(15, 0, 0))
	self:CreateHitPFX(hTarget)
end
function roland_zelkova:CreatePFX21(hCaster, hTarget)
	self:SlashPFX(hCaster, Vector(0, 0, 128), 100, 1, Vector(0, 0, 0))
	self:CreateHitPFX(hTarget)
end
function roland_zelkova:CreatePFX22(hCaster, hTarget)
	self:SlashPFX(hCaster, Vector(0, 0, 128), 100, 1, Vector(90, 0, 30))
	self:CreateHitPFX(hTarget)
end
function roland_zelkova:CreateHitPFX(hTarget)
	local nHitPFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_logic/roland_logic_shot_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleShouldCheckFoW(nHitPFX, false)
					ParticleManager:SetParticleControl(nHitPFX, 0, hTarget:GetAbsOrigin() + Vector(0, 0, 50))
					ParticleManager:SetParticleControl(nHitPFX, 3, hTarget:GetAbsOrigin() + Vector(0, 0, 50))
					ParticleManager:ReleaseParticleIndex(nHitPFX)
end
--====================================================================================================--
--====================================================================================================--
roland_zelkova_ex = class(roland_zelkova)