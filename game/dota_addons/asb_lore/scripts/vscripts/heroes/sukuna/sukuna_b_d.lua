require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_b_d = class({})

function sukuna_b_d:GetManaCost(nLevel)
	return self.BaseClass.GetManaCost(self, nLevel) * self:GetCaster():GetMaxMana() * 0.01
end
function sukuna_b_d:GetPlaybackRateOverride()
	return GetAnimPlayRate(30, 29, 30, self:GetCastPoint())
end
function sukuna_b_d:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sukuna_animation_generic_activity", {duration = 0.1, activity = "book"})
	if not self.nPFX then
		self.nPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_fuga/sukuna_fuga_cast_ball.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	end
	return true
end
function sukuna_b_d:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
	if self.nPFX then
		ParticleManager:DestroyParticle(self.nPFX, false)
		ParticleManager:ReleaseParticleIndex(self.nPFX)
		self.nPFX = nil
	end
end
function sukuna_b_d:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sukuna_b_d:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition() + hCaster:GetForwardVector()

	EmitSoundOn("sukuna_fuga.cast", hCaster)

	self:OnAbilityPhaseInterrupted()

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

		ca_act = ACT_DOTA_CAST_ABILITY_4_END,
		ca_act_mod = "book",

		projectile =
		{
			speed = self:GetSpecialValueFor("proj_speed"),
			range = GetDistance(vPoint, hCaster),--self:GetSpecialValueFor("proj_range"),
			width = self:GetSpecialValueFor("proj_width"),

			projectile_name = "particles/heroes/sukuna/sukuna_fuga/sukuna_fuga_projectile.vpcf",

			extra_data =
			{
				caster_id = hCaster:entindex(),

				team_id = hCaster:GetTeamNumber(),
				target_team = self:GetAbilityTargetTeam(),
				target_type = self:GetAbilityTargetType(),
				target_flags = self:GetAbilityTargetFlags(),

				dir_x = vDir.x,
				dir_y = vDir.y,

				radius = self:GetAOERadius(),

				damage = self:GetSpecialValueFor("damage"),

				burn_duration = self:GetSpecialValueFor("burn_duration"),
				burn_damage = self:GetSpecialValueFor("burn_damage"),
			}
		}
	}

	tInfo.ca_rate = GetAnimPlayRate(60, 59, 30, tInfo.ca_time)
	-- tInfo.ca_impact_time = GetAnimImpactTime(38, 10, 30, tInfo.ca_time)

	self:CastAnimation(tInfo)
end
function sukuna_b_d:CastAnimation(tInfo)
	local tAnim =
	{
		duration = tInfo.ca_time,
		-- pause = -1,
		pause_sync = 1,
		activity = tInfo.ca_act,
		activities = json.encode({tInfo.ca_act_mod}),
		rate = tInfo.ca_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	local hChanneling = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_sukuna_b_d_channeling", {duration = tInfo.ca_time})

	hAnim:AddCallbackThink(FrameTime(), function(hMod, _tTimer, nTime)
		if tInfo.ca_stunnable > 0 and tInfo.caster:IsStunned() then
			hMod:Destroy(true)
			return
		end
		return nTime
	end)

	-- hAnim:AddCallbackThink(tInfo.ca_impact_time, function(hMod)
	-- end)

	hAnim:AddCallbackEnd(function(hMod)
		if IsNotNull(hChanneling) then
			hChanneling:Destroy()
		end
		if hMod:IsInterrupted() then return end
		self:ProjectileLaunch(tInfo)
	end)
end
function sukuna_b_d:ProjectileLaunch(tInfo)
	local tProj =
	{
		vSpawnOrigin = (tInfo.caster:GetAbsOrigin()),
		vVelocity = tInfo.caster:GetForwardVector() * tInfo.projectile.speed,

		fDistance = tInfo.projectile.range,
		fStartRadius = tInfo.projectile.width,
		fEndRadius = tInfo.projectile.width,

		iUnitTargetTeam = tInfo.target_team,
		iUnitTargetType = tInfo.target_type,
		iUnitTargetFlags = tInfo.target_flags,

		EffectName = tInfo.projectile.projectile_name,

		Ability = self,
		Source = tInfo.caster,

		bProvidesVision = true,
		iVisionRadius = tInfo.projectile.extra_data.radius,
		iVisionTeamNumber = tInfo.caster:GetTeamNumber(),

		ExtraData = tInfo.projectile.extra_data,
	}

	ProjectileManager:CreateLinearProjectile(tProj)

	EmitSoundOn("sukuna_fuga.launch", tInfo.caster)
end
function sukuna_b_d:OnProjectileHit_ExtraData(hTarget, vLocation, tInfo)
	tInfo.caster = EntIndexToHScript(tInfo.caster_id)
	tInfo.target = hTarget
	tInfo.point = vLocation

	self:Explosion(tInfo)

	return true
end
function sukuna_b_d:Explosion(tInfo)
	local tEntities = FindUnitsInRadius(
		tInfo.team_id,
		tInfo.point,
		nil,
		tInfo.radius,
		tInfo.target_team,
		tInfo.target_type,
		tInfo.target_flags,
		FIND_CLOSEST,
		false)

	for _, hEnt in ipairs(tEntities) do
		if hEnt ~= tInfo.caster then
			self:ExplodeTarget({
				target = hEnt,
				caster = tInfo.caster,
				damage = tInfo.damage,
			})
		end
	end

	CreateModifierThinker(
		tInfo.caster,
		self,
		"modifier_sukuna_b_d_burn_ground",
		{
			duration = tInfo.burn_duration,
			-- damage = tInfo.burn_damage,
			-- radius = tInfo.radius,
		},
		tInfo.point,
		tInfo.team_id,
		false)

	local nEXPLODE_PFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_fuga/sukuna_fuga_explode/sukuna_fuga_explode.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleShouldCheckFoW(nEXPLODE_PFX, false)
						ParticleManager:SetParticleControl(nEXPLODE_PFX, 0, tInfo.point)
						ParticleManager:SetParticleControl(nEXPLODE_PFX, 1, Vector(tInfo.radius, tInfo.radius, tInfo.radius))
						ParticleManager:ReleaseParticleIndex(nEXPLODE_PFX)

	EmitSoundOnLocationWithCaster(tInfo.point, "sukuna_fuga.explode", tInfo.caster)
end
function sukuna_b_d:ExplodeTarget(tInfo)
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
--====================================================================================================--


-- particles/anime/heroes/anime_hero_lancer/lancer_spear_impact.vpcf






--====================================================================================================--
LinkLuaModifier("modifier_sukuna_b_d_burn_ground", "heroes/sukuna/sukuna_b_d", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_b_d_burn_ground = class({})

function modifier_sukuna_b_d_burn_ground:IsHidden()														return true end
function modifier_sukuna_b_d_burn_ground:IsDebuff()														return false end
function modifier_sukuna_b_d_burn_ground:IsPurgable()													return false end
function modifier_sukuna_b_d_burn_ground:IsPurgeException()												return false end
function modifier_sukuna_b_d_burn_ground:RemoveOnDeath()												return true end
function modifier_sukuna_b_d_burn_ground:IsAura()														return true end
function modifier_sukuna_b_d_burn_ground:IsAuraActiveOnDeath()											return false end
function modifier_sukuna_b_d_burn_ground:IsPermanent()													return false end
function modifier_sukuna_b_d_burn_ground:CheckState()
	local t = 
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return t
end
function modifier_sukuna_b_d_burn_ground:GetAuraRadius()
	return self.nRadius
end
function modifier_sukuna_b_d_burn_ground:GetAuraSearchTeam()
	return self.nABILITY_TARGET_TEAM
end
function modifier_sukuna_b_d_burn_ground:GetAuraSearchType()
	return self.nABILITY_TARGET_TYPE
end
function modifier_sukuna_b_d_burn_ground:GetAuraSearchFlags()
	return self.nABILITY_TARGET_FLAGS
end
function modifier_sukuna_b_d_burn_ground:GetModifierAura()
	return "modifier_sukuna_b_d_burn_ground_debuff"
end
function modifier_sukuna_b_d_burn_ground:OnCreated(tInfo)
	self.hCaster  = self:GetCaster()
	self.hParent  = self:GetParent()
	self.hAbility = self:GetAbility()

	self.nRadius = self.hAbility:GetAOERadius()

	if not IsServer() then return end

	self.nABILITY_TARGET_TEAM  = self.hAbility:GetAbilityTargetTeam()
	self.nABILITY_TARGET_TYPE  = self.hAbility:GetAbilityTargetType() 
	self.nABILITY_TARGET_FLAGS = self.hAbility:GetAbilityTargetFlags()

	if self.nAOE_PFX then return end
	
	self.nBLOW_PFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_fuga/sukuna_fuga_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleShouldCheckFoW(self.nBLOW_PFX, false)
					ParticleManager:SetParticleControl(self.nBLOW_PFX, 0, self.hParent:GetAbsOrigin())

	self:AddParticle(self.nBLOW_PFX, false, false, -1, false, false)

	self.nAOE_PFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_fuga/sukuna_fuga_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleShouldCheckFoW(self.nAOE_PFX, false)
					ParticleManager:SetParticleControl(self.nAOE_PFX, 0, self.hParent:GetAbsOrigin())
					ParticleManager:SetParticleControl(self.nAOE_PFX, 1, Vector(self.nRadius, 1, 1))
					ParticleManager:SetParticleControl(self.nAOE_PFX, 2, Vector(self:GetDuration(), 0, 0))

	self:AddParticle(self.nAOE_PFX, false, false, -1, false, false)

	EmitSoundOn("sukuna_fuga.burn", self.hParent)
end
function modifier_sukuna_b_d_burn_ground:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_sukuna_b_d_burn_ground:OnDestroy()
	StopSoundOn("sukuna_fuga.burn", self.hParent)
end

--====================================================================================================--
LinkLuaModifier("modifier_sukuna_b_d_burn_ground_debuff", "heroes/sukuna/sukuna_b_d", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_b_d_burn_ground_debuff = class({})

function modifier_sukuna_b_d_burn_ground_debuff:IsHidden()															return false end
function modifier_sukuna_b_d_burn_ground_debuff:IsDebuff()															return true end
function modifier_sukuna_b_d_burn_ground_debuff:IsPurgable()														return true end
function modifier_sukuna_b_d_burn_ground_debuff:IsPurgeException()													return true end
function modifier_sukuna_b_d_burn_ground_debuff:RemoveOnDeath()														return true end
-- function modifier_sukuna_b_d_burn_ground_debuff:GetAttributes()														return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_sukuna_b_d_burn_ground_debuff:OnCreated(tInfo)
	self.hCaster  = self:GetCaster()
	self.hParent  = self:GetParent()
	self.hAbility = self:GetAbility()

	if not IsServer() then return end

	self.nTick = 0.25
	self.nDamage = self.hAbility:GetSpecialValueFor("burn_damage") * self.nTick

	self.tDamage =
	{
		victim = self.hParent,
		attacker = self.hCaster,
		damage = self.nDamage,
		damage_type = self.hAbility:GetAbilityDamageType(),
		ability = self.hAbility
	}

	self:StartIntervalThink(self.nTick)
	
	if not self.nBurnPFX then
		self.nBurnPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_fuga/sukuna_fuga_burn_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hParent)
			
		self:AddParticle(self.nBurnPFX, false, false, -1, false, false)
	end
end
function modifier_sukuna_b_d_burn_ground_debuff:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_sukuna_b_d_burn_ground_debuff:OnIntervalThink()
	ApplyDamage(self.tDamage)
end




--====================================================================================================--
LinkLuaModifier("modifier_sukuna_b_d_channeling", "heroes/sukuna/sukuna_b_d", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_b_d_channeling = class({})

function modifier_sukuna_b_d_channeling:IsHidden()															return false end
function modifier_sukuna_b_d_channeling:IsDebuff()															return false end
function modifier_sukuna_b_d_channeling:IsPurgable()														return false end
function modifier_sukuna_b_d_channeling:IsPurgeException()													return false end
function modifier_sukuna_b_d_channeling:RemoveOnDeath()													return true end
-- function modifier_sukuna_b_d_channeling:GetAttributes()														return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_sukuna_b_d_channeling:CheckState()
	local t =
	{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
	}
	return t
end
function modifier_sukuna_b_d_channeling:OnCreated(tInfo)
	self.hCaster  = self:GetCaster()
	self.hParent  = self:GetParent()
	self.hAbility = self:GetAbility()

	if not IsServer() then return end
	
	if not self.nBowPPX then
		self.nBowPPX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_fuga/sukuna_fuga.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hParent)
			
		self:AddParticle(self.nBowPPX, false, false, -1, false, false)
	end
end
function modifier_sukuna_b_d_channeling:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_sukuna_b_d_channeling:OnDestroy()
end