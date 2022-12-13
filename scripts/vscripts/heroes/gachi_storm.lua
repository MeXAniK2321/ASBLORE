gachi_storm = class({})
LinkLuaModifier( "modifier_gachi_storm", "modifiers/modifier_gachi_storm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_disarmed", "modifiers/modifier_generic_disarmed", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Ability Start
function gachi_storm:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor("AbilityDuration")

	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_gachi_storm", -- modifier name
		{
			duration = 12,
			start = true,
		} -- kv
	)
	local radius = 700
	local duration = 3
	local damage = 100

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
			"modifier_generic_disarmed", -- modifier name
			{ duration = duration } -- kv
		)
	end

	
end

--------------------------------------------------------------------------------
-- Ability Channeling
-- function gachi_storm:GetChannelTime()

-- end

function gachi_storm:OnChannelFinish( bInterrupted )
	local delay = self:GetSpecialValueFor("sand_storm_invis_delay")
	self:GetCaster():AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_gachi_storm", -- modifier name
		{
			duration = delay,
			start = false,
		} -- kv
	)
end