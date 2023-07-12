pangolier_shield_crash_lua = class({})
LinkLuaModifier( "modifier_pangolier_shield_crash_lua", "heroes/bogdan/pangolier_shield_crash_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua", "modifiers/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )

function pangolier_shield_crash_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
		local scale =self:GetSpecialValueFor( "int_scale" )
	local int = caster:GetIntellect() * scale
	local damage = self:GetSpecialValueFor( "damage" ) + int
	local radius = self:GetSpecialValueFor( "radius" )
	local point = self:GetCursorPosition()
local point2 = self:GetCaster():GetOrigin()
local distance = (point2 - point):Length2D()
	local duration = self:GetSpecialValueFor( "jump_duration" )
	local height = self:GetSpecialValueFor( "jump_height" )
	local buff_duration = self:GetSpecialValueFor( "duration" )

	-- arc
	local arc = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			distance = distance,
			duration = duration,
			height = height,
			fix_duration = false,
			isForward = true,
			isStun = true,
			activity = ACT_DOTA_CAST_ABILITY_3,
		} -- kv
	)
	arc:SetEndCallback(function()
		-- find enemies
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		-- precache damage
		local damageTable = {
			-- victim = target,
			attacker = caster,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}

		local stack = 0
		for _,enemy in pairs(enemies) do
			-- damage
			damageTable.victim = enemy
			ApplyDamage(damageTable)
if caster:HasTalent("special_bonus_bogdan_25") then
enemy:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_stunned",
		{duration = 1.0}
	)
end
			-- count stack
			if enemy:IsHero() and not enemy:IsIllusion() then
				stack = stack + 1
			end

			-- play effects
			self:PlayEffects4( enemy )
		end

		-- add buff
		if stack>0 then
			
		end

		-- play effects
		self:PlayEffects2()
		if stack>0 then
			self:PlayEffects3()
		end
	end)

	-- play effects
	self:PlayEffects1( arc )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function pangolier_shield_crash_lua:PlayEffects1( modifier )
	-- Get Resources
	
	local caster = self:GetCaster()
if IsASBPatreon(caster) then
	local particle_cast = "particles/hurk_tail.vpcf"
	local sound_cast = "hurk.gachi_jump"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

	-- buff particle
	modifier:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	else
	local particle_cast = "particles/pangolier_tailthump_cast1.vpcf"
	local sound_cast = "bogdan.jump"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )

	-- buff particle
	modifier:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
end

function pangolier_shield_crash_lua:PlayEffects2()
	-- Get Resources
	local caster = self:GetCaster()
if IsASBPatreon(caster) then
	local particle_cast = "particles/hurk_landing.vpcf"
	local sound_cast = "hurk.gachi_jump_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	else
	local particle_cast = "particles/pangolier_ti8_immortal_shield_crash1.vpcf"
	local sound_cast = "bogdan.gasm"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	end
end

function pangolier_shield_crash_lua:PlayEffects3()
	-- Get Resources
	local particle_cast = "particles/econ/items/pangolier/pangolier_ti8_immortal/pangolier_ti8_immortal_shield_crash.vpcf"
	local sound_cast = "Hero_Pangolier.TailThump.Shield"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function pangolier_shield_crash_lua:PlayEffects3()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_hero.vpcf"
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function pangolier_shield_crash_lua:PlayEffects4( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_shield_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
















modifier_pangolier_shield_crash_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_pangolier_shield_crash_lua:IsHidden()
	return false
end

function modifier_pangolier_shield_crash_lua:IsDebuff()
	return false
end

function modifier_pangolier_shield_crash_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_pangolier_shield_crash_lua:OnCreated( kv )
	-- references
	local stack_pct = self:GetAbility():GetSpecialValueFor( "hero_stacks" )

	if not IsServer() then return end

	-- calculate buff
	self.reduction = kv.stack * stack_pct
	self:SetStackCount( self.reduction )

	-- play effects
	self:PlayEffects()
end

function modifier_pangolier_shield_crash_lua:OnRefresh( kv )
	-- references
	local stack_pct = self:GetAbility():GetSpecialValueFor( "hero_stacks" )

	if not IsServer() then return end

	-- get stronger value
	local reduction = kv.stack * stack_pct
	if self.reduction<reduction then
		self.reduction = reduction
		self:PlayEffects()
	end

	self:SetStackCount( self.reduction )
end

function modifier_pangolier_shield_crash_lua:OnRemoved()
end

function modifier_pangolier_shield_crash_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_pangolier_shield_crash_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_pangolier_shield_crash_lua:OnAttack( params )

end

function modifier_pangolier_shield_crash_lua:GetModifierIncomingDamage_Percentage()
	return -self.reduction
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_pangolier_shield_crash_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_pangolier_shield.vpcf"
end

function modifier_pangolier_shield_crash_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_pangolier_shield_crash_lua:PlayEffects()
	-- destroy previous
	if self.effect_cast then
		ParticleManager:DestroyParticle( self.effect_cast, false )
	end

	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf"
	-- local sound_cast = "string"

	-- Get Data
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( self.reduction, 0, 0 ) )


	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	
	self.effect_cast = effect_cast
end