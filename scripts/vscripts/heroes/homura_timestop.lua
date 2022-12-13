homura_timestop = class({})
LinkLuaModifier( "modifier_homura_timestop_thinker", "modifiers/modifier_homura_timestop_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_homura_timestop", "modifiers/modifier_homura_timestop", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_homura_timestop_effect", "modifiers/modifier_homura_timestop_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function homura_timestop:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("homura_grenade")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function homura_timestop:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function homura_timestop:GetCooldown( level )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "cooldown_scepter" )
	end

	return self.BaseClass.GetCooldown( self, level )
end

--------------------------------------------------------------------------------
-- Ability Start
function homura_timestop:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = caster:GetOrigin()

	-- load data
	local duration = self:GetSpecialValueFor("duration")
	local vision = self:GetSpecialValueFor("vision_radius")

	-- create thinker
	caster:AddNewModifier(caster, self, "modifier_homura_timestop", {duration = duration})
	self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_homura_timestop_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self.thinker = self.thinker:FindModifierByName("modifier_homura_timestop_thinker")
	if self:GetCaster():HasModifier( "modifier_item_ultimate_scepter" ) then
	EmitSoundOn("homura.kupola", caster)
	else
	EmitSoundOn("homura.4", caster)
	end
	

	-- create fov
	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision, duration, false)
end