modifier_horn_1_1 = class({})

function modifier_horn_1_1:IsHidden()
	return false
end
function modifier_horn_1_1:RemoveOnDeath() return false end
function modifier_horn_1_1:AllowIllusionDuplicate()
	return false
end

function modifier_horn_1_1:IsPurgable()
    return false
end

function modifier_horn_1_1:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
MODIFIER_EVENT_ON_ATTACK_LANDED,
MODIFIER_EVENT_ON_TAKEDAMAGE,		
       
        
		
    }

    return funcs
end

function modifier_horn_1_1:GetModifierConstantHealthRegen()
    return 70
end
function modifier_horn_1_1:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:GetParent():Heal(params.damage * 0.25, nil)
			
			
			end
		end
	end
function modifier_horn_1_1:OnTakeDamage(keys)
	if IsServer() then
	self.parent = self:GetParent()
		if keys.attacker == self.parent and keys.inflictor ~= self:GetAbility() then
		

			local flags = 0
			if keys.inflictor then
				flags = keys.inflictor:GetAbilityTargetFlags()
			end
		
				--print(keys.original_damage, "STONE ORIG, DAMAGE")
               
                local heal = keys.damage * 0.25
             	self.parent:Heal( heal, self:GetParent() )
			end
		end
	end

function modifier_horn_1_1:GetTexture()
	return "note"
end
function modifier_horn_1_1:GetEffectName()
	return "particles/heal_great.vpcf"
end