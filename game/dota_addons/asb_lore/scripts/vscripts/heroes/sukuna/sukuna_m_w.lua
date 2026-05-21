require("heroes/sukuna/sukuna_init")

--====================================================================================================--
--====================================================================================================--
sukuna_m_w = class({})

function sukuna_m_w:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sukuna_m_w:GetPlaybackRateOverride()
	return GetAnimPlayRate(20, 10, 30, self:GetCastPoint())
end
function sukuna_m_w:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sukuna_animation_generic_activity", {duration = 0.1, activity = "mage"})
	return true
end
function sukuna_m_w:OnAbilityPhaseInterrupted()
	local hCaster = self:GetCaster()
end
function sukuna_m_w:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPoint = self:GetCursorPosition()

	local tInfo =
	{
		point = vPoint,
		caster = hCaster,

		team_id = hCaster:GetTeamNumber(),
		target_team = self:GetAbilityTargetTeam(),
		target_type = self:GetAbilityTargetType(),
		target_flags = self:GetAbilityTargetFlags(),

		radius = self:GetAOERadius(),

		hits = self:GetSpecialValueFor("hits"),
		hits_tick = self:GetSpecialValueFor('hits_tick'),

		damage = self:GetSpecialValueFor("damage"),

		slow_ms_pct = self:GetSpecialValueFor("slow_ms_pct"),
		slow_duration = self:GetSpecialValueFor("slow_duration"),
		silence_duration = self:GetSpecialValueFor("silence_duration"),
	}

	local nSlashesPFX = ParticleManager:CreateParticle("particles/heroes/sukuna/sukuna_slashes_aoe/sukuna_slashes_aoe.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleShouldCheckFoW(nSlashesPFX, false)
						ParticleManager:SetParticleControl(nSlashesPFX, 0, tInfo.point)
						ParticleManager:SetParticleControl(nSlashesPFX, 1, Vector(tInfo.radius, tInfo.radius, tInfo.radius))

	local nHits = 0
	Timers:CreateTimer(0, function()
		if nHits >= tInfo.hits then
			ParticleManager:DestroyParticle(nSlashesPFX, false)
			ParticleManager:ReleaseParticleIndex(nSlashesPFX)
			return
		end

		nHits = nHits + 1

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
				self:SlashTarget({
					target = hEnt,
					caster = tInfo.caster,
					damage = tInfo.damage
				})		

				hEnt:AddNewModifier(tInfo.caster, self, "modifier_sukuna_m_w_slow_ms", {duration = tInfo.slow_duration})
				hEnt:AddNewModifier(tInfo.caster, self, "modifier_silence", {duration = tInfo.silence_duration})
			end
		end

		EmitSoundOnLocationWithCaster(tInfo.point, "sukuna_slashes_aoe.slash", tInfo.caster)

		return tInfo.hits_tick
	end)


end
function sukuna_m_w:SlashTarget(tInfo)
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
LinkLuaModifier("modifier_sukuna_m_w_slow_ms", "heroes/sukuna/sukuna_m_w", LUA_MODIFIER_MOTION_NONE)

modifier_sukuna_m_w_slow_ms = class({})

function modifier_sukuna_m_w_slow_ms:IsHidden()										return false end
function modifier_sukuna_m_w_slow_ms:IsDebuff()										return true end
function modifier_sukuna_m_w_slow_ms:IsPurgable()									return true end
function modifier_sukuna_m_w_slow_ms:IsPurgeException()								return true end
function modifier_sukuna_m_w_slow_ms:RemoveOnDeath()								return true end
function modifier_sukuna_m_w_slow_ms:GetAttributes()								return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_sukuna_m_w_slow_ms:GetPriority()									return MODIFIER_PRIORITY_NORMAL end
function modifier_sukuna_m_w_slow_ms:DeclareFunctions()
	local t = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return t
end
function modifier_sukuna_m_w_slow_ms:GetModifierMoveSpeedBonus_Percentage(keys)
	return self:GetAbility():GetSpecialValueFor("slow_ms_pct")
end