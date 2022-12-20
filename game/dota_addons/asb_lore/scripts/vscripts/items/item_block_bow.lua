item_block_bow = class({})
LinkLuaModifier("modifier_item_block_bow_force_ally", "items/item_block_bow", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_item_block_bow", "items/item_block_bow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_block_bow_buff", "items/item_block_bow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_block_bow_vision", "items/item_block_bow", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_yoru_debuff", "items/item_yoru", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_block_bow_attack_speed", "items/item_block_bow", LUA_MODIFIER_MOTION_NONE)
function item_block_bow:GetIntrinsicModifierName()
	return "modifier_item_block_bow"
end


function item_block_bow:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local hTarget = self:GetCursorTarget()



	if caster:GetTeamNumber() == hTarget:GetTeamNumber() then
             EmitSoundOn("DOTA_Item.ForceStaff.Activate", hTarget)

						hTarget:AddNewModifier(caster, self, "modifier_item_block_bow_force_ally", {})
						else
		
		local knockback = { should_stun = 1,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 400,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }
						local knockback2 = { should_stun = 0,
                        knockback_duration = 0.2,
                        duration = 0.2,
                        knockback_distance = 400,
                        knockback_height = 0,
                        center_x = hTarget:GetAbsOrigin().x,
                        center_y = hTarget:GetAbsOrigin().y,
                        center_z = hTarget:GetAbsOrigin().z }

    hTarget:AddNewModifier(caster, self, "modifier_knockback", knockback)
	hTarget:AddNewModifier(caster, self, "modifier_block_bow_vision", {duration = 1})
	caster:AddNewModifier(caster, self, "modifier_knockback", knockback2)
    caster:AddNewModifier(caster, self, "modifier_block_bow_buff", {duration = 3})
	caster:MoveToTargetToAttack(hTarget)
	
	EmitSoundOn("DOTA_Item.HurricanePike.Activate", caster)


end
end
---------------------------------------------------------------------------------------------------------------------


modifier_item_block_bow = class({})

function modifier_item_block_bow:IsHidden() 			return true end
function modifier_item_block_bow:IsDebuff() 			return false end
function modifier_item_block_bow:IsPurgable() 			return false end
function modifier_item_block_bow:IsPurgeException() 	return false end
function modifier_item_block_bow:RemoveOnDeath() 		return false end
function modifier_item_block_bow:DeclareFunctions()
	local func = 	{	
						MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
						MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
						MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
						MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
						MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
						MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
						MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
						MODIFIER_EVENT_ON_ATTACK_LANDED,
						
					}
	return func
end
function modifier_item_block_bow:GetModifierConstantHealthRegen()
	return 2
end
function modifier_item_block_bow:GetModifierBonusStats_Strength()
	return 13
end
function modifier_item_block_bow:GetModifierBonusStats_Agility()
	return 36
end
function modifier_item_block_bow:GetModifierBonusStats_Intellect()
	return 23
end
function modifier_item_block_bow:GetModifierPreAttack_BonusDamage()
	return 70
end
function modifier_item_block_bow:GetModifierAttackSpeedBonus_Constant()
	return 40
end
function modifier_item_block_bow:GetModifierAttackRangeBonusUnique()
	if self.parent:IsRangedAttacker() then
		return 140
	end
end
  function modifier_item_block_bow:GetModifierPhysicalArmorBonus()
return 5
end    
function modifier_item_block_bow:OnAttackLanded(params)
	if IsServer() then
	if self.parent:IsRangedAttacker() then
	
	self.chance = 25
		if params.attacker == self:GetParent() then	
			if not params.attacker:IsIllusion() then
			if self:GetCaster():HasModifier("modifier_block_bow_buff") then			
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_yoru_debuff", {duration = 2 })
			local damageTable = {
		attacker = self:GetParent(),
		damage = 200,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		self:GetParent():EmitSound("bonk")
		else
			if RandomInt(0, 100)<self.chance  then
			 if self:GetParent():HasItemInInventory("item_debate_club") then 
			 else
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_yoru_debuff", {duration = 2 })
			local damageTable = {
		attacker = self:GetParent(),
		damage = 250,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		self:GetParent():EmitSound("bonk")
			end
		end
	end
	end
end
end
end
end

function modifier_item_block_bow:OnCreated(hTable)
	self.caster  = self:GetCaster()
	self.parent  = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_health_regen = self.ability:GetSpecialValueFor("bonus_health_regen")
	self.bonus_strength 	= self.ability:GetSpecialValueFor("bonus_strength")
	self.bonus_agility 		= self.ability:GetSpecialValueFor("bonus_agility")
	self.bonus_intellect 	= self.ability:GetSpecialValueFor("bonus_intellect")
	self.bonus_damage 		= self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_as 			= self.ability:GetSpecialValueFor("bonus_as")

	self.base_attack_range 	= self.ability:GetSpecialValueFor("base_attack_range")

	
end
function modifier_item_block_bow:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_item_block_bow:OnDestroy()
end



modifier_item_block_bow_force_ally = class({})

function modifier_item_block_bow_force_ally:IsHidden() 				return false end
function modifier_item_block_bow_force_ally:IsDebuff() 				return self.bParentEnemy end
function modifier_item_block_bow_force_ally:IsPurgable() 			return self.bParentEnemy end
function modifier_item_block_bow_force_ally:IsPurgeException() 		return self.bParentEnemy end
function modifier_item_block_bow_force_ally:RemoveOnDeath() 		return true end
function modifier_item_block_bow_force_ally:DeclareFunctions()
	local func = 	{	
						MODIFIER_PROPERTY_OVERRIDE_ANIMATION
					}
	return func
end
function modifier_item_block_bow_force_ally:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end
function modifier_item_block_bow_force_ally:OnCreated(hTable)
	self.caster  = self:GetCaster()
	self.parent  = self:GetParent()
	self.ability = self:GetAbility()

	self.bParentEnemy = self.caster:GetTeamNumber() ~= self.parent:GetTeamNumber()

	if IsServer() then
		self.hTarget      = self.ability:GetCursorTarget()
		self.bTargetEnemy = self.caster:GetTeamNumber() ~= self.hTarget:GetTeamNumber()

		self.fDistance    = self.ability:GetSpecialValueFor("push_length")
		self.vDirection   = self.parent:GetForwardVector():Normalized()

		if self.bTargetEnemy then
			self.fDistance  = self.ability:GetSpecialValueFor("enemy_length")
			self.vDirection = GetDirection(self.caster, self.hTarget)
			self.vDirection = self.caster == self.parent 
							  and self.vDirection
							  or -self.vDirection
		end

		self.fSpeed = 1500

		if self:ApplyHorizontalMotionController() == false then 
            self:Destroy()
        end
	end
end
function modifier_item_block_bow_force_ally:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_item_block_bow_force_ally:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		if self.fDistance <= 0 then
			return self:Destroy()
		end

		local fUnitsDT = self.fSpeed * dt
	    local vCurPos  = self.parent:GetOrigin()

	    GridNav:DestroyTreesAroundPoint(vCurPos, 80, false)
 
	    vCurPos = vCurPos + self.vDirection * fUnitsDT
	    vCurPos = GetGroundPosition(vCurPos, self.parent)

	    self.parent:SetOrigin(vCurPos)

	    self.fDistance = self.fDistance - fUnitsDT
	end
end
function modifier_item_block_bow_force_ally:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end
function modifier_item_block_bow_force_ally:OnDestroy()
    if IsServer() then
        self.parent:InterruptMotionControllers(true)
    end
end
function modifier_item_block_bow_force_ally:GetStatusEffectName()
	return "particles/status_fx/status_effect_forcestaff.vpcf"
end
function modifier_item_block_bow_force_ally:GetEffectName()
	return "particles/items/item_block_bow/pumpkin_force.vpcf"
end
function modifier_item_block_bow_force_ally:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


modifier_block_bow_buff = class({})

function modifier_block_bow_buff:IsHidden() 				return false end
function modifier_block_bow_buff:IsDebuff() 				return self.bParentEnemy end
function modifier_block_bow_buff:IsPurgable() 			return self.bParentEnemy end
function modifier_block_bow_buff:IsPurgeException() 		return self.bParentEnemy end
function modifier_block_bow_buff:RemoveOnDeath() 		return true end
function modifier_block_bow_buff:DeclareFunctions()
	local func = 	{	
						
						MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
						
					}
	return func
end
function modifier_block_bow_buff:GetModifierAttackRangeBonusUnique()
self.parent  = self:GetParent()
	if self.parent:IsRangedAttacker() then
		return 800
	end
end
modifier_block_bow_vision = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_block_bow_vision:IsHidden()
	return false
end

function modifier_block_bow_vision:IsDebuff()
	return true
end

function modifier_block_bow_vision:IsStunDebuff()
	return false
end

function modifier_block_bow_vision:IsPurgable()
	return true
end

function modifier_block_bow_vision:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations

function modifier_block_bow_vision:OnRefresh( kv )
	
end

function modifier_block_bow_vision:OnRemoved()
end

function modifier_block_bow_vision:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_block_bow_vision:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,

		
	}

	return funcs
end

function modifier_block_bow_vision:GetModifierProvidesFOWVision()
	return 1
end