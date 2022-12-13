jin_mori_original = class({})
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jin_mori_original_attack", "modifiers/modifier_jin_mori_original_attack", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function jin_mori_original:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_young_tiger") then
		return "jin_mori_4_1"
	end
	return "jin_mori_4"
end
function jin_mori_original:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("kinton")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function jin_mori_original:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- get projectile_data
	if self:GetCaster():HasModifier("modifier_young_tiger") then
	local projectile_name = "particles/jin_mori_original2.vpcf"
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
 if self:GetCaster():HasModifier("modifier_young_tiger") then
	self:PlayEffects3()
	else
	self:PlayEffects1()
	end
	else
	
	local projectile_name = "particles/jin_mori_original.vpcf"
	
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
 if self:GetCaster():HasModifier("modifier_young_tiger") then
	self:PlayEffects3()
	else
	self:PlayEffects1()
	end
	end
end

function jin_mori_original:OnProjectileHit( hTarget, vLocation )
	local target = hTarget
	local caster = self:GetCaster()
	local damage = 1500 
	local target = hTarget
	if target==nil then return end
	if target:IsInvulnerable() or target:IsMagicImmune() then return end
	if target:TriggerSpellAbsorb( self ) then return end
	
	
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
	self:Hit( target, true )
	 
	hTarget:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_generic_slow",
		{duration = self:GetDuration()}
	)
if self:GetCaster():HasModifier("modifier_young_tiger") then
	self:PlayEffects4( hTarget )
	else
	self:PlayEffects2( hTarget )
	end
end
function jin_mori_original:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = 1500

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
function jin_mori_original:PlayEffects1()
	-- Get Resources
	

	local sound_cast = "mori.4"
	
	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function jin_mori_original:PlayEffects3()
	-- Get Resources
	

	local sound_cast = "mori.7"
	
	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function jin_mori_original:PlayEffects2( target )
	-- Get Resources
	
	
	
	local sound_target = "mori.4_1"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end
function jin_mori_original:PlayEffects4( target )
	-- Get Resources
	
	
	
	local sound_target = "mori.7_2"

	-- Create Sound
	EmitSoundOn( sound_target, target )
end