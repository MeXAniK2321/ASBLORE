LinkLuaModifier( "modifier_fount_invul_effect", "modifiers/modifier_fount_invul_effect", LUA_MODIFIER_MOTION_NONE )
modifier_fount_invul = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_fount_invul:IsHidden()
	return true
end

function modifier_fount_invul:IsDebuff()
	return false
end

function modifier_fount_invul:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
-- Aura
function modifier_fount_invul:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_fount_invul:GetModifierAura()
	return "modifier_fount_invul_effect"
end

function modifier_fount_invul:GetAuraRadius()
	return 1500
end
function modifier_fount_invul:GetAuraDuration()
	return 0.1
end
function modifier_fount_invul:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_fount_invul:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end