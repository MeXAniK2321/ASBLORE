chocolate = class({})
LinkLuaModifier( "modifier_chocolate", "modifiers/modifier_chocolate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chocolate_debuff", "modifiers/modifier_chocolate_debuff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function chocolate:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local ally = false
	if target:GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		ally = true
	end

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- add modifier
	if ally  then
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_chocolate", -- modifier name
		{ duration = duration } -- kv
	)
	else
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_chocolate_debuff", -- modifier name
		{ duration = duration } -- kv
	)
	end

	-- play effects
	local sound_cast = "chara.8"
	EmitSoundOn( sound_cast, caster )
end