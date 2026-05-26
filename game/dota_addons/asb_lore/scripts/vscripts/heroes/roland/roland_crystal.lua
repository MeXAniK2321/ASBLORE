require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
roland_crystal = class(roland_card)

function roland_crystal:OnCardDashImpact(hCaster, hTarget, vDir)
	if IsNull(hTarget) or hTarget:TriggerSpellAbsorb(self) then return end

	local tInfo =
	{
		target = hTarget,
		caster = hCaster,

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		radius = self:GetSpecialValueFor("radius"),

		part_1 =
		{
			ca_time = self:GetSpecialValueFor("ca_time_1"),
			ca_invul = self:GetSpecialValueFor("ca_invul_1"),
			ca_stunnable = self:GetSpecialValueFor("ca_stunnable_1"),

			ca_act = ACT_DOTA_CAST_ABILITY_1,
			ca_act_mod = "crystal_cast_1",

			da_stunnable = self:GetSpecialValueFor("da_stunnable_1"),
			da_time = self:GetSpecialValueFor("da_time_1"),
			da_range = self:GetSpecialValueFor("da_range_1"),

			act = ACT_DOTA_OVERRIDE_ABILITY_1,
			act_mod = "crystal_slash_1",

			damage = self:GetSpecialValueFor("da_damage_1"),
			bleeds = self:GetSpecialValueFor("da_bleeds_1") * FindTalentValue(hCaster, "special_bonus_roland_25l", nil, 1),

			sound_dash = "roland_turn.end",
			sound_slash = "roland_ranga.slash_1",
		},

		part_2 =
		{
			ca_time = self:GetSpecialValueFor("ca_time_2"),
			ca_invul = self:GetSpecialValueFor("ca_invul_2"),
			ca_stunnable = self:GetSpecialValueFor("ca_stunnable_2"),

			ca_act = ACT_DOTA_CAST_ABILITY_2,
			ca_act_mod = "crystal_cast_2",

			da_stunnable = self:GetSpecialValueFor("da_stunnable_2"),
			da_time = self:GetSpecialValueFor("da_time_2"),
			da_range = self:GetSpecialValueFor("da_range_2"),

			act = ACT_DOTA_OVERRIDE_ABILITY_2,
			act_mod = "crystal_slash_2",

			damage = self:GetSpecialValueFor("da_damage_2"),
			bleeds = self:GetSpecialValueFor("da_bleeds_2") * FindTalentValue(hCaster, "special_bonus_roland_25l", nil, 1),

			sound_dash = "roland_turn.end",
			sound_slash = "roland_ranga.slash_2",
		}
	}

	local nAttackScale = self:GetSpecialValueFor("damage_attack_pct") * 0.01 * tInfo.caster:GetAverageTrueAttackDamage(tInfo.caster)

	tInfo.part_1.damage = tInfo.part_1.damage + nAttackScale
	tInfo.part_2.damage = tInfo.part_2.damage + nAttackScale

	tInfo.part_1.ca_rate = GetAnimPlayRate(8, 8, 30, tInfo.part_1.ca_time)
	tInfo.part_2.ca_rate = GetAnimPlayRate(13, 4, 30, tInfo.part_2.ca_time)

	tInfo.part_1.da_rate = GetAnimPlayRate(29, 29, 30, tInfo.part_1.da_time)
	tInfo.part_2.da_rate = GetAnimPlayRate(22, 22, 30, tInfo.part_2.da_time)

	self:CrystalCast(tInfo, 1)
end
function roland_crystal:CrystalCast(tInfo, nIndex)
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
		activity = _tInfo.ca_act,
		activities = json.encode({_tInfo.ca_act_mod}),
		rate = _tInfo.ca_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, _tInfo.ca_time, _tInfo.da_range, _tInfo.ca_stunnable > 0)

	local hInvul = self:AddInvul({
		target = tInfo.caster,
		caster = tInfo.caster,
		invul_time = _tInfo.ca_invul
	})

	hAnim:AddCallbackEnd(function(hMod)
		if IsNotNull(hInvul) then hInvul:Destroy() end
		if hMod:IsInterrupted() then return end
		_tInfo.dir = tInfo.caster:GetForwardVector()
		self:CrystalSlash(tInfo, nIndex, tInfo.caster:GetForwardVector())
	end)
end
function roland_crystal:CrystalSlash(tInfo, nIndex, vDir)
	local _tInfo = tInfo["part_"..nIndex]
	if not _tInfo then return end

	local tDash =
	{
		caster = tInfo.caster,

		team_id = tInfo.team_id,
		target_team = tInfo.target_team,
		target_type = tInfo.target_type,
		target_flags = tInfo.target_flags,

		radius = tInfo.radius,

		stunnable = _tInfo.da_stunnable,

		sound = _tInfo.sound_dash,

		-- on_hit
		-- on_end

		particle_dash = 1,
	}

	local tMotion =
	{
		duration = _tInfo.da_time,
		dir_x = vDir.x,
		dir_y = vDir.y,
		distance = _tInfo.da_range,
		-- target = tInfo.target:entindex(),
	}

	local tAnim =
	{
		pause = -1,
		pause_sync = 1,
		activity = _tInfo.act,
		activities = json.encode({_tInfo.act_mod}),
		rate = _tInfo.da_rate,
		rate_time = _tInfo.da_time,
	}

	local function OnHit(hTarget, _nIndex)
		if tInfo.caster == hTarget then return end
		ROLAND_AddBleeds({
			target = hTarget,
			caster = tInfo.caster,
			bleeds = _tInfo.bleeds
		})
		self:DoDamage({
			target = hTarget,
			caster = tInfo.caster,
			damage = _tInfo.damage
		})
		self:CreateSlashHitPFX(hTarget, vDir)
		EmitSoundOn(_tInfo.sound_slash, tInfo.caster)
		if nIndex == 2 and _nIndex == 1 then
			self:CreateCrossSlashPFX(tInfo.caster, hTarget:GetAbsOrigin() + Vector(0, 0, 128), vDir, _tInfo.da_range)
		end
		return false
	end

	local function OnEnd(hTarget, bInterrupted)
		if bInterrupted then return end-- or IsNull(hTarget) then return end
		self:CrystalCast(tInfo, nIndex + 1)
	end

	tDash.on_hit = OnHit
	tDash.on_end = OnEnd

	self:DashToWithCallback(tDash, tMotion, tAnim)

	self:CreateSwingCrossSlashPFX(tInfo.caster)
end
function roland_crystal:CreateCrossSlashPFX(hCaster, vPoint, vDir, nRadius)
	local function CreateSlash(_vPoint, _vDir, _nRadius)
		local vStart = _vPoint - _vDir * _nRadius * 0.6
		local vEnd = _vPoint + _vDir * _nRadius * 0.6
		local nPFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_crystal/roland_crystall_slash_cross.vpcf", PATTACH_WORLDORIGIN, nil)
					 ParticleManager:SetParticleShouldCheckFoW(nPFX, false)
					 ParticleManager:SetParticleControl(nPFX, 0, vStart)
					 ParticleManager:SetParticleControl(nPFX, 2, vEnd)
					 ParticleManager:ReleaseParticleIndex(nPFX)
	end

	local vDir1 = RotateVector2D(vDir, 20, true)
	local vDir2 = RotateVector2D(vDir, -20, true)

	CreateSlash(vPoint, vDir1, nRadius)
	CreateSlash(vPoint, vDir2, nRadius)
end
function roland_crystal:CreateSlashHitPFX(hTarget, vDir)
	local vPoint1 = hTarget:GetAbsOrigin() + RandomVector(100)
	local vPoint2 = hTarget:GetAbsOrigin() + RandomVector(100)

	local nSlashPFX =	ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
						ParticleManager:SetParticleControl(nSlashPFX, 0, vPoint1)
						ParticleManager:SetParticleControl(nSlashPFX, 2, vPoint2)
						ParticleManager:ReleaseParticleIndex(nSlashPFX)

	local vStart = (hTarget:GetAbsOrigin() + vDir * -200) + Vector(0, 0, 128)
	local vEnd = (hTarget:GetAbsOrigin() + vDir * 200) + Vector(-0, -0, 128)

	local nSlashPFX =	ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_big.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleShouldCheckFoW(nSlashPFX, false)
						ParticleManager:SetParticleControl(nSlashPFX, 0, vStart)
						ParticleManager:SetParticleControl(nSlashPFX, 2, vEnd)
						ParticleManager:ReleaseParticleIndex(nSlashPFX)
end
function roland_crystal:CreateSwingCrossSlashPFX(hCaster)
	self:SlashPFX(hCaster, Vector(0, 0, 128), 100, 1, Vector(-45, 30, 60)) --NOTE: Left slash
	self:SlashPFX(hCaster, Vector(0, 0, 128), 100, 1, Vector(45, -30, 60)) --NOTE: Right slash
end


































--====================================================================================================--
--====================================================================================================--
roland_crystal_ex = class(roland_crystal)