modifier_aksel_building_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aksel_building_debuff:IsHidden()
	return false
end

function modifier_aksel_building_debuff:IsDebuff()
	return true
end

function modifier_aksel_building_debuff:IsStunDebuff()
	return true
end

function modifier_aksel_building_debuff:IsPurgable()
	return true
end

function modifier_aksel_building_debuff:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_aksel_building_debuff:OnCreated( kv )
	if not IsServer() then return end
	self.projectile = kv.projectile
end

function modifier_aksel_building_debuff:OnRefresh( kv )
end

function modifier_aksel_building_debuff:OnRemoved()
	if not IsServer() then return end
	-- destroy tree
	GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 120, false )
end

function modifier_aksel_building_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_aksel_building_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_aksel_building_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_aksel_building_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_aksel_building_debuff:GetEffectName()
	return "particles/mars_spear_impact_debuff2.vpcf"
end

function modifier_aksel_building_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_aksel_building_debuff:GetStatusEffectName()
	return "particles/status_effect_mars_spear2.vpcf"
end