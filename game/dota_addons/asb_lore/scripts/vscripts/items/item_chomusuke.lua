item_chomusuke = class({})
LinkLuaModifier("modifier_item_chomusuke", "items/item_chomusuke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chomusuke_debuff", "items/item_chomusuke", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_axis_sheet_cooldown", "items/item_axis_sheet", LUA_MODIFIER_MOTION_NONE)
function item_chomusuke:GetIntrinsicModifierName()
	return "modifier_item_chomusuke"
end
function item_chomusuke:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function item_chomusuke:CastFilterResultTarget( hTarget )


local caster = self:GetCaster()
if hTarget:HasModifier("modifier_item_axis_sheet_cooldown") then
return UF_FAIL_CUSTOM
end

	local result = UnitFilter(
		hTarget,	-- Target Filter
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- Team Filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,	-- Unit Filter
		0,	-- Unit Flag
		self:GetCaster():GetTeamNumber()	-- Team reference
	)
	
	if result ~= UF_SUCCESS then
		return result
	end

	return UF_SUCCESS
end
--------------------------------------------------------------------------------
-- Ability Start
function item_chomusuke:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = target:GetAbsOrigin()
	caster:EmitSound("chatwheel.104")

	-- load data
	local damage = 200
	local radius = self:GetSpecialValueFor("radius")
	local debuffDuration = 2.5

	local vision_radius = 900
	local vision_duration = 6

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- Precache damage	 
	local damageTable = {
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}

	for _,enemy in pairs(enemies) do
		-- Apply damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- Add modifier
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = debuffDuration } -- kv
		)
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_item_axis_sheet_cooldown", -- modifier name
			{ duration = debuffDuration + 2 } -- kv
		)
	end

	

	self:PlayEffects( point, radius, debuffDuration )
end

--------------------------------------------------------------------------------
-- Ability Considerations
function item_chomusuke:AbilityConsiderations()
	-- Scepter
	local bScepter = caster:HasScepter()

	-- Linken & Lotus
	local bBlocked = target:TriggerSpellAbsorb( self )

	-- Break
	local bBroken = caster:PassivesDisabled()

	-- Advanced Status
	local bInvulnerable = target:IsInvulnerable()
	local bInvisible = target:IsInvisible()
	local bHexed = target:IsHexed()
	local bMagicImmune = target:IsMagicImmune()

	-- Illusion Copy
	local bIllusion = target:IsIllusion()
end

--------------------------------------------------------------------------------
function item_chomusuke:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/chomusuke.vpcf"
	local sound_cast = "chomusuke.exp"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_chomusuke = class({})
function modifier_item_chomusuke:IsHidden() return true end
function modifier_item_chomusuke:IsDebuff() return false end
function modifier_item_chomusuke:IsPurgable() return false end
function modifier_item_chomusuke:IsPurgeException() return false end
function modifier_item_chomusuke:RemoveOnDeath() return false end
function modifier_item_chomusuke:IsAura() return true end
function modifier_item_chomusuke:IsAuraActiveOnDeath() return false end
function modifier_item_chomusuke:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_chomusuke:DeclareFunctions()
	local func = { 	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_HEALTH_BONUS,
					MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_BONUS,}
	return func
end
function modifier_item_chomusuke:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('hp')
end
function modifier_item_chomusuke:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
function modifier_item_chomusuke:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mp')
end
function modifier_item_chomusuke:GetModifierBonusStats_Strength()
	return self.strength
end
function modifier_item_chomusuke:GetModifierBonusStats_Agility()
	return self.agility
end
function modifier_item_chomusuke:GetModifierBonusStats_Intellect()
	return self.intellect
end
function modifier_item_chomusuke:GetModifierPreAttack_BonusDamage()
	return 80
end
function modifier_item_chomusuke:GetEffectName()
	return "particles/chomusuke_burn.vpcf"
end

function modifier_item_chomusuke:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end
function modifier_item_chomusuke:GetAuraRadius()
	return 450
end
function modifier_item_chomusuke:GetAuraEntityReject(hEntity)
	if IsServer() then
		local modifier = hEntity:FindModifierByName("modifier_item_chomusuke_debuff")
		if self:GetParent() and not self:GetParent():IsNull() and self:GetParent():IsIllusion() and modifier and not modifier:IsNull() then
			local caster = modifier:GetCaster()
			if caster and not caster:IsNull() and not caster:IsIllusion() then
				return true
			end
		end

		return self:GetAbility():GetToggleState()
	end
end
function modifier_item_chomusuke:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_item_chomusuke:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_item_chomusuke:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_item_chomusuke:GetModifierAura()
	return "modifier_item_chomusuke_debuff"
end



function modifier_item_chomusuke:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.strength = self.ability:GetSpecialValueFor("bonus_strength")
	self.agility = self.ability:GetSpecialValueFor("bonus_agility")
	self.intellect = self.ability:GetSpecialValueFor("bonus_intellect")
	
end

function modifier_item_chomusuke:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/chomusuke_radiance.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_chomusuke_debuff = class({})
function modifier_item_chomusuke_debuff:IsHidden() return false end
function modifier_item_chomusuke_debuff:IsDebuff() return true end
function modifier_item_chomusuke_debuff:IsPurgable() return true end
function modifier_item_chomusuke_debuff:IsPurgeException() return true end
function modifier_item_chomusuke_debuff:RemoveOnDeath() return true end
--function modifier_item_chomusuke_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_chomusuke_debuff:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_MISS_PERCENTAGE,
					MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,}
	return func
end
function modifier_item_chomusuke_debuff:GetModifierMagicalResistanceBonus()
    return -10
end
function modifier_item_chomusuke_debuff:GetModifierMiss_Percentage()
	return self.miss_chance
end
function modifier_item_chomusuke_debuff:OnCreated(table)
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then
		return nil
	end

	self.miss_chance = 15
	

	self.damage 		 = 200
	self.damage_illusion = 20

	self.time = 0

	self.damage_table	 = {victim = self:GetParent(),
							attacker = self:GetCaster(), 
							ability = ability, 
							damage = self.damage, 
							damage_type = DAMAGE_TYPE_MAGICAL}

	if IsServer() then
		self._AnimeHamonTarget = 	ParticleManager:CreateParticle("particles/econ/events/ti10/radiance_ti10_glow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
									ParticleManager:SetParticleControl(self._AnimeHamonTarget, 0, self:GetParent():GetAbsOrigin())
									ParticleManager:SetParticleControl(self._AnimeHamonTarget, 1, self:GetCaster():GetAbsOrigin())

		self:AddParticle(self._AnimeHamonTarget, true, false, -1, false, false)

		self:StartIntervalThink(FrameTime())
	end
end
function modifier_item_chomusuke_debuff:OnIntervalThink()
	if IsServer() then
		if not self:GetCaster() or self:GetCaster():IsNull() or not self:GetCaster():IsAlive() or not self:GetParent() or self:GetParent():IsNull() or not self:GetParent():IsAlive() or not self:GetAbility() or self:GetAbility():IsNull() then
			self:Destroy()

			return nil
		end

		ParticleManager:SetParticleControl(self._AnimeHamonTarget, 1, self:GetCaster():GetAbsOrigin())

		self.time = self.time + FrameTime()
		if self.time >= 1 then
			self.time = 0
			
			if self:GetCaster():IsIllusion() then
				self.damage_table.damage = self.damage_illusion
			else
				self.damage_table.damage = self.damage 
			end
			
			ApplyDamage(self.damage_table)
		end
	end
end
function modifier_item_chomusuke_debuff:OnRefresh(table)
	self:OnCreated(table)
end