modifier_uranys_system_initialization = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_uranys_system_initialization:IsHidden()
	return false
end

function modifier_uranys_system_initialization:IsDebuff()
	return false
end

function modifier_uranys_system_initialization:IsStunDebuff()
	return false
end

function modifier_uranys_system_initialization:IsPurgable()
	return false
end
function modifier_uranys_system_initialization:RemoveOnDeath() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_uranys_system_initialization:OnCreated( kv )
	-- references
	

	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_uranys_system_initialization:OnRefresh( kv )
	-- references
   
	local max_stack = 6

	if IsServer() then
		if self:GetStackCount()<max_stack then
			self:IncrementStackCount()
			
		end
	end
	 if self:GetStackCount() == 6 then
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_uranys_system_launched", -- modifier name
		{} -- kv
	)
	end
end

function modifier_uranys_system_initialization:OnDestroy( kv )

end

