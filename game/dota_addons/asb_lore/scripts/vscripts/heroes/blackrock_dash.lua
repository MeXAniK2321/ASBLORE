blackrock_dash = class({})
LinkLuaModifier("modifier_kirito_ggo_dash", "heroes/blackrock_dash", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blackrock_dash", "heroes/blackrock_dash", LUA_MODIFIER_MOTION_NONE)

function blackrock_dash:IsStealable() return true end
function blackrock_dash:IsHiddenWhenStolen() return false end
function blackrock_dash:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function blackrock_dash:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_kirito_ggo_dash", {})
end
---------------------------------------------------------------------------------------------------------------------
modifier_kirito_ggo_dash = class({})
function modifier_kirito_ggo_dash:IsHidden() return true end
function modifier_kirito_ggo_dash:IsDebuff() return false end
function modifier_kirito_ggo_dash:IsPurgable() return false end
function modifier_kirito_ggo_dash:IsPurgeException() return false end
function modifier_kirito_ggo_dash:RemoveOnDeath() return true end
function modifier_kirito_ggo_dash:GetMotionControllerPriority() 
	return DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM 
end
function modifier_kirito_ggo_dash:CheckState()
	if IsServer() then
		if self:GetParent() then
			state = {	[MODIFIER_STATE_STUNNED] = true,
						[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
						[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
						[MODIFIER_STATE_INVULNERABLE] = true,
						[MODIFIER_STATE_NO_HEALTH_BAR] = true,
						[MODIFIER_STATE_NOT_ON_MINIMAP] = true,}
		else
			state = {	[MODIFIER_STATE_STUNNED] = true,
						[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
						[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
		end
		return state
	end
end
function modifier_kirito_ggo_dash:OnIntervalThink()
	if IsServer() then
		self:HorizontalMotion(self:GetParent(), self.interval)
	end
end
function modifier_kirito_ggo_dash:HorizontalMotion(unit, time)
	if IsServer() then
		self.time = self.time + time
		if self.time < self.dash_time then
			local location = unit:GetAbsOrigin() + self.direction * self.speed * time
			unit:SetAbsOrigin(location)
			--FindClearSpaceForUnit(unit, location, true)        
		else
			unit:AddNewModifier(unit, self:GetAbility(), "modifier_blackrock_dash", {})
			self:Destroy()
		end
	end 
end
function modifier_kirito_ggo_dash:OnCreated()
	if IsServer() then
		self.time = 0
		self.speed = self:GetAbility():GetSpecialValueFor("speed")
		self.point = self:GetAbility():GetCursorPosition()
		self.distance = (self:GetParent():GetAbsOrigin() - self.point):Length2D()
		self.dash_time = self.distance/self.speed
		self.direction = (self.point - self:GetParent():GetAbsOrigin()):Normalized()

		self.interval = FrameTime()
		self:StartIntervalThink(self.interval)
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_blackrock_dash = class({})
function modifier_blackrock_dash:IsHidden() return true end
function modifier_blackrock_dash:IsDebuff() return false end
function modifier_blackrock_dash:IsPurgable() return false end
function modifier_blackrock_dash:IsPurgeException() return false end
function modifier_blackrock_dash:RemoveOnDeath() return true end
function modifier_blackrock_dash:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_OVERRIDE_ANIMATION,}
	return func
end
function modifier_blackrock_dash:CheckState()
	local state = {	[MODIFIER_STATE_STUNNED] = true,}
	return state
end
function modifier_blackrock_dash:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_5
end
function modifier_blackrock_dash:OnCreated()
	if IsServer() then
		self.attacks = self:GetAbility():GetSpecialValueFor("attacks")
		self.distance = self:GetAbility():GetSpecialValueFor("distance")
		self.interval = self:GetAbility():GetSpecialValueFor("interval")
		self.width = self:GetAbility():GetSpecialValueFor("width")

		self.i = 0

		self:StartIntervalThink(self.interval)
	end
end
function modifier_blackrock_dash:OnIntervalThink()
	if IsServer() then
		self.i = self.i + 1
		if self.i >= self.attacks then
			self:Destroy()
		end
		
		EmitSoundOn("blackrock.katana", self:GetParent())

		local particle =   	ParticleManager:CreateParticle("particles/brs_dash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			            	ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())

		local enemies = FindUnitsInLine(self:GetParent():GetTeamNumber(),
										self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 150,
										self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * self.distance,
										nil,
										self.width,
										self:GetAbility():GetAbilityTargetTeam(),
										self:GetAbility():GetAbilityTargetType(),
										self:GetAbility():GetAbilityTargetFlags() )

		for _,enemy in pairs(enemies) do
			if not enemy:IsAttackImmune() then
				local damage_table = {	victim = enemy,
										attacker = self:GetParent(),
										damage = self:GetAbility():GetSpecialValueFor("damage")+self:GetCaster():FindTalentValue("special_bonus_brs_20"),
										damage_type = self:GetAbility():GetAbilityDamageType(),
										ability = self:GetAbility() }	

				if self.i <= self.attacks - 1 then
					

					damage_table.damage = damage_table.damage * (self.attacks - 1)
				end

				ApplyDamage(damage_table)

				
			end
		end
	end
end