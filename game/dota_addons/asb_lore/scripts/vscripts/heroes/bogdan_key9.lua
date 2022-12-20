bogdan_key9 = class({})
LinkLuaModifier( "modifier_bogdan_key9", "modifiers/modifier_bogdan_key9", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Ability Start
function bogdan_key9:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	if IsASBPatreon(caster) then
		local projectile_name = "particles/hurk_bolt.vpcf"
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

	self:PlayEffects1_1()
	else
	local projectile_name = "particles/bogdan_bolt.vpcf"
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
end

function bogdan_key9:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end
	
	

	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_bogdan_key9",
		{duration = self:GetDuration()}
	)
	local caster = self:GetCaster()
if IsASBPatreon(caster) then
	self:PlayEffects2_1( hTarget )
	else
	self:PlayEffects2( hTarget )
	end
end

--------------------------------------------------------------------------------
function bogdan_key9:PlayEffects1()
	-- Get Resources
	local sound_cast = "bogdan.boy"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function bogdan_key9:PlayEffects1_1()
	-- Get Resources
	local sound_cast = "hurk.cum_1"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function bogdan_key9:PlayEffects2_1()
	-- Get Resources
	local sound_cast = "hurk.cum"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function bogdan_key9:PlayEffects2( target )
	-- Get Resources
	local sound_target = "anime_chatwheel_non_sorted_9_1"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end