shamak = class({})
LinkLuaModifier( "modifier_shamak", "modifiers/modifier_shamak", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leonidas", "heroes/shamak.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function shamak:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function shamak:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("cor_leonis")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function shamak:GetIntrinsicModifierName()
    return "modifier_leonidas"
end
--------------------------------------------------------------------------------
-- Ability Start
function shamak:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	   local damage = self:GetSpecialValueFor("damage")
    local modifier = caster:FindModifierByNameAndCaster("modifier_leonidas",caster)
	if not modifier == nil then 
	local current = modifier:GetStackCount()
	local modifier_up = self:GetSpecialValueFor("stack_damage") * current
	self.damage = damage + modifier_up
	else
	self.damage = damage
	end

	local duration = self:GetSpecialValueFor( "duration" )
	local radius = self:GetSpecialValueFor( "radius" )
	

		local debuff_duration = self:GetSpecialValueFor("duration")
	
 
	
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
		damage = self.damage,
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
			"modifier_shamak", -- modifier name
			{ duration = debuff_duration } -- kv
		)
	end

	
	
	EmitSoundOn("subaru.1", caster)
	self:PlayEffects( radius )
end
function shamak:PlayEffects( radius )
	local particle_cast = "particles/shamak_new.vpcf"
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
modifier_leonidas = class ({})
function modifier_leonidas:IsHidden() return false end
function modifier_leonidas:IsDebuff() return false end
function modifier_leonidas:IsPurgable() return false end
function modifier_leonidas:IsPurgeException() return false end
function modifier_leonidas:RemoveOnDeath() return false end

function modifier_leonidas:OnCreated()
    if IsServer() then  		
	if IsServer() then
		self:SetStackCount(0)
	end
    end
end
function modifier_leonidas:OnRefresh()
    if IsServer() then
	
    end
end
function modifier_leonidas:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
       MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}

	return funcs
end
function modifier_leonidas:GetModifierBaseAttackTimeConstant()
	return 2.5
end
function modifier_leonidas:OnDeath( params )
	if IsServer() then
		self:DeathLogic( params )
	end
end
function modifier_leonidas:DeathLogic( params )
	-- filter
	local unit = params.unit
	local pass = false
	if unit==self:GetParent()  then
		pass = true
	end

	-- logic
	if pass then
		self:AddStack(1)
	end
end
function modifier_leonidas:AddStack( value )
self.soul_min = 20
	local current = self:GetStackCount()
	local after = current + value
		if after > self.soul_min then
			after = self.soul_min
		end
	self:SetStackCount( after )
end
