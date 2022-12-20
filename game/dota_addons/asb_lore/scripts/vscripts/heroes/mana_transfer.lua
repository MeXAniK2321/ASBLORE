mana_transfer = class({})


--------------------------------------------------------------------------------
-- Ability Start
mana_transfer.modifiers = {}
function mana_transfer:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local mana = self:GetSpecialValueFor("mana")
    if target:GetUnitName()== "npc_dota_hero_night_stalker" then
	target:ReduceMana( mana )
	caster:GiveMana( mana )
	

	-- play effects
	self.sound_cast = "betty.4"
	EmitSoundOn( self.sound_cast, caster )
	else
	end
end