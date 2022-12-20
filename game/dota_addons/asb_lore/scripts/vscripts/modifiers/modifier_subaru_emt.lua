modifier_subaru_emt = class({})

--------------------------------------------------------------------------------

function modifier_subaru_emt:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_subaru_emt:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_subaru_emt:GetModifierAura()
	return "modifier_subaru_emt2"
end

--------------------------------------------------------------------------------

function modifier_subaru_emt:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_subaru_emt:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end
function modifier_subaru_emt:GetEffectName()
	return "particles/subaru_emt.vpcf"
end
function modifier_subaru_emt:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

--function modifier_vengefulspirit_command_aura_lua:GetAuraSearchFlags()
--	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
--end

--------------------------------------------------------------------------------

function modifier_subaru_emt:GetAuraRadius()
	return 600
end