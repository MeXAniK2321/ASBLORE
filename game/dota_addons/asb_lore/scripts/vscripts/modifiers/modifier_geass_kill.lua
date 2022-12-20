modifier_geass_kill = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_geass_kill:IsHidden()
	return false
end

function modifier_geass_kill:IsDebuff()
	return true
end

function modifier_geass_kill:IsStunDebuff()
	return false
end

function modifier_geass_kill:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_geass_kill:OnCreated( kv )
	if IsServer() then
		-- two not working...?
		-- self:GetParent():SetAggroTarget( self:GetCaster() )
		-- self:GetParent():SetAttacking( self:GetCaster() )
		self:GetParent():SetForceAttackTarget( self:GetCaster() ) -- for creeps
		self:GetParent():MoveToTargetToAttack( self:GetCaster() ) -- for heroes
	end
end

function modifier_geass_kill:OnRefresh( kv )
end

function modifier_geass_kill:OnRemoved()
	if IsServer() then
		self:GetParent():SetForceAttackTarget( nil )
	end
end

function modifier_geass_kill:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_geass_kill:CheckState()
	local state = {
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}

	return state
end
function modifier_geass_kill:DeclareFunctions()
	local func = { 
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					}
	return func
end
function  modifier_geass_kill:GetModifierMoveSpeedBonus_Constant()
    
    return 140
end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_geass_kill:GetStatusEffectName()
	return "particles/status_fx/status_effect_beserkers_call.vpcf"
end
