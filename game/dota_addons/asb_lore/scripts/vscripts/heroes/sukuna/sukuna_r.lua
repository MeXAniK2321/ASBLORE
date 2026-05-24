require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_r = class({})

function sukuna_r:Spawn()
	if not IsServer() then return end
	self:SetLevel(1)
	self:StartCooldown(self:GetSpecialValueFor("start_cd"))
end
function sukuna_r:GetBehavior()
	local hCaster = self:GetCaster()
	if hCaster:HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + 1099511627776
	end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end
function sukuna_r:GetCooldown(nLevel)
	local hCaster = self:GetCaster()
	if IsServer() and hCaster:HasScepter() and self:GetAltCastState() then
		return self:GetSpecialValueFor("alt_cd")
	end
	return self.BaseClass.GetCooldown(self, nLevel)
end
function sukuna_r:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	if not self.nPFX then
		self.nPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_aura/sukuna_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	end
	EmitSoundOn("sukuna_r.cast", hCaster)
	return true
end
function sukuna_r:OnAbilityPhaseInterrupted()
	if self.nPFX then
		ParticleManager:DestroyParticle(self.nPFX, false)
		ParticleManager:ReleaseParticleIndex(self.nPFX)
		self.nPFX = nil
	end
	StopSoundOn("sukuna_r.cast", self:GetCaster())
end
function sukuna_r:GetAOERadius()
	local hCaster = self:GetCaster()
	if IsServer() and hCaster:HasScepter() and self:GetAltCastState() then
		return self:GetSpecialValueFor("alt_radius")
	end
	return self:GetSpecialValueFor("radius")
end
function sukuna_r:OnSpellStart()
	local hCaster = self:GetCaster()

	local vDir = hCaster:GetForwardVector()

	local vOffsetSpawn = hCaster:GetAbsOrigin() + vDir * -300

	local nTeamID = hCaster:GetTeamNumber()

	self:OnAbilityPhaseInterrupted()

	if hCaster:HasScepter() and self:GetAltCastState() then
		self:StartWithoutDomain()
		return
	end

	local hDomain = self.hDomain or CreateUnitByName("npc_dota_sukuna_domain", vOffsetSpawn, true, hCaster, hCaster, hCaster:GetTeamNumber())
	if IsNull(hDomain) then return end
	self.hDomain = hDomain

	hDomain:RespawnUnit()
	hDomain:SetAbsOrigin(vOffsetSpawn)

	-- FindClearSpaceForUnit(hDomain, vOffsetSpawn, true)

	local nHealth = self:GetSpecialValueFor("health") + FindTalentValue(hCaster, "special_bonus_sukuna_15r")

	hDomain:SetBaseMaxHealth(nHealth)
	hDomain:SetMaxHealth(nHealth)
	hDomain:SetHealth(nHealth)

	SetForwardVector(hDomain, vDir, true)

	local hInvul = hDomain:AddNewModifier(hCaster, self, "modifier_sukuna_r_domain_invul", {})

	local nSpawnTime = self:GetSpecialValueFor("spawn_time")

	local tAnim =
	{
		duration = nSpawnTime,--self:GetSpecialValueFor("spawn_time"),
		pause = -1,
		pause_sync = 1,
		activity = ACT_DOTA_SPAWN,
		activities = json.encode({""}),
		rate = GetAnimPlayRate(30, 30, 30, nSpawnTime),
	}

	local hAnim = hDomain:AddNewModifier(hCaster, self, "modifier_sukuna_animation_generic", tAnim)
	if IsNull(hAnim) then return end

	local nDuration = self:GetSpecialValueFor("duration")

	local nCastPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_domain/sukuna_domain_radius.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleShouldCheckFoW(nCastPFX, false)
					ParticleManager:SetParticleControl(nCastPFX, 0, hDomain:GetAbsOrigin())
					ParticleManager:SetParticleControl(nCastPFX, 1, Vector(self:GetAOERadius(), 0, 0))

	hAnim:AddCallbackEnd(function(hMod)
		if IsNotNull(hInvul) then
			hInvul:Destroy()
		end
		hDomain:AddNewModifier(hCaster, self, "modifier_sukuna_r_domain_aura", {duration = nDuration, domain_cast = nCastPFX})
		hDomain:AddNewModifier(hCaster, self, "modifier_kill", {duration = nDuration})
	end)

	local tEntities = FindUnitsInRadius(
		nTeamID,
		vOffsetSpawn,
		nil,
		self:GetAOERadius(),
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		FIND_CLOSEST,
		false)

	for _, hEnt in ipairs(tEntities) do
		if hEnt ~= hCaster and hEnt ~= hDomain then
			hEnt:AddNewModifier(hCaster, self, "modifier_stunned", {duration = nSpawnTime})
		end
	end
end
function sukuna_r:StartWithoutDomain()
	local hCaster = self:GetCaster()

	local nTeamID = hCaster:GetTeamNumber()

	local nDuration = self:GetSpecialValueFor("alt_duration")

	local nCastPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_domain/sukuna_domain_radius.vpcf", PATTACH_WORLDORIGIN, nil)
					ParticleManager:SetParticleShouldCheckFoW(nCastPFX, false)
					ParticleManager:SetParticleControl(nCastPFX, 0, hCaster:GetAbsOrigin())
					ParticleManager:SetParticleControl(nCastPFX, 1, Vector(self:GetAOERadius(), 0, 0))

	local tEntities = FindUnitsInRadius(
		nTeamID,
		hCaster:GetAbsOrigin(),
		nil,
		self:GetAOERadius(),
		self:GetAbilityTargetTeam(),
		self:GetAbilityTargetType(),
		self:GetAbilityTargetFlags(),
		FIND_CLOSEST,
		false)

	for _, hEnt in ipairs(tEntities) do
		if hEnt ~= hCaster and hEnt ~= hDomain then
			hEnt:AddNewModifier(hCaster, self, "modifier_stunned", {duration = nDuration})
		end
	end

	CreateModifierThinker(hCaster, self, "modifier_sukuna_r_domain_aura", {duration = nDuration, domain_cast = nCastPFX}, hCaster:GetAbsOrigin(), nTeamID, false)
end










--====================================================================================================--
LinkLuaModifier("modifier_sukuna_r_domain_invul", "heroes/sukuna/sukuna_r", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_r_domain_invul = class({})

function modifier_sukuna_r_domain_invul:IsHidden()														return false end
function modifier_sukuna_r_domain_invul:IsDebuff()														return false end
function modifier_sukuna_r_domain_invul:IsPurgable()													return false end
function modifier_sukuna_r_domain_invul:IsPurgeException()												return false end
function modifier_sukuna_r_domain_invul:RemoveOnDeath()													return true end
function modifier_sukuna_r_domain_invul:CheckState()
	local t = 
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	return t
end
function modifier_sukuna_r_domain_invul:GetEffectName()
	return "particles/heroes/sukuna/sukuna_aura/sukuna_aura_domain.vpcf"
end
function modifier_sukuna_r_domain_invul:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--====================================================================================================--
LinkLuaModifier("modifier_sukuna_r_domain_aura", "heroes/sukuna/sukuna_r", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_r_domain_aura = class({})

function modifier_sukuna_r_domain_aura:IsHidden()														return true end
function modifier_sukuna_r_domain_aura:IsDebuff()														return false end
function modifier_sukuna_r_domain_aura:IsPurgable()														return false end
function modifier_sukuna_r_domain_aura:IsPurgeException()												return false end
function modifier_sukuna_r_domain_aura:RemoveOnDeath()													return true end
function modifier_sukuna_r_domain_aura:IsAura()															return true end
function modifier_sukuna_r_domain_aura:IsAuraActiveOnDeath()											return false end
function modifier_sukuna_r_domain_aura:IsPermanent()													return false end
function modifier_sukuna_r_domain_aura:CheckState()
	local t = 
	{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
	return t
end
function modifier_sukuna_r_domain_aura:GetAuraRadius()
	return self.nRadius
end
function modifier_sukuna_r_domain_aura:GetAuraSearchTeam()
	return self.nABILITY_TARGET_TEAM
end
function modifier_sukuna_r_domain_aura:GetAuraSearchType()
	return self.nABILITY_TARGET_TYPE
end
function modifier_sukuna_r_domain_aura:GetAuraSearchFlags()
	return self.nABILITY_TARGET_FLAGS
end
function modifier_sukuna_r_domain_aura:GetModifierAura()
	return "modifier_sukuna_r_domain_aura_debuff"
end
function modifier_sukuna_r_domain_aura:OnCreated(tInfo)
	self.hCaster  = self:GetCaster()
	self.hParent  = self:GetParent()
	self.hAbility = self:GetAbility()

	self.nRadius = self.hAbility:GetAOERadius()

	if not IsServer() then return end

	self.nABILITY_TARGET_TEAM  = self.hAbility:GetAbilityTargetTeam()
	self.nABILITY_TARGET_TYPE  = self.hAbility:GetAbilityTargetType() 
	self.nABILITY_TARGET_FLAGS = self.hAbility:GetAbilityTargetFlags()

	if self.nDomainSlashes then return end
	
	self.nDomainCast = tInfo.domain_cast or -1

	self.nDomainSlashes = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_domain/sukuna_domain_main.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleShouldCheckFoW(self.nDomainSlashes, false)
						ParticleManager:SetParticleControl(self.nDomainSlashes, 0, self.hParent:GetAbsOrigin())
						ParticleManager:SetParticleControl(self.nDomainSlashes, 1, Vector(self.nRadius, 1, 1))

	self:AddParticle(self.nDomainSlashes, false, false, -1, false, false)

	self.hAbility:SetActivated(false)

	EmitSoundOn("sukuna_r.domain", self.hParent)
	-- EmitSoundOnLocationWithCaster(self.hParent:GetAbsOrigin(), "sukuna_r.domain", self.hParent)

	self:StartIntervalThink(FrameTime())
end
function modifier_sukuna_r_domain_aura:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_sukuna_r_domain_aura:OnIntervalThink()
	if IsNull(self.hCaster) or not self.hCaster:IsAlive() then
		self.hParent:Kill(self.hAbility, self.hCaster)
	end
end
function modifier_sukuna_r_domain_aura:OnDestroy()
	if not IsServer() then return end

	if self.nDomainCast then
		ParticleManager:DestroyParticle(self.nDomainCast, false)
		ParticleManager:ReleaseParticleIndex(self.nDomainCast)
		self.nDomainCast = nil
	end

	if self.nDomainSlashes then
		ParticleManager:DestroyParticle(self.nDomainSlashes, false)
		ParticleManager:ReleaseParticleIndex(self.nDomainSlashes)
		self.nDomainSlashes = nil
	end

	self.hAbility:SetActivated(true)

	StopSoundOn("sukuna_r.domain", self.hParent)

	if IsNotNull(self.hCaster) and self.hCaster:IsAlive() then
		self.hCaster:AddNewModifier(self.hCaster, self.hAbility, "modifier_sukuna_r_domain_fuga_buff", {})
	end
end
function modifier_sukuna_r_domain_aura:GetEffectName()
	return "particles/heroes/sukuna/sukuna_aura/sukuna_aura_domain.vpcf"
end
function modifier_sukuna_r_domain_aura:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--====================================================================================================--
LinkLuaModifier("modifier_sukuna_r_domain_aura_debuff", "heroes/sukuna/sukuna_r", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_r_domain_aura_debuff = class({})

function modifier_sukuna_r_domain_aura_debuff:IsHidden()															return false end
function modifier_sukuna_r_domain_aura_debuff:IsDebuff()															return true end
function modifier_sukuna_r_domain_aura_debuff:IsPurgable()															return true end
function modifier_sukuna_r_domain_aura_debuff:IsPurgeException()													return true end
function modifier_sukuna_r_domain_aura_debuff:RemoveOnDeath()														return true end
-- function modifier_sukuna_r_domain_aura_debuff:GetAttributes()														return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_sukuna_r_domain_aura_debuff:DeclareFunctions()
	local t =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return t
end
function modifier_sukuna_r_domain_aura_debuff:GetModifierMoveSpeedBonus_Percentage(keys)
	return self.nSlowMSPct
end
function modifier_sukuna_r_domain_aura_debuff:GetModifierIncomingDamage_Percentage(keys)
	if keys.inflictor == self.hAbility then return end
	return self.nDamageAmp
end
function modifier_sukuna_r_domain_aura_debuff:OnCreated(tInfo)
	self.hCaster  = self:GetCaster()
	self.hParent  = self:GetParent()
	self.hAbility = self:GetAbility()

	self.nSlowMSPct = self.hAbility:GetSpecialValueFor("slow_ms_pct")

	if not IsServer() then return end

	self.nDamageAmp = self.hAbility:GetSpecialValueFor("damage_amp")

	self.nDamageTick = self.hAbility:GetSpecialValueFor("damage_tick")
	self.nDamage = self.hAbility:GetSpecialValueFor("damage")
	self.nDamageMaxHp = (self.hAbility:GetSpecialValueFor("damage_max_hp") + FindTalentValue(self.hCaster, "special_bonus_sukuna_25r")) * 0.01

	self.tDamage =
	{
		victim = self.hParent,
		attacker = self.hCaster,
		damage = nil,
		damage_type = self.hAbility:GetAbilityDamageType(),
		ability = self.hAbility
	}

	self:OnIntervalThink()
	self:StartIntervalThink(self.nDamageTick)
end
function modifier_sukuna_r_domain_aura_debuff:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_sukuna_r_domain_aura_debuff:OnIntervalThink()

	-- EmitSoundOn("sukuna_r.slash", self.hParent)

	local nDamage = (self.nDamage + (self.nDamageMaxHp * self.hParent:GetMaxHealth())) * self.nDamageTick
	self.tDamage.damage = nDamage
	ApplyDamage(self.tDamage)
end





--====================================================================================================--
LinkLuaModifier("modifier_sukuna_r_domain_fuga_buff", "heroes/sukuna/sukuna_r", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_r_domain_fuga_buff = class({})

function modifier_sukuna_r_domain_fuga_buff:IsHidden()															return false end
function modifier_sukuna_r_domain_fuga_buff:IsDebuff()															return false end
function modifier_sukuna_r_domain_fuga_buff:IsPurgable()														return false end
function modifier_sukuna_r_domain_fuga_buff:IsPurgeException()													return false end
function modifier_sukuna_r_domain_fuga_buff:RemoveOnDeath()														return false end