axe_berserkers_call_lua = class({})
LinkLuaModifier( "modifier_axe_berserkers_call_lua", "heroes/bogdan/axe_berserkers_call_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_berserkers_call_lua_debuff", "heroes/bogdan/axe_berserkers_call_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_bogdangasm", "heroes/bogdan/axe_berserkers_call_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_slow", "modifiers/modifier_generic_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )
function axe_berserkers_call_lua:GetIntrinsicModifierName()
    return "modifier_bogdangasm"
end
function axe_berserkers_call_lua:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("bogdan_chill")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Phase Start
function axe_berserkers_call_lua:OnAbilityPhaseInterrupted()
	-- stop effects 
	local sound_cast = "bogdan.spank"
	StopGlobalSound( sound_cast )
end
function axe_berserkers_call_lua:OnAbilityPhaseStart()
	-- play effects 
	local sound_cast = "bogdan.spank"
	local caster = self:GetCaster()
	local point = caster:GetOrigin()
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )

	return true -- if success
end

--------------------------------------------------------------------------------
-- Ability Start
function axe_berserkers_call_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = caster:GetOrigin()

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")



	-- self buff
	if caster:HasTalent("special_bonus_bogdan_20_alt") then
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_axe_berserkers_call_lua", -- modifier name
		{ duration = 2 } -- kv
	)
end
	-- play effects
	
	local scale =self:GetSpecialValueFor( "int_scale" )
	local int = caster:GetIntellect() * scale
	local damage = self:GetSpecialValueFor( "damage" ) + int
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	-- Prepare damage table
	local damageTable = {
		victim = nil,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	-- for each caught enemies
	for _,enemy in pairs(enemies) do
		-- Apply Damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	enemy:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_slow", -- modifier name
		{ duration = 1.5 } -- kv
	)
		if caster:HasTalent("special_bonus_bogdan_20") then
		enemy:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_silenced_lua", -- modifier name
		{ duration = 1.0 } -- kv
	)
		end
		-- Apply stun debuff
		
	end
if IsASBPatreon(caster) then
	self:PlayEffects2()
	else
	self:PlayEffects()
	end
end

--------------------------------------------------------------------------------
function axe_berserkers_call_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/axe_beserkers_call_owner1.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
function axe_berserkers_call_lua:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/hurk_spank.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_mouth",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
		local sound_cast = "hurk.spank"
	EmitSoundOn( sound_cast, self:GetCaster() )
end
modifier_bogdangasm = class ({})
function modifier_bogdangasm:IsHidden() return true end
function modifier_bogdangasm:IsDebuff() return false end
function modifier_bogdangasm:IsPurgable() return false end
function modifier_bogdangasm:IsPurgeException() return false end
function modifier_bogdangasm:RemoveOnDeath() return false end

function modifier_bogdangasm:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_bogdangasm:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_bogdangasm:OnIntervalThink()
    if IsServer() then
        local dungeonmaster = self:GetParent():FindAbilityByName("bogdan_chill")
        if dungeonmaster and not dungeonmaster:IsNull() then
            if self:GetParent():HasScepter() then
                if dungeonmaster:IsHidden() then
                    dungeonmaster:SetHidden(false)
                end
            else
                if not dungeonmaster:IsHidden() then
                    dungeonmaster:SetHidden(true)
                end
            end
        end
    end
end













































modifier_axe_berserkers_call_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_axe_berserkers_call_lua:IsHidden()
	return false
end

function modifier_axe_berserkers_call_lua:IsDebuff()
	return false
end

function modifier_axe_berserkers_call_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_axe_berserkers_call_lua:OnCreated( kv )
self.red = 0
	-- references
local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		500,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)
		for _,enemy in pairs(enemies) do
		local lc = self.red
		self.red = lc + 5
		end
end

function modifier_axe_berserkers_call_lua:OnRefresh( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
end

function modifier_axe_berserkers_call_lua:OnRemoved()
end

function modifier_axe_berserkers_call_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_axe_berserkers_call_lua:DeclareFunctions()
	local funcs = {
                    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end

function modifier_axe_berserkers_call_lua:GetModifierIncomingDamage_Percentage( params )
	

		return self.red * -1
	end
	

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_axe_berserkers_call_lua:GetEffectName()
	return "particles/axe_beserkers_call1.vpcf"
end

function modifier_axe_berserkers_call_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end



















modifier_axe_berserkers_call_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_axe_berserkers_call_lua_debuff:IsHidden()
	return false
end

function modifier_axe_berserkers_call_lua_debuff:IsDebuff()
	return true
end

function modifier_axe_berserkers_call_lua_debuff:IsStunDebuff()
	return false
end

function modifier_axe_berserkers_call_lua_debuff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_axe_berserkers_call_lua_debuff:OnCreated( kv )
	if IsServer() then
		-- two not working...?
		-- self:GetParent():SetAggroTarget( self:GetCaster() )
		-- self:GetParent():SetAttacking( self:GetCaster() )
		self:GetParent():SetForceAttackTarget( self:GetCaster() ) -- for creeps
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) -- for heroes
	end
end

function modifier_axe_berserkers_call_lua_debuff:OnRefresh( kv )
end

function modifier_axe_berserkers_call_lua_debuff:OnRemoved()
	if IsServer() then
		self:GetParent():SetForceAttackTarget( nil )
	end
end

function modifier_axe_berserkers_call_lua_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_axe_berserkers_call_lua_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_axe_berserkers_call_lua_debuff:GetStatusEffectName()
	return "particles/status_effect_beserkers_call1.vpcf"
end