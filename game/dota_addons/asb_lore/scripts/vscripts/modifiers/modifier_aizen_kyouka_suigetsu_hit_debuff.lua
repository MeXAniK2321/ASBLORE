modifier_aizen_kyouka_suigetsu_hit_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_aizen_kyouka_suigetsu_hit_debuff:IsHidden()
	return false
end

function modifier_aizen_kyouka_suigetsu_hit_debuff:IsDebuff()
	return true
end

function modifier_aizen_kyouka_suigetsu_hit_debuff:IsStunDebuff()
	return false
end

function modifier_aizen_kyouka_suigetsu_hit_debuff:IsPurgable()
	return true
end

function modifier_aizen_kyouka_suigetsu_hit_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_aizen_kyouka_suigetsu_hit_debuff:OnCreated( kv )
	-- references
	self.duration = 0.2
	

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	local sound_cast = ""
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_aizen_kyouka_suigetsu_hit_debuff:OnRefresh( kv )
	
end

function modifier_aizen_kyouka_suigetsu_hit_debuff:OnRemoved()
end

function modifier_aizen_kyouka_suigetsu_hit_debuff:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_aizen_kyouka_suigetsu_hit_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_aizen_kyouka_suigetsu_hit_debuff:GetModifierProvidesFOWVision()
	return 1
end

function modifier_aizen_kyouka_suigetsu_hit_debuff:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end

	-- silence
	self:Silence()
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_aizen_kyouka_suigetsu_hit_debuff:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_aizen_kyouka_suigetsu_hit_debuff:Silence()

	

	-- play effects
	self:PlayEffects()

	local sound_cast = "aizen.4_1"
	EmitSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations


function modifier_aizen_kyouka_suigetsu_hit_debuff:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/aizen_kyouka_suigetsu.vpcf"
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end