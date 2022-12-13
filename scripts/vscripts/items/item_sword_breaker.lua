item_sword_breaker = class({})
LinkLuaModifier("modifier_item_sword_breaker", "items/item_sword_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sword_breaker_debuff", "items/item_sword_breaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_sword_breaker_ghost", "items/item_sword_breaker", LUA_MODIFIER_MOTION_NONE)
function item_sword_breaker:CastFilterResultTarget( hTarget )


local caster = self:GetCaster()


	local result = UnitFilter(
		hTarget,	-- Target Filter
		DOTA_UNIT_TARGET_TEAM_BOTH,	-- Team Filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP,	-- Unit Filter
		0,	-- Unit Flag
		self:GetCaster():GetTeamNumber()	-- Team reference
	)
	
	if result ~= UF_SUCCESS then
		return result
	end

	return UF_SUCCESS
end

function item_sword_breaker:GetIntrinsicModifierName()
	return "modifier_item_sword_breaker"
end
function item_sword_breaker:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local speed = 900
	
	local info = {	Target = target,
    				Source = caster,
   					Ability = self,    
    
    				EffectName = "particles/econ/items/ancient_apparition/aa_2021_immortal/aa_2021_immortal_chilling_projectile.vpcf",
    				iMoveSpeed = speed,
    				bDodgeable = true,                           			-- Optional

    				--iSourceAttachmet = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,  -- Optional
    				--vSourceLoc = caster:GetAbsOrigin(),                -- Optional (HOW)
    				--bIsAttack = false,                                -- Optional
    				bReplaceExisting = false,                         -- Optional
    				flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
    
    				bDrawsOnMinimap = false,                          -- Optional
    				bVisibleToEnemies = true,                         -- Optional
    				bProvidesVision = false,                           -- Optional
    				iVisionRadius = 400,                              -- Optional
    				iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
				}
	
	ProjectileManager:CreateTrackingProjectile(info)
	

end
function item_sword_breaker:OnProjectileHit(hTarget, vLocation)
    local caster = self:GetCaster()
	local target = hTarget
	if not hTarget then
		return nil
	end
	local team = caster:GetTeamNumber()
	local target_team = target:GetTeamNumber()
if target == caster  then
	caster:AddNewModifier(self:GetCaster(), self, "modifier_item_sword_breaker_ghost", {duration = self:GetSpecialValueFor("duration") + 0.5})
	caster:EmitSound("sword.breaker_self")
	
elseif target_team == team then
target:AddNewModifier(self:GetCaster(), self, "modifier_item_sword_breaker_ghost", {duration = self:GetSpecialValueFor("duration") + 0.5})
	target:EmitSound("sword.breaker_self")
else
	target:AddNewModifier(self:GetCaster(), self, "modifier_item_sword_breaker_debuff", {duration = self:GetSpecialValueFor("duration")})
	caster:EmitSound("sword.breaker_enemy")

end
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_sword_breaker = class({})
function modifier_item_sword_breaker:IsHidden() return true end
function modifier_item_sword_breaker:IsDebuff() return false end
function modifier_item_sword_breaker:IsPurgable() return false end
function modifier_item_sword_breaker:IsPurgeException() return false end
function modifier_item_sword_breaker:RemoveOnDeath() return false end
function modifier_item_sword_breaker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_sword_breaker:DeclareFunctions()
	local func = { 	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					MODIFIER_PROPERTY_EVASION_CONSTANT,
}
	return func
end

function modifier_item_sword_breaker:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor('evasion')
end

function modifier_item_sword_breaker:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor('str')
end
function modifier_item_sword_breaker:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor('agility')
end
function modifier_item_sword_breaker:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor('int')
end
function modifier_item_sword_breaker:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_sword_breaker_debuff = class({})
function modifier_item_sword_breaker_debuff:IsHidden() return false end
function modifier_item_sword_breaker_debuff:IsDebuff() return true end
function modifier_item_sword_breaker_debuff:IsPurgable() return false end
function modifier_item_sword_breaker_debuff:IsPurgeException() return false end
function modifier_item_sword_breaker_debuff:RemoveOnDeath() return true end
function modifier_item_sword_breaker_debuff:CheckState()
	local state = {	[MODIFIER_STATE_DISARMED] = true,
	                 [MODIFIER_STATE_MUTED] = true ,}
	return state
end
function modifier_item_sword_breaker_debuff:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_inner_fire_debuff_disarm_model.vpcf"
end
function modifier_item_sword_breaker_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


modifier_item_sword_breaker_ghost = class({})
function modifier_item_sword_breaker_ghost:IsHidden() return false end
function modifier_item_sword_breaker_ghost:IsDebuff() return false end
function modifier_item_sword_breaker_ghost:IsPurgable() return true end
function modifier_item_sword_breaker_ghost:IsPurgeException() return true end
function modifier_item_sword_breaker_ghost:RemoveOnDeath() return true end
function modifier_item_sword_breaker_ghost:CheckState()
	local state = {	[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true,}
	return state
end
function modifier_item_sword_breaker_ghost:DeclareFunctions()
    local decFuncs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		
	
    }
	
	return decFuncs
end

function modifier_item_sword_breaker_ghost:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_item_sword_breaker_ghost:GetEffectName()
	return "particles/ghost_new.vpcf"
end
function modifier_item_sword_breaker_ghost:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_item_sword_breaker_ghost:OnCreated()
	self:StartIntervalThink(0.05)
end
function modifier_item_sword_breaker_ghost:OnIntervalThink()
	if self:GetParent():IsMagicImmune() then
	self:Destroy()
	end
end