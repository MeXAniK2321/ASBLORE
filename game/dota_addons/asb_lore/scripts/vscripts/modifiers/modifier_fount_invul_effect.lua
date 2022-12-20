modifier_fount_invul_effect = class({})

-- Classifications
function modifier_fount_invul_effect:IsHidden()
	return false
end

function modifier_fount_invul_effect:IsDebuff()
	return false
end

function modifier_fount_invul_effect:IsPurgable()
	return false
end

function modifier_fount_invul_effect:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		
	}

	return state
end
function modifier_fount_invul_effect:GetTexture()
	return "betty_3"
end
