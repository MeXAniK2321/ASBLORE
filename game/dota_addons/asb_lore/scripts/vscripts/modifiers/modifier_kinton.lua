modifier_kinton = class({})
function modifier_kinton:IsHidden() return false end
function modifier_kinton:IsDebuff() return false end
function modifier_kinton:IsPurgable() return true end
function modifier_kinton:IsPurgeException() return true end
function modifier_kinton:RemoveOnDeath() return true end

function modifier_kinton:DeclareFunctions()
	local func = {	
					
					
					}
	return func
end

function modifier_kinton:OnCreated(hTable)
    if IsServer() then
        local ability = self:GetParent():FindAbilityByName("kinton_lightning")
        if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
    end
end
function modifier_kinton:OnDestroy()
    if IsServer() then
        local ability = self:GetParent():FindAbilityByName("kinton_lightning")
        if ability and ability:IsActivated() then
            ability:SetActivated(false)
        end
    end
end

function modifier_kinton:GetEffectName()
	return "particles/kinton.vpcf"
end
function modifier_kinton:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end