cor_leonis = class({})
LinkLuaModifier( "modifier_cor_leonis", "modifiers/modifier_cor_leonis", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_cor_leonis_self", "modifiers/modifier_cor_leonis_self", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
--------------------------------------------------------------------------------
-- Ability Start
function cor_leonis:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("second_hand")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function cor_leonis:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	
   caster:AddNewModifier(caster, self, "modifier_cor_leonis_self", {duration = duration})
   caster:AddNewModifier(caster, self, "modifier_star_tier1", {duration = duration})
	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	
	for _,enemy in pairs(enemies) do
		-- damage
			-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_cor_leonis", -- modifier name
			{ duration = duration } -- kv
		)
	end

	self:PlayEffects( radius )
end

function cor_leonis:PlayEffects( radius )
	local particle_cast = "particles/cor_leonis.vpcf"
	local sound_cast = "subaru.7"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end