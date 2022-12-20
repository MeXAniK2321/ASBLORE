underlord_pit_of_malice_lua = class({})
LinkLuaModifier( "modifier_underlord_pit_of_malice_lua", "modifiers/modifier_underlord_pit_of_malice_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_underlord_pit_of_malice_lua_cooldown", "modifiers/modifier_underlord_pit_of_malice_lua_cooldown", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_underlord_pit_of_malice_lua_thinker", "modifiers/modifier_underlord_pit_of_malice_lua_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_kakaton", "heroes/underlord_pit_of_malice_lua.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function underlord_pit_of_malice_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function underlord_pit_of_malice_lua:GetIntrinsicModifierName()
    return "modifier_kakaton"
end
function underlord_pit_of_malice_lua:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("ryen_hoka")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--------------------------------------------------------------------------------
-- Ability Phase Start


--------------------------------------------------------------------------------
-- Ability Start
function underlord_pit_of_malice_lua:OnSpellStart()
	-- release cast effect
	
	

	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local radius = 700

	-- load data
	local duration = self:GetSpecialValueFor( "pit_duration" )
	
	

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_underlord_pit_of_malice_lua_thinker", -- modifier name
		{ duration = duration },		-- kv
		point,
		caster:GetTeamNumber(),
		false
	)
   self:PlayEffects( point, radius, duration )
end

--------------------------------------------------------------------------------
function underlord_pit_of_malice_lua:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/jukai_kotan.vpcf"
	local sound_cast = "jukai.kotan"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
modifier_kakaton = class ({})
function modifier_kakaton:IsHidden() return true end
function modifier_kakaton:IsDebuff() return false end
function modifier_kakaton:IsPurgable() return false end
function modifier_kakaton:IsPurgeException() return false end
function modifier_kakaton:RemoveOnDeath() return false end

function modifier_kakaton:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_kakaton:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_kakaton:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_kakaton:GetModifierBaseAttackTimeConstant()
	return 2.5
end
function modifier_kakaton:OnIntervalThink()
    if IsServer() then
        local uchiha_leader = self:GetParent():FindAbilityByName("ryen_hoka")
        if uchiha_leader and not uchiha_leader:IsNull() then
            if self:GetParent():HasScepter() then
                if uchiha_leader:IsHidden() then
                    uchiha_leader:SetHidden(false)
                end
            else
                if not uchiha_leader:IsHidden() then
                    uchiha_leader:SetHidden(true)
                end
            end
        end
    end
end