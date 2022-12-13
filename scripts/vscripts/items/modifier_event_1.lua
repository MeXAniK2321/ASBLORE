modifier_event_1 = class({})

function modifier_event_1:IsHidden()
	return false
end
function modifier_event_1:RemoveOnDeath() return true end
function modifier_event_1:AllowIllusionDuplicate()
	return false
end

function modifier_event_1:IsPurgable()
    return false
end

function modifier_event_1:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
       
        
		
    }

    return funcs
end
function modifier_event_1:GetModifierPreAttack_BonusDamage()
    return 400
end
function modifier_event_1:GetModifierSpellAmplify_Percentage()
    return 75
end

function modifier_event_1:OnTakeDamage(keys)
	if IsServer() then
    local caster = self:GetCaster()
	
		local attacker = keys.attacker
	local target = keys.unit
	
	
				
			
			
		   
			
				
				if self:GetParent():GetHealth() <= 20 then
				if not self:GetParent():IsIllusion() then
				local hp = self:GetParent():GetMaxHealth() * 0.8
			     
				 self:GetParent():SetHealth(hp)
				
					
					self:Destroy()
					
					
					return
				end
               
		end
			end
		end
function modifier_event_1:OnDestroy()
	StopGlobalSound("star.event_1")
	
end

function modifier_event_1:GetTexture()
	return "note"
end
function modifier_event_1:GetEffectName()
	return "particles/event_1.vpcf"
end