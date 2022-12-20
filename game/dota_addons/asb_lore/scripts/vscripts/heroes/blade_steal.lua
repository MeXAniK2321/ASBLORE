blade_steal = class({})

LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blade_steal2", "modifiers/modifier_blade_steal2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_perrr", "heroes/blade_steal.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function blade_steal:GetIntrinsicModifierName()
    return "modifier_perrr"
end
function blade_steal:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("perfect_vision")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function blade_steal:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb( self ) then return end

	-- set duration
	local bduration = self:GetSpecialValueFor("duration")+self:GetCaster():FindTalentValue("special_bonus_ikki_20")
	if target:IsCreep() and (target:GetLevel()<=6) then
		bduration = self:GetSpecialValueFor("duration")
	end

	local stun_duration = 0.1

	-- Add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_blade_steal2", -- modifier name
		{ duration = bduration } -- kv
	)
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_stunned_lua", -- modifier name
		{ duration = stun_duration } -- kv
	)

	self:PlayEffects( caster, target )
end

--------------------------------------------------------------------------------
-- Ability Considerations
function blade_steal:AbilityConsiderations()
	-- Scepter
	local bScepter = caster:HasScepter()

	-- Linken & Lotus
	local bBlocked = target:TriggerSpellAbsorb( self )

	-- Break
	local bBroken = caster:PassivesDisabled()

	-- Advanced Status
	local bInvulnerable = target:IsInvulnerable()
	local bInvisible = target:IsInvisible()
	local bHexed = target:IsHexed()
	local bMagicImmune = target:IsMagicImmune()

	-- Illusion Copy
	local bIllusion = target:IsIllusion()
end

--------------------------------------------------------------------------------
function blade_steal:PlayEffects( caster, target )
	-- Create Projectile
	local projectile_name = ""
	local projectile_speed = 3000
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)

		bDodgeable = false,                                -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
modifier_perrr = class ({})
function modifier_perrr:IsHidden() return true end
function modifier_perrr:IsDebuff() return false end
function modifier_perrr:IsPurgable() return false end
function modifier_perrr:IsPurgeException() return false end
function modifier_perrr:RemoveOnDeath() return false end

function modifier_perrr:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_perrr:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_perrr:OnIntervalThink()
    if IsServer() then
        local masohist = self:GetParent():FindAbilityByName("perfect_vision")
        if masohist and not masohist:IsNull() then
            if self:GetParent():HasScepter() then
                if masohist:IsHidden() then
                    masohist:SetHidden(false)
                end
            else
                if not masohist:IsHidden() then
                    masohist:SetHidden(true)
                end
            end
        end
    end
end
