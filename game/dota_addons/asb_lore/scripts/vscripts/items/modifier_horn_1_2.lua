modifier_horn_1_2 = class({})

function modifier_horn_1_2:IsHidden()
	return false
end
function modifier_horn_1_2:RemoveOnDeath() return false end
function modifier_horn_1_2:AllowIllusionDuplicate()
	return false
end

function modifier_horn_1_2:IsPurgable()
    return false
end

function modifier_horn_1_2:DeclareFunctions()
    local funcs = {
      	MODIFIER_EVENT_ON_TAKEDAMAGE,
       
        
		
    }

    return funcs
end

function modifier_horn_1_2:OnTakeDamage(params)
	if IsServer() then
	local caster = self:GetParent()
		if params.attacker == caster then
		if not params.attacker:IsIllusion() then
		if params.unit == caster then return end
		if not self:GetParent():HasModifier("modifier_horn_truth_cd") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_horn_truth_cd", {duration = 6.0 })
		params.unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_doki_doki", {duration = 5.0 })
		

			end
		end
	end
end
end
function modifier_horn_1_2:GetEffectName()
	return "particles/doki_doki_chance.vpcf"
end

function modifier_horn_1_2:GetTexture()
	return "note"
end
