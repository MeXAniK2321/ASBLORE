second_hand = class({})
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start


function second_hand:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	
	local projectile_name = "particles/second_hand.vpcf"
	
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
	caster:AddNewModifier(caster, self, "modifier_generic_stunned_lua", {duration = 0.5})
	
	end


function second_hand:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end
	local damage = self:GetSpecialValueFor( "damage" )


	self:Hit( target, true )
	
	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_generic_slow",
		{duration = self:GetDuration()}
	)

	self:PlayEffects2( hTarget )
	
end
function second_hand:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" )

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
function second_hand:PlayEffects1()
	-- Get Resources
	

	local sound_cast = "subaru.4"
	
	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function second_hand:PlayEffects2( target )
	-- Get Resources
	
	
	
	local sound_target = "subaru.4"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end
