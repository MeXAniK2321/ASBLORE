artemis_launcher = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_artemis_launcher", "modifiers/modifier_artemis_launcher", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function artemis_launcher:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	self.target = self:GetCursorTarget()


	
     self.target:AddNewModifier(caster, ability, "modifier_artemis_launcher",{duration = 0.5})
	

	self:PlayEffects1()
end


function artemis_launcher:PlayEffects1()
	-- Get Resources
	local sound_cast = "ikaros.5_2"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end

