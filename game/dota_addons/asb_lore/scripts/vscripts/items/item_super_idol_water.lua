item_super_idol_water = class({})

LinkLuaModifier( "modifier_item_super_idol_water", "items/item_super_idol_water", LUA_MODIFIER_MOTION_NONE )

function item_super_idol_water:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
			local Player = PlayerResource:GetPlayer(target:GetPlayerID())

	if not target:HasModifier("modifier_hidnotea") then
	target:AddNewModifier(caster, self, "modifier_item_super_idol_water", { duration = 6.0 } )
	EmitSoundOn("item_idol_water_sound", caster)
	self:PlayEffects(target)
	end
end
function item_super_idol_water:PlayEffects( target )
	-- Load effects
	local particle_cast = "particles/econ/events/ti7/shivas_guard_active_ti7_intial_splash.vpcf"



	
	
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
modifier_item_super_idol_water = class({})

--------------------------------------------------------------------------------

function modifier_item_super_idol_water:IsHidden()
	return false
end
function modifier_item_super_idol_water:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		
	}
	return funcs
end






function modifier_item_super_idol_water:GetTexture()
	return "item_super_idol_water"
end

--------------------------------------------------------------------------------

function modifier_item_super_idol_water:GetModifierConstantHealthRegen( params )
	return 125
end

--------------------------------------------------------------------------------
function modifier_item_super_idol_water:GetModifierIncomingDamage_Percentage( params )
	if GameRules:GetGameTime() < 260 then

		return -30
		else
		return 0
	end
end


--------------------------------------------------------------------------------

function modifier_item_super_idol_water:GetModifierConstantManaRegen( params )
	return 60
end
function modifier_item_super_idol_water:GetEffectName()
	return "particles/econ/events/winter_major_2016/radiant_fountain_regen_wm_lvl2_a.vpcf"
end
