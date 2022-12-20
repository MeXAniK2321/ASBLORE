howling = class({})
LinkLuaModifier( "modifier_howling", "modifiers/modifier_howling", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kanana", "heroes/howling.lua", LUA_MODIFIER_MOTION_NONE )

function howling:GetIntrinsicModifierName()
    return "modifier_kanana"
end
function howling:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("distotion")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function howling:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = 5

	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_howling", -- modifier name
		{
			duration = duration,
			start = true,
		} -- kv
	)
	local radius = self:GetSpecialValueFor("radius")
	local duration2 = 1.0
	local damage = self:GetSpecialValueFor("sand_storm_damage")

	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		450,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = duration2 } -- kv
		)
	end

	-- effects
	local sound_cast = "kanade.howling"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Ability Channeling
-- function howling:GetChannelTime()

-- end

function howling:OnChannelFinish( bInterrupted )
	local delay = self:GetSpecialValueFor("sand_storm_invis_delay")
	self:GetCaster():AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_howling", -- modifier name
		{
			duration = delay,
			start = false,
		} -- kv
	)
end
modifier_kanana = class ({})
function modifier_kanana:IsHidden() return true end
function modifier_kanana:IsDebuff() return false end
function modifier_kanana:IsPurgable() return false end
function modifier_kanana:IsPurgeException() return false end
function modifier_kanana:RemoveOnDeath() return false end

function modifier_kanana:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_kanana:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_kanana:OnIntervalThink()
    if IsServer() then
        local silent_girl = self:GetParent():FindAbilityByName("distotion")
        if silent_girl and not silent_girl:IsNull() then
            if self:GetParent():HasScepter() then
                if silent_girl:IsHidden() then
                    silent_girl:SetHidden(false)
                end
            else
                if not silent_girl:IsHidden() then
                    silent_girl:SetHidden(true)
                end
            end
        end
    end
end