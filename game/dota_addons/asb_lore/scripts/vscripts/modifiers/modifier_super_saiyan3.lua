modifier_super_saiyan3 = class({})
function modifier_super_saiyan3:IsHidden() return true end
function modifier_super_saiyan3:IsDebuff() return true end
function modifier_super_saiyan3:IsPurgable() return false end
function modifier_super_saiyan3:IsPurgeException() return false end
function modifier_super_saiyan3:RemoveOnDeath() return true end
function modifier_super_saiyan3:AllowIllusionDuplicate() return true end

function modifier_super_saiyan3:GetEffectName()

	return "particles/gods_arrival_aura1.vpcf"
	end