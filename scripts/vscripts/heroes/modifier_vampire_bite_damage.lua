modifier_vampire_bite_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_vampire_bite_damage:IsHidden()
	return true
end

function modifier_vampire_bite_damage:IsDebuff()
	return false
end

function modifier_vampire_bite_damage:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_vampire_bite_damage:OnCreated( kv )
	-- references

	self.bonus_crit = self:GetAbility():GetSpecialValueFor( "crit_mult" )
end

function modifier_vampire_bite_damage:OnRefresh( kv )
end

function modifier_vampire_bite_damage:OnRemoved()
end

function modifier_vampire_bite_damage:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_vampire_bite_damage:DeclareFunctions()
	local funcs = {
	
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}

	return funcs
end


function modifier_vampire_bite_damage:GetModifierPreAttack_CriticalStrike( params )
	return self.bonus_crit
end