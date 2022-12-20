modifier_taboo_spirits_of_the_past = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_taboo_spirits_of_the_past:IsHidden()
	return false
end

function modifier_taboo_spirits_of_the_past:IsDebuff()
	return true
end

function modifier_taboo_spirits_of_the_past:IsStunDebuff()
	return false
end

function modifier_taboo_spirits_of_the_past:IsPurgable()
	return true
end

function modifier_taboo_spirits_of_the_past:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_taboo_spirits_of_the_past:OnCreated( kv )
	-- references


	 local caster = self:GetCaster()
    local duration = 1.5
    local incoming = 100
    local outgoing = 100
    local clones = 1 



    for i = 1,clones do
        local clone = CreateIllusionForPlayer(caster, caster, caster, self, self:GetParent():GetAbsOrigin() + RandomVector(100), duration, 1, incoming, outgoing)
    end
	end


function modifier_taboo_spirits_of_the_past:OnRefresh( kv )
	
end  

function modifier_taboo_spirits_of_the_past:OnRemoved()
end

function modifier_taboo_spirits_of_the_past:OnDestroy()
	if not IsServer() then return end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_taboo_spirits_of_the_past:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end



--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_taboo_spirits_of_the_past:GetEffectName()
	return "particles/void_spirit_astral_step_debuff1.vpcf"
end

function modifier_taboo_spirits_of_the_past:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_taboo_spirits_of_the_past:GetStatusEffectName()
	return "particles/void_spirit_astral_step_debuff1.vpcf"
end

function modifier_taboo_spirits_of_the_past:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end

function modifier_taboo_spirits_of_the_past:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/taboo_spirits_of_the_past_blood.vpcf"
	local sound_target = "flandr.4_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end