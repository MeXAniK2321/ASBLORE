item_deltarune_missile = class({})

function item_deltarune_missile:Precache(context)
	PrecacheResource("model", "models/items/units/deltarune_missile/deltarune_missile.vmdl", context)
	if not IsServer() then return end
	PrecacheUnitByNameSync("npc_dota_deltarune_missile", context, -1)
end
function item_deltarune_missile:GetManaCost(nLevel)
	return self:GetCaster():GetMaxMana() - 1
end
function item_deltarune_missile:IsRefreshable()				return false end
function item_deltarune_missile:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	if IsServer() then
		hCaster:EmitSound("Hero_Gyrocopter.Rocket_Barrage.A Launch")
	end
	return true
end
function item_deltarune_missile:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	local vTargetPos = hTarget:GetAbsOrigin() + hCaster:GetForwardVector()

	-- local vDir = GetDirection(vTargetPos, hCaster, false)
	local vDir = (vTargetPos - hCaster:GetAbsOrigin()):Normalized()

	local vSpawnPos = hCaster:GetAbsOrigin() + vDir * 150

	local hMissile = CreateUnitByName(
		"npc_dota_deltarune_missile",
		vSpawnPos,
		false,
		hCaster,
		hCaster,
		hCaster:GetTeamNumber()
	)

	if not IsNotNull(hMissile) then return end

	hMissile:SetForwardVector(vDir)

	-- hMissile:AddNewModifier(hCaster, self, "modifier_item_deltarune_missile_pips", {pips = 3})

	hMissile:AddNewModifier(hCaster, self, "modifier_item_deltarune_missile_launch",
	{
		duration = self:GetSpecialValueFor("launch_delay"),
		target = hTarget:entindex(),
	})

	hCaster:EmitSound("Hero_Gyrocopter.HomingMissile")

	self:SpendCharge(1200)
end

--============================================================--
LinkLuaModifier("modifier_item_deltarune_missile_pips", "items/item_deltarune_missile", LUA_MODIFIER_MOTION_NONE)

modifier_item_deltarune_missile_pips = class({})

function modifier_item_deltarune_missile_pips:IsHidden()			return true end
function modifier_item_deltarune_missile_pips:IsPurgable()			return false end
function modifier_item_deltarune_missile_pips:DeclareFunctions()
	local t =
	{
		MODIFIER_PROPERTY_HEALTHBAR_PIPS,
		MODIFIER_PROPERTY_DISABLE_HEALING,
	}
	return t
end
function modifier_item_deltarune_missile_pips:GetModifierHealthBarPips(keys)
	return self:GetStackCount()
end
function modifier_item_deltarune_missile_pips:GetDisableHealing(keys)
	return 1
end
function modifier_item_deltarune_missile_pips:OnCreated(tInfo)
	self.hCaster = self:GetCaster()
	self.hParent = self:GetParent()
	self.hAbility = self:GetAbility()

	if not IsServer() then return end
end

--============================================================--
LinkLuaModifier("modifier_item_deltarune_missile_target", "items/item_deltarune_missile", LUA_MODIFIER_MOTION_NONE)

modifier_item_deltarune_missile_target = class({})

function modifier_item_deltarune_missile_target:IsHidden()			return true end
function modifier_item_deltarune_missile_target:IsPurgable()		return false end
function modifier_item_deltarune_missile_target:OnCreated(tInfo)
	self.hCaster = self:GetCaster()
	self.hParent = self:GetParent()
	self.hAbility = self:GetAbility()

	if not IsServer() then return end

	local nFX_Target = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self.hParent)

	self:AddParticle(nFX_Target, false, false, -1, false, false)
end
function modifier_item_deltarune_missile_target:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_item_deltarune_missile_target:OnDestroy()
end

--============================================================--
LinkLuaModifier("modifier_item_deltarune_missile_launch", "items/item_deltarune_missile", LUA_MODIFIER_MOTION_NONE)

modifier_item_deltarune_missile_launch = class({})

function modifier_item_deltarune_missile_launch:IsHidden()			return true end
function modifier_item_deltarune_missile_launch:IsPurgable()		return false end
function modifier_item_deltarune_missile_launch:CheckState()
	local t =
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		-- [MODIFIER_STATE_NO_HEALTH_BAR] = true,
		-- [MODIFIER_STATE_INVULNERABLE] = true,
		-- [MODIFIER_STATE_UNSELECTABLE] = true,
	}
	return t
end
function modifier_item_deltarune_missile_launch:OnCreated(tInfo)
	self.hCaster = self:GetCaster()
	self.hParent = self:GetParent()
	self.hAbility = self:GetAbility()

	if not IsServer() then return end

	self.nTarget = tInfo.target or -1
	self.hTarget = EntIndexToHScript(self.nTarget)

	self.hTargetBuff = self.hTarget:AddNewModifier(self.hParent, self, "modifier_item_deltarune_missile_target", {})

	local nFX_Target = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self.hTarget)

	self:AddParticle(nFX_Target, false, false, -1, false, false)

	local nFX = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_homing_missile_fuse.vpcf", PATTACH_POINT_FOLLOW, self.hParent)
				ParticleManager:SetParticleControlEnt(
					nFX,
					0,
					self.hParent,
					PATTACH_POINT_FOLLOW,
					"attach_foot",
					Vector(0,0,0),
					true
				)
				-- ParticleManager:SetParticleControlForward(nFX, 0, self.hParent:GetForwardVector())

	self:AddParticle(nFX, false, false, -1, false, false)

	self.hParent:EmitSound("Hero_Gyrocopter.HomingMissile.Launch")
end
function modifier_item_deltarune_missile_launch:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_item_deltarune_missile_launch:OnDestroy()
	if not IsServer() then return end
	if not IsNotNull(self.hParent) or not self.hParent:IsAlive() then
		if IsNotNull(self.hTargetBuff) then
			self.hTargetBuff:Destroy()
		end
		return
	end

	self.hParent:AddNewModifier(self.hCaster, self.hAbility, "modifier_item_deltarune_missile_flight",
	{
		duration = 60,
		target = self.nTarget,
		target_buff = self.hTargetBuff:GetSerialNumber(),
	})
end


--============================================================--
LinkLuaModifier("modifier_item_deltarune_missile_flight", "items/item_deltarune_missile", LUA_MODIFIER_MOTION_HORIZONTAL)

modifier_item_deltarune_missile_flight = class({})

function modifier_item_deltarune_missile_flight:IsHidden()				return true end
function modifier_item_deltarune_missile_flight:IsPurgable()			return false end
function modifier_item_deltarune_missile_flight:CheckState()
	local t =
	{
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
	return t
end
function modifier_item_deltarune_missile_flight:DeclareFunctions()
	local t =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return t
end
function modifier_item_deltarune_missile_flight:GetOverrideAnimation()
	return ACT_DOTA_RUN
end
function modifier_item_deltarune_missile_flight:OnCreated(tInfo)
	self.hCaster = self:GetCaster()
	self.hParent = self:GetParent()
	self.hAbility = self:GetAbility()

	if not IsServer() then return end

	self.nTeamID = self.hParent:GetTeamNumber()

	self.nDamageType = self.hAbility:GetAbilityDamageType()

	self.hTarget = EntIndexToHScript(tInfo.target)

	if not IsNotNull(self.hTarget) then
		self:Destroy()
		return
	end

	self.hTargetBuff = nil
	for _, hModifier in ipairs(self.hTarget:FindAllModifiersByName("modifier_item_deltarune_missile_target")) do
		if hModifier:GetSerialNumber() == tInfo.target_buff then
			self.hTargetBuff = hModifier
			break
		end
	end

	self.nDamage = self.hAbility:GetSpecialValueFor("damage")
	self.nStunDuration = self.hAbility:GetSpecialValueFor("stun_duration")
	self.nMaxSpeed = self.hAbility:GetSpecialValueFor("max_speed")
	self.nAccelTime = self.hAbility:GetSpecialValueFor("accel_time")

	self.fCurrentSpeed = 200
	self.fElapsed = 0

	self.hParent:EmitSound("Hero_Gyrocopter.HomingMissile.Loop")

	local nFX = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile.vpcf", PATTACH_POINT_FOLLOW, self.hParent)
				ParticleManager:SetParticleControlEnt(
					nFX,
					0,
					self.hParent,
					PATTACH_POINT_FOLLOW,
					"attach_foot",
					Vector(0,0,0),
					true
				)

	self:AddParticle(nFX, false, false, -1, false, false)

	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end
end
function modifier_item_deltarune_missile_flight:OnRefresh(tInfo)
	self:OnCreated(tInfo)
end
function modifier_item_deltarune_missile_flight:UpdateHorizontalMotion(me, dt)
	if not IsNotNull(self.hParent) then return end

	if not IsNotNull(self.hTarget) or not self.hTarget:IsAlive() then
		self:Explode(self.hParent:GetAbsOrigin())
		return
	end

	self.fElapsed = self.fElapsed + dt
	local t = math.min(self.fElapsed / self.nAccelTime, 1.0)
	self.fCurrentSpeed = 200 + (self.nMaxSpeed - 200) * t

	local vPos = self.hParent:GetAbsOrigin()
	local vTarget = self.hTarget:GetAbsOrigin()
	local vDir = (vTarget - vPos):Normalized()
	local vNewPos = vPos + vDir * self.fCurrentSpeed * dt

	self.hParent:SetForwardVector(vDir, true)

	local nDist = (vTarget - vNewPos):Length2D()
	if nDist < 100 then
		self:OnHit(self.hTarget, vNewPos)
		return
	end

	if nDist > 2500 then
		self:Explode(vNewPos)
		return
	end

	self.hParent:SetAbsOrigin(vNewPos)

	AddFOWViewer(self.nTeamID, vNewPos, 400, 0.1, false)
end
function modifier_item_deltarune_missile_flight:OnHorizontalMotionInterrupted()
	self:Destroy()
end
function modifier_item_deltarune_missile_flight:OnHit(hTarget, vPos)
	ApplyDamage({
		victim = hTarget,
		attacker = self.hCaster,
		ability = self.hAbility,
		damage = self.nDamage * hTarget:GetMaxHealth() * 0.01,
		damage_type = self.nDamageType,
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL,
	})

	hTarget:AddNewModifier(self.hCaster, self.hAbility, "modifier_stunned",
	{
		duration = self.nStunDuration,
	})

	hTarget:EmitSound("Hero_Gyrocopter.HomingMissile.Impact")

	AddFOWViewer(self.nTeamID, vPos, 400, 4, false)

	self:Explode(vPos)
end
function modifier_item_deltarune_missile_flight:Explode(vPos)
	local nFX = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
				ParticleManager:SetParticleControl(nFX, 0, vPos)
				ParticleManager:ReleaseParticleIndex(nFX)

	self:Destroy()
end
function modifier_item_deltarune_missile_flight:OnDestroy()
	if not IsServer() or not IsNotNull(self.hParent) then return end

	self.hParent:InterruptMotionControllers(true)

	if IsNotNull(self.hTargetBuff) then
		self.hTargetBuff:Destroy()
	end

	self.hParent:StopSound("Hero_Gyrocopter.HomingMissile.Loop")
	self.hParent:AddNoDraw()
	self.hParent:ForceKill(false)
end