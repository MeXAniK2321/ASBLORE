modifier_duel_chrono = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_duel_chrono:OnCreated( kv )
	-- references
	self.radius = 999999

	if IsServer() then
	end
end



function modifier_duel_chrono:OnRemoved()
end

function modifier_duel_chrono:OnDestroy()
	if IsServer() then
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_duel_chrono:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_duel_chrono:IsAura()
	return true
end

function modifier_duel_chrono:GetModifierAura()
	return "modifier_duel_chrono_effect"
end

function modifier_duel_chrono:GetAuraRadius()
	return self.radius
end

function modifier_duel_chrono:GetAuraDuration()
	return 0.01
end

function modifier_duel_chrono:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_BOTH
end

function modifier_duel_chrono:GetAuraSearchType()
	return DOTA_UNIT_TARGET_ALL
end

function modifier_duel_chrono:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end

function modifier_duel_chrono:GetAuraEntityReject( hEntity )
	if IsServer() then
		-- -- reject if owner
		-- if hEntity==self:GetCaster() then return true end

		-- -- reject if owner controlled
		-- if hEntity:GetPlayerOwnerID()==self:GetCaster():GetPlayerOwnerID() then return true end

		-- reject if unit is named faceless void
		if hEntity:HasModifier("modifier_duel_unit_passive") or hEntity:HasAbility("duel_unit_passive") or hEntity:GetUnitName()=="npc_duel_box" then return true end
	end

	return false
end


modifier_duel_chrono_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_duel_chrono_effect:IsHidden()
	return false
end

function modifier_duel_chrono_effect:IsDebuff()
	return true
end

function modifier_duel_chrono_effect:IsStunDebuff()
	return true
end

function modifier_duel_chrono_effect:IsPurgable()
	return false
end

function modifier_duel_chrono_effect:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end


--------------------------------------------------------------------------------
-- Initializations
function modifier_duel_chrono_effect:OnCreated( kv )
	self.speed = 1000

	if IsServer() then
		
			self:GetParent():InterruptMotionControllers( false )
	
		end
	end


function modifier_duel_chrono_effect:OnRefresh( kv )
	
end

function modifier_duel_chrono_effect:OnRemoved()
end

function modifier_duel_chrono_effect:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects


--------------------------------------------------------------------------------
-- Status Effects
function modifier_duel_chrono_effect:CheckState()

	local state2 = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
return state2
end

 function modifier_duel_chrono_effect:DeclareFunctions()
	local func = { 
					
					MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
					MODIFIER_PROPERTY_DISABLE_HEALING,   
					}
	return func
end
function modifier_duel_chrono_effect:GetModifierIncomingDamage_Percentage( params )
	

		return -200
	end
	function modifier_duel_chrono_effect:GetDisableHealing()
	return 1
end
