modifier_shinobu_annoing = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_shinobu_annoing:IsHidden()
	return false
end

function modifier_shinobu_annoing:IsDebuff()
	return true
end

function modifier_shinobu_annoing:IsStunDebuff()
	return false
end

function modifier_shinobu_annoing:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_shinobu_annoing:OnCreated( kv )
	-- references
	self.armor_stack = self:GetAbility():GetSpecialValueFor( "armor_per_stack" ) 


	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_shinobu_annoing:OnRefresh( kv )
	-- references
	self.armor_stack = self:GetAbility():GetSpecialValueFor( "armor_per_stack" ) 
	local max_stack = 10

	if IsServer() then
		if self:GetStackCount()<max_stack then
			self:IncrementStackCount()
		end
	end
end

function modifier_shinobu_annoing:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_shinobu_annoing:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end
function modifier_shinobu_annoing:GetModifierPhysicalArmorBonus()
	return -self.armor_stack * self:GetStackCount()
end


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_shinobu_annoing:GetEffectName()
	return "particles/shinobu_annoing_debuff.vpcf"
end

function modifier_shinobu_annoing:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end