mars_gods_rebuke_lua = class({})
LinkLuaModifier( "modifier_mars_gods_rebuke_lua", "modifiers/modifier_mars_gods_rebuke_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_knockback_lua", "modifiers/modifier_generic_knockback_lua", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------
-- Ability Start
function mars_gods_rebuke_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local damage = self:GetSpecialValueFor("crit_mult") + self:GetCaster():FindTalentValue("special_bonus_shinobu_20")

	-- load data
	if caster:HasModifier("modifier_kisshot") then
	self.damage = self:GetSpecialValueFor("crit_mult") + self:GetCaster():FindTalentValue("special_bonus_shinobu_20") +1000
	self.radius = self:GetSpecialValueFor("radius") +300
	self:EndCooldown()
	else
	self.damage = self:GetSpecialValueFor("crit_mult") + self:GetCaster():FindTalentValue("special_bonus_shinobu_20")
	self.radius = self:GetSpecialValueFor("radius")
	end
	local angle = self:GetSpecialValueFor("angle")/2
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")

	-- find units
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local damageTable = {
		attacker = caster,
		ability = self, --Optional.
	}
	
	-- Damage yourself
	damageTable.victim = caster
    damageTable.damage = caster:GetMaxHealth() * 0.10
    damageTable.damage_type = DAMAGE_TYPE_PURE
	damageTable.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	ApplyDamage(damageTable)

	for _,enemy in pairs(enemies) do
		-- Apply damage
		damageTable.victim = enemy
        damageTable.damage = self.damage
        damageTable.damage_type = DAMAGE_TYPE_PHYSICAL
	    damageTable.damage_flags = DOTA_DAMAGE_FLAG_NONE
		ApplyDamage(damageTable)
	end

	-- add buff modifier
	local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_mars_gods_rebuke_lua", -- modifier name
		{  } -- kv
	)

	-- precache
	local origin = caster:GetOrigin()
	local cast_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()
		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )
		if angle_diff<=angle then
			-- attack
			

			-- knockback if not having spear stun
			local knockback = { should_stun = 1,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 300,
                        knockback_height = 100,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    enemy:AddNewModifier(caster, self, "modifier_knockback", knockback)

			caught = true
			-- play effects
			self:PlayEffects2( enemy, origin, cast_direction )
		end
	end

	-- destroy buff modifier
	buff:Destroy()

	if caster:HasModifier("modifier_kisshot") then
	self:PlayEffects3( caught, (point-origin):Normalized() )
	else
	self:PlayEffects1( caught, (point-origin):Normalized() )
	end
end

--------------------------------------------------------------------------------
-- Play Effects
function mars_gods_rebuke_lua:PlayEffects1( caught, direction )
	-- Get Resources
	local particle_cast = "particles/blood_strike.vpcf"
	local sound_cast = "Blood.Strike"
	if not caught then
		local sound_cast = "Blood.Strike"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
function mars_gods_rebuke_lua:PlayEffects3( caught, direction )
	-- Get Resources
	local particle_cast = "particles/blood_strike_ts.vpcf"
	local sound_cast = "Blood.Strike_ts"
	if not caught then
		local sound_cast = "Blood.Strike_ts"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function mars_gods_rebuke_lua:PlayEffects2( target, origin, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_medusa/medusa_mystic_snake_impact_blood.vpcf"
	local sound_cast = "Hero_Mars.Shield.Crit"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end