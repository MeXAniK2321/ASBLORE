modifier_genkidama = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_genkidama:IsHidden()
	return false
end

function modifier_genkidama:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_genkidama:OnCreated( kv )
	if not IsServer() then return end
	self:GetParent():SetModel( "" )
	self:PlayEffects()

	-- check if stolen
	local spell_steal = self:GetCaster():FindAbilityByName("rubick_spell_steal_lua")
	local stolen = (self:GetAbility():IsStolen() and spell_steal)
	if stolen then
		self:GetParent():SetModelScale( 0.01 )
	end

end

function modifier_genkidama:OnRefresh( kv )
	
end

function modifier_genkidama:OnRemoved()
end

function modifier_genkidama:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_genkidama:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}

	return funcs
end

function modifier_genkidama:GetModifierBaseAttack_BonusDamage()
	if not IsServer() then return end

	-- update cp
	local target = self:GetParent():GetOrigin() + self:GetParent():GetForwardVector()
	local forward = self:GetParent():GetForwardVector()
	ParticleManager:SetParticleControl( self.effect_cast, 2, target )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_genkidama:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_genkidama:PlayEffects()
	if IsASBPatreon(self:GetCaster()) then
	self.particle_cast = "particles/supreme_genkidama.vpcf"
	else
	self.particle_cast = "particles/genkidama.vpcf"
	end

	-- Create Particle
	-- self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self.effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, self.particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		self.effect_cast,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end