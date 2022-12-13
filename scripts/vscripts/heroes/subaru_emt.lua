subaru_emt = class({})
LinkLuaModifier( "modifier_subaru_emt", "modifiers/modifier_subaru_emt", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_fount_invul_effect", "modifiers/modifier_fount_invul_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_subaru_emt2", "modifiers/modifier_subaru_emt2", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function subaru_emt:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor("AbilityDuration")

	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_subaru_emt", -- modifier name
		{
			duration = duration,
			start = true,
		} -- kv
	)

	-- effects
	local sound_cast = "betty.4_1"
	EmitSoundOn( sound_cast, caster )
end

--------------------------------------------------------------------------------
-- Ability Channeling
-- function subaru_emt:GetChannelTime()

-- end

function subaru_emt:OnChannelFinish( bInterrupted )
	local delay = self:GetSpecialValueFor("sand_storm_invis_delay")
	self:GetCaster():AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_subaru_emt", -- modifier name
		{
			duration = delay,
			start = false,
		} -- kv
	)
	self:GetCaster():RemoveModifierByName("modifier_subaru_emt")
end