modifier_minya = class({})
function modifier_minya:IsHidden() return false end
function modifier_minya:IsDebuff() return false end
function modifier_minya:IsPurgable() return true end
function modifier_minya:IsPurgeException() return true end
function modifier_minya:RemoveOnDeath() return true end

function modifier_minya:DeclareFunctions()
	local func = {	
					
					
					}
	return func
end

function modifier_minya:OnCreated(hTable)
    if IsServer() then
        local ability = self:GetParent():FindAbilityByName("minya_arrow")
        if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
    end
	if IsServer() then
        local ability = self:GetParent():FindAbilityByName("minya_arrow_2")
        if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
    end
	if IsServer() then
        local ability = self:GetParent():FindAbilityByName("minya_arrow_3")
        if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
    end
end
function modifier_minya:OnDestroy()
    if IsServer() then
        local ability = self:GetParent():FindAbilityByName("minya_arrow")
        if ability and ability:IsActivated() then
            ability:SetActivated(false)
        end
    end
	if IsServer() then
        local ability = self:GetParent():FindAbilityByName("minya_arrow_2")
        if ability and ability:IsActivated() then
            ability:SetActivated(false)
        end
    end
	if IsServer() then
        local ability = self:GetParent():FindAbilityByName("minya_arrow_3")
        if ability and ability:IsActivated() then
            ability:SetActivated(false)
        end
    end
end

function modifier_minya:GetEffectName()
	return "particles/minya.vpcf"
end
function modifier_minya:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end