knife_play = class({})
LinkLuaModifier( "modifier_knife_play", "modifiers/modifier_knife_play", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_knife_play_attack", "modifiers/modifier_knife_play_attack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function knife_play:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	local projectile_name = "particles/chara_knife_throw.vpcf"
	if self:GetCaster():HasModifier( "modifier_little_nightmare" ) then
	self.projectile_speed = 2300
	else
	self.projectile_speed = self:GetSpecialValueFor("dagger_speed")
	end
	local projectile_vision = 450

	-- Create Projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		EffectName = projectile_name,
		iMoveSpeed = self.projectile_speed,
		bReplaceExisting = false,                         -- Optional
		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,				-- Optional
		iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	self:PlayEffects1()
end

function knife_play:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	local caster = self:GetCaster()
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end
	
	local modifier = self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_knife_play_attack",
		{}
	)
	self:GetCaster():PerformAttack (
		hTarget,
		true,
		true,
		true,
		false,
		false,
		false,
		true
	)
	modifier:Destroy()


	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_knife_play",
		{duration = self:GetDuration()}
	)
	
	local blinkDistance = 50
	local blinkDirection = (caster:GetOrigin() - target:GetOrigin()):Normalized() * blinkDistance
	local blinkPosition = target:GetOrigin() + blinkDirection

	-- Blink
	caster:SetOrigin( blinkPosition )
	FindClearSpaceForUnit( caster, blinkPosition, true )

	self:PlayEffects2( hTarget )
end

--------------------------------------------------------------------------------
function knife_play:PlayEffects1()
	-- Get Resources
	local sound_cast = "chara.1"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function knife_play:PlayEffects2( target )
	-- Get Resources
	local sound_target = "Hero_PhantomAssassin.CoupDeGrace"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end