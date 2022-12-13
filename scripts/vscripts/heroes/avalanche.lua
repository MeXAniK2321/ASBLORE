LinkLuaModifier("modifier_gon_avalanche", "heroes/anime_hero_gon", LUA_MODIFIER_MOTION_NONE)

gon_avalanche = class({})

function gon_avalanche:IsStealable() return true end
function gon_avalanche:IsHiddenWhenStolen() return false end
function gon_avalanche:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function gon_avalanche:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration") + caster:FindTalentValue("special_bonus_anime_gon_10L")

	local thinker = CreateModifierThinker(caster, self, "modifier_gon_avalanche", {duration = duration}, point, caster:GetTeamNumber(), false)

	EmitSoundOn("Gon.Avalanche.Cast.1", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_gon_avalanche = class({})
function modifier_gon_avalanche:IsHidden() return false end
function modifier_gon_avalanche:IsDebuff() return false end
function modifier_gon_avalanche:IsPurgable() return true end
function modifier_gon_avalanche:IsPurgeException() return true end
function modifier_gon_avalanche:RemoveOnDeath() return true end
function modifier_gon_avalanche:CheckState()
	local state = {	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
	return state
end
function modifier_gon_avalanche:OnCreated(hTable)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.radius = self.ability:GetAOERadius() * 0.8
	self.duration = self:GetDuration()
	self.stun_interval = self.ability:GetSpecialValueFor("stun_interval")
	self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")

	self.total_damage = self.ability:GetSpecialValueFor("total_damage") + self.caster:FindTalentValue("special_bonus_anime_gon_15L")
		self.total_damage = self.total_damage + (self.total_damage * (self.caster:GetModifierStackCount("modifier_gon_jankenpon", self.caster) or 0) * 0.01)
		print(self.total_damage)
	self.damage = (self.total_damage / (self.duration / self.stun_interval)) or 1

	if IsServer() then
		self.parent:SetForwardVector(self.caster:GetForwardVector())

		self.avalanche_fx = ParticleManager:CreateParticle("particles/heroes/anime_hero_gon/gon_avalanche.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
							ParticleManager:SetParticleControl(self.avalanche_fx, 0, self.parent:GetAbsOrigin())
							ParticleManager:SetParticleControl(self.avalanche_fx, 1, Vector(self.radius, self.radius, self.radius))
							--ParticleManager:SetParticleControl(self.avalanche_fx, 60, Vector(0,0,0))
							--ParticleManager:SetParticleControl(self.avalanche_fx, 61, Vector(0,0,0))

		self:AddParticle(self.avalanche_fx, false, false, -1, false, false)

		self:StartIntervalThink(self.stun_interval)
	end
end
function modifier_gon_avalanche:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_gon_avalanche:OnDestroy()
	if IsServer() then
		local modifier = self.caster:FindModifierByNameAndCaster("modifier_gon_jankenpon", self.caster)
		if modifier and not modifier:IsNull() then
			modifier:Destroy()
		end
	end
end
function modifier_gon_avalanche:OnIntervalThink()
	if IsServer() then
	    local enemies = FindUnitsInRadius(  self.caster:GetTeamNumber(),
	                                        self.parent:GetAbsOrigin(),
	                                        nil,
	                                        self.radius,
	                                        self.ability:GetAbilityTargetTeam(),
	                                        self.ability:GetAbilityTargetType(),
	                                        self.ability:GetAbilityTargetFlags(),
	                                        FIND_ANY_ORDER,
	                                        false)
	    for _, enemy in pairs(enemies) do
	    	enemy:AddNewModifier(self.caster, self.ability, "modifier_stunned", {duration = self.stun_duration})

	        local damage_table = {  victim = enemy,
	                                attacker = self.caster,
	                                damage = self.damage,
	                                damage_type = self.ability:GetAbilityDamageType(),
	                                ability = self }

	        ApplyDamage(damage_table)

	        EmitSoundOn("Gon.Avalanche.Impact.1", enemy)
	    end
	end
end