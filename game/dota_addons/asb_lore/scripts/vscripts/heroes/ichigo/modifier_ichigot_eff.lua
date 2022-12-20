modifier_ichigoT_eff = class({})

--------------------------------------------------------------------------------
function modifier_ichigoT_eff:IsHidden()
	return false
end

function modifier_ichigoT_eff:IsDebuff()
	return false
end

function modifier_ichigoT_eff:IsStunDebuff()
	return false
end

function modifier_ichigoT_eff:IsPurgable()
	return false
end

function modifier_ichigoT_eff:OnCreated(kv)
	if IsServer() then
		self.intelligence = 0

		self.DirTimer = Timers:CreateTimer(0.3,function ()
			if self.location ~= nil then
				self:GetParent():FaceTowards(self.location)
			end

			return 0
		end)
	end
end
--------------------------------------------------------------------------------
function modifier_ichigoT_eff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }

    return funcs
end


function modifier_ichigoT_eff:OnDestroy( kv )
	if not IsServer() then return end
	Timers:RemoveTimer(self.DirTimer)
end

function modifier_ichigoT_eff:GetModifierBonusStats_Intellect()
    return self.intelligence
end

function modifier_ichigoT_eff:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true
	}

	return state
end

--[[ function modifier_ichigoT_eff:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ORDER
    }

    return funcs
end

function modifier_ichigoT_eff:OnOrder(keys)
    self.position = Vector(keys.new_pos.x, keys.new_pos.y, 0)
	print("M")
end ]]

--------------------------------------------------------------------------------
function modifier_ichigoT_eff:GetEffectName()
	return "particles/ichigo_eff/ichigo_t/ichigo_t_charge1.vpcf"
end

function modifier_ichigoT_eff:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end