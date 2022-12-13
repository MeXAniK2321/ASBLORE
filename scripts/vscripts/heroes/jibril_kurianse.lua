jibril_kurianse = class({})
LinkLuaModifier( "modifier_jibril_kurianse_thinker", "modifiers/modifier_jibril_kurianse_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jibril_kurianse_effect", "modifiers/modifier_jibril_kurianse_effect", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function jibril_kurianse:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function jibril_kurianse:GetCooldown( level )
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "cooldown_scepter" )
	end

	return self.BaseClass.GetCooldown( self, level )
end

--------------------------------------------------------------------------------
-- Ability Start
function jibril_kurianse:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor("duration")
	local vision = self:GetSpecialValueFor("vision_radius")

	-- create thinker
	self.thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_jibril_kurianse_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self.thinker = self.thinker:FindModifierByName("modifier_jibril_kurianse_thinker")

	-- create fov
	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision, duration, false)
end