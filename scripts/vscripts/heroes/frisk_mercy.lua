frisk_mercy = class({})
LinkLuaModifier( "modifier_frisk_mercy", "modifiers/modifier_frisk_mercy", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- AOE Radius
function frisk_mercy:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function frisk_mercy:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("silent_kill")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function frisk_mercy:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration") + self:GetCaster():FindTalentValue("special_bonus_frisk_25")
	local hp = target:GetMaxHealth()
	local heal = hp * 0.5


	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_frisk_mercy", -- modifier name
		{ duration = duration } -- kv
	)

	-- heal
	target:Heal( heal, self )
	 target:Purge( false, true, false, true, false)

	-- Find Units in Radius
	

	local sound_cast = "frisk.4"
	EmitSoundOn( sound_cast, target )
end

--------------------------------------------------------------------------------
-- Ability Considerations
function frisk_mercy:AbilityConsiderations()
	-- Scepter
	local bScepter = caster:HasScepter()

	-- Linken & Lotus
	local bBlocked = target:TriggerSpellAbsorb( self )

	-- Break
	local bBroken = caster:PassivesDisabled()

	-- Advanced Status
	local bInvulnerable = target:IsInvulnerable()
	local bInvisible = target:IsInvisible()
	local bHexed = target:IsHexed()
	local bMagicImmune = target:IsMagicImmune()

	-- Illusion Copy
	local bIllusion = target:IsIllusion()
end

--------------------------------------------------------------------------------
