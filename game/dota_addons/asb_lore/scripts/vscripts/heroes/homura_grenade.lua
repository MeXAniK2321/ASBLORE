homura_grenade = class({})
LinkLuaModifier( "modifier_homura_grenade_thinker", "modifiers/modifier_homura_grenade_thinker", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start

function homura_grenade:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
	local radius = self:GetSpecialValueFor("radius")
	local damage = self:GetSpecialValueFor("damage")
	local player = caster:GetPlayerID()
	local max_range = self:GetSpecialValueFor("blink_range")

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
	
	
	
	self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_homura_grenade_thinker", -- modifier name
		{ duration = 2 }, -- kv
		origin,
		caster:GetTeamNumber(),
		false
	)
	self.thinker = self.thinker:FindModifierByName("modifier_homura_grenade_thinker")

	
	local direction = (point - origin)
	if direction:Length2D() > max_range then
		direction = direction:Normalized() * max_range
	end

	-- teleport
	FindClearSpaceForUnit( caster, origin + direction, true )
	
	
	

	-- Play effects
	self:PlayEffects( origin, direction )
	
	
	
end

--------------------------------------------------------------------------------
function homura_grenade:PlayEffects( origin, direction )
	-- Get Resources
	local particle_cast_a = "particles/econ/items/antimage/antimage_ti7/antimage_blink_start_ti7_sparkles.vpcf"
	local sound_cast_a = "homura.4_1"

	local particle_cast_b = "particles/antimage_blink_ti7_end_b1.vpcf"
	local sound_cast_b = ""

	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( particle_cast_a, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, sound_cast_a, self:GetCaster() )

	-- At original position
	local effect_cast_b = ParticleManager:CreateParticle( particle_cast_b, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_b, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast_b, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_b )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast_b, self:GetCaster() )
end