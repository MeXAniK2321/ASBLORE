mikagura = class({})
LinkLuaModifier( "modifier_mikagura", "modifiers/modifier_mikagura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mikagura_slow", "modifiers/modifier_mikagura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jelllllal", "heroes/mikagura.lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function mikagura:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end
function mikagura:GetIntrinsicModifierName()
    return "modifier_jelllllal"
end
function mikagura:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("cerma")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--------------------------------------------------------------------------------
-- Ability Start
function mikagura:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration  = 1.5

	-- load data
	local delay = self:GetSpecialValueFor("delay")+ self:GetCaster():FindTalentValue("special_bonus_jellal_20")

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_mikagura", -- modifier name
		{ duration = delay }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
	self:PlayEffects( point, radius, duration )
end
function mikagura:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/jellal_circle2.vpcf"
	local sound_cast = "jellal.1"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end
modifier_x_canon_thinker = class ({})

function modifier_x_canon_thinker:CheckState()
    return {[MODIFIER_STATE_PROVIDES_VISION] = true}
end

modifier_jelllllal = class ({})
function modifier_jelllllal:IsHidden() return true end
function modifier_jelllllal:IsDebuff() return false end
function modifier_jelllllal:IsPurgable() return false end
function modifier_jelllllal:IsPurgeException() return false end
function modifier_jelllllal:RemoveOnDeath() return false end

function modifier_jelllllal:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_jelllllal:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_jelllllal:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_jelllllal:GetModifierBaseAttackTimeConstant()
	return 2.5
end
function modifier_jelllllal:OnIntervalThink()
    if IsServer() then
        local xenos = self:GetParent():FindAbilityByName("cerma")
        if xenos and not xenos:IsNull() then
            if self:GetParent():HasScepter() then
                if xenos:IsHidden() then
                    xenos:SetHidden(false)
                end
            else
                if not xenos:IsHidden() then
                    xenos:SetHidden(true)
                end
            end
        end
    end
end