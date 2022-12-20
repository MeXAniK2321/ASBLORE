modifier_artemis_launcher = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_artemis_launcher:IsHidden()
	return false
end

function modifier_artemis_launcher:IsDebuff()
	return true
end

function modifier_artemis_launcher:IsStunDebuff()
	return false
end

function modifier_artemis_launcher:IsPurgable()
return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_artemis_launcher:OnCreated( kv )

	self.interval = 0.1
		-- Start interval
		self:StartIntervalThink( self.interval )
		


	
end

function modifier_artemis_launcher:OnRefresh( kv )
	-- references	
		self:StartIntervalThink( self.interval )

	
end

function modifier_artemis_launcher:OnDestroy()

end


function modifier_artemis_launcher:OnIntervalThink()
local caster = self:GetCaster()

	caster:PerformAttack(
				self:GetParent(),
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
end








