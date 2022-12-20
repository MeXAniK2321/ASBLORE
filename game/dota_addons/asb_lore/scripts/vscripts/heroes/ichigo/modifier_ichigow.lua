modifier_ichigoW = class({})

--------------------------------------------------------------------------------
function modifier_ichigoW:IsHidden()
	return false
end

function modifier_ichigoW:IsDebuff()
	return false
end

function modifier_ichigoW:IsStunDebuff()
	return false
end

function modifier_ichigoW:IsPurgable()
	return false
end

function modifier_ichigoW:OnCreated(kv)
	if IsServer() then
		self.intelligence = 0
	end
end
--------------------------------------------------------------------------------
function modifier_ichigoW:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return funcs
end


function modifier_ichigoW:OnDestroy( kv )
	if not IsServer() then return end
end

function modifier_ichigoW:GetModifierBonusStats_Intellect()
    return self.intelligence
end