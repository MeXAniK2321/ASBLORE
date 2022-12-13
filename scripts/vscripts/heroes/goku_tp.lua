goku_tp = class({})

--------------------------------------------------------------------------------
-- Ability Start
function goku_tp:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("true_kamehameha")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function goku_tp:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
	local player = caster:GetPlayerID()
	

	-- load data
	local max_range = self:GetSpecialValueFor("blink_range")

	-- determine target position
	local direction = (point - origin)
	if direction:Length2D() > max_range then
		direction = direction:Normalized() * max_range
	end

	-- teleport
	FindClearSpaceForUnit( caster, origin + direction, true )
	local radius = 400
	local damage = 500
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
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		end

	-- Play effects
	self:PlayEffects( origin, direction )
end

--------------------------------------------------------------------------------
function goku_tp:PlayEffects( origin, direction )
	if IsASBPatreon(self:GetCaster()) then
		self.particle_cast_a = "particles/drip_teleport.vpcf"
	self.sound_cast_a = "drip.effect"

	self.particle_cast_b = "particles/drip_teleport.vpcf"
	self.sound_cast_b = "drip.effect"
	else
	self.particle_cast_a = "particles/econ/events/ti7/blink_dagger_start_ti7_lvl2.vpcf"
	self.sound_cast_a = "goku.5_1"

	self.particle_cast_b = "particles/econ/events/ti7/blink_dagger_end_ti7_lvl2.vpcf"
	self.sound_cast_b = "goku.5_1"
end
	-- At original position
	local effect_cast_a = ParticleManager:CreateParticle( self.particle_cast_a, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_a, 0, origin )
	ParticleManager:SetParticleControlForward( effect_cast_a, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_a )
	EmitSoundOnLocationWithCaster( origin, self.sound_cast_a, self:GetCaster() )

	-- At original position
	local effect_cast_b = ParticleManager:CreateParticle( self.particle_cast_b, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast_b, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast_b, 0, direction:Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast_b )
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), self.sound_cast_b, self:GetCaster() )
end