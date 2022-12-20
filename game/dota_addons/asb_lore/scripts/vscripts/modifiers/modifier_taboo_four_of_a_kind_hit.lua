modifier_taboo_four_of_a_kind_hit = class({})

function modifier_taboo_four_of_a_kind_hit:IsHidden()
	return true
end

function modifier_taboo_four_of_a_kind_hit:IsPurgable()
    return false
end

function modifier_taboo_four_of_a_kind_hit:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_taboo_four_of_a_kind_hit:DeclareFunctions()
    local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }

    return funcs
end

function modifier_taboo_four_of_a_kind_hit:OnAttackLanded( keys )
    if not IsServer() then return end
    local attacker = self:GetParent()

    if attacker ~= keys.attacker then
        return
    end

    local target = keys.target

    if attacker:GetTeam() == target:GetTeam() then
        return 
    end 
    if target:IsOther() then
        return nil
    end

    
    

	
		keys.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_taboo_four_of_a_kind_hit_debuff", {duration = 0.5})
	
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_kill", -- modifier name
		{ duration = 0.1 } -- kv
	)
end