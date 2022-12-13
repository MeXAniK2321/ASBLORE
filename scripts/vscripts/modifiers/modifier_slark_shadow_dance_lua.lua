modifier_slark_shadow_dance_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_shadow_dance_lua:IsHidden()
	return false
end

function modifier_slark_shadow_dance_lua:IsDebuff()
	return false
end

function modifier_slark_shadow_dance_lua:IsPurgable()
	return false
end
function modifier_slark_shadow_dance_lua:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
--------------------------------------------------------------------------------
-- Aura


--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_shadow_dance_lua:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "scepter_aoe" ) -- special value

	-- generate data
	self.parent = self:GetParent()==self:GetCaster()


	
	
end

function modifier_slark_shadow_dance_lua:OnRefresh( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "scepter_aoe" ) -- special value
	
	-- generate data
	self.parent = self:GetParent()==self:GetCaster()
	
end

function modifier_slark_shadow_dance_lua:OnDestroy( kv )
	if IsServer() then
		local sound_cast = "rumia_1"
		StopSoundOn( sound_cast, self:GetParent() )
	end
end

function modifier_slark_shadow_dance_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}

	return funcs
end

function modifier_slark_shadow_dance_lua:GetModifierInvisibilityLevel()
	return 2
end
function modifier_slark_shadow_dance_lua:CheckState()
    local state = { 
                    [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                    [MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
                    [MODIFIER_STATE_INVISIBLE] = true,
                    [MODIFIER_STATE_UNSELECTABLE] = true,
                    [MODIFIER_STATE_UNTARGETABLE] = true,
                }
    return state
end




function modifier_slark_shadow_dance_lua:GetStatusEffectName()
	return "particles/status_fx/status_effect_slark_shadow_dance.vpcf"
end

function modifier_slark_shadow_dance_lua:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_slark_shadow_dance_lua:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/slark_shadow_dance1.vpcf"


	-- Get Data
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent, parent:GetTeamNumber() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)



end

function modifier_slark_shadow_dance_lua:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf"

	-- Get Data
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, parent )
	ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, parent:GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self.effect_cast = effect_cast
end