item_axis_sheet = class({})
LinkLuaModifier("modifier_item_axis_sheet", "items/item_axis_sheet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_axis_sheet_debuff", "items/item_axis_sheet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_axis_sheet_cooldown", "items/item_axis_sheet", LUA_MODIFIER_MOTION_NONE)

function item_axis_sheet:GetIntrinsicModifierName()
	return "modifier_item_axis_sheet"
end
function item_axis_sheet:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local speed = self:GetSpecialValueFor("speed")

	local info = {	Target = target,
    				Source = caster,
   					Ability = self,    
    
    				EffectName = "particles/sheet_projectile.vpcf",
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

	caster:EmitSound("axis.sheet_throw")
end
function item_axis_sheet:OnProjectileHit(hTarget, vLocation)
    local caster = self:GetCaster()
	if not hTarget then
		return nil
	end

	if hTarget:TriggerSpellAbsorb(self) then
		return nil
	end

	if UnitFilter(	hTarget,      
					self:GetAbilityTargetTeam(),
                    self:GetAbilityTargetType(),
                    self:GetAbilityTargetFlags(),
                    self:GetCaster():GetTeamNumber()) ~= UF_SUCCESS then
		return nil
	end
	
    if not hTarget:HasModifier("modifier_item_axis_sheet_cooldown") then
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_axis_sheet_debuff", {duration = self:GetSpecialValueFor("duration")})
	hTarget:AddNewModifier(self:GetCaster(), self, "modifier_item_axis_sheet_cooldown", {duration = self:GetSpecialValueFor("duration") + 1.5})
	caster:EmitSound("axis.sheet")
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_axis_sheet = class({})
function modifier_item_axis_sheet:IsHidden() return true end
function modifier_item_axis_sheet:IsDebuff() return false end
function modifier_item_axis_sheet:IsPurgable() return false end
function modifier_item_axis_sheet:IsPurgeException() return false end
function modifier_item_axis_sheet:RemoveOnDeath() return false end
function modifier_item_axis_sheet:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_axis_sheet:DeclareFunctions()
	local func = { 	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,}
	return func
end
function modifier_item_axis_sheet:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end

function modifier_item_axis_sheet:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end
function modifier_item_axis_sheet:GetModifierBonusStats_Strength()
	return self.strength
end
function modifier_item_axis_sheet:GetModifierBonusStats_Agility()
	return self.agility
end
function modifier_item_axis_sheet:GetModifierBonusStats_Intellect()
	return self.intellect
end
function modifier_item_axis_sheet:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.strength = self.ability:GetSpecialValueFor("bonus_strength")
	self.agility = self.ability:GetSpecialValueFor("bonus_agility")
	self.intellect = self.ability:GetSpecialValueFor("bonus_intellect")
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_axis_sheet_debuff = class({})
function modifier_item_axis_sheet_debuff:IsHidden() return false end
function modifier_item_axis_sheet_debuff:IsDebuff() return true end
function modifier_item_axis_sheet_debuff:IsPurgable() return true end
function modifier_item_axis_sheet_debuff:IsPurgeException() return true end
function modifier_item_axis_sheet_debuff:RemoveOnDeath() return true end
function modifier_item_axis_sheet_debuff:CheckState()
	local state = {	[MODIFIER_STATE_PASSIVES_DISABLED] = true,
					[MODIFIER_STATE_STUNNED] = true,
					[MODIFIER_STATE_INVISIBLE] = false,}
	return state
end
function modifier_item_axis_sheet_debuff:GetEffectName()
	return "particles/generic_stunned_old1.vpcf"
end
function modifier_item_axis_sheet_debuff:GetEffectAttachType()
	return PATTACH_CENTER_FOLLOW
end
function modifier_item_axis_sheet_debuff:OnCreated(table)
	if IsServer() then
		self.particle_fx = ParticleManager:CreateParticle("particles/items2_fx/rod_of_atos_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

		self:AddParticle(self.particle_fx, false, false, -1, false, false)
	end
end

modifier_item_axis_sheet_cooldown = class({})
function modifier_item_axis_sheet_cooldown:IsHidden() return false end
function modifier_item_axis_sheet_cooldown:IsDebuff() return true end
function modifier_item_axis_sheet_cooldown:IsPurgable() return true end
function modifier_item_axis_sheet_cooldown:IsPurgeException() return true end
function modifier_item_axis_sheet_cooldown:RemoveOnDeath() return true end