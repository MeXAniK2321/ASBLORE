sans_bone_throw = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_burn", "modifiers/modifier_generic_burn", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_root", "modifiers/modifier_root", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Ability Start
function sans_bone_throw:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	self.rng = RandomInt(1,4)
	if self.rng == 1 then
	self.projectile = "particles/bone.vpcf"
	elseif self.rng == 2 then
	self.projectile = "particles/throw_boot.vpcf"
	elseif self.rng == 3 then
	self.projectile = "particles/sans_throw_3.vpcf"
	else
	self.projectile = "particles/sans_throw_4.vpcf"
	end
	local projectile_name = self.projectile
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

function sans_bone_throw:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if not target then return end

	self:Hit( target, true )
	
	local duration2 = self:GetSpecialValueFor("duration2")
 if self.rng == 1 then
 hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_root",
		{duration = self:GetDuration() + 0.5}
	)
	self:PlayEffects2( hTarget )
 elseif self.rng == 2 then
 hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_generic_burn",
		{duration = duration2}
	)
	self:PlayEffects3( hTarget )
 elseif self.rng == 3 then
 hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_generic_slow",
		{duration = duration2}
	)
	self:PlayEffects4( hTarget )
 else
	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_generic_stunned_lua",
		{duration = self:GetDuration()}
	)
	self:PlayEffects2( hTarget )
	end

	
end
function sans_bone_throw:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_sans_20")

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
function sans_bone_throw:PlayEffects1()
	-- Get Resources
	local sound_cast = "Bone.Throw"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function sans_bone_throw:PlayEffects2( target )
	-- Get Resources
	local sound_target = "Bone.Hit"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end
function sans_bone_throw:PlayEffects3( target )
	-- Get Resources
	local sound_target = "Bone.Throw_impact_2"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end
function sans_bone_throw:PlayEffects4( target )
	-- Get Resources
	local sound_target = "Bone.Throw_impact_3"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end