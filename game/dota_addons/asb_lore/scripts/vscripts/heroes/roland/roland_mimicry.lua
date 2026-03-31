require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
roland_mimicry = class(roland_card)

function roland_mimicry:OnCardDashImpact(hCaster, hTarget, vDir)
	if IsNull(hTarget) then return end

	if hTarget:TriggerSpellAbsorb(self) then return end

	local vDirNow = GetDirection(hTarget, hCaster)
	hCaster:FaceTowards(hTarget:GetAbsOrigin() + vDirNow * 300)
	SetForwardVector(hCaster, vDirNow, true)

	local vPoint = hTarget:GetAbsOrigin()

	local team_id = hCaster:GetTeamNumber()
	local target_team = self:GetAbilityTargetTeam()
	local target_type = self:GetAbilityTargetType()
	local target_flags = self:GetAbilityTargetFlags()

	local bsaStunnable = self:GetSpecialValueFor("sa_stunnable") > 0

	local nsaTime = self:GetSpecialValueFor("sa_time")

	local nsaRadius = self:GetSpecialValueFor("sa_radius")
	
	local nsaDamage = self:GetSpecialValueFor("sa_damage")

	local nImpactTime = GetAnimImpactTime(37, 20, 30, nsaTime)

	local nsaVisionTime = self:GetSpecialValueFor("sa_vision_time")

	local tAnim =
	{
		duration = nsaTime,
		pause = -1,
		pause_sync = 1,
		activity = ACT_DOTA_OVERRIDE_ABILITY_1,
		activities = json.encode({"mimicry_slash"}),
		rate = GetAnimPlayRate(37, 37, 30, nsaTime),
	}

	local hAnim = hCaster:AddNewModifier(hCaster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	hAnim:AddCallbackThink(FrameTime(), function(hMod, _tTimer, nTime)
		if IsNull(hTarget) or GetDistance(hTarget, hCaster) > 300 or (bsaStunnable and hCaster:IsStunned()) then
			hMod:Destroy(true)
			return
		end
		return nTime
	end)

	hAnim:AddCallbackThink(nImpactTime, function(hMod, _tTimer, nTime)
		if hMod:IsInterrupted() then return end
		local tEntities = FindUnitsInRadius(team_id, vPoint, nil, nsaRadius, target_team, target_type, target_flags, FIND_CLOSEST, false)
		for _, hEnt in ipairs(tEntities) do
			if hCaster ~= hEnt and IsNotNull(hEnt) then
				self:AddVision({target = hEnt, caster = hCaster, vision_time = nsaVisionTime})
				self:DoDamage({target = hEnt, caster = hCaster, damage = nsaDamage})
			end
		end
		EmitSoundOn("roland_durandal.slash_3", hCaster)
	end)
end
function roland_mimicry:AddVision(tInfo)
	local nVisionTime = tInfo.vision_time
	if not nVisionTime or nVisionTime == 0 then return end
	tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_roland_mimicry_vision_debuff", {duration = nVisionTime})
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