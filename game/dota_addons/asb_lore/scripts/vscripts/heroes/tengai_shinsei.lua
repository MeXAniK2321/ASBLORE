tengai_shinsei = class({})
LinkLuaModifier( "modifier_tengai_shinsei", "heroes/tengai_shinsei", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_tengai_shinsei_land", "heroes/tengai_shinsei", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function tengai_shinsei:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Start
function tengai_shinsei:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 1.5

	-- load data
	local delay = self:GetSpecialValueFor("delay")
if caster:HasScepter() and caster:HasModifier("modifier_tengai_shinsei_land") then
CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_tengai_shinsei", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	EmitGlobalSound("Tengai.Shinsei_second")
else


	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_tengai_shinsei", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	
	if  caster:HasScepter() then
	caster:AddNewModifier(self:GetCaster(), self, "modifier_tengai_shinsei_land", {duration = 2.0})
	EmitGlobalSound("Tengai.Shinsei")
	self:EndCooldown()
	else
	EmitGlobalSound("Tengai.Shinsei")
	end
	end
	end


modifier_tengai_shinsei = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tengai_shinsei:IsHidden()
	return true
end

function modifier_tengai_shinsei:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tengai_shinsei:OnCreated( kv )
	if not IsServer() then return end

	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if  self:GetCaster():HasScepter() then
	self.damage = 1300
	else
	self.damage = self:GetAbility():GetAbilityDamage()
	end

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
		--Optional.
	}
	self:PlayEffects1()
end 
function modifier_tengai_shinsei:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/tengai_shinsei_fly.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = 1.0

	-- Get Data
	local height = 1500
	local height_target = -0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end

function modifier_tengai_shinsei:OnRefresh( kv )
	
end

function modifier_tengai_shinsei:OnRemoved()
end

function modifier_tengai_shinsei:OnDestroy()
	if not IsServer() then return end
	local origin = self:GetParent():GetOrigin()
	local caster = self:GetCaster()

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
		-- stun
		

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	self:PlayEffects()
	

	UTIL_Remove( self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_tengai_shinsei:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/tengai_shinsei_crate.vpcf"
	local sound_cast = "Tengai.Shinsei_land"

	-- -- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end

modifier_tengai_shinsei_land = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tengai_shinsei_land:IsHidden()
	return false
end

function modifier_tengai_shinsei_land:IsDebuff()
	return false
end

function modifier_tengai_shinsei_land:IsStunDebuff()
	return false
end

function modifier_tengai_shinsei_land:IsPurgable()
	return false
end

function modifier_tengai_shinsei_land:OnDestroy()
self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(-1) * self:GetParent():GetCooldownReduction())
end