require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

--====================================================================================================--
--====================================================================================================--
roland_mook = class(roland_card)

function roland_mook:OnCardDashImpact(hCaster, hTarget, vDir)
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
			ca_act_mod = "mook_cast_123",

			ca_stunnable = self:GetSpecialValueFor("ca_stunnable"),
			ca_time = self:GetSpecialValueFor("ca_time"),

			sa_act = ACT_DOTA_OVERRIDE_ABILITY_1,
			sa_act_mod = "mook_slash_123",

			sa_stunnable = self:GetSpecialValueFor("sa_stunnable"),
			sa_time = self:GetSpecialValueFor("sa_time"),

			count = self:GetSpecialValueFor("count"),

			radius = self:GetSpecialValueFor("radius"),

			damage = self:GetSpecialValueFor("damage"),
			damage_last = self:GetSpecialValueFor("damage_last"),

			sound_cast = "roland_mook.cast",
			sound_slashes = "roland_mook.slashes",
			sound_last = "roland_mook.slash_last",
		}
	}

	local p = tInfo.part_1

	p.ca_rate = GetAnimPlayRate(8, 8, 30, p.ca_time)

	p.sa_slash_rate = GetAnimPlayRate(
		14,
		14,
		30,
		p.sa_time / p.count
	)

	p.sa_impact_time = GetAnimImpactTime(
		14,
		14,
		30,
		p.sa_time / p.count
	)

	self:MookCast(tInfo)
end
function roland_mook:MookCast(tInfo)
	local p = tInfo.part_1

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

	self:SetInterruptAndFacing(hAnim, tInfo.target, p.ca_time, 300, p.ca_stunnable > 0)

	EmitSoundOn(p.sound_cast, tInfo.caster)

	hAnim:AddCallbackEnd(function(hMod)
		if hMod:IsInterrupted() then return end
		tInfo.dir = tInfo.caster:GetForwardVector()
		self:MookSlashes(tInfo)
	end)
end
function roland_mook:MookSlashes(tInfo)
	local p = tInfo.part_1
	local nCounted = 0

	local vPoint = tInfo.target:GetAbsOrigin() + tInfo.dir * p.radius * 0.5

	local vPointPFX = Vector(vPoint.x, vPoint.y, vPoint.z + p.radius * 0.5)

	EmitSoundOnLocationWithCaster(vPoint, p.sound_slashes, tInfo.caster)
	-- EmitSoundOn(p.sound_slashes, tInfo.caster)

	self:SlashPFX(tInfo.caster, Vector(0, 0, 128), 100, -1, Vector(90, 0, 30))

	local nPFX = self:CreateSlashesPFX(tInfo.caster, vPointPFX, p.radius)

	local tAnim =
	{
		duration = p.sa_time + p.sa_impact_time,
		pause = -1,
		pause_sync = 1,
		activity = p.sa_act,
		activities = json.encode({p.sa_act_mod}),
		rate = p.sa_slash_rate,
	}

	local hAnim = tInfo.caster:AddNewModifier(tInfo.caster, self, "modifier_roland_animation_generic", tAnim)
	if IsNull(hAnim) then return end


	hAnim:AddCallbackThink(FrameTime(),function(hMod)
		if p.sa_stunnable > 0 and tInfo.caster:IsStunned() then
			hMod:Destroy(true)
			return
		end
	end)

	local bHasTalent = HasTalent(tInfo.caster, "special_bonus_roland_10l")
	local nHeal = FindTalentValue(tInfo.caster, "special_bonus_roland_10l") * 0.01 * p.damage
	local nHealLast = FindTalentValue(tInfo.caster, "special_bonus_roland_10l") * 0.01 * p.damage_last

	hAnim:AddCallbackThink(0, function(hMod, _tTimer, nTime)
		if hMod:IsInterrupted() then return end
		if nCounted >= p.count then return end

		nCounted = nCounted + 1

		local tEntities = FindUnitsInRadius(
			tInfo.team_id,
			vPoint,
			nil,
			p.radius,
			tInfo.target_team,
			tInfo.target_type,
			tInfo.target_flags,
			FIND_CLOSEST,
			false
		)

		for _, hEnt in ipairs(tEntities) do
			if IsNotNull(hEnt) and hEnt ~= tInfo.caster then
				if nCounted == p.count then
					self:DoDamage({
						target = hEnt,
						caster = tInfo.caster,
						damage = p.damage_last
					})

					if bHasTalent then
						tInfo.caster:Heal(nHealLast, self)
					end
				else
					self:DoDamage({
						target = hEnt,
						caster = tInfo.caster,
						damage = p.damage
					})

					if bHasTalent then
						tInfo.caster:Heal(nHeal, self)
					end
				end
				self:CreateSlashSmallPFX(hEnt)
			end
		end

		return p.sa_impact_time
	end)

	hAnim:AddCallbackEnd(function(hMod)
		self:ReleasePFX(nPFX)
		EmitSoundOn(p.sound_last, tInfo.caster)

		if hMod:IsInterrupted() then return end

		self:TurnPlayNext(tInfo.caster, tInfo.target, GetDirection(tInfo.target, tInfo.caster))
	end)
end
function roland_mook:CreateSlashesPFX(hCaster, vPoint, nRadius)
	local vAttach = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_attack1")) + Vector(0, 0, -20)
	local vDir = GetDirection(vPoint, vAttach, true)

	local vStart = vAttach + vDir * -nRadius
	local vEnd = vAttach + vDir * nRadius * 2

	local nSlashPFX =	ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_big.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleShouldCheckFoW(nSlashPFX, false)
						ParticleManager:SetParticleControl(nSlashPFX, 0, vStart)
						ParticleManager:SetParticleControl(nSlashPFX, 2, vEnd)
						ParticleManager:ReleaseParticleIndex(nSlashPFX)

	local nFlashPFX =	ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_sheath_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
						ParticleManager:SetParticleControlEnt(
							nFlashPFX,
							0,
							hCaster,
							PATTACH_POINT_FOLLOW,
							"attach_attack1",
							Vector(0, 0, 0),
							true)
						ParticleManager:SetParticleControl(nFlashPFX, 1, Vector(nRadius, 0, 0))
						ParticleManager:ReleaseParticleIndex(nFlashPFX)

	local nSlashesPFX = ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slashes.vpcf", PATTACH_WORLDORIGIN, nil)
						ParticleManager:SetParticleShouldCheckFoW(nSlashesPFX, false)
						ParticleManager:SetParticleControl(nSlashesPFX, 0, vPoint)
						ParticleManager:SetParticleControl(nSlashesPFX, 1, Vector(nRadius, nRadius, nRadius))

	return nSlashesPFX
end
function roland_mook:ReleasePFX(nPFX)
	ParticleManager:DestroyParticle(nPFX, false)
	ParticleManager:ReleaseParticleIndex(nPFX)
end
function roland_mook:CreateSlashSmallPFX(hTarget)
	local vPoint = hTarget:GetAbsOrigin() + RandomVector(30)
	local nSlashPFX =	ParticleManager:CreateParticle("particles/heroes/roland/roland_mook/roland_mook_slash_small.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
						ParticleManager:SetParticleControl(nSlashPFX, 0, vPoint + Vector(0, 0, 100))
						ParticleManager:SetParticleControl(nSlashPFX, 2, vPoint + Vector(0, 0, -100))
						ParticleManager:ReleaseParticleIndex(nSlashPFX)
end
--====================================================================================================--
--====================================================================================================--
roland_mook_ex = class(roland_mook)


require("heroes/roland/roland_init")
require("heroes/roland/roland_card")

