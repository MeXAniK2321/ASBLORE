modifier_angeloid = class({})

--------------------------------------------------------------------------------

function modifier_angeloid:IsHidden()
	return false
end

function modifier_angeloid:IsDebuff()
	return false
end

function modifier_angeloid:IsPurgable()
	return false
end

function modifier_angeloid:RemoveOnDeath()
	return false
end
function modifier_angeloid:AllowIllusionDuplicate()
 return false 
 end
--------------------------------------------------------------------------------

function modifier_angeloid:OnCreated( kv )
   local current = self:GetStackCount()

	if IsServer() then
	if current < 1 then 
		self:SetStackCount(1)
		else
	end
	end
	self.soul_max = 30
end
function modifier_angeloid:OnRefresh( kv )
 self:OnCreated(kv)
 self.soul_max = 30
end

--------------------------------------------------------------------------------

function modifier_angeloid:DeclareFunctions()
	local funcs = {
		 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}

	return funcs
end


----
----------------------------------------------------------------------------


function modifier_angeloid:GetModifierBonusStats_Intellect( params )
	if not self:GetParent():IsIllusion() then
		local max_stack = self.soul_max
		
			return math.min(self.soul_max,self:GetStackCount()) * 1 
		end
	end

function modifier_angeloid:GetModifierBonusStats_Agility( params )
	if not self:GetParent():IsIllusion() then
		local max_stack = self.soul_max
		
			return math.min(self.soul_max,self:GetStackCount()) * 1
		end
	end

function modifier_angeloid:GetModifierBonusStats_Strength( params )
	if not self:GetParent():IsIllusion() then
		local max_stack = self.soul_max
		
			return math.min(self.soul_max,self:GetStackCount()) * 1
		end
	end


--------------------------------------------------------------------------------




