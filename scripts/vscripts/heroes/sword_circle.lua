sword_circle = class({})
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sword_circle", "modifiers/modifier_sword_circle", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sword_circle_blood", "modifiers/modifier_sword_circle", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chair_that_is_approaching", "heroes/sword_circle.lua", LUA_MODIFIER_MOTION_NONE )

function sword_circle:GetIntrinsicModifierName()
    return "modifier_chair_that_is_approaching"
end
function sword_circle:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("superior_chair")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function sword_circle:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local duration = self:GetSpecialValueFor( "debuff_duration" )
	if target:TriggerSpellAbsorb( self ) then return end

	-- add debuff
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_sword_circle", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	self:PlayEffects( target )
end

--------------------------------------------------------------------------------
function sword_circle:PlayEffects( target )
	-- Get Resources
	local particle_cast = ""
	local sound_cast = "vergil.1"

	-- Get Data
	local direction = target:GetOrigin()-self:GetCaster():GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
modifier_chair_that_is_approaching = class ({})
function modifier_chair_that_is_approaching:IsHidden() return true end
function modifier_chair_that_is_approaching:IsDebuff() return false end
function modifier_chair_that_is_approaching:IsPurgable() return false end
function modifier_chair_that_is_approaching:IsPurgeException() return false end
function modifier_chair_that_is_approaching:RemoveOnDeath() return false end

function modifier_chair_that_is_approaching:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_chair_that_is_approaching:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_chair_that_is_approaching:OnIntervalThink()
    if IsServer() then
        local chair = self:GetParent():FindAbilityByName("superior_chair")
        if chair and not chair:IsNull() then
            if self:GetParent():HasScepter() then
                if chair:IsHidden() then
                    chair:SetHidden(false)
                end
            else
                if not chair:IsHidden() then
                    chair:SetHidden(true)
                end
            end
        end
    end
end