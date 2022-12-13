modifier_dreams_buff = class({})
function modifier_dreams_buff:IsHidden() return false end
function modifier_dreams_buff:IsDebuff() return false end
function modifier_dreams_buff:IsPurgable() return false end
function modifier_dreams_buff:IsPurgeException() return false end
function modifier_dreams_buff:RemoveOnDeath() return true end
function modifier_dreams_buff:CheckState()
	local state = {	[MODIFIER_STATE_MAGIC_IMMUNE] = true,}
	return state
end
function modifier_dreams_buff:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_MODEL_SCALE,
					 }
	return func
end
function modifier_dreams_buff:GetModifierModelScale()
	return self.scale
end

function modifier_dreams_buff:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.scale = self.ability:GetSpecialValueFor("model_scale")
	
end
function modifier_dreams_buff:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_dreams_buff:GetEffectName()
	return "particles/dreams_buff.vpcf"
end
function modifier_dreams_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_avatar.vpcf"
end
function modifier_dreams_buff:StatusEffectPriority()
	return 10
end
function modifier_dreams_buff:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end