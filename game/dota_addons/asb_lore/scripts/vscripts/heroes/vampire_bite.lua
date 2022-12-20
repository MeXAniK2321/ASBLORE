vampire_bite = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vampire_bite", "modifiers/modifier_vampire_bite", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vampire_bite_damage", "heroes/modifier_vampire_bite_damage", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV


function vampire_bite:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()



if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local damage = self:GetAbilityDamage()
	local duration = self:GetSpecialValueFor( "stun_duration" )
    
	-- damage
	local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_vampire_bite_damage", -- modifier name
		{  } -- kv
	)
	caster:PerformAttack(
				target,
				true,
				true,
				true,
				true,
				true,
				false,
				true
			)
 

    target:AddNewModifier(caster, self, "modifier_vampire_bite", {duration = duration})
	target:AddNewModifier(caster, self, "modifier_generic_stunned_lua", {duration = 1})
	
	ApplyDamage(damageTable)
	self:PlayEffects(target)
	buff:Destroy()
	if caster:HasModifier("modifier_kisshot") then
	EmitSoundOn("Shinobu.3_ts", caster)
	else
	EmitSoundOn("Shinobu.Donut", caster)
	end
end
function vampire_bite:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/chara_blood2.vpcf"
	local sound_cast = ""

	-- Get Data
	local forward = (target:GetOrigin()-self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 2, forward )
	ParticleManager:SetParticleControlForward( effect_cast, 5, forward )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end