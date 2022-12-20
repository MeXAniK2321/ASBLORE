modifier_rimuru_merciless = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_rimuru_merciless:IsHidden()
	return false
end

function modifier_rimuru_merciless:IsDebuff()
	return false
end

function modifier_rimuru_merciless:IsStunDebuff()
	return false
end

function modifier_rimuru_merciless:IsPurgable()
	return false
end
function modifier_rimuru_merciless:RemoveOnDeath() return false end
--------------------------------------------------------------------------------
-- Initializations
function modifier_rimuru_merciless:OnCreated( kv )
	-- references
	

	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_rimuru_merciless:OnRefresh( kv )
	-- references
   
	local max_stack = 5

	if IsServer() then
		if self:GetStackCount()<max_stack then
			self:IncrementStackCount()
			
		end
	end
	 if self:GetStackCount() == 5 then
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_rimuru_harvest_begin", -- modifier name
		{} -- kv
	)
	end
end

function modifier_rimuru_merciless:OnDestroy( kv )

end