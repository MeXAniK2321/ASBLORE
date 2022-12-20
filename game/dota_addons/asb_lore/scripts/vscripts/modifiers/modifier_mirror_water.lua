modifier_mirror_water = class({})

-- Classifications
function modifier_mirror_water:IsHidden()
	return false
end

function modifier_mirror_water:IsDebuff()
	return false
end

function modifier_mirror_water:IsPurgable()
	return false
end

function modifier_mirror_water:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		
	}

	return state
end
function modifier_mirror_water:GetEffectName()
    return "particles/jellal_mirror_water.vpcf"
end