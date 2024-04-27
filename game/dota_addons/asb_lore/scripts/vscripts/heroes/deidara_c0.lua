deidara_c0 = class({})
LinkLuaModifier( "modifier_deidara_c0", "modifiers/modifier_deidara_c0", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_muted", "modifiers/modifier_muted", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function deidara_c0:GetBehavior()
     return self:GetCaster():HasShard()
            and DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
            or self.BaseClass.GetBehavior(self)
end
function deidara_c0:OnSpellStart()
	local caster  = self:GetCaster()
	local hTarget = self:GetCursorTarget()
    
	if not IsNotNull(hTarget) then
	hTarget = caster
	end
    
	if not IsNotNull(caster) then
	return
	end
    
	hTarget:AddNewModifier(caster, self, "modifier_deidara_c0", {duration = 4})
	hTarget:AddNewModifier(caster, self, "modifier_muted", {duration = 4})
	EmitSoundOn("deidara.c0", caster)
end


