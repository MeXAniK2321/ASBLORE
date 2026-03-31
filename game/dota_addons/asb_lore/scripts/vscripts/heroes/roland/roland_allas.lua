require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
roland_allas = class(roland_card)

function roland_allas:OnCardDashImpact(hCaster, hTarget, vDir)
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
			ca_stunnable = self:GetSpecialValueFor("ca_stunnable_1"),

			ca_time = self:GetSpecialValueFor("ca_time_1"),

			ca_act = ACT_DOTA_CAST_ABILITY_1,
			ca_act_mod = "allas_cast_1",

			damage = self:GetSpecialValueFor("damage_1"),

			knock_time = self:GetSpecialValueFor("knock_time_1"),
			knock_range = self:GetSpecialValueFor("knock_range_1"),
			knock_stun_time = self:GetSpecialValueFor("knock_stun_time_1"),
		},

		part_2 =
		{
			ca_stunnable = self:GetSpecialValueFor("ca_stunnable_2"),

			ca_time = self:GetSpecialValueFor("ca_time_2"),
			ca_act = ACT_DOTA_CAST_ABILITY_2,
			ca_act_mod = "allas_cast_2",
			
			da_stunnable = self:GetSpecialValueFor("da_stunnable_2"),

			da_time = self:GetSpecialValueFor("da_time_2"),
			
			da_act = ACT_DOTA_OVERRIDE_ABILITY_2,
			da_act_mod = "allas_slash_loop",

			da_range = self:GetSpecialValueFor("da_range_2"),

			radius = self:GetSpecialValueFor("radius_2"),
			damage = self:GetSpecialValueFor("damage_2"),
		}
	}

	tInfo.part_1.ca_rate = GetAnimPlayRate(22, 22, 30, tInfo.part_1.ca_time)
	tInfo.part_1.ca_impact_time = GetAnimImpactTime(22, 12, 30, tInfo.part_1.ca_time)

	tInfo.part_2.ca_rate = GetAnimPlayRate(11, 11, 30, tInfo.part_2.ca_time)
	tInfo.part_2.da_rate = GetAnimPlayRate(19, 19, 30, tInfo.part_2.da_time)

	self:AllasSlash1(tInfo, 1)
end

function roland_allas:AllasSlash1(tInfo, nIndex)
	local _tInfo = tInfo["part_"..nIndex]
	if not _tInfo then return end

	local tAnim =
	{
		duration = _tInfo.ca_time,
		pause = -1,
		pause_sync = 1,
		activity = _tInfo.ca_act,
		activities = json.encode({_tInfo.ca_act_mod}),
		rate = _tInfo.ca_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, _tInfo.ca_impact_time or _tInfo.ca_time, 300 + (_tInfo.da_range or 0), _tInfo.ca_stunnable > 0)

	if _tInfo.ca_impact_time then
		hAnim:AddCallbackThink(_tInfo.ca_impact_time, function(hMod, _tTimer, nTime)
			if hMod:IsInterrupted() then return end
			self:AddStun({
				target = tInfo.target,
				caster = tInfo.caster,
				stun_time = _tInfo.knock_stun_time
			})
			self:AddKnock({
				target = tInfo.target,
				caster = tInfo.caster,
				dir = tInfo.caster:GetForwardVector(),
				knock_time = _tInfo.knock_time,
				knock_range = _tInfo.knock_range
			})
			self:DoDamage({
				target = tInfo.target,
				caster = tInfo.caster,
				damage = _tInfo.damage
			})
			EmitSoundOn("roland_mimicry.slash_guard", tInfo.caster)
			self:CreateImpactPFX(tInfo.target)
		end)
	end

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		tInfo.dir = tInfo.caster:GetForwardVector()
		self:AllasSlash2(tInfo, nIndex)
	end)
end
function roland_allas:AllasSlash2(tInfo, nIndex)
	local _tInfo = tInfo["part_"..nIndex]
	if not _tInfo then return end

	if not _tInfo.da_range then
		self:AllasSlash1(tInfo, nIndex + 1)
		return
	end

	local tDash =
	{
		caster = tInfo.caster,

		team_id = tInfo.team_id,
		target_team = tInfo.target_team,
		target_type = tInfo.target_type,
		target_flags = tInfo.target_flags,

		radius = _tInfo.radius,

		stunnable = _tInfo.da_stunnable,

		sound = "roland_turn.end",

		-- on_hit
		-- on_end

		particle_dash = 1,
	}

	local tMotion =
	{
		duration = _tInfo.da_time,
		dir_x = tInfo.dir.x,
		dir_y = tInfo.dir.y,
		distance = _tInfo.da_range,
		-- target = tInfo.target:entindex(),
	}

	local tAnim =
	{
		pause = -1,
		pause_sync = 1,
		activity = _tInfo.da_act,
		activities = json.encode({_tInfo.da_act_mod}),
		rate = _tInfo.da_rate,
		rate_time = _tInfo.da_time,
	}

	local function OnHit(hTarget, _nIndex)
		if tInfo.caster == hTarget then return end
		self:AddDamageReduction({
			target = hTarget,
			caster = tInfo.caster
		})
		self:DoDamage({
			target = hTarget,
			caster = tInfo.caster,
			damage = _tInfo.damage
		})
		EmitSoundOn("roland_mimicry.slash_guard", tInfo.caster)
		self:CreateImpactPFX(hTarget)
		return false
	end

	local function OnEnd(hTarget, bInterrupted)
		if bInterrupted then return end-- or IsNull(hTarget) then return end
		-- self:AllasSlash1(tInfo, nIndex)
		self:TurnPlayNext(tInfo.caster, tInfo.target, GetDirection(tInfo.target, tInfo.caster))
	end

	tDash.on_hit = OnHit
	tDash.on_end = OnEnd

	local hMotion, hAnim = self:DashToWithCallback(tDash, tMotion, tAnim)
	if IsNull(hMotion) then return end
	if not hMotion._nAllasDashPFX then
		local nDashPFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_allas/roland_allas_dash.vpcf", PATTACH_ABSORIGIN_FOLLOW, tInfo.caster)
		hMotion:AddParticle(nDashPFX, false, false, -1, false, false)
		hMotion._nAllasDashPFX = nDashPFX
	end
end
function roland_allas:AddDamageReduction(tInfo)
	tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_roland_allas_damage_reduction_debuff", {duration = self:GetSpecialValueFor("dr_duration_2")})
end
function roland_allas:CreateImpactPFX(hTarget)
	local nHitPFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_logic/roland_logic_shot_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleShouldCheckFoW(nHitPFX, false)
					ParticleManager:SetParticleControl(nHitPFX, 0, hTarget:GetAbsOrigin() + Vector(0, 0, 50))
					ParticleManager:SetParticleControl(nHitPFX, 3, hTarget:GetAbsOrigin() + Vector(0, 0, 50))
					ParticleManager:ReleaseParticleIndex(nHitPFX)
end







--====================================================================================================--
LinkLuaModifier("modifier_roland_allas_damage_reduction_debuff", "heroes/roland/roland_allas", LUA_MODIFIER_MOTION_NONE)

modifier_roland_allas_damage_reduction_debuff = class({})

function modifier_roland_allas_damage_reduction_debuff:IsHidden()										return false end
function modifier_roland_allas_damage_reduction_debuff:IsDebuff()										return true end
function modifier_roland_allas_damage_reduction_debuff:IsPurgable()										return true end
function modifier_roland_allas_damage_reduction_debuff:IsPurgeException()								return true end
function modifier_roland_allas_damage_reduction_debuff:RemoveOnDeath()									return true end
function modifier_roland_allas_damage_reduction_debuff:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_allas_damage_reduction_debuff:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_roland_allas_damage_reduction_debuff:DeclareFunctions()
	local t = 
	{
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
	return t
end
function modifier_roland_allas_damage_reduction_debuff:GetModifierTotalDamageOutgoing_Percentage(keys)
	return self:GetAbility():GetSpecialValueFor("dr_value_2")
end


--====================================================================================================--
--====================================================================================================--
roland_allas_ex = class(roland_allas)