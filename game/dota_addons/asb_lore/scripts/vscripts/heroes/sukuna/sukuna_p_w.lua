require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_p_w = class({})

function sukuna_p_w:GetPlaybackRateOverride()
	return GetAnimPlayRate(15, 11, 30, self:GetCastPoint())
end
function sukuna_p_w:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sukuna_animation_generic_activity", {duration = 0.1, activity = "phys"})
	return true
end
function sukuna_p_w:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
end
function sukuna_p_w:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition()

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

		ca_act = ACT_DOTA_CAST_ABILITY_2_END,
		ca_act_mod = "phys",

		radius = self:GetSpecialValueFor("radius"),

		angle = self:GetSpecialValueFor("angle") * 0.5,
		
		damage = self:GetSpecialValueFor("damage"),
		
		dash_range = self:GetSpecialValueFor("dash_range"),
		
		stun_duration = self:GetSpecialValueFor("stun_duration"),
		
		black_flash_duration = self:GetSpecialValueFor("black_flash_duration"),
	}

	tInfo.damage = tInfo.damage + (self:GetSpecialValueFor("damage_attack_pct") * 0.01 * tInfo.caster:GetAverageTrueAttackDamage(tInfo.caster))

	tInfo.ca_rate = GetAnimPlayRate(24, 24, 30, tInfo.ca_time)
	tInfo.ca_impact_time = GetAnimImpactTime(24, 8, 30, tInfo.ca_time)

	local tEntities = FindUnitsInRadius(
		tInfo.team_id,
		hCaster:GetAbsOrigin(),
		nil,
		tInfo.radius,
		tInfo.target_team,
		tInfo.target_type,
		tInfo.target_flags,
		FIND_CLOSEST,
		false)

	tInfo.enemies = {}

	for _, hEnt in ipairs(tEntities) do
		if hEnt ~= tInfo.caster then
			local vToEnemy = GetDirection(hEnt, hCaster)
			local nDirDiff = GetDirDiff(tInfo.dir, vToEnemy)

			if math.abs(nDirDiff) <= tInfo.angle then
				table.insert(tInfo.enemies, hEnt)
			end
		end
	end

	self:CastAnimation(tInfo)
end
function sukuna_p_w:CastAnimation(tInfo)
	local hNextEnt = nil
	for n = #tInfo.enemies, 1, -1 do
		local hEnt = tInfo.enemies[n]
		if self:IsValidTarget(hEnt) then
			hNextEnt = hEnt
		end
		tInfo.enemies[n] = nil
		break
	end

	if IsNull(hNextEnt) then return end

	local vDashDir = hNextEnt:GetForwardVector()

	local vOffsetSpawn = hNextEnt:GetAbsOrigin() + -vDashDir * tInfo.dash_range

	FindClearSpaceForUnit(tInfo.caster, vOffsetSpawn, true)

	local tMotion =
	{
		duration = tInfo.ca_impact_time,

		target = hNextEnt:entindex(),

		-- distance = tInfo.dash_range,
		-- speed = 1000,
		-- height = tInfo.dash_height,

		facing = 1,

		path_trees = 1,
		path_hg = 1,
		path_blocked = 1,
	}

	local hMotion = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_motion_generic", tMotion)

	if IsNull(hMotion) or hMotion:IsInterrupted() then return end

	EmitSoundOn("sukuna_dash.cast", tInfo.caster)

	local nPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_dash/sukuna_dash_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, tInfo.caster)
	
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
		hNextEnt:AddNewModifier(tInfo.caster, self, "modifier_stunned", {duration = tInfo.stun_duration})
		hNextEnt:AddNewModifier(tInfo.caster, self, "sukuna_p_w_black_flash_debuff", {duration = tInfo.black_flash_duration})
		self:SlashTarget({
			target = hNextEnt,
			caster = tInfo.caster,
			damage = tInfo.damage,
		})
	end)

	hAnim:AddCallbackThink(tInfo.ca_impact_time + 0.1, function(hMod)
		self:CastAnimation(tInfo)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		ParticleManager:DestroyParticle(nPFX, false)
		ParticleManager:ReleaseParticleIndex(nPFX)
		if IsNull(hMotion) then return end
		hMotion:Destroy(hMod:IsInterrupted())
	end)
end
function sukuna_p_w:SlashTarget(tInfo)
	EmitSoundOn("sukuna_black_flash.impact", tInfo.target)

	local nBlackFlash = ParticleManager:CreateParticle("", PATTACH_CENTER_FOLLOW, tInfo.target)
						ParticleManager:ReleaseParticleIndex(nBlackFlash)

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
function sukuna_p_w:IsValidTarget(hTarget)
	local hCaster = self:GetCaster()
	return IsNotNull(hCaster) and (UnitFilter(
		hTarget,
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		hCaster:GetTeamNumber()) == UF_SUCCESS)
end


--====================================================================================================--
LinkLuaModifier("sukuna_p_w_black_flash_debuff", "heroes/sukuna/sukuna_p_w", LUA_MODIFIER_MOTION_NONE)

sukuna_p_w_black_flash_debuff = class({})

function sukuna_p_w_black_flash_debuff:IsHidden()											return false end
function sukuna_p_w_black_flash_debuff:IsDebuff()											return true end
function sukuna_p_w_black_flash_debuff:IsPurgable()											return false end
function sukuna_p_w_black_flash_debuff:IsPurgeException()									return false end
function sukuna_p_w_black_flash_debuff:RemoveOnDeath()										return true end
function sukuna_p_w_black_flash_debuff:GetAttributes()										return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function sukuna_p_w_black_flash_debuff:GetPriority()										return MODIFIER_PRIORITY_NORMAL end
function sukuna_p_w_black_flash_debuff:CheckState()
	local t = {}
	t[MODIFIER_STATE_TETHERED] = true
	return t
end
function sukuna_p_w_black_flash_debuff:GetEffectName()
	return "particles/heroes/sukuna/sukuna_black_flash/sukuna_black_flash.vpcf"
end
function sukuna_p_w_black_flash_debuff:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end