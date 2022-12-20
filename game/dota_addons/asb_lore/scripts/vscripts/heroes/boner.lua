boner = class({})
LinkLuaModifier( "modifier_orange_boner", "heroes/boner", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blue_boner", "heroes/boner", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blue_bones", "heroes/boner.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boner_check", "heroes/boner.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function boner:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function boner:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_blue_bones") then
		return "sans_3_1"
	end
	return "sans_3_2"
end
function boner:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = target:GetOrigin()
	local duration  = 1.5

	-- load data
	local delay = self:GetSpecialValueFor("duration")


if caster:HasModifier("modifier_blue_bones") then
CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_blue_boner", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
		self:PlayEffects()
else
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_orange_boner", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
		self:PlayEffects()
	end
	end

	

function boner:PlayEffects()
local caster = self:GetCaster()
	local point = caster:GetOrigin()
	local sound_cast = "Sans.Boner"

	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end





modifier_blue_bones = class({})


function modifier_blue_bones:IsHidden()
    return false
end
function modifier_blue_bones:RemoveOnDeath() 
return false 
end
function modifier_blue_bones:IsPurgable()
    return false
end





modifier_blue_boner = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_blue_boner:IsHidden()
	return false
end

function modifier_blue_boner:IsDebuff()
	return true
end

function modifier_blue_boner:IsStunDebuff()
	return false
end

function modifier_blue_boner:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_blue_boner:OnCreated( kv )
	-- references
	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" ) * 2
	self.armor = self:GetAbility():GetSpecialValueFor( "root" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end

	-- precache damage
	self.damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	self:StartIntervalThink( interval )

	self:PlayEffects()
end

function modifier_blue_boner:OnRefresh( kv )
	
end

function modifier_blue_boner:OnRemoved()
end

function modifier_blue_boner:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end


function modifier_blue_boner:OnIntervalThink()
	-- find enemies 
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		if enemy:IsMoving() or enemy:HasModifier("modifier_knockback") then
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		end
	end
end

function modifier_blue_boner:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/blue_boner.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound

end


modifier_orange_boner = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_orange_boner:IsHidden()
	return false
end

function modifier_orange_boner:IsDebuff()
	return true
end

function modifier_orange_boner:IsStunDebuff()
	return false
end

function modifier_orange_boner:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_orange_boner:OnCreated( kv )
	-- references
	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.armor = self:GetAbility():GetSpecialValueFor( "root" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end

	-- precache damage
	self.damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}

	self:StartIntervalThink( interval )

	self:PlayEffects()
end

function modifier_orange_boner:OnRefresh( kv )
	
end

function modifier_orange_boner:OnRemoved()
end

function modifier_orange_boner:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end


function modifier_orange_boner:OnIntervalThink()
	-- find enemies 
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		if not enemy:IsMoving() then
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		end
	end
end

function modifier_orange_boner:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/orange_boner.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound

end
