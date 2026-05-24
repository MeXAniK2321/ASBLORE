require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_b_q = class({})

function sukuna_b_q:GetRecast()
	local hCaster = self:GetCaster()
	return hCaster:GetModifierStackCount("modifier_sukuna_b_q_recast", hCaster)
end
function sukuna_b_q:GetIntrinsicModifierName()
	return "modifier_sukuna_b_q_recast"
end
function sukuna_b_q:GetManaCost(nLevel)
	if self:GetRecast() > 0 then return 0 end
	return self.BaseClass.GetManaCost(self, nLevel) * self:GetCaster():GetMaxMana() * 0.01
end
function sukuna_b_q:CastFilterResultLocation(vLocation)
	if IsServer() then
		local hCaster = self:GetCaster()
		local hModifier = hCaster:FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), hCaster)
		if IsNull(hModifier) or hModifier:IsNearOtherPoint(vLocation) then
			return UF_FAIL_CUSTOM
		end
	end
	return self.BaseClass.CastFilterResultLocation(self, vLocation)
end
function sukuna_b_q:GetCustomCastErrorLocation(vLocation)
	return "#error_sukuna_b_q_too_close_to_other_point"
end
function sukuna_b_q:OnAbilityPhaseStart()
	-- print("STARTING")
	return true
end
function sukuna_b_q:OnAbilityPhaseInterrupted()
	-- print("ENDING")
end
function sukuna_b_q:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition()

	local hModifier = hCaster:FindModifierByNameAndCaster(self:GetIntrinsicModifierName(), hCaster)
	if IsNull(hModifier) then return end

	hModifier:AddPoint(vPoint)

	EmitSoundOnLocationWithCaster(vPoint, "sukuna_wcs_point.cast", hCaster)
end







--====================================================================================================--
LinkLuaModifier("modifier_sukuna_b_q_recast", "heroes/sukuna/sukuna_b_q", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_b_q_recast = class({})

function modifier_sukuna_b_q_recast:IsHidden()										return false end
function modifier_sukuna_b_q_recast:IsDebuff()										return false end
function modifier_sukuna_b_q_recast:IsPurgable()									return false end
function modifier_sukuna_b_q_recast:IsPurgeException()								return false end
function modifier_sukuna_b_q_recast:RemoveOnDeath()									return false end
function modifier_sukuna_b_q_recast:DestroyOnExpire()								return false end
function modifier_sukuna_b_q_recast:GetAttributes()									return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_sukuna_b_q_recast:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_sukuna_b_q_recast:OnCreated(tInfo)
	self._hCaster  = self:GetCaster()
	self._hParent  = self:GetParent()
	self._hAbility = self:GetAbility()

	if not IsServer() then return end

	self.nTEAM_ID 			   = self._hCaster:GetTeamNumber()
	self.nABILITY_TARGET_TEAM  = self._hAbility:GetAbilityTargetTeam()
	self.nABILITY_TARGET_TYPE  = self._hAbility:GetAbilityTargetType() 
	self.nABILITY_TARGET_FLAGS = self._hAbility:GetAbilityTargetFlags()

	self.nRecastTime = self._hAbility:GetSpecialValueFor("recast_time")

	self.nMaxPoints = self._hAbility:GetSpecialValueFor("max_points")
	self.nMinRange = self._hAbility:GetSpecialValueFor("min_range")

	self.nWidth = self._hAbility:GetSpecialValueFor("width")
	self.nDamage = self._hAbility:GetSpecialValueFor("damage")

	self.nReleaseTime = self._hAbility:GetSpecialValueFor("release_time") + FindTalentValue(self._hCaster, "special_bonus_sukuna_20r")

	self.tPoints = self.tPoints or {}
	self.tParticles = self.tParticles or {}

	self:StartIntervalThink(0.01)
end
function modifier_sukuna_b_q_recast:IsNearOtherPoint(vPos)
	for _, _vPos in ipairs(self.tPoints) do
		if GetDistance(vPos, _vPos) <= self.nMinRange then
			return true
		end
	end
	return false
end
function modifier_sukuna_b_q_recast:AddPoint(vPos)
	local nNow = #self.tPoints
	local nNew = nNow + 1

	self.tPoints[nNew] = vPos

	self:SetDuration(self.nRecastTime, true)
	self:SetStackCount(nNew)

	self._hAbility:EndCooldown()

	local v7thPos = self.tPoints[nNow] or vPos

	local nPFX = ParticleManager:CreateParticleForPlayer("particles/heroes/sukuna/sukuna_wcs_pointed/sukuna_wcs_pointed_point.vpcf", PATTACH_WORLDORIGIN, nil, self._hParent:GetPlayerOwner())
				ParticleManager:SetParticleShouldCheckFoW(nPFX, false)
				ParticleManager:SetParticleControl(nPFX, 0, vPos)
				ParticleManager:SetParticleControl(nPFX, 2, vPos)
				ParticleManager:SetParticleControl(nPFX, 3, Vector(self.nMinRange, 0, 0))
				ParticleManager:SetParticleControl(nPFX, 4, Vector(255, 0, 40))
				ParticleManager:SetParticleControl(nPFX, 7, v7thPos)

	self.tParticles[nNew] = nPFX

	if nNew >= self.nMaxPoints then
		return self:Release()
	end
end
function modifier_sukuna_b_q_recast:Release()
	local nPoints = #self.tPoints
	if nPoints < 2 then
		self.tPoints[nPoints + 1] = self._hParent:GetAbsOrigin()
	end

	for nPoint, vPoint in ipairs(self.tPoints) do
		local vPoint2 = self.tPoints[nPoint + 1]
		if vPoint2 then
			self:SlashPoints(vPoint, vPoint2)
		end
	end

	self.tPoints = {}

	for _, nPFX in ipairs(self.tParticles) do
		ParticleManager:DestroyParticle(nPFX, false)
		ParticleManager:ReleaseParticleIndex(nPFX)
	end
	self.tParticles = {}

	self:SetDuration(-1, true)
	self:SetStackCount(0)

	self._hAbility:UseResources(false, false, false, true)
end
function modifier_sukuna_b_q_recast:OnIntervalThink()
	if not IsServer() then return end

	if self:GetRemainingTime() <= 0 and self:GetDuration() > 0 then
		self:Release()
	end
end
function modifier_sukuna_b_q_recast:SlashPoints(vP1, vP2)
	local tDamage =
	{
		victim = nil,
		attacker = self._hParent,
		damage = self.nDamage,
		damage_type = self._hAbility:GetAbilityDamageType(),
		ability = self._hAbility
	}

	local nPreSlash = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_wcs_pointed/sukuna_wcs_pointed_pre_slash.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleShouldCheckFoW(nPreSlash, false)
						ParticleManager:SetParticleControl(nPreSlash, 0, vP1)
						ParticleManager:SetParticleControl(nPreSlash, 1, vP2)

	EmitSoundOnLocationWithCaster(vP1, "sukuna_wcs_point.preslash", self._hCaster)
	EmitSoundOnLocationWithCaster(vP2, "sukuna_wcs_point.preslash", self._hCaster)

	Timers:CreateTimer(self.nReleaseTime, function()
		local tUnits = FindUnitsInLine(
			self.nTEAM_ID,
			vP1,
			vP2,
			nil,
			self.nWidth,
			self.nABILITY_TARGET_TEAM,
			self.nABILITY_TARGET_TYPE,
			self.nABILITY_TARGET_FLAGS)

		for _, hEnt in ipairs(tUnits) do
			tDamage.victim = hEnt
			ApplyDamage(tDamage)
		end

		ParticleManager:DestroyParticle(nPreSlash, false)
		ParticleManager:ReleaseParticleIndex(nPreSlash)

		local nSlashPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_wcs_pointed/sukuna_wcs_pointed_slash/sukuna_wcs_pointed_slash.vpcf", PATTACH_WORLDORIGIN, nil)
							ParticleManager:SetParticleShouldCheckFoW(nSlashPFX, false)
							ParticleManager:SetParticleControl(nSlashPFX, 0, vP1)
							ParticleManager:SetParticleControl(nSlashPFX, 1, vP2)
							ParticleManager:SetParticleControl(nSlashPFX, 2, vP2)
							ParticleManager:ReleaseParticleIndex(nSlashPFX)

		EmitSoundOnLocationWithCaster(vP1, "sukuna_web.slash", self._hCaster)
		-- EmitSoundOn("sukuna_web.slash", self._hCaster)
		EmitSoundOnLocationWithCaster(vP2, "sukuna_web.slash", self._hCaster)
	end)
end



