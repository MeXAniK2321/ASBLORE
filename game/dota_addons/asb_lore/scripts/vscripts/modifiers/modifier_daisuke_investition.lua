modifier_daisuke_investition = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_daisuke_investition:IsHidden()
	return false
end

function modifier_daisuke_investition:IsDebuff()
	return false
end

function modifier_daisuke_investition:IsPurgable()
	return false
end

function modifier_daisuke_investition:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_daisuke_investition:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_daisuke_investition:OnCreated( kv )
	self.kill = 150
	self.bonus_gold = self:GetAbility():GetSpecialValueFor( "gold" ) 
	self:StartIntervalThink(1)
		if IsServer() then
		self:SetStackCount(0)
	end
end

function modifier_daisuke_investition:OnRefresh( kv )
		self.bonus_gold = self:GetAbility():GetSpecialValueFor( "gold" )
end

function modifier_daisuke_investition:OnRemoved()
 
end

function modifier_daisuke_investition:OnDestroyed()

end
function modifier_daisuke_investition:OnIntervalThink()

	if self:GetParent():IsAlive() then
	self:AddStack(1)
		PlayerResource:ModifyGold( self:GetParent():GetPlayerOwnerID(), self.bonus_gold, false, DOTA_ModifyGold_Unspecified )
	end
end

function modifier_daisuke_investition:AddStack( value )
	local current = self:GetStackCount()
	local after = current + value
		if after > self.kill then
			after = self.kill
		end
	self:SetStackCount( after )
end