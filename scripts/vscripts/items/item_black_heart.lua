item_black_heart = class({})
LinkLuaModifier( "modifier_item_black_heart", "items/item_black_heart", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_black_heart_buff", "items/item_black_heart", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_black_heart_slow", "items/item_black_heart", LUA_MODIFIER_MOTION_NONE )
function item_black_heart:GetIntrinsicModifierName()
	return "modifier_item_black_heart"
end
function item_black_heart:OnOwnerSpawned()
	if self._BlackHeartState ~= nil and self._BlackHeartState ~= self:GetToggleState() then
		self:ToggleAbility()
	end
end
function item_black_heart:OnOwnerDied()
end
function item_black_heart:OnToggle()
	local caster = self:GetCaster()

	self._BlackHeartState = self:GetToggleState()

	if self:GetItemState() == 1 then
		if self:GetToggleState() == true then
			caster:AddNewModifier(caster, self, "modifier_item_black_heart_buff", {})

			self:EndCooldown()
		else
			if caster:HasModifier("modifier_item_black_heart_buff") then
				caster:RemoveModifierByNameAndCaster("modifier_item_black_heart_buff", caster)
			end
			--self:UseResources(true, false, true)
		end
	end
end
function item_black_heart:GetAbilityTextureName()
	if self:GetToggleState() == true then
		return "black_heart_toggle" 
	else
		return "black_heart"
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_black_heart = class({})
function modifier_item_black_heart:IsHidden() return true end
function modifier_item_black_heart:IsDebuff() return false end
function modifier_item_black_heart:IsPurgable() return false end
function modifier_item_black_heart:IsPurgeException() return false end
function modifier_item_black_heart:RemoveOnDeath() return false end
function modifier_item_black_heart:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_black_heart:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
					MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
					MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
					MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, } 
	return func
end
function modifier_item_black_heart:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end
function modifier_item_black_heart:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_as
end
function modifier_item_black_heart:GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end
function modifier_item_black_heart:GetModifierConstantHealthRegen()
	return self.bonus_hp_regen
end
function modifier_item_black_heart:GetModifierBonusStats_Strength()
	return self.bonus_str
end

function modifier_item_black_heart:OnCreated(table)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_damage 	= self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_as 		= self.ability:GetSpecialValueFor("bonus_as")
	self.bonus_armor 	= self.ability:GetSpecialValueFor("bonus_armor")
	self.bonus_hp_regen = self.ability:GetSpecialValueFor("bonus_hp_regen")

	self.bonus_str 		= self.ability:GetSpecialValueFor("bonus_str")


	if IsServer() then
		if self.ability:GetToggleState() == true and self.ability:IsFullyCastable() then
			self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_black_heart_buff", {})
		end
	end
end
function modifier_item_black_heart:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_black_heart:OnDestroy()
	if IsServer() then
		if not self.parent or self.parent:IsNull() or not IsValidEntity(self.parent) then
			return nil
		end
		
		self.parent:RemoveModifierByNameAndCaster("modifier_item_black_heart_buff", self.parent)
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_black_heart_buff = class({})
function modifier_item_black_heart_buff:IsHidden() return false end
function modifier_item_black_heart_buff:IsDebuff() return false end
function modifier_item_black_heart_buff:IsPurgable() return false end
function modifier_item_black_heart_buff:IsAura() return true end
function modifier_item_black_heart_buff:IsAuraActiveOnDeath() return false end
function modifier_item_black_heart_buff:IsPurgeException() return false end
function modifier_item_black_heart_buff:RemoveOnDeath() return true end
function modifier_item_black_heart_buff:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
					MODIFIER_EVENT_ON_ATTACK_LANDED
				}
	return func
end
function modifier_item_black_heart_buff:GetModifierPreAttack_BonusDamage()
	return self.buff_attack
end
function modifier_item_black_heart_buff:GetModifierAttackSpeedBonus_Constant()
	return self.buff_as
end
function modifier_item_black_heart_buff:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:GetParent():Heal(params.damage * 0.12, nil)
		end
	end
end
function modifier_item_black_heart_buff:OnCreated(table)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.buff_attack  = self.caster:GetStrength()
	self.buff_as = self.ability:GetSpecialValueFor("buff_as")
	
	

	

	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_item_black_heart_buff:OnRefresh(table)

	self:OnCreated(table)
end
function modifier_item_black_heart_buff:OnDestroy()
	if IsServer() then
		if self.ability and not self.ability:IsNull() then
		
			local cooldown = self.ability:GetSpecialValueFor("cooldown")

			self.ability:StartCooldown(cooldown * self.parent:GetCooldownReduction())

			if self.ability:GetToggleState() == true then
				self.ability:ToggleAbility()
			end
		end
	end
end
function modifier_item_black_heart_buff:OnIntervalThink()
	if IsServer() and self.parent:IsRealHero() then
		if not self.ability or self.ability:IsNull() then
			return nil
		end
		
		
  self.buff_attack  = self.caster:GetStrength() * 0.6
		self.buff_hp_loss = self.ability:GetSpecialValueFor("buff_hp_loss") * self.parent:GetHealth() * 0.01 * FrameTime()

		self.parent:ModifyHealth(self.parent:GetHealth() - self.buff_hp_loss, self.ability, false, 0)


	end
end
function modifier_item_black_heart_buff:GetEffectName()
	return "particles/black_heart.vpcf"
end
function modifier_item_black_heart_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_black_heart_buff:GetAuraRadius()
	return 450
end
function modifier_item_black_heart_buff:GetAuraEntityReject(hEntity)
	if IsServer() then
		local modifier = hEntity:FindModifierByName("modifier_black_heart_slow")
		if self:GetParent() and not self:GetParent():IsNull() and self:GetParent():IsIllusion() and modifier and not modifier:IsNull() then
			local caster = modifier:GetCaster()
			if caster and not caster:IsNull() and not caster:IsIllusion() then
				return true
			end
		end

	end
end
function modifier_item_black_heart_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_item_black_heart_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_item_black_heart_buff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_item_black_heart_buff:GetModifierAura()
	return "modifier_black_heart_slow"
end







modifier_black_heart_slow = class({})

--------------------------------------------------------------------------------

function modifier_black_heart_slow:IsDebuff()
	return true
end

function modifier_black_heart_slow:IsStunDebuff()
	return false
end
function modifier_black_heart_slow:IsHidden()
	return false
end
function modifier_black_heart_slow:IsPurgable()
	return true
end

--------------------------------------------------------------------------------



--------------------------------------------------------------------------------

function modifier_black_heart_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_black_heart_slow:GetModifierMoveSpeedBonus_Percentage()
	return -5
end

--------------------------------------------------------------------------------

function modifier_black_heart_slow:GetEffectName()
	return "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_slow_debuff_trail.vpcf"
end

function modifier_black_heart_slow:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
