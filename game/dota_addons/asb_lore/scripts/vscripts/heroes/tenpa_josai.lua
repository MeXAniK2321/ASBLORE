LinkLuaModifier("modifier_tenpa_josai", "heroes/tenpa_josai", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tenpa_josai_position", "heroes/tenpa_josai", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tenpa_josai_invul", "heroes/tenpa_josai", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muted", "modifiers/modifier_muted", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alastor_awake", "modifiers/modifier_alastor_awake", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tenpa_josai_burn", "heroes/tenpa_josai", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_asta_sword_buff", "items/item_asta_sword", LUA_MODIFIER_MOTION_NONE)
tenpa_josai = class({})

function tenpa_josai:IsStealable() return true end
function tenpa_josai:IsHiddenWhenStolen() return false end
function tenpa_josai:OnSpellStart()
    local caster = self:GetCaster()
	local origin  = self:GetCaster():GetOrigin()
	caster:AddNewModifier(caster, self, "modifier_muted", {duration = 8.1})
	caster:AddNewModifier(caster, self, "modifier_tenpa_josai", {duration = 8})
	caster:AddNewModifier(caster, self, "modifier_tenpa_josai_invul", {duration = 8})
	caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 8})
  self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_tenpa_josai_position", -- modifier name
		{ duration = 8 }, -- kv
		origin,
		caster:GetTeamNumber(),
		false
	)
	
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		800,	-- float, radius. or use FIND_UNITS_EVERYWHERE
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
		damage = 1200,
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
	end
	
function tenpa_josai:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/tenpa_josai_shockwave.vpcf"
	local caster = self:GetCaster()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end
modifier_tenpa_josai_position = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tenpa_josai_position:IsHidden()
	return false
end

function modifier_tenpa_josai_position:IsDebuff()
	return false
end

function modifier_tenpa_josai_position:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tenpa_josai_position:OnCreated( kv )
	-- references
	self.radius = 800

	if not IsServer() then return end
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	-- start interval
	

	-- play effects
	
	self:PlayEffects()
	 EmitSoundOn("shana.5_1", self.parent)
		

end

function modifier_tenpa_josai_position:OnRefresh( kv )
	
end

function modifier_tenpa_josai_position:OnRemoved()

end

function modifier_tenpa_josai_position:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end
function modifier_tenpa_josai_position:IsAura() return true end
function modifier_tenpa_josai_position:IsAuraActiveOnDeath() return false end
function modifier_tenpa_josai_position:GetAuraDuration()
	return 1.0
end
function modifier_tenpa_josai_position:GetAuraEntityReject(hEntity)
end
function modifier_tenpa_josai_position:GetAuraRadius()
    return 800
end
function modifier_tenpa_josai_position:GetAuraSearchFlags()
    return self:GetAbility():GetAbilityTargetFlags()
end
function modifier_tenpa_josai_position:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end
function modifier_tenpa_josai_position:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end
function modifier_tenpa_josai_position:GetModifierAura()
    return "modifier_tenpa_josai_burn"
end
function modifier_tenpa_josai_position:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/tenpa_josai_demon.vpcf"
	self.parent_origin = self:GetParent():GetOrigin()
	self.delay = 8

	-- Get Data
	local height = -1000
	local height_target = 0

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	
end
function modifier_tenpa_josai_position:GetEffectName()

	return "particles/tenpa_josai.vpcf"
	end
modifier_tenpa_josai_burn = class({})
function modifier_tenpa_josai_burn:IsHidden() return false end
function modifier_tenpa_josai_burn:IsDebuff() return true end
function modifier_tenpa_josai_burn:IsPurgable() return true end
function modifier_tenpa_josai_burn:IsPurgeException() return true end
function modifier_tenpa_josai_burn:RemoveOnDeath() return true end
function modifier_tenpa_josai_burn:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_tenpa_josai_burn:OnCreated(table)
    if IsServer() then
        self.parent = self:GetParent()
		self.caster = self:GetCaster()
        self.ability = self:GetAbility()
        self.ring_dot_interval  = 0.5
        self.ring_dot_damage    = 400

        local burn_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        
        self:AddParticle(burn_fx, false, false, -1, true, true)

        self:StartIntervalThink(0.5)
    end
end
function modifier_tenpa_josai_burn:OnRefresh(table)
	if IsServer() then
		self:OnCreated(table)
	end
end
function modifier_tenpa_josai_burn:OnIntervalThink()
    if IsServer() then
        local damage_table = {  victim = self.parent,
                                attacker = self.caster,
                                damage = 400,
                                damage_type = DAMAGE_TYPE_MAGICAL,
                                ability = self }

        ApplyDamage(damage_table)
    end
end


modifier_tenpa_josai = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tenpa_josai:IsHidden()
	return false
end

function modifier_tenpa_josai:IsDebuff()
	return true
end

function modifier_tenpa_josai:IsStunDebuff()
	return false
end

function modifier_tenpa_josai:IsPurgable()
	return true
end

function modifier_tenpa_josai:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tenpa_josai:OnCreated( kv )


	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

end

function modifier_tenpa_josai:OnRefresh( kv )
	
end

function modifier_tenpa_josai:OnRemoved()
end

function modifier_tenpa_josai:OnDestroy()
self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_tenpa_josai:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_tenpa_josai:GetModifierProvidesFOWVision()
	return 1
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_tenpa_josai:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_tenpa_josai:Silence()
	-- add silence
	self:Destroy()
	if self:GetParent():HasScepter() then
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetParent(),
		damage = 8000,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		self:PlayEffects()
		local radius = 1000
		end
		 self:GetParent():RemoveModifierByName("modifier_shana_wings")
	self:GetParent():RemoveModifierByName("modifier_star_tier2")
	self:GetParent():RemoveModifierByName("modifier_star_tier3")
	 self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_alastor_awake", {duration = 30})
	self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_star_tier3", {duration = 30})
	else
	self:GetParent():Kill(self, self:GetParent())
	self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_tenpa_josai_death", {duration = 8})
	
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = self:GetParent(),
		damage = 8000,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)
		self:PlayEffects()
		local radius = 1000
		end
end
end

function modifier_tenpa_josai:PlayEffects()
	-- Get Resources
	
	local sound_cast = "shana.explosion"

	EmitSoundOn( sound_cast, self:GetParent() )
end


modifier_tenpa_josai_invul = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_tenpa_josai_invul:IsHidden()
	return false
end

function modifier_tenpa_josai_invul:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_tenpa_josai_invul:IsStunDebuff()
	return true
end

function modifier_tenpa_josai_invul:IsPurgable()
	return true
end

function modifier_tenpa_josai_invul:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_tenpa_josai_invul:OnCreated( kv )
	self:GetParent():AddNoDraw()
end

function modifier_tenpa_josai_invul:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveNoDraw()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_tenpa_josai_invul:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end
