bookmaker = class({})
LinkLuaModifier( "modifier_bookmaker", "modifiers/modifier_bookmaker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_root", "modifiers/modifier_root", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_throw_screw", "modifiers/modifier_throw_screw", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function bookmaker:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	local projectile_name = "particles/kumagawa_bookmaker_screw.vpcf"
	local projectile_speed = self:GetSpecialValueFor("dagger_speed")
	local projectile_vision = 450

	-- Create Projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bReplaceExisting = false,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,				-- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	self:PlayEffects1()
	
end

function bookmaker:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if not target then return end

	self:Hit( target, true )
	
	

	

	self:PlayEffects2( hTarget )
end
function bookmaker:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) 
    local duration = self:GetSpecialValueFor( "duration" ) 
	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	caster:PerformAttack(
				target,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
	target:AddNewModifier(caster, self, "modifier_bookmaker", {duration = 10})
	target:AddNewModifier(caster, self, "modifier_throw_screw", {duration = 1})
	
end

--------------------------------------------------------------------------------
function bookmaker:PlayEffects1()
	-- Get Resources
	local sound_cast = "kumagawa.7"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
	local sound_cast2 = "kumagawa.6_1"

	-- Create Sound
	EmitSoundOn( sound_cast2, self:GetCaster() )
end

function bookmaker:PlayEffects2( target )
	-- Get Resources
	local sound_target = "kumagawa.1_1"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end