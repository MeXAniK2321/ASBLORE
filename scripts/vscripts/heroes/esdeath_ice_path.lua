esdeath_ice_path = class({})
LinkLuaModifier( "modifier_esdeath_ice_path", "modifiers/modifier_esdeath_ice_path", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ice_lady", "heroes/esdeath_ice_path.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_esdeath_ice_path_thinker", "modifiers/modifier_esdeath_ice_path_thinker", LUA_MODIFIER_MOTION_NONE )
function esdeath_ice_path:GetIntrinsicModifierName()
    return "modifier_ice_lady"
end
function esdeath_ice_path:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("esdeath_freeze")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function esdeath_ice_path:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition() + (caster:GetForwardVector() * 1)

	-- calculate direction
	local dir = point - caster:GetOrigin()
	dir.z = 0
	dir = dir:Normalized()

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_esdeath_ice_path_thinker", -- modifier name
		{
			x = dir.x,
			y = dir.y,
		}, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
end
modifier_ice_lady = class ({})
function modifier_ice_lady:IsHidden() return true end
function modifier_ice_lady:IsDebuff() return false end
function modifier_ice_lady:IsPurgable() return false end
function modifier_ice_lady:IsPurgeException() return false end
function modifier_ice_lady:RemoveOnDeath() return false end

function modifier_ice_lady:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_ice_lady:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_ice_lady:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("esdeath_freeze")
        if vongolle and not vongolle:IsNull() then
            if self:GetParent():HasScepter() then
                if vongolle:IsHidden() then
                    vongolle:SetHidden(false)
                end
            else
                if not vongolle:IsHidden() then
                    vongolle:SetHidden(true)
                end
            end
        end
    end
end