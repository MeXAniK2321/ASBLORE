require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
roland_ranga = class(roland_card)

function roland_ranga:OnCardDashImpact(hCaster, hTarget, vDir)
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
			ca_act = ACT_DOTA_CAST_ABILITY_1,
			ca_act_mod = "ranga_cast_1",

			ca_stunnable = self:GetSpecialValueFor("ca_stunnable_1"),
			ca_time = self:GetSpecialValueFor("ca_time_1"),

			da_act = ACT_DOTA_OVERRIDE_ABILITY_1,
			da_act_mod = "ranga_slash_1",

			da_stunnable = self:GetSpecialValueFor("da_stunnable_1"),
			da_time = self:GetSpecialValueFor("da_time_1"),
			da_range = self:GetSpecialValueFor("da_range_1"),

			damage = self:GetSpecialValueFor("damage_1"),
			bleeds = self:GetSpecialValueFor("bleeds_1") * FindTalentValue(hCaster, "special_bonus_roland_25l", nil, 1),

			sound_dash = "roland_turn.end",
			sound_slash = "roland_ranga.slash_1",
		},

		part_2 =
		{
			ca_act = ACT_DOTA_CAST_ABILITY_1,
			ca_act_mod = "ranga_cast_1",

			ca_stunnable = self:GetSpecialValueFor("ca_stunnable_2"),
			ca_time = self:GetSpecialValueFor("ca_time_2"),

			da_act = ACT_DOTA_OVERRIDE_ABILITY_2,
			da_act_mod = "ranga_slash_2",

			da_stunnable = self:GetSpecialValueFor("da_stunnable_2"),
			da_time = self:GetSpecialValueFor("da_time_2"),
			da_range = self:GetSpecialValueFor("da_range_2"),

			damage = self:GetSpecialValueFor("damage_2"),
			bleeds = self:GetSpecialValueFor("bleeds_2") * FindTalentValue(hCaster, "special_bonus_roland_25l", nil, 1),

			sound_dash = "roland_turn.end",
			sound_slash = "roland_ranga.slash_2",
		},

		part_3 =
		{
			ca_act = ACT_DOTA_CAST_ABILITY_1,
			ca_act_mod = "ranga_cast_1",

			ca_stunnable = self:GetSpecialValueFor("ca_stunnable_3"),
			ca_time = self:GetSpecialValueFor("ca_time_3"),

			da_act = ACT_DOTA_OVERRIDE_ABILITY_3,
			da_act_mod = "ranga_slash_3",

			da_stunnable = self:GetSpecialValueFor("da_stunnable_3"),
			da_time = self:GetSpecialValueFor("da_time_3"),
			da_range = self:GetSpecialValueFor("da_range_3"),

			damage = self:GetSpecialValueFor("damage_3"),
			bleeds = self:GetSpecialValueFor("bleeds_3") * FindTalentValue(hCaster, "special_bonus_roland_25l", nil, 1),

			sound_dash = "roland_turn.end",
			sound_slash = "roland_ranga.slash_3",
		},

		radius = self:GetSpecialValueFor("radius")
	}

	local nAttackScale = self:GetSpecialValueFor("damage_attack_pct") * 0.01 * tInfo.caster:GetAverageTrueAttackDamage(tInfo.caster)

	for i = 1, 3 do
		local p = tInfo["part_"..i]
		if p then
			p.ca_rate = GetAnimPlayRate(
				10,
				10,
				30,
				p.ca_time
			)
			p.da_rate = GetAnimPlayRate(
				i == 3 and 28 or 24,
				i == 3 and 28 or 24,
				30,
				p.da_time
			)

			p.damage = p.damage + nAttackScale
		end
	end

	self:RangaCast(tInfo, 1)
end
function roland_ranga:RangaCast(tInfo, nIndex)
	local p = tInfo["part_"..nIndex]
	if not p then
		self:TurnPlayNext(tInfo.caster, tInfo.target, GetDirection(tInfo.target, tInfo.caster))
		return
	end

	local tAnim =
	{
		duration = p.ca_time,
		pause = -1,
		pause_sync = 1,
		activity = p.ca_act,
		activities = json.encode({p.ca_act_mod}),
		rate = p.ca_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, p.ca_time, p.da_range + 300, p.ca_stunnable > 0)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		p.dir = tInfo.caster:GetForwardVector()
		self:RangaSlash(tInfo, nIndex)
	end)
end
function roland_ranga:RangaSlash(tInfo, nIndex)
	local p = tInfo["part_"..nIndex]
	if not p then return end

	local tDash =
	{
		caster = tInfo.caster,

		team_id = tInfo.team_id,
		target_team = tInfo.target_team,
		target_type = tInfo.target_type,
		target_flags = tInfo.target_flags,

		radius = tInfo.radius,

		stunnable = p.da_stunnable,

		sound = p.sound_dash,

		-- on_hit
		-- on_end

		particle_dash = 1,
	}

	local tMotion =
	{
		duration = p.da_time,
		dir_x = p.dir.x,
		dir_y = p.dir.y,
		distance = p.da_range,
	}

	local tAnim =
	{
		pause = -1,
		pause_sync = 1,
		activity = p.da_act,
		activities = json.encode({p.da_act_mod}),
		rate = p.da_rate,
	}

	local function OnHit(hTarget, _nIndex)
		ROLAND_AddBleeds({
			target = hTarget,
			caster = tInfo.caster,
			bleeds = p.bleeds
		})

		self:DoDamage({
			target = hTarget,
			caster = tInfo.caster,
			damage = p.damage
		})

		self:CreateHitPFX(hTarget, p)

		if not p.slashed then
			p.slashed = true
			EmitSoundOn(p.sound_slash, tInfo.caster)
		end
	end

	local function OnEnd(hTarget, bInterrupted)
		if bInterrupted then return end
		self:RangaCast(tInfo, nIndex + 1)
	end

	tDash.on_hit = OnHit
	tDash.on_end = OnEnd

	self:DashToWithCallback(tDash, tMotion, tAnim)

	self:SlashPFX(tInfo.caster, Vector(0, 0, 128), 125, -1, Vector(-90, 0, 45))
end
function roland_ranga:CreateHitPFX(hTarget, tPart)
	local vPoint1 = hTarget:GetAbsOrigin() + RandomVector(100)
	local vPoint2 = hTarget:GetAbsOrigin() + RandomVector(100)

	local nSlashPFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
					ParticleManager:SetParticleControl(nSlashPFX, 0, vPoint1)
					ParticleManager:SetParticleControl(nSlashPFX, 2, vPoint2)
					ParticleManager:ReleaseParticleIndex(nSlashPFX)

	local vStart = (hTarget:GetAbsOrigin() + tPart.dir * -300) + Vector(25, 25, 128)
	local vEnd = (hTarget:GetAbsOrigin() + tPart.dir * 300) + Vector(-25, -25, 128)

	local nSlashPFX =	ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_big.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleShouldCheckFoW(nSlashPFX, false)
						ParticleManager:SetParticleControl(nSlashPFX, 0, vStart)
						ParticleManager:SetParticleControl(nSlashPFX, 2, vEnd)
						ParticleManager:ReleaseParticleIndex(nSlashPFX)
end



--====================================================================================================--
--====================================================================================================--
roland_ranga_ex = class(roland_ranga)

