modifier_unthinkable_present = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_unthinkable_present:IsHidden()
	return false
end

function modifier_unthinkable_present:IsDebuff()
	return true
end

function modifier_unthinkable_present:IsStunDebuff()
	return false
end

function modifier_unthinkable_present:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_unthinkable_present:OnCreated( kv )
	if not IsServer() then return end
	-- play effects
	

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

function modifier_unthinkable_present:OnRefresh( kv )
	
end

function modifier_unthinkable_present:OnRemoved()
end

function modifier_unthinkable_present:OnDestroy()
	if not IsServer() then return end

	-- stop running
	self:GetParent():Stop()
	if self:GetParent():IsCreep() then
		self:GetParent():SetForceAttackTargetAlly( nil ) -- for creeps
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_unthinkable_present:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
	}

	return funcs
end

function modifier_unthinkable_present:GetModifierProvidesFOWVision()
	return 1
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_unthinkable_present:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = self.neutral,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_unthinkable_present:GetEffectName()
	return "particles/unthinkable_present.vpcf"
end
function modifier_unthinkable_present:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

