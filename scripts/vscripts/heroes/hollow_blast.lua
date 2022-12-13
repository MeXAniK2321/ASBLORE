hollow_blast = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Ability Start


function hollow_blast:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	
	local projectile_name = "particles/hollow_blast.vpcf"
	
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


function hollow_blast:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end
	local damage = self:GetSpecialValueFor( "damage" )


	self:Hit( target, true )
	
	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_generic_stunned_lua",
		{duration = self:GetDuration()}
	)

	self:PlayEffects2( hTarget )
	
end
function hollow_blast:Hit( target, dragonform )
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
function hollow_blast:PlayEffects1()
	-- Get Resources
	

	local sound_cast = "aizen_6"
	
	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function hollow_blast:PlayEffects2( target )
	-- Get Resources
	
	
	
	local sound_target = "aizen.5_1_sfx"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end
