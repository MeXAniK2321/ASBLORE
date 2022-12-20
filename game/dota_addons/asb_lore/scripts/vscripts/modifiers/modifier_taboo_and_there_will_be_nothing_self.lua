modifier_taboo_and_there_will_be_nothing_self = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_taboo_and_there_will_be_nothing_self:IsHidden()
	return false
end

function modifier_taboo_and_there_will_be_nothing_self:IsDebuff()
	return false
end

function modifier_taboo_and_there_will_be_nothing_self:IsStunDebuff()
	return true
end

function modifier_taboo_and_there_will_be_nothing_self:IsPurgable()
	return false
end

function modifier_taboo_and_there_will_be_nothing_self:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_taboo_and_there_will_be_nothing_self:OnCreated( kv )

	self:GetParent():AddNoDraw()
end


function modifier_taboo_and_there_will_be_nothing_self:OnRefresh( kv )

	if not IsServer() then return end
end

function modifier_taboo_and_there_will_be_nothing_self:OnRemoved()
end

function modifier_taboo_and_there_will_be_nothing_self:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveNoDraw()
end

function modifier_taboo_and_there_will_be_nothing_self:CheckState()
	local state = {
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end


