modifier_judgment_chain = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_judgment_chain:IsHidden()
	return true
end

function modifier_judgment_chain:IsDebuff()
	return true
end

function modifier_judgment_chain:IsStunDebuff()
	return false
end

function modifier_judgment_chain:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_judgment_chain:OnCreated( kv )
	-- references
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	self.damage = 8000

	if self:GetParent():HasModifier("modifier_chain_jail") then
self:Silence()
	else
	end
end

function modifier_judgment_chain:OnRefresh( kv )
	
end

function modifier_judgment_chain:OnRemoved()
end

function modifier_judgment_chain:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_judgment_chain:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_ABILITY_START,
	}

	return funcs
end

function modifier_judgment_chain:GetModifierProvidesFOWVision()
	return 1
end

function modifier_judgment_chain:OnAbilityStart( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end

	-- silence
	self:Silence()
end
--------------------------------------------------------------------------------
-- Interval Effects


--------------------------------------------------------------------------------
-- Helper
function modifier_judgment_chain:Silence()
	-- add silence

	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- play effects
	self:PlayEffects()
	-- destroy
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_judgment_chain:GetEffectName()
	return "particles/judgment_chain_effect.vpcf"
end

function modifier_judgment_chain:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_judgment_chain:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/kyoka_suigetsu_blood.vpcf"
	local sound_cast = "kurapika.5_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
modifier_judgment_death= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_judgment_death:IsHidden()
	return false
end

function modifier_judgment_death:IsDebuff()
	return false
end
function modifier_judgment_death:RemoveOnDeath() return true end
function modifier_judgment_death:IsStunDebuff()
	return false
end

function modifier_judgment_death:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_judgment_death:OnCreated( kv )
	-- references
	local damage = 99999
	

	if not IsServer() then return end

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 0.2 )
end

function modifier_judgment_death:OnRefresh( kv )
	-- references
	local damage = 999999
	

	if not IsServer() then return end

	-- update damage
	self.damageTable.damage = damage	
end

function modifier_judgment_death:OnRemoved()
end

function modifier_judgment_death:OnDestroy()
end

-- Interval Effects
function modifier_judgment_death:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_judgment_death:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_judgment_death:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end