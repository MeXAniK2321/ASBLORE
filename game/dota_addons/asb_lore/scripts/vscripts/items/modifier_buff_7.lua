modifier_buff_7 = class({})

function modifier_buff_7:IsHidden()
	return false
end
function modifier_buff_7:RemoveOnDeath() return true end
function modifier_buff_7:AllowIllusionDuplicate()
	return true
end

function modifier_buff_7:IsPurgable()
    return false
end

function modifier_buff_7:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
       
        
		
    }

    return funcs
end

function modifier_buff_7:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:GetParent():Heal(params.damage * 0.15, nil)
			
			
			end
		end
	end


function modifier_buff_7:GetTexture()
	return "note"
end
function modifier_buff_7:GetEffectName()
	return "particles/vampirism_chance.vpcf"
end