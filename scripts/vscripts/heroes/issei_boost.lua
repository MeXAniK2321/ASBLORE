issei_boost = class({})
LinkLuaModifier( "modifier_issei_boost", "modifiers/modifier_issei_boost", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_juggernaut_drive_unlocked", "modifiers/modifier_issei_boost", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function issei_boost:OnSpellStart()

 local caster = self:GetCaster()
	 caster:AddNewModifier(caster, self, "modifier_issei_boost", {})
	

	self:PlayEffects()
end

function issei_boost:PlayEffects()
  
	local sound_cast = "issei.2"
	

	-- play particles

	-- play sounds
	EmitSoundOn(sound_cast, self:GetCaster())
end
