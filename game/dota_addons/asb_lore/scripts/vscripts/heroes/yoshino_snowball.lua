yoshino_snowball = class({})
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Ability Start
function yoshino_snowball:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	local projectile_name = "particles/econ/events/snowball/snowball_projectile.vpcf"
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

function yoshino_snowball:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if not target then return end

	self:Hit( target, true )
	
	

	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_generic_slow",
		{duration = self:GetDuration()}
	)

	self:PlayEffects2( hTarget )
end
function yoshino_snowball:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" )+self:GetCaster():FindTalentValue("special_bonus_yoshino_20")

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	
	

	
end

--------------------------------------------------------------------------------
function yoshino_snowball:PlayEffects1()
	-- Get Resources
	local sound_cast = "yoshino.snowball"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function yoshino_snowball:PlayEffects2( target )
	-- Get Resources
	local sound_target = "yoshino.snowball_hit"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end