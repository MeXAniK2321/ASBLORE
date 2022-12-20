modifier_ryougi_shikiE_deb = class({})

--------------------------------------------------------------------------------
function modifier_ryougi_shikiE_deb:IsHidden()
	return false
end

function modifier_ryougi_shikiE_deb:IsDebuff()
	return false
end

function modifier_ryougi_shikiE_deb:IsStunDebuff()
	return false
end

function modifier_ryougi_shikiE_deb:IsPurgable()
	return false
end

function modifier_ryougi_shikiE_deb:OnCreated(kv)
	if IsServer() then
		self.intelligence = 0
	end
end
--------------------------------------------------------------------------------
function modifier_ryougi_shikiE_deb:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return funcs
end


function modifier_ryougi_shikiE_deb:OnDestroy( kv )
end

function modifier_ryougi_shikiE_deb:GetModifierBonusStats_Intellect()
    return self.intelligence
end
