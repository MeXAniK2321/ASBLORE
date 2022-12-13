modifier_buy_sniper = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_buy_sniper:IsHidden()
	return true
end

function modifier_buy_sniper:IsDebuff()
	return true
end

function modifier_buy_sniper:IsStunDebuff()
	return false
end

function modifier_buy_sniper:IsPurgable()
	return true
end

function modifier_buy_sniper:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_buy_sniper:OnCreated( kv )
	local caster = self:GetCaster()
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	  local gold = caster:GetGold()
	  local damage_per_gold = gold * 0.08
	  if gold > 10000 then
	  self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_daisuke_25") +800
	  else
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():FindTalentValue("special_bonus_daisuke_25") +damage_per_gold
end
	if not IsServer() then return end

	-- Start interval
	self:StartIntervalThink( kv.duration )

	-- play effects
	local sound_cast = "daisuke_3_1"
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_buy_sniper:OnRefresh( kv )
	
end

function modifier_buy_sniper:OnRemoved()
end

function modifier_buy_sniper:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_buy_sniper:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,

		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end


function modifier_buy_sniper:OnIntervalThink()
	-- silence
	self:Silence()
end

--------------------------------------------------------------------------------
-- Helper
function modifier_buy_sniper:Silence()
	-- add silence
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = self.duration } -- kv
	)

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

	local sound_cast = "daisuke_3_1"
	StopSoundOn( sound_cast, self:GetParent() )

	-- destroy
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_buy_sniper:GetEffectName()
	return ""
end

function modifier_buy_sniper:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_buy_sniper:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/daisuke_exp.vpcf"
	local sound_cast = "daisuke_3_2"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end