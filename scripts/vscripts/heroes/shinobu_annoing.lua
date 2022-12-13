shinobu_annoing = class({})
LinkLuaModifier( "modifier_shinobu_annoing", "modifiers/modifier_shinobu_annoing", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_grand_donut",        "heroes/donut", LUA_MODIFIER_MOTION_NONE)
function shinobu_annoing:GetIntrinsicModifierName()
    return "modifier_grand_donut"
end
--------------------------------------------------------------------------------
-- Ability Start
function shinobu_annoing:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("silence_duration")
	local damage = self:GetSpecialValueFor("damage") +self:GetCaster():FindTalentValue("special_bonus_shinobu_25")

	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
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
			"modifier_shinobu_annoing", -- modifier name
			{ duration = duration } -- kv
		)
	end
     if caster:HasModifier("modifier_kisshot") then
	 self:PlayEffects1( radius )
	 else
	self:PlayEffects( radius )
	end
end

function shinobu_annoing:PlayEffects( radius )
	local particle_cast = "particles/shinobu_annoing.vpcf"
	local sound_cast = "shinobu.2_"..RandomInt(1, 3)

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
function shinobu_annoing:PlayEffects1( radius )
	local particle_cast = "particles/shinobu_annoing_ts.vpcf"
	local sound_cast = "Shinobu.annoing_ts"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end