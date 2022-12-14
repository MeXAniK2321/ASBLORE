dragon_knight_breathe_fire_lua = class({})
LinkLuaModifier( "modifier_dragon_knight_breathe_fire_lua", "modifiers/modifier_dragon_knight_breathe_fire_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function dragon_knight_breathe_fire_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	-- unit target just indicates point
	if target then point = target:GetOrigin() end

	local value1 = self:GetSpecialValueFor("some_value")
	
	-- load projectile
	local projectile_name = "particles/dark_blast.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "range" )
	local projectile_start_radius = self:GetSpecialValueFor( "start_radius" )
	local projectile_end_radius = self:GetSpecialValueFor( "end_radius" )
	local projectile_speed = self:GetSpecialValueFor( "speed" )
	local projectile_direction = point - caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius =projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,
		}
	ProjectileManager:CreateLinearProjectile(info)

	-- play effects
	EmitSoundOn("rumia_2", self:GetCaster())
	
	EmitSoundOn( "nevermore_nev_attack_04", caster )
	
end
--------------------------------------------------------------------------------
-- Projectile
function dragon_knight_breathe_fire_lua:OnProjectileHit( target, location )
	if not target then return end

	-- load data
	local damage = self:GetAbilityDamage()+self:GetCaster():FindTalentValue("special_bonus_rumia_20")
	local duration = self:GetSpecialValueFor( "duration" )

	-- damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- debuff
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_dragon_knight_breathe_fire_lua", -- modifier name
		{ duration = duration } -- kv
	)
end