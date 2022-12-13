angeloid = class({})
LinkLuaModifier( "modifier_angeloid", "modifiers/modifier_angeloid", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Passive Modifier
function angeloid:GetIntrinsicModifierName()
	return "modifier_angeloid"
end
function angeloid:OnHeroLevelUp()
self.soul_max = 30
 local caster = self:GetCaster()
 local modifier = caster:FindModifierByName("modifier_angeloid")
local current = modifier:GetStackCount()
	local after = current + 1
		if after > self.soul_max then
			after = self.soul_max
	
	end
	
	modifier:SetStackCount( after )
	EmitSoundOn( "ikaros.sfx", self:GetCaster() )
end