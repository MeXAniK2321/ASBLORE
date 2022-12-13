rimuru_shield = class({})
LinkLuaModifier( "modifier_rimuru_shield", "modifiers/modifier_rimuru_shield", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_lord_seed", "modifiers/modifier_demon_lord_seed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_demon_lord_awake_started", "modifiers/modifier_demon_lord_awake_started", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Ability Start
function rimuru_shield:GetIntrinsicModifierName()
	return "modifier_demon_lord_seed"
end
function rimuru_shield:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rimuru_water_blade")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function rimuru_shield:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local buffDuration = self:GetSpecialValueFor("duration")+ self:GetCaster():FindTalentValue("special_bonus_rimuru_20")

	-- Add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_rimuru_shield", -- modifier name
		{ duration = buffDuration } -- kv
	)

	-- Play Effects
	self:PlayEffects()
end

function rimuru_shield:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_omniknight/omniknight_repel_cast.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack2",
		self:GetCaster():GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end