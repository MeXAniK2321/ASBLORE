require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--SEQUENCE
--1:  Logic cast + small shots 1 & 2 forward (each knocks target)
--2:  Allas part-2 long dash behind/through target
--3:  Boys - knock enemy backward
--4:  Mook - reposition dash if out of range, then full multi-slash
--5:  Ranga - all 3 slashes
--6:  Zelkova - 2 hits with root
--7:  Wheel - AoE strike
--8:  Crystal - 2nd slash only
--9:  Logic big shot 3 (large knock range)
--10: Dash to target + Durandal hits 1 & 2 + bonus 3rd hit, snap backward
--====================================================================================================--
roland_furioso = class(roland_card)

function roland_furioso:OnCardDashImpact(hCaster, hTarget, vDir)
	if IsNull(hTarget) or hTarget:TriggerSpellAbsorb(self) then return end

	local tInfo =
	{
		target       = hTarget,
		caster       = hCaster,
		team_id      = hCaster:GetTeamNumber(),
		target_team  = self:GetAbilityTargetTeam(),
		target_type  = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		last_damage =  self:GetSpecialValueFor("last_damage"),
	}

	--======================================================================--
	-- DASH-TO (reposition between steps)
	--======================================================================--
	tInfo.dash_to =
	{
		da_act       = ACT_DOTA_CAST_ABILITY_1_END,
		da_act_mod   = "",
		da_stunnable = self:GetSpecialValueFor("dash_to_da_stunnable"),
		da_time      = -1,
		da_rate      = GetAnimPlayRate(15, 15, 30, 1),
		da_rate_time = 1,
		da_speed     = self:GetSpecialValueFor("dash_to_da_speed"),
		da_range     = self:GetSpecialValueFor("dash_to_da_range"),
		radius       = self:GetSpecialValueFor("dash_to_radius"),
	}

	--======================================================================--
	-- LOGIC
	--======================================================================--
	tInfo.logic =
	{
		ca_act       = ACT_DOTA_CAST_ABILITY_1,
		ca_act_mod   = "logic_cast",
		ca_time      = self:GetSpecialValueFor("logic_ca_time"),
		ca_stunnable = self:GetSpecialValueFor("logic_ca_stunnable"),

		proj =
		{
			speed    = self:GetSpecialValueFor("logic_proj_speed"),
			distance = self:GetSpecialValueFor("logic_proj_distance"),
			width    = self:GetSpecialValueFor("logic_proj_width"),
		},

		small =
		{
			act             = ACT_DOTA_OVERRIDE_ABILITY_1,
			act_mod         = "logic_shot_1",
			ca_time         = self:GetSpecialValueFor("logic_small_ca_time"),
			ca_stunnable    = self:GetSpecialValueFor("logic_small_ca_stunnable"),
			knock_stun_time = self:GetSpecialValueFor("logic_small_knock_stun_time"),
			knock_time      = self:GetSpecialValueFor("logic_small_knock_time"),
			knock_range     = self:GetSpecialValueFor("logic_small_knock_range"),
			damage          = self:GetSpecialValueFor("logic_small_damage"),
		},

		big =
		{
			act             = ACT_DOTA_OVERRIDE_ABILITY_2,
			act_mod         = "logic_shot_2",
			ca_time         = self:GetSpecialValueFor("logic_big_ca_time"),
			ca_stunnable    = self:GetSpecialValueFor("logic_big_ca_stunnable"),
			knock_stun_time = self:GetSpecialValueFor("logic_big_knock_stun_time"),
			knock_time      = self:GetSpecialValueFor("logic_big_knock_time"),
			knock_range     = self:GetSpecialValueFor("logic_big_knock_range"),
			damage          = self:GetSpecialValueFor("logic_big_damage"),
		},
	}
	local l = tInfo.logic
	l.ca_rate         = GetAnimPlayRate(10,  5, 30, l.ca_time)
	l.small.ca_rate   = GetAnimPlayRate(6,   6, 30, l.small.ca_time)
	l.small.ca_impact = GetAnimImpactTime(6, 3, 30, l.small.ca_time)
	l.big.ca_rate     = GetAnimPlayRate(16, 16, 30, l.big.ca_time)
	l.big.ca_impact   = GetAnimImpactTime(16, 6, 30, l.big.ca_time)

	--======================================================================--
	-- ALLAS (part 2 only)
	--======================================================================--
	tInfo.allas =
	{
		ca_act       = ACT_DOTA_CAST_ABILITY_2,
		ca_act_mod   = "allas_cast_2",
		ca_stunnable = self:GetSpecialValueFor("allas_ca_stunnable"),
		ca_time      = self:GetSpecialValueFor("allas_ca_time"),

		da_act       = ACT_DOTA_OVERRIDE_ABILITY_2,
		da_act_mod   = "allas_slash_loop",
		da_stunnable = self:GetSpecialValueFor("allas_da_stunnable"),
		da_time      = self:GetSpecialValueFor("allas_da_time"),
		da_range     = self:GetSpecialValueFor("allas_da_range"),

		radius       = self:GetSpecialValueFor("allas_radius"),
		damage       = self:GetSpecialValueFor("allas_damage"),
	}
	local a = tInfo.allas
	a.ca_rate = GetAnimPlayRate(11, 11, 30, a.ca_time)
	a.da_rate = GetAnimPlayRate(19, 19, 30, a.da_time)

	--======================================================================--
	-- BOYS
	--======================================================================--
	tInfo.boys =
	{
		ca_act          = ACT_DOTA_CAST_ABILITY_1,
		ca_act_mod      = "boys_cast",
		ca_stunnable    = self:GetSpecialValueFor("boys_ca_stunnable"),
		ca_time         = self:GetSpecialValueFor("boys_ca_time"),
		damage          = self:GetSpecialValueFor("boys_damage"),
		knock_time      = self:GetSpecialValueFor("boys_knock_time"),
		knock_range     = self:GetSpecialValueFor("boys_knock_range"),
		knock_stun_time = self:GetSpecialValueFor("boys_knock_stun_time"),
	}
	local b = tInfo.boys
	b.ca_rate        = GetAnimPlayRate(34, 34, 30, b.ca_time)
	b.ca_impact_time = GetAnimImpactTime(34, 19, 30, b.ca_time)

	--======================================================================--
	-- MOOK
	--======================================================================--
	tInfo.mook =
	{
		ca_act       = ACT_DOTA_CAST_ABILITY_1,
		ca_act_mod   = "mook_cast_123",
		ca_stunnable = self:GetSpecialValueFor("mook_ca_stunnable"),
		ca_time      = self:GetSpecialValueFor("mook_ca_time"),

		sa_act       = ACT_DOTA_OVERRIDE_ABILITY_1,
		sa_act_mod   = "mook_slash_123",
		sa_stunnable = self:GetSpecialValueFor("mook_sa_stunnable"),
		sa_time      = self:GetSpecialValueFor("mook_sa_time"),

		count       = self:GetSpecialValueFor("mook_count"),
		radius      = self:GetSpecialValueFor("mook_radius"),
		damage      = self:GetSpecialValueFor("mook_damage"),
		damage_last = self:GetSpecialValueFor("mook_damage_last"),
	}
	local m = tInfo.mook
	m.ca_rate        = GetAnimPlayRate(8,  8,  30, m.ca_time)
	m.sa_slash_rate  = GetAnimPlayRate(14, 14, 30, m.sa_time / m.count)
	m.sa_impact_time = GetAnimImpactTime(14, 14, 30, m.sa_time / m.count)

	--======================================================================--
	-- RANGA (3 parts)
	--======================================================================--
	tInfo.ranga = { radius = self:GetSpecialValueFor("ranga_radius") }
	local _rDaActs = { ACT_DOTA_OVERRIDE_ABILITY_1, ACT_DOTA_OVERRIDE_ABILITY_2, ACT_DOTA_OVERRIDE_ABILITY_3 }
	local _rDaMods = { "ranga_slash_1", "ranga_slash_2", "ranga_slash_3" }
	for i = 1, 3 do
		local p =
		{
			ca_act       = ACT_DOTA_CAST_ABILITY_1,
			ca_act_mod   = "ranga_cast_1",
			ca_stunnable = self:GetSpecialValueFor("ranga_ca_stunnable_"..i),
			ca_time      = self:GetSpecialValueFor("ranga_ca_time_"..i),
			da_act       = _rDaActs[i],
			da_act_mod   = _rDaMods[i],
			da_stunnable = self:GetSpecialValueFor("ranga_da_stunnable_"..i),
			da_time      = self:GetSpecialValueFor("ranga_da_time_"..i),
			da_range     = self:GetSpecialValueFor("ranga_da_range_"..i),
			damage       = self:GetSpecialValueFor("ranga_damage_"..i),
			bleeds       = self:GetSpecialValueFor("ranga_bleeds_"..i) * FindTalentValue(tInfo.caster, "special_bonus_roland_25l", nil, 1),
			sound_dash   = "roland_turn.end",
			sound_slash  = "roland_ranga.slash_"..i,
		}
		p.ca_rate = GetAnimPlayRate(10, 10, 30, p.ca_time)
		p.da_rate = GetAnimPlayRate(i == 3 and 28 or 24, i == 3 and 28 or 24, 30, p.da_time)
		tInfo.ranga["part_"..i] = p
	end

	--======================================================================--
	-- ZELKOVA
	--======================================================================--
	tInfo.zelkova =
	{
		sa_act        = ACT_DOTA_OVERRIDE_ABILITY_1,  -- may be overridden in FuriosoZelkova
		sa_act_mod    = "zelkova_slash_12",
		sa_stunnable  = self:GetSpecialValueFor("zelkova_sa_stunnable"),
		sa_time_1     = self:GetSpecialValueFor("zelkova_sa_time_1"),
		sa_time_2     = self:GetSpecialValueFor("zelkova_sa_time_2"),
		root_duration = self:GetSpecialValueFor("zelkova_root_duration"),
		damage_1      = self:GetSpecialValueFor("zelkova_damage_1"),
		damage_2      = self:GetSpecialValueFor("zelkova_damage_2"),
	}
	local z = tInfo.zelkova
	z.sa_time_12      = z.sa_time_1 + z.sa_time_2
	z.sa_rate         = GetAnimPlayRate(33, 33, 30, z.sa_time_12)
	z.sa_impact_time_1 = GetAnimImpactTime(33,  8, 30, z.sa_time_12)
	z.sa_impact_time_2 = GetAnimImpactTime(33, 23, 30, z.sa_time_12)

	--======================================================================--
	-- WHEEL
	--======================================================================--
	tInfo.wheel =
	{
		ca_act         = ACT_DOTA_CAST_ABILITY_1,
		ca_act_mod     = "wheel_cast",
		ca_time        = self:GetSpecialValueFor("wheel_ca_time"),
		ca_stunnable   = self:GetSpecialValueFor("wheel_ca_stunnable"),

		sa_act         = ACT_DOTA_OVERRIDE_ABILITY_1,
		sa_act_mod     = "wheel_slash",
		ca_time_1      = self:GetSpecialValueFor("wheel_ca_time_1"),
		ca_stunnable_1 = self:GetSpecialValueFor("wheel_ca_stunnable_1"),

		damage    = self:GetSpecialValueFor("wheel_ca_damage_1"),
		stun_time = self:GetSpecialValueFor("wheel_ca_stun_time_1"),
		radius    = self:GetSpecialValueFor("wheel_ca_radius_1"),
	}
	local w = tInfo.wheel
	w.ca_rate        = GetAnimPlayRate(13, 13, 30, w.ca_time)
	w.sa_rate        = GetAnimPlayRate(25, 25, 30, w.ca_time_1)
	w.sa_impact_time = GetAnimImpactTime(25,  9, 30, w.ca_time_1)

	--======================================================================--
	-- CRYSTAL (part 2 only)
	--======================================================================--
	tInfo.crystal =
	{
		ca_act       = ACT_DOTA_CAST_ABILITY_2,
		ca_act_mod   = "crystal_cast_2",
		ca_stunnable = self:GetSpecialValueFor("crystal_ca_stunnable_2"),
		ca_time      = self:GetSpecialValueFor("crystal_ca_time_2"),

		da_act       = ACT_DOTA_OVERRIDE_ABILITY_2,
		da_act_mod   = "crystal_slash_2",
		da_stunnable = self:GetSpecialValueFor("crystal_da_stunnable_2"),
		da_time      = self:GetSpecialValueFor("crystal_da_time_2"),
		da_range     = self:GetSpecialValueFor("crystal_da_range_2"),
		da_damage    = self:GetSpecialValueFor("crystal_da_damage_2"),
		da_bleeds    = self:GetSpecialValueFor("crystal_da_bleeds_2") * FindTalentValue(tInfo.caster, "special_bonus_roland_25l", nil, 1),

		radius       = self:GetSpecialValueFor("crystal_radius"),
	}
	local c = tInfo.crystal
	c.ca_rate = GetAnimPlayRate(13, 4, 30, c.ca_time)
	c.da_rate = GetAnimPlayRate(22, 22, 30, c.da_time)

	--======================================================================--
	-- DURANDAL
	--======================================================================--
	tInfo.durandal =
	{
		ca_act       = ACT_DOTA_CAST_ABILITY_1,
		ca_act_mod   = "durandal_slash_12",
		ca_stunnable = self:GetSpecialValueFor("durandal_ca_stunnable"),
		ca_time      = self:GetSpecialValueFor("durandal_ca_time"),

		ca_act_3     = ACT_DOTA_CAST_ABILITY_3,
		ca_act_mod_3 = "durandal_slash_3",
		ca_time_3    = 0.6,

		da_range      = self:GetSpecialValueFor("durandal_da_range"),
		slow_duration = self:GetSpecialValueFor("durandal_slow_duration"),

		damage_1      = self:GetSpecialValueFor("durandal_damage_1"),
		damage_2      = self:GetSpecialValueFor("durandal_damage_2"),
		damage_3      = self:GetSpecialValueFor("durandal_damage_3"),
	}
	local d = tInfo.durandal
	d.ca_rate          = GetAnimPlayRate(36, 36, 30, d.ca_time)
	d.ca_impact_time_1 = GetAnimImpactTime(36,  8, 30, d.ca_time)
	d.ca_impact_time_2 = GetAnimImpactTime(36, 23, 30, d.ca_time)
	d.da_start_time    = GetAnimImpactTime(36, 20, 30, d.ca_time)
	d.da_time          = d.ca_time - d.da_start_time
	d.ca_rate_3        = GetAnimPlayRate(12, 12, 30, d.ca_time_3)
	d.ca_impact_time_3 = GetAnimImpactTime(12,  6, 30, d.ca_time_3)

	--======================================================================--
	-- KICK OFF — apply full-sequence invulnerability
	--======================================================================--
	local nStunTime = 0
	for _, value in pairs(tInfo) do
		if type(value) == "table" then
			for _key, _value in pairs(value) do
				if type(_value) == "number" and string.match(_key, "_time") then
					nStunTime = nStunTime + _value
				end
			end
		end
	end

	tInfo.special_invul_target = tInfo.target:AddNewModifier(tInfo.caster, self, "modifier_roland_furioso_invul_target", {duration = nStunTime})
	tInfo.special_invul_caster = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_furioso_invul_caster", {duration = nStunTime})

	self:FuriosoLogicCast(tInfo)
end


--====================================================================================================--
-- HELPER: create animation modifier
--====================================================================================================--
function roland_furioso:AddAnim(hCaster, tAnim)
	return hCaster:AddNewModifier(hCaster, self, "modifier_roland_animation_generic", tAnim)
end


--====================================================================================================--
-- HELPER: dash toward tInfo.target, stop on contact, call fOnEnd(hTarget, bInterrupted)
--====================================================================================================--
function roland_furioso:FuriosoDashTo(tInfo, fOnEnd)
	local dt   = tInfo.dash_to
	local vDir = GetDirection(tInfo.target, tInfo.caster, false)

	local tDash =
	{
		caster          = tInfo.caster,
		team_id         = tInfo.team_id,
		target_team     = tInfo.target_team,
		target_type     = tInfo.target_type,
		target_flags    = tInfo.target_flags,
		radius          = dt.radius,
		stunnable       = dt.da_stunnable,
		sound           = "roland_turn.end",
		special_targets = {[tInfo.target] = true},
		particle_seq    = 3,
	}

	local tMotion =
	{
		target   = tInfo.target:entindex(),
		duration = dt.da_time,
		dir_x    = vDir.x,
		dir_y    = vDir.y,
		distance = dt.da_range,
		speed    = dt.da_speed,
	}

	local tAnim =
	{
		pause      = -1,
		pause_sync = 1,
		activity   = dt.da_act,
		activities = json.encode({dt.da_act_mod}),
		rate       = dt.da_rate,
		rate_time  = dt.da_rate_time,
	}

	local function OnHit(hTarget)
		if hTarget ~= tInfo.target then return end
		return true
	end

	local function OnEnd(hTarget, bInterrupted)
		if fOnEnd then fOnEnd(hTarget, bInterrupted) end
	end

	tDash.on_hit = OnHit
	tDash.on_end = OnEnd

	self:DashToWithCallback(tDash, tMotion, tAnim)
end


--====================================================================================================--
-- STEP 1A: Logic cast anim
--====================================================================================================--
function roland_furioso:FuriosoLogicCast(tInfo)
	local l = tInfo.logic

	local tAnim =
	{
		duration   = l.ca_time,
		pause      = -1,
		pause_sync = 1,
		activity   = l.ca_act,
		activities = json.encode({l.ca_act_mod}),
		rate       = l.ca_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, l.ca_time, l.proj.distance + 30000, l.ca_stunnable > 0)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		tInfo.logic_dir_1 = tInfo.caster:GetForwardVector()
		tInfo.logic_dir_2 = tInfo.caster:GetForwardVector()
		self:FuriosoLogicSmallShot(tInfo, 1)
	end)
end


--====================================================================================================--
-- STEP 1B: Small shots 1 and 2
--====================================================================================================--
function roland_furioso:FuriosoLogicSmallShot(tInfo, nIndex)
	if nIndex > 2 then
		self:FuriosoAllasCast(tInfo)
		return
	end

	local ls = tInfo.logic.small

	local tAnim =
	{
		duration   = ls.ca_time,
		pause      = -1,
		pause_sync = 1,
		activity   = ls.act,
		activities = json.encode({ls.act_mod}),
		rate       = ls.ca_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	hAnim:AddCallbackThink(FrameTime(), function(hMod)
		if ls.ca_stunnable > 0 and tInfo.caster:IsStunned() then
			hMod:Destroy(true)
		end
	end)

	hAnim:AddCallbackThink(ls.ca_impact, function(hMod)
		if hMod:IsInterrupted() then return end
		local vDir = tInfo["logic_dir_"..nIndex]
		self:FuriosoFireProjectile(tInfo, vDir, ls)
		EmitSoundOn("roland_logic.shot_1", tInfo.caster)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:FuriosoLogicSmallShot(tInfo, nIndex + 1)
	end)
end


--====================================================================================================--
-- SHARED: fire a linear logic projectile
--====================================================================================================--
function roland_furioso:FuriosoFireProjectile(tInfo, vDir, tKnock)
	local proj = tInfo.logic.proj

	local tProj =
	{
		vSpawnOrigin = tInfo.caster:GetAbsOrigin() + Vector(0, 0, 175),
		vVelocity    = vDir * proj.speed,

		fDistance    = proj.distance,
		fStartRadius = proj.width,
		fEndRadius   = proj.width,

		iUnitTargetTeam  = tInfo.target_team,
		iUnitTargetType  = tInfo.target_type,
		iUnitTargetFlags = tInfo.target_flags,

		EffectName = "particles/heroes/roland/roland_logic/roland_logic_shot_linear.vpcf",

		Ability  = self,
		Source   = tInfo.caster,

		bProvidesVision   = true,
		iVisionRadius     = proj.width,
		iVisionTeamNumber = tInfo.caster:GetTeamNumber(),

		ExtraData =
		{
			caster_id       = tInfo.caster:entindex(),
			dir_x           = vDir.x,
			dir_y           = vDir.y,
			knock_stun_time = tKnock.knock_stun_time,
			knock_time      = tKnock.knock_time,
			knock_range     = tKnock.knock_range,
			knock_damage    = tKnock.damage,
		}
	}

	-- Dota2API.ProjectileManager.CreateLinearProjectile(ProjectileManager, tProj)
	ProjectileManager:CreateLinearProjectile(tProj)
end

function roland_furioso:OnProjectileHit_ExtraData(hTarget, vLocation, tExData)
	if IsNull(hTarget) then return end
	local hCaster = EntIndexToHScript(tExData.caster_id)
	if IsNull(hCaster) then return end

	self:AddStun({target = hTarget, caster = hCaster, stun_time = tExData.knock_stun_time})
	self:AddKnock(
	{
		target       = hTarget,
		caster       = hTarget,
		dir          = Vector(tExData.dir_x, tExData.dir_y, 0),
		knock_time   = tExData.knock_time,
		knock_range  = tExData.knock_range,
		path_trees   = 1,
		path_hg      = 1,
		path_blocked = 1,
	})
	self:DoDamage({target = hTarget, caster = hCaster, damage = tExData.knock_damage})
	self:CreateLogicHitPFX(hTarget)

	if HasTalent(hCaster, "special_bonus_roland_15l") then
		hTarget:AddNewModifier(hCaster, self, "modifier_roland_logic_vision_debuff", {duration = FindTalentValue(hCaster, "special_bonus_roland_15l", "duration", 0)})
	end

	return false
end


--====================================================================================================--
-- STEP 2A: Allas cast anim
--====================================================================================================--
function roland_furioso:FuriosoAllasCast(tInfo)
	local a = tInfo.allas

	local tAnim =
	{
		duration   = a.ca_time,
		pause      = -1,
		pause_sync = 1,
		activity   = a.ca_act,
		activities = json.encode({a.ca_act_mod}),
		rate       = a.ca_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, a.ca_time, a.da_range + 30000, a.ca_stunnable > 0)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		tInfo.allas.dash_dir = tInfo.caster:GetForwardVector()
		self:FuriosoAllasDash(tInfo)
	end)
end


--====================================================================================================--
-- STEP 2B: Allas long dash through/behind target
--====================================================================================================--
function roland_furioso:FuriosoAllasDash(tInfo)
	local a = tInfo.allas

	local tDash =
	{
		caster        = tInfo.caster,
		team_id       = tInfo.team_id,
		target_team   = tInfo.target_team,
		target_type   = tInfo.target_type,
		target_flags  = tInfo.target_flags,
		radius        = a.radius,
		stunnable     = a.da_stunnable,
		sound         = "roland_turn.end",
		particle_dash = 1,
	}

	local tMotion =
	{
		duration = a.da_time,
		dir_x    = a.dash_dir.x,
		dir_y    = a.dash_dir.y,
		distance = a.da_range,
	}

	local tAnim =
	{
		pause      = -1,
		pause_sync = 1,
		activity   = a.da_act,
		activities = json.encode({a.da_act_mod}),
		rate       = a.da_rate,
		rate_time  = a.da_time,
	}

	local function OnHit(hTarget)
		self:DoDamage({target = hTarget, caster = tInfo.caster, damage = a.damage})
		EmitSoundOn("roland_mimicry.slash_guard", tInfo.caster)
		self:CreateAllasHitPFX(hTarget)
		return false
	end

	local function OnEnd(hTarget, bInterrupted)
		if bInterrupted then return end
		self:FuriosoDashTo(tInfo, function(_, bInt)
			if bInt then return end
			self:FuriosoBoys(tInfo)
		end)
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


--====================================================================================================--
-- STEP 3: Boys - knock backward
--====================================================================================================--
function roland_furioso:FuriosoBoys(tInfo)
	local b = tInfo.boys

	local tAnim =
	{
		duration   = b.ca_time,
		pause      = -1,
		pause_sync = 1,
		activity   = b.ca_act,
		activities = json.encode({b.ca_act_mod}),
		rate       = b.ca_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, b.ca_impact_time, 30000, b.ca_stunnable > 0)

	hAnim:AddCallbackThink(b.ca_impact_time, function(hMod)
		if hMod:IsInterrupted() then return end
		self:AddStun({target = tInfo.target, caster = tInfo.caster, stun_time = b.knock_stun_time})
		self:AddKnock(
		{
			target       = tInfo.target,
			caster       = tInfo.target,
			dir          = tInfo.caster:GetForwardVector(),
			knock_time   = b.knock_time,
			knock_range  = b.knock_range,
			path_trees   = 1,
			path_hg      = 1,
			path_blocked = 1,
		})
		self:DoDamage({target = tInfo.target, caster = tInfo.caster, damage = b.damage})
		EmitSoundOn("roland_mimicry.slash_guard", tInfo.caster)
		self:CreateBoysPFX(tInfo)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:FuriosoDashTo(tInfo, function(_, bInt)
			if bInt then return end
			self:FuriosoMookCast(tInfo)
		end)
	end)
end


--====================================================================================================--
-- STEP 4A: Mook cast anim
--====================================================================================================--
function roland_furioso:FuriosoMookCast(tInfo)
	local m = tInfo.mook

	local tAnim =
	{
		duration   = m.ca_time,
		pause      = -1,
		pause_sync = 1,
		activity   = m.ca_act,
		activities = json.encode({m.ca_act_mod}),
		rate       = m.ca_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, m.ca_time, 30000, m.ca_stunnable > 0)

	EmitSoundOn("roland_mook.cast", tInfo.caster)
	self:CreateMookCastPFX(tInfo.caster)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		tInfo.mook.dir = tInfo.caster:GetForwardVector()
		self:FuriosoMookSlashes(tInfo)
	end)
end


--====================================================================================================--
-- STEP 4B: Mook multi-slash loop
--====================================================================================================--
function roland_furioso:FuriosoMookSlashes(tInfo)
	local m        = tInfo.mook
	local nCounted = 0
	local vPoint   = tInfo.target:GetAbsOrigin() + m.dir * m.radius * 0.5
	local vPFXPos  = Vector(vPoint.x, vPoint.y, vPoint.z + m.radius * 0.5)

	EmitSoundOnLocationWithCaster(vPoint, "roland_mook.slashes", tInfo.caster)
	-- EmitSoundOn("roland_mook.slashes", tInfo.caster)

	local nSlashesPFX = self:CreateMookSlashesPFX(tInfo.caster, vPFXPos, m.radius)

	local tAnim =
	{
		duration   = m.sa_time + m.sa_impact_time,
		pause      = -1,
		pause_sync = 1,
		activity   = m.sa_act,
		activities = json.encode({m.sa_act_mod}),
		rate       = m.sa_slash_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then
		self:ReleaseMookSlashesPFX(nSlashesPFX)
		return
	end

	hAnim:AddCallbackThink(FrameTime(), function(hMod)
		if m.sa_stunnable > 0 and tInfo.caster:IsStunned() then
			hMod:Destroy(true)
		end
	end)

	local bHasTalent = HasTalent(tInfo.caster, "special_bonus_roland_10l")
	local nHeal = FindTalentValue(tInfo.caster, "special_bonus_roland_10l") * 0.01 * m.damage
	local nHealLast = FindTalentValue(tInfo.caster, "special_bonus_roland_10l") * 0.01 * m.damage_last

	hAnim:AddCallbackThink(0, function(hMod, _tTimer, nTime)
		if hMod:IsInterrupted() then return end
		if nCounted >= m.count then return end
		nCounted = nCounted + 1

		local tEntities = FindUnitsInRadius(
			tInfo.team_id, vPoint, nil, m.radius,
			tInfo.target_team, tInfo.target_type, tInfo.target_flags,
			FIND_CLOSEST, false)

		for _, hEnt in ipairs(tEntities) do
			if IsNotNull(hEnt) and hEnt ~= tInfo.caster then
				local nDmg = (nCounted == m.count) and m.damage_last or m.damage
				self:DoDamage({target = hEnt, caster = tInfo.caster, damage = nDmg})
				if bHasTalent then
					local nHeal1 = (nCounted == m.count) and nHealLast or nHeal
					tInfo.caster:Heal(nHeal1, self)
				end
				self:CreateMookHitPFX(hEnt)
			end
		end

		return m.sa_impact_time
	end)

	hAnim:AddCallbackEnd(function(hMod)
		self:ReleaseMookSlashesPFX(nSlashesPFX)
		self:CreateMookSheathFlashPFX(tInfo.caster, m.radius)
		EmitSoundOn("roland_mook.slash_last", tInfo.caster)

		if not hMod:IsInterrupted() then
			self:FuriosoDashTo(tInfo, function(_, bInt)
				if bInt then return end
				self:FuriosoRangaCast(tInfo, 1)
			end)
		end
	end)
end


--====================================================================================================--
-- STEP 5A: Ranga cast anim (iterates 1->2->3)
--====================================================================================================--
function roland_furioso:FuriosoRangaCast(tInfo, nIndex)
	local p = tInfo.ranga["part_"..nIndex]
	if not p then
		self:FuriosoDashTo(tInfo, function(_, bInt)
			if bInt then return end
			self:FuriosoZelkova(tInfo)
		end)
		return
	end

	local tAnim =
	{
		duration   = p.ca_time,
		pause      = -1,
		pause_sync = 1,
		activity   = p.ca_act,
		activities = json.encode({p.ca_act_mod}),
		rate       = p.ca_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, p.ca_time, p.da_range + 30000, p.ca_stunnable > 0)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		p.dir = tInfo.caster:GetForwardVector()
		self:FuriosoRangaSlash(tInfo, nIndex)
	end)
end


--====================================================================================================--
-- STEP 5B: Ranga slash dash
--====================================================================================================--
function roland_furioso:FuriosoRangaSlash(tInfo, nIndex)
	local p = tInfo.ranga["part_"..nIndex]
	if not p then return end

	local tDash =
	{
		caster        = tInfo.caster,
		team_id       = tInfo.team_id,
		target_team   = tInfo.target_team,
		target_type   = tInfo.target_type,
		target_flags  = tInfo.target_flags,
		radius        = tInfo.ranga.radius,
		stunnable     = p.da_stunnable,
		sound         = p.sound_dash,
		particle_dash = 1,
	}

	local tMotion =
	{
		duration = p.da_time,
		dir_x    = p.dir.x,
		dir_y    = p.dir.y,
		distance = p.da_range,
	}

	local tAnim =
	{
		pause      = -1,
		pause_sync = 1,
		activity   = p.da_act,
		activities = json.encode({p.da_act_mod}),
		rate       = p.da_rate,
	}

	local function OnHit(hTarget)
		ROLAND_AddBleeds({target = hTarget, caster = tInfo.caster, bleeds = p.bleeds})
		self:DoDamage({target = hTarget, caster = tInfo.caster, damage = p.damage})
		self:CreateRangaHitPFX(hTarget, p)
		if not p.slashed then
			p.slashed = true
			EmitSoundOn(p.sound_slash, tInfo.caster)
		end
	end

	local function OnEnd(hTarget, bInterrupted)
		if bInterrupted then return end
		self:FuriosoRangaCast(tInfo, nIndex + 1)
	end

	tDash.on_hit = OnHit
	tDash.on_end = OnEnd

	self:DashToWithCallback(tDash, tMotion, tAnim)

	self:CreateRangaSwingPFX(tInfo.caster)
end


--====================================================================================================--
-- STEP 6: Zelkova 2-hit combo
--====================================================================================================--
function roland_furioso:FuriosoZelkova(tInfo)
	local z = tInfo.zelkova

	local bSecondary = RollPercentage(51)
	if bSecondary then
		z.sa_act           = ACT_DOTA_OVERRIDE_ABILITY_2
		z.sa_rate          = GetAnimPlayRate(45, 45, 30, z.sa_time_12)
		z.sa_impact_time_1 = GetAnimImpactTime(45, 13, 30, z.sa_time_12)
		z.sa_impact_time_2 = GetAnimImpactTime(45, 26, 30, z.sa_time_12)
	end

	local tAnim =
	{
		duration   = z.sa_time_12,
		pause      = -1,
		pause_sync = 1,
		activity   = z.sa_act,
		activities = json.encode({z.sa_act_mod}),
		rate       = z.sa_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, z.sa_time_12, 30000, z.sa_stunnable > 0)

	hAnim:AddCallbackThink(z.sa_impact_time_1, function(hMod)
		if hMod:IsInterrupted() then return end
		self:AddRoot({target = tInfo.target, caster = tInfo.caster, root_time = z.root_duration})
		self:DoDamage({target = tInfo.target, caster = tInfo.caster, damage = z.damage_1})
		EmitSoundOn("roland_zelkova.slash_1", tInfo.caster)
		self:CreateZelkovaPFX(tInfo.caster, tInfo.target, bSecondary, 1)
	end)

	hAnim:AddCallbackThink(z.sa_impact_time_2, function(hMod)
		if hMod:IsInterrupted() then return end
		self:AddRoot({target = tInfo.target, caster = tInfo.caster, root_time = z.root_duration})
		self:DoDamage({target = tInfo.target, caster = tInfo.caster, damage = z.damage_2})
		EmitSoundOn("roland_zelkova.slash_2", tInfo.caster)
		self:CreateZelkovaPFX(tInfo.caster, tInfo.target, bSecondary, 2)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:FuriosoDashTo(tInfo, function(_, bInt)
			if bInt then return end
			self:FuriosoWheel(tInfo)
		end)
	end)
end


--====================================================================================================--
-- STEP 7A: Wheel cast anim
--====================================================================================================--
function roland_furioso:FuriosoWheel(tInfo)
	local w = tInfo.wheel

	local tAnim =
	{
		duration   = w.ca_time,
		pause      = -1,
		pause_sync = 1,
		activity   = w.ca_act,
		activities = json.encode({w.ca_act_mod}),
		rate       = w.ca_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, w.ca_time, 30000, w.ca_stunnable > 0)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		tInfo.wheel.range = IsNotNull(tInfo.target) and GetDistance(tInfo.target, tInfo.caster) or 300
		self:FuriosoWheelSlash(tInfo)
	end)
end


--====================================================================================================--
-- STEP 7B: Wheel AoE strike
--====================================================================================================--
function roland_furioso:FuriosoWheelSlash(tInfo)
	local w = tInfo.wheel

	local tAnim =
	{
		duration   = w.ca_time_1,
		pause      = -1,
		pause_sync = 1,
		activity   = w.sa_act,
		activities = json.encode({w.sa_act_mod}),
		rate       = w.sa_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	hAnim:AddCallbackThink(w.sa_impact_time, function(hMod)
		if hMod:IsInterrupted() then return end
		local vPoint = tInfo.caster:GetAbsOrigin() + tInfo.caster:GetForwardVector() * (w.range or 300)
		local tEntities = FindUnitsInRadius(
			tInfo.team_id, vPoint, nil, w.radius,
			tInfo.target_team, tInfo.target_type, tInfo.target_flags,
			FIND_CLOSEST, false)
		for _, hEnt in ipairs(tEntities) do
			if IsNotNull(hEnt) and hEnt ~= tInfo.caster then
				self:AddStun({target = hEnt, caster = tInfo.caster, stun_time = w.stun_time})
				self:DoDamage({target = hEnt, caster = tInfo.caster, damage = w.damage})
			end
		end
		self:CreateWheelPFX(tInfo.caster, vPoint, w.radius)
		EmitSoundOn("roland_wheel.slash", tInfo.caster)
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
		self:FuriosoCrystalCast(tInfo)
	end)
end


--====================================================================================================--
-- STEP 8A: Crystal part-2 cast anim
--====================================================================================================--
function roland_furioso:FuriosoCrystalCast(tInfo)
	local c = tInfo.crystal

	local tAnim =
	{
		duration   = c.ca_time,
		pause      = -1,
		pause_sync = 1,
		activity   = c.ca_act,
		activities = json.encode({c.ca_act_mod}),
		rate       = c.ca_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, c.ca_time, c.da_range + 30000, c.ca_stunnable > 0)

	-- FIX: hInvul removed - crystal_ca_invul_2 = 0, no invul needed
	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:CreateCrystalSwingPFX(tInfo.caster)
		self:FuriosoCrystalSlash(tInfo, tInfo.caster:GetForwardVector())
	end)
end


--====================================================================================================--
-- STEP 8B: Crystal slash dash (part 2)
--====================================================================================================--
function roland_furioso:FuriosoCrystalSlash(tInfo, vDir)
	local c = tInfo.crystal

	local tDash =
	{
		caster        = tInfo.caster,
		team_id       = tInfo.team_id,
		target_team   = tInfo.target_team,
		target_type   = tInfo.target_type,
		target_flags  = tInfo.target_flags,
		radius        = c.radius,
		stunnable     = c.da_stunnable,
		sound         = "roland_turn.end",
		particle_dash = 1,
	}

	local tMotion =
	{
		duration = c.da_time,
		dir_x    = vDir.x,
		dir_y    = vDir.y,
		distance = c.da_range,
	}

	local tAnim =
	{
		pause      = -1,
		pause_sync = 1,
		activity   = c.da_act,
		activities = json.encode({c.da_act_mod}),
		rate       = c.da_rate,
		rate_time  = c.da_time,
	}

	local function OnHit(hTarget)
		if hTarget == tInfo.caster then return end  -- FIX: was hTarget ~= tInfo.target
		ROLAND_AddBleeds({target = hTarget, caster = tInfo.caster, bleeds = c.da_bleeds})
		self:DoDamage({target = hTarget, caster = tInfo.caster, damage = c.da_damage})
		self:CreateCrystalHitPFX(hTarget, vDir, c.da_range)
		EmitSoundOn("roland_ranga.slash_2", tInfo.caster)
	end

	local function OnEnd(hTarget, bInterrupted)
		if bInterrupted then return end
		self:FuriosoLogicBigShot(tInfo)
	end

	tDash.on_hit = OnHit
	tDash.on_end = OnEnd

	self:DashToWithCallback(tDash, tMotion, tAnim)
end


--====================================================================================================--
-- STEP 9: Logic big shot 3
--====================================================================================================--
function roland_furioso:FuriosoLogicBigShot(tInfo)
	local lb = tInfo.logic.big

	local tAnim =
	{
		duration   = lb.ca_time,
		pause      = -1,
		pause_sync = 1,
		activity   = lb.act,
		activities = json.encode({lb.act_mod}),
		rate       = lb.ca_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, lb.ca_impact, 30000, lb.ca_stunnable > 0)

	hAnim:AddCallbackThink(lb.ca_impact, function(hMod)
		if hMod:IsInterrupted() then return end
		local vDir = tInfo.caster:GetForwardVector()
		self:FuriosoFireProjectile(tInfo, vDir, lb)
		EmitSoundOn("roland_logic.shot_2", tInfo.caster)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:FuriosoDashTo(tInfo, function(_, bInt)
			if bInt then return end
			self:FuriosoDurandalCast(tInfo)
		end)
	end)
end


--====================================================================================================--
-- STEP 10A: Durandal hits 1 and 2
--====================================================================================================--
function roland_furioso:FuriosoDurandalCast(tInfo)
	local d = tInfo.durandal

	local tAnim =
	{
		duration   = d.ca_time,
		pause      = -1,
		pause_sync = 1,
		activity   = d.ca_act,
		activities = json.encode({d.ca_act_mod}),
		rate       = d.ca_rate,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, d.ca_impact_time_1, 30000, d.ca_stunnable > 0)

	-- Hit 1
	hAnim:AddCallbackThink(d.ca_impact_time_1, function(hMod)
		if hMod:IsInterrupted() then return end
		self:FuriosoApplySlow(tInfo, tInfo.target)
		self:DoDamage({target = tInfo.target, caster = tInfo.caster, damage = d.damage_1})
		EmitSoundOn("roland_durandal.slash_1", tInfo.caster)
		self:CreateDurandalHitPFX1(tInfo)
	end)

	-- Micro-dash embedded in cast anim (identical to original Durandal)
	hAnim:AddCallbackThink(d.da_start_time, function(hMod)
		if hMod:IsInterrupted() then return end
		local vFwd = tInfo.caster:GetForwardVector()
		tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_motion_generic",
		{
			facing      = 1,
			facing_cast = 1,
			duration    = d.da_time,
			dir_x       = vFwd.x,
			dir_y       = vFwd.y,
			distance    = d.da_range,
		})
		EmitSoundOn("roland_turn.end", tInfo.caster)
	end)

	-- Hit 2
	hAnim:AddCallbackThink(d.ca_impact_time_2, function(hMod)
		if hMod:IsInterrupted() or GetDistance(tInfo.target, tInfo.caster) > 300 then return end
		self:FuriosoApplySlow(tInfo, tInfo.target)
		self:DoDamage({target = tInfo.target, caster = tInfo.caster, damage = d.damage_2})
		EmitSoundOn("roland_durandal.slash_2", tInfo.caster)
		self:CreateDurandalHitPFX2(tInfo)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		self:FuriosoDurandalBonus3rd(tInfo)
	end)
end


--====================================================================================================--
-- STEP 10B: Bonus 3rd hit + release invulnerability
--====================================================================================================--
function roland_furioso:FuriosoDurandalBonus3rd(tInfo)
	local d = tInfo.durandal

	local tAnim =
	{
		duration   = d.ca_time_3,
		pause      = -1,
		pause_sync = 1,
		activity   = d.ca_act_3,
		activities = json.encode({d.ca_act_mod_3}),
		rate       = d.ca_rate_3,
	}

	local hAnim = self:AddAnim(tInfo.caster, tAnim)
	if IsNull(hAnim) then return end

	self:SetInterruptAndFacing(hAnim, tInfo.target, d.ca_impact_time_3, 30000, d.ca_stunnable > 0)

	hAnim:AddCallbackThink(d.ca_impact_time_3, function(hMod)
		if hMod:IsInterrupted() then return end
		self:FuriosoApplySlow(tInfo, tInfo.target)
		self:DoDamage({target = tInfo.target, caster = tInfo.caster, damage = d.damage_3})
		EmitSoundOn("roland_durandal.slash_3", tInfo.caster)
		self:CreateDurandalHitPFX3(tInfo)
	end)

	hAnim:AddCallbackEnd(function(hMod)
		if IsNotNull(tInfo.special_invul_target) then tInfo.special_invul_target:Destroy() end
		if IsNotNull(tInfo.special_invul_caster) then tInfo.special_invul_caster:Destroy() end

		if hMod:IsInterrupted() then return end

		self:DoDamage({target = tInfo.target, caster = tInfo.caster, damage = tInfo.last_damage})

		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, tInfo.target, tInfo.last_damage, nil)

		self:TurnPlayNext(tInfo.caster, tInfo.target, GetDirection(tInfo.target, tInfo.caster))
	end)
end


--====================================================================================================--
-- SHARED: apply durandal slow (modifier reads "slow_ms_value" from ability via KV)
--====================================================================================================--
function roland_furioso:FuriosoApplySlow(tInfo, hTarget)
	if IsNull(hTarget) then return end
	local d = tInfo.durandal
	if not d.slow_duration or d.slow_duration == 0 then return end
	hTarget:AddNewModifier(tInfo.caster, self, "modifier_roland_durandal_slow", {duration = d.slow_duration})
end


--====================================================================================================--
-- PFX FUNCTIONS
--====================================================================================================--

-- Step 1 & 9: logic projectile explosion on hit
function roland_furioso:CreateLogicHitPFX(hTarget)
	local nFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_logic/roland_logic_shot_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleShouldCheckFoW(nFX, false)
				ParticleManager:SetParticleControl(nFX, 0, hTarget:GetAbsOrigin() + Vector(0, 0, 50))
				ParticleManager:SetParticleControl(nFX, 3, hTarget:GetAbsOrigin() + Vector(0, 0, 50))
				ParticleManager:ReleaseParticleIndex(nFX)
end

-- Step 2: allas per-hit explosion
function roland_furioso:CreateAllasHitPFX(hTarget)
	local nFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_logic/roland_logic_shot_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleShouldCheckFoW(nFX, false)
				ParticleManager:SetParticleControl(nFX, 0, hTarget:GetAbsOrigin() + Vector(0, 0, 50))
				ParticleManager:SetParticleControl(nFX, 3, hTarget:GetAbsOrigin() + Vector(0, 0, 50))
				ParticleManager:ReleaseParticleIndex(nFX)
end

-- Step 3: boys slash swing + explosion on target
function roland_furioso:CreateBoysPFX(tInfo)
	self:SlashPFX(tInfo.caster, Vector(0, 0, 128), 75, 2, Vector(-90, 0, 25))
	local nFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_logic/roland_logic_shot_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleShouldCheckFoW(nFX, false)
				ParticleManager:SetParticleControl(nFX, 0, tInfo.target:GetAbsOrigin() + Vector(0, 0, 50))
				ParticleManager:SetParticleControl(nFX, 3, tInfo.target:GetAbsOrigin() + Vector(0, 0, 50))
				ParticleManager:ReleaseParticleIndex(nFX)
end

-- Step 4: mook slash swing at cast moment
function roland_furioso:CreateMookCastPFX(hCaster)
	self:SlashPFX(hCaster, Vector(0, 0, 128), 100, -1, Vector(90, 0, 30))
end

-- Step 4: mook sustained slashes circle + big slash line + sheath flash (returns sustained PFX handle)
function roland_furioso:CreateMookSlashesPFX(hCaster, vPFXPos, nRadius)
	local vAttach = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_attack1")) + Vector(0, 0, -20)
	local vDir    = GetDirection(vPFXPos, vAttach, true)

	local nBigFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_big.vpcf", PATTACH_WORLDORIGIN, nil)
				   ParticleManager:SetParticleShouldCheckFoW(nBigFX, false)
				   ParticleManager:SetParticleControl(nBigFX, 0, vAttach + vDir * -nRadius)
				   ParticleManager:SetParticleControl(nBigFX, 2, vAttach + vDir * nRadius * 2)
				   ParticleManager:ReleaseParticleIndex(nBigFX)

	self:CreateMookSheathFlashPFX(hCaster, nRadius)

	local nSlashesPFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slashes.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleShouldCheckFoW(nSlashesPFX, false)
						ParticleManager:SetParticleControl(nSlashesPFX, 0, vPFXPos)
						ParticleManager:SetParticleControl(nSlashesPFX, 1, Vector(nRadius, nRadius, nRadius))
	return nSlashesPFX
end

-- Step 4: sheath flash (called at start and end of mook slashes)
function roland_furioso:CreateMookSheathFlashPFX(hCaster, nRadius)
	local nFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_sheath_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
				ParticleManager:SetParticleControlEnt(nFX, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)
				ParticleManager:SetParticleControl(nFX, 1, Vector(nRadius, 0, 0))
				ParticleManager:ReleaseParticleIndex(nFX)
end

-- Step 4: destroy sustained mook slashes PFX
function roland_furioso:ReleaseMookSlashesPFX(nPFX)
	ParticleManager:DestroyParticle(nPFX, false)
	ParticleManager:ReleaseParticleIndex(nPFX)
end

-- Step 4: small slash spark on each mook hit
function roland_furioso:CreateMookHitPFX(hEnt)
	local vHit = hEnt:GetAbsOrigin() + RandomVector(30)
	local nFX  = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, hEnt)
				 ParticleManager:SetParticleControl(nFX, 0, vHit + Vector(0, 0,  100))
				 ParticleManager:SetParticleControl(nFX, 2, vHit + Vector(0, 0, -100))
				 ParticleManager:ReleaseParticleIndex(nFX)
end

-- Step 5: ranga slash swing at start of each dash
function roland_furioso:CreateRangaSwingPFX(hCaster)
	self:SlashPFX(hCaster, Vector(0, 0, 128), 125, -1, Vector(-90, 0, 45))
end

-- Step 5: ranga per-hit small + big directional slash
function roland_furioso:CreateRangaHitPFX(hTarget, p)
	local vP1    = hTarget:GetAbsOrigin() + RandomVector(100)
	local vP2    = hTarget:GetAbsOrigin() + RandomVector(100)
	local nSmall = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
				   ParticleManager:SetParticleControl(nSmall, 0, vP1)
				   ParticleManager:SetParticleControl(nSmall, 2, vP2)
				   ParticleManager:ReleaseParticleIndex(nSmall)

	local vStart = (hTarget:GetAbsOrigin() + p.dir * -300) + Vector( 25,  25, 128)
	local vEnd   = (hTarget:GetAbsOrigin() + p.dir *  300) + Vector(-25, -25, 128)
	local nBig   = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_big.vpcf", PATTACH_WORLDORIGIN, nil)
				   ParticleManager:SetParticleShouldCheckFoW(nBig, false)
				   ParticleManager:SetParticleControl(nBig, 0, vStart)
				   ParticleManager:SetParticleControl(nBig, 2, vEnd)
				   ParticleManager:ReleaseParticleIndex(nBig)
end

-- Step 6: zelkova per-hit slash swing + explosion
-- bSecondary: true = alt animation; nHit: 1 or 2
function roland_furioso:CreateZelkovaPFX(hCaster, hTarget, bSecondary, nHit)
	if bSecondary then
		self:SlashPFX(hCaster, Vector(0, 0, 128), 100, 1, nHit == 1 and Vector(0, 0, 0) or Vector(90, 0, 30))
	else
		self:SlashPFX(hCaster, Vector(0, 0, 128), 100, 1, nHit == 1 and Vector(-15, 0, 0) or Vector(15, 0, 0))
	end
	local nFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_logic/roland_logic_shot_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleShouldCheckFoW(nFX, false)
				ParticleManager:SetParticleControl(nFX, 0, hTarget:GetAbsOrigin() + Vector(0, 0, 50))
				ParticleManager:SetParticleControl(nFX, 3, hTarget:GetAbsOrigin() + Vector(0, 0, 50))
				ParticleManager:ReleaseParticleIndex(nFX)
end

-- Step 7: wheel big swing + explosion at strike point
function roland_furioso:CreateWheelPFX(hCaster, vPoint, nRadius)
	self:SlashPFX(hCaster, Vector(0, 0, 128), 200, 0, Vector(0, 0, 0))
	local nFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_wheel/roland_wheel_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleShouldCheckFoW(nFX, false)
				ParticleManager:SetParticleControl(nFX, 0, vPoint)
				ParticleManager:SetParticleControl(nFX, 1, Vector(nRadius, nRadius, nRadius))
				ParticleManager:ReleaseParticleIndex(nFX)
end

-- Step 8: crystal dual swing at cast-end (left + right slash)
function roland_furioso:CreateCrystalSwingPFX(hCaster)
	self:SlashPFX(hCaster, Vector(0, 0, 128), 100, 1, Vector(-45,  30, 60))
	self:SlashPFX(hCaster, Vector(0, 0, 128), 100, 1, Vector( 45, -30, 60))
end

-- Step 8: crystal per-hit small + big slash + cross PFX
function roland_furioso:CreateCrystalHitPFX(hTarget, vDir, nRange)
	local vP1    = hTarget:GetAbsOrigin() + RandomVector(100)
	local vP2    = hTarget:GetAbsOrigin() + RandomVector(100)
	local nSmall = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
				   ParticleManager:SetParticleControl(nSmall, 0, vP1)
				   ParticleManager:SetParticleControl(nSmall, 2, vP2)
				   ParticleManager:ReleaseParticleIndex(nSmall)

	local vBigStart = (hTarget:GetAbsOrigin() + vDir * -200) + Vector(0, 0, 128)
	local vBigEnd   = (hTarget:GetAbsOrigin() + vDir *  200) + Vector(0, 0, 128)
	local nBig = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_big.vpcf", PATTACH_WORLDORIGIN, nil)
				 ParticleManager:SetParticleShouldCheckFoW(nBig, false)
				 ParticleManager:SetParticleControl(nBig, 0, vBigStart)
				 ParticleManager:SetParticleControl(nBig, 2, vBigEnd)
				 ParticleManager:ReleaseParticleIndex(nBig)

	local vBase = hTarget:GetAbsOrigin() + Vector(0, 0, 128)
	local function MakeCross(vCrossDir)
		local vS    = vBase - vCrossDir * nRange * 0.6
		local vE    = vBase + vCrossDir * nRange * 0.6
		local nCFX  = ParticleManager:CreateParticle("particles/heroes/roland/roland_crystal/roland_crystall_slash_cross.vpcf", PATTACH_WORLDORIGIN, nil)
					  ParticleManager:SetParticleShouldCheckFoW(nCFX, false)
					  ParticleManager:SetParticleControl(nCFX, 0, vS)
					  ParticleManager:SetParticleControl(nCFX, 2, vE)
					  ParticleManager:ReleaseParticleIndex(nCFX)
	end
	MakeCross(RotateVector2D(vDir,  20, true))
	MakeCross(RotateVector2D(vDir, -20, true))
end

-- Step 10: durandal hit 1
function roland_furioso:CreateDurandalHitPFX1(tInfo)
	self:SlashPFX(tInfo.caster, Vector(0, 0, 128), 125, 1, nil)
	local vStart = tInfo.target:GetAbsOrigin() + Vector(-100, -100, 300)
	local vEnd   = tInfo.target:GetAbsOrigin() + Vector( 100,  100, -100)
	local nFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_big.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleShouldCheckFoW(nFX, false)
				ParticleManager:SetParticleControl(nFX, 0, vStart)
				ParticleManager:SetParticleControl(nFX, 2, vEnd)
				ParticleManager:ReleaseParticleIndex(nFX)
end

-- Step 10: durandal hit 2
function roland_furioso:CreateDurandalHitPFX2(tInfo)
	self:SlashPFX(tInfo.caster, Vector(0, 0, 128), 125, 1, Vector(0, 180, 200))
	local vStart = tInfo.target:GetAbsOrigin() + Vector( 100,  100, 300)
	local vEnd   = tInfo.target:GetAbsOrigin() + Vector(-100, -100, -100)
	local nFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_big.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleShouldCheckFoW(nFX, false)
				ParticleManager:SetParticleControl(nFX, 0, vStart)
				ParticleManager:SetParticleControl(nFX, 2, vEnd)
				ParticleManager:ReleaseParticleIndex(nFX)
end

-- Step 10: durandal bonus 3rd hit (finishing cross slash)
function roland_furioso:CreateDurandalHitPFX3(tInfo)
	self:SlashPFX(tInfo.caster, Vector(0, 0, 128), 150, 1, Vector(0, 0, 0))
	local vStart = tInfo.target:GetAbsOrigin() + Vector(-150,  150, 200)
	local vEnd   = tInfo.target:GetAbsOrigin() + Vector( 150, -150, -50)
	local nFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_big.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleShouldCheckFoW(nFX, false)
				ParticleManager:SetParticleControl(nFX, 0, vStart)
				ParticleManager:SetParticleControl(nFX, 2, vEnd)
				ParticleManager:ReleaseParticleIndex(nFX)
end


--====================================================================================================--
-- MODIFIER: full invulnerability + stun on TARGET during the sequence
--====================================================================================================--
LinkLuaModifier("modifier_roland_furioso_invul_target", "heroes/roland/roland_furioso", LUA_MODIFIER_MOTION_NONE)

modifier_roland_furioso_invul_target = class({})

function modifier_roland_furioso_invul_target:IsHidden()			return false end
function modifier_roland_furioso_invul_target:IsDebuff()			return true end
function modifier_roland_furioso_invul_target:IsPurgable()			return false end
function modifier_roland_furioso_invul_target:IsPurgeException()	return false end
function modifier_roland_furioso_invul_target:RemoveOnDeath()		return true end
function modifier_roland_furioso_invul_target:GetAttributes()		return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_furioso_invul_target:GetPriority()			return MODIFIER_PRIORITY_NORMAL end
function modifier_roland_furioso_invul_target:CheckState()
	return
	{
		[MODIFIER_STATE_INVULNERABLE]  = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_STUNNED]       = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
end


--====================================================================================================--
-- MODIFIER: invulnerability on CASTER during the sequence
--====================================================================================================--
LinkLuaModifier("modifier_roland_furioso_invul_caster", "heroes/roland/roland_furioso", LUA_MODIFIER_MOTION_NONE)

modifier_roland_furioso_invul_caster = class({})

function modifier_roland_furioso_invul_caster:IsHidden()			return false end
function modifier_roland_furioso_invul_caster:IsDebuff()			return false end
function modifier_roland_furioso_invul_caster:IsPurgable()			return false end
function modifier_roland_furioso_invul_caster:IsPurgeException()	return false end
function modifier_roland_furioso_invul_caster:RemoveOnDeath()		return true end
function modifier_roland_furioso_invul_caster:GetAttributes()		return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_roland_furioso_invul_caster:GetPriority()			return MODIFIER_PRIORITY_NORMAL end
function modifier_roland_furioso_invul_caster:CheckState()
	return
	{
		[MODIFIER_STATE_INVULNERABLE]  = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
end
function modifier_roland_furioso_invul_caster:OnCreated(tInfo)
	if not IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_roland_furioso_invul_caster:OnIntervalThink()
	if self:GetRemainingTime() <= 7 and not self._sounded then
		self._sounded = true
		EmitSoundOn("roland_die.1", self:GetParent())
	end
end
function modifier_roland_furioso_invul_caster:OnDestroy()
	StopSoundOn("roland_die.1", self:GetParent())
end
--====================================================================================================--
--====================================================================================================--
roland_furioso_ex = class(roland_furioso)
