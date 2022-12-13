modifier_taboo_four_of_a_kind_damage = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_taboo_four_of_a_kind_damage:IsHidden()
	return true
end

function modifier_taboo_four_of_a_kind_damage:IsDebuff()
	return true
end

function modifier_taboo_four_of_a_kind_damage:IsStunDebuff()
	return false
end

function modifier_taboo_four_of_a_kind_damage:IsPurgable()
	return true
end

function modifier_taboo_four_of_a_kind_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_taboo_four_of_a_kind_damage:OnCreated( kv )
	-- references
	self.duration = 2
	local caster = self:GetCaster()
	local level = caster:GetLevel()
	local level_damage = level * 32
	self.damage = 500 + level_damage

	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	
	
end

function modifier_taboo_four_of_a_kind_damage:OnRefresh( kv )
	
end

function modifier_taboo_four_of_a_kind_damage:OnRemoved()
end

function modifier_taboo_four_of_a_kind_damage:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_taboo_four_of_a_kind_damage:DeclareFunctions()
	local funcs = {
		

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_taboo_four_of_a_kind_damage:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end

	-- silence
	self:Silence()
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_taboo_four_of_a_kind_damage:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_taboo_four_of_a_kind_damage:Silence()
	-- add silence
	

	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self,
		--Optional.
	}
	ApplyDamage( damageTable )


self:PlayEffects()
	-- destroy
	self:Destroy()
end
function modifier_taboo_four_of_a_kind_damage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/taboo_eternal_hunting_blood.vpcf"
	local sound_target = "flandr.4_1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end