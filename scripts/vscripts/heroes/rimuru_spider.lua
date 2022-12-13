rimuru_spider = class({})
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rimuru_spider", "modifiers/modifier_rimuru_spider", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function rimuru_spider:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("gluttony")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function rimuru_spider:OnSpellStart() 
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb( self ) then return end

	-- set duration
	local bduration = self:GetSpecialValueFor("duration")
	if target:IsCreep() and (target:GetLevel()<=6) then
		bduration = self:GetSpecialValueFor("creep_duration")
	end

	local stun_duration = 0.1

	-- Add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_rimuru_spider", -- modifier name
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
function rimuru_spider:AbilityConsiderations()
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
function rimuru_spider:PlayEffects( caster, target )
	-- Create Projectile
	local projectile_name = "particles/rimuru_spider.vpcf"
	local projectile_speed = 1000
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