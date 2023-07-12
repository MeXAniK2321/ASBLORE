superior_chair = class({})
LinkLuaModifier( "modifier_superior_chair", "modifiers/modifier_superior_chair", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start

function superior_chair:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor("AbilityDuration")

	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_superior_chair", -- modifier name
		{
			duration = duration,
			start = true,
		} -- kv
	)

	-- effects
	self.launcher_charge_fx = 	ParticleManager:CreateParticle("particles/stul.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 0, self:GetCaster(), 5, "chair", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.launcher_charge_fx, 1, self:GetCaster(), 5, "chair", Vector(0,0,0), true)
EmitSoundOn("vergil.6", caster)
EmitSoundOn("vergil.fuck_u", caster)
end

--------------------------------------------------------------------------------
-- Ability Channeling
-- function superior_chair:GetChannelTime()

-- end

function superior_chair:OnChannelFinish( bInterrupted )
	self:GetCaster():RemoveModifierByName("modifier_superior_chair")
	local caster = self:GetCaster()
    local special_damage = self:GetSpecialValueFor("sand_storm_damage")
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = 40 * caster:GetLevel() + special_damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = 1.0 } -- kv
		)
	end
	local radius = 600
	self:PlayEffects( radius )
	if self.launcher_charge_fx then
	    ParticleManager:DestroyParticle(self.launcher_charge_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.launcher_charge_fx)
	end
end
function superior_chair:PlayEffects( radius )
	local particle_cast = "particles/chair_cut.vpcf"
	local sound_cast = "vergil.2"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end