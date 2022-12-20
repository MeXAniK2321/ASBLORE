subaru_suffering = class({})
LinkLuaModifier( "modifier_subaru_suffering", "modifiers/modifier_subaru_suffering", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function subaru_suffering:GetIntrinsicModifierName()
	return "modifier_subaru_suffering"
end


