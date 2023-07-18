modifier_fountain_aura_lua = class({})

function modifier_fountain_aura_lua:IsHidden() return true end
function modifier_fountain_aura_lua:IsDebuff() return false end
function modifier_fountain_aura_lua:IsPurgable() return false end
function modifier_fountain_aura_lua:IsPurgeException() return false end
function modifier_fountain_aura_lua:RemoveOnDeath() return false end
function modifier_fountain_aura_lua:IsAura() return true end
function modifier_fountain_aura_lua:IsAuraActiveOnDeath() return false end
function modifier_fountain_aura_lua:IsPermanent() return true end
function modifier_fountain_aura_lua:GetModifierAura()
	return "modifier_fountain_aura_effect_lua"
end
function modifier_fountain_aura_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_fountain_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

--function modifier_vengefulspirit_command_aura_lua:GetAuraSearchFlags()
--	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
--end

--------------------------------------------------------------------------------
function modifier_fountain_aura_lua:GetAuraRadius()
	return 1300
end
function modifier_fountain_aura_lua:GetAuraDuration()
	return 3
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_fountain_aura_linken_lua = class({})

function modifier_fountain_aura_linken_lua:IsHidden()
	return false
end
function modifier_fountain_aura_linken_lua:IsAura()
	return true
end
function modifier_fountain_aura_linken_lua:GetModifierAura()
	return "modifier_item_sphere_target"
end
function modifier_fountain_aura_linken_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_fountain_aura_linken_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------
function modifier_fountain_aura_linken_lua:GetAuraRadius()
	return 1300
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------