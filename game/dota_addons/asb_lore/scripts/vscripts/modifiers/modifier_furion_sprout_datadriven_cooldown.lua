modifier_furion_sprout_datadriven_cooldown = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_furion_sprout_datadriven_cooldown:IsHidden()
	return true
end

function modifier_furion_sprout_datadriven_cooldown:IsDebuff()
	return true
end

function modifier_furion_sprout_datadriven_cooldown:IsPurgable()
	return false
end

function modifier_furion_sprout_datadriven_cooldown:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_furion_sprout_datadriven_cooldown:OnCreated( kv )

end

function modifier_furion_sprout_datadriven_cooldown:OnRefresh( kv )
	
end

function modifier_furion_sprout_datadriven_cooldown:OnRemoved()
end

function modifier_furion_sprout_datadriven_cooldown:OnDestroy()
end