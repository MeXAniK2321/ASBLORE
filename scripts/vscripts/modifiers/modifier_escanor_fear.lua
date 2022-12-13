--------------------------------------------------------------------------------
modifier_escanor_fear = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_escanor_fear:IsHidden()
	return false
end

function modifier_escanor_fear:IsDebuff()
	return true
end

function modifier_escanor_fear:IsStunDebuff()
	return false
end

function modifier_escanor_fear:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_escanor_fear:OnCreated( kv )
	if not IsServer() then return end
	-- play effects
	self:PlayEffects()
	self.speed = self:GetAbility():GetSpecialValueFor("speed")

	-- if neutral, set disarm to run back towards camp
	if self:GetParent():IsNeutralUnitType() then
		self.neutral = true
	end

	-- find enemy fountain
	local buildings = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		Vector(0,0,0),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local fountain = nil
	for _,building in pairs(buildings) do
		if building:GetClassname()=="ent_dota_fountain" then
			fountain = building
			break
		end
	end

	-- if no fountain, just don't do anything
	if not fountain then return end

	-- for lane creep, MoveToPosition won't work, so use this
	if self:GetParent():IsCreep() then
		self:GetParent():SetForceAttackTargetAlly( fountain ) -- for creeps
	end

	-- for others, order to run to fountain
	self:GetParent():MoveToPosition( fountain:GetOrigin() )
end

function modifier_escanor_fear:OnRefresh( kv )
	self.speed = self:GetAbility():GetSpecialValueFor("speed")
end

function modifier_escanor_fear:OnRemoved()
end

function modifier_escanor_fear:OnDestroy()
	if not IsServer() then return end

	-- stop running
	self:GetParent():Stop()
	if self:GetParent():IsCreep() then
		self:GetParent():SetForceAttackTargetAlly( nil ) -- for creeps
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_escanor_fear:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}

	return funcs
end


function modifier_escanor_fear:GetModifierMoveSpeed_AbsoluteMin()
     self.speed = self:GetAbility():GetSpecialValueFor("speed")
	 return self.speed
	 end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_escanor_fear:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = self.neutral,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_escanor_fear:GetStatusEffectName()
	return "particles/status_fx/status_effect_dark_willow_wisp_fear.vpcf"
end

function modifier_escanor_fear:PlayEffects()
	-- Get Resources
	local particle_cast1 = ""
	local particle_cast2 = ""

	-- Create Particle
	-- local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	-- local effect_cast2 = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	local effect_cast1 = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast1, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	local effect_cast2 = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

	-- buff particle
	self:AddParticle(
		effect_cast1,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
	self:AddParticle(
		effect_cast2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end