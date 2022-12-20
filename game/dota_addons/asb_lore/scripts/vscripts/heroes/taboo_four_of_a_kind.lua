taboo_four_of_a_kind = class({})
LinkLuaModifier( "modifier_generic_stunned_lua2", "heroes/taboo_four_of_a_kind", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_taboo_four_of_a_kind_hit", "modifiers/modifier_taboo_four_of_a_kind_hit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_taboo_four_of_a_kind_hit_debuff", "modifiers/modifier_taboo_four_of_a_kind_hit_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_taboo_four_of_a_kind_damage", "modifiers/modifier_taboo_four_of_a_kind_damage", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_untarget", "modifiers/modifier_untarget", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV


--------------------------------------------------------------------------------
-- Ability Start
function taboo_four_of_a_kind:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
     if not IsServer() then return nil end

    local duration = 1.5
    local incoming = 100
    local outgoing = 25
    local clones = 4 



    for i = 1,clones do
        local clone = CreateIllusionForPlayer(caster, caster, caster, self, target:GetAbsOrigin() + RandomVector(100), duration, 1, incoming, outgoing)
		
		clone:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_untarget", -- modifier name
		{ duration = duration } -- kv
	)
    end

	-- check if simple form
	if not modifier then
		-- cancel if linken
		if target:TriggerSpellAbsorb( self ) then return end

		-- directly hit
		self:Hit( target, false )

		-- play effects
		return
	end

end

-- Helper
function taboo_four_of_a_kind:Hit( target, dragonform )
	local caster = self:GetCaster()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data

	local duration = self:GetSpecialValueFor( "stun_duration" )

	-- damage
	

	-- stun
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua2", -- modifier name
		{ duration = duration } -- kv
	)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_taboo_four_of_a_kind_damage", -- modifier name
		{ duration = 1.4 } -- kv
	)

	-- Play effects

	local sound_cast = "flandr.4"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Projectile


--------------------------------------------------------------------------------


modifier_generic_stunned_lua2 = class({})

--------------------------------------------------------------------------------

function modifier_generic_stunned_lua2:IsHidden()
    return false
end

function modifier_generic_stunned_lua2:IsPurgable()
    return false
end
function modifier_generic_stunned_lua2:OnDestroy()

	self:PlayEffects()
end

--------------------------------------------------------------------------------

function modifier_generic_stunned_lua2:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end
function modifier_generic_stunned_lua2:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/test3.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end