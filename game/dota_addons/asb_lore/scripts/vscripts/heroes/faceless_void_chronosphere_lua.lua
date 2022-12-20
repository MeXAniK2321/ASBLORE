faceless_void_chronosphere_lua = class({})
LinkLuaModifier( "modifier_faceless_void_chronosphere_lua_thinker", "modifiers/modifier_faceless_void_chronosphere_lua_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_faceless_void_chronosphere_lua_effect", "modifiers/modifier_faceless_void_chronosphere_lua_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_esdeath_strike", "heroes/faceless_void_chronosphere_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function faceless_void_chronosphere_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end



--------------------------------------------------------------------------------
-- Ability Start
function faceless_void_chronosphere_lua:OnSpellStart()
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
		"modifier_faceless_void_chronosphere_lua_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self.thinker = self.thinker:FindModifierByName("modifier_faceless_void_chronosphere_lua_thinker")
     caster:AddNewModifier(self:GetCaster(), self, "modifier_esdeath_strike", {duration = duration})
	-- create fov
	AddFOWViewer( self:GetCaster():GetTeamNumber(), point, vision, duration, false)
	if self:GetCaster():HasModifier( "modifier_item_ultimate_scepter" ) then
	 EmitSoundOn("anime_chatwheel_non_sorted_1_7", caster)
	else
	 EmitSoundOn("Esdeath.timestop", caster) 
	end
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cooldown"))
end


modifier_esdeath_strike = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_esdeath_strike:IsHidden()
	return false
end

function modifier_esdeath_strike:IsDebuff()
	return false
end

function modifier_esdeath_strike:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_esdeath_strike:OnCreated( kv )
	-- references
	self.bonus = 12000 -- special value
	
end

function modifier_esdeath_strike:OnRefresh( kv )
	-- references
	self.bonus = 12000

end

function modifier_esdeath_strike:OnDestroy( kv )
  
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_esdeath_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}

	return funcs
end
function modifier_esdeath_strike:GetModifierMoveSpeedBonus_Constant()
  
	return 550
	end
  function modifier_esdeath_strike:GetModifierPreAttack_BonusDamage()
return self.bonus
end 

function modifier_esdeath_strike:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		-- effects
		local sound_cast = "Esdeath.fatal_blow"
		EmitSoundOn( sound_cast, params.target )
		self:PlayEffects(params.target)

		self:Destroy()
	end
end

function modifier_esdeath_strike:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_esdeath_strike:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/esdeath_fatal_blow.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetParent():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end