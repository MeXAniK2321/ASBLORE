item_escalibur = class({})
LinkLuaModifier("modifier_item_escalibur", "items/item_escalibur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_escalibur_buff", "items/item_escalibur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_escalibur_resist_debuff", "items/item_escalibur", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_escalibur_resist_debuff_2", "items/item_escalibur", LUA_MODIFIER_MOTION_NONE)
function item_escalibur:GetIntrinsicModifierName()
	return "modifier_item_escalibur"
end
function item_escalibur:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_item_escalibur_buff", {duration = duration})
	
	--EmitSoundOn("escalibur", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_escalibur = class({})
function modifier_item_escalibur:IsHidden() return true end
function modifier_item_escalibur:IsDebuff() return false end
function modifier_item_escalibur:IsPurgable() return false end
function modifier_item_escalibur:IsPurgeException() return false end
function modifier_item_escalibur:RemoveOnDeath() return false end
function modifier_item_escalibur:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_escalibur:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
self.crit_chance = self:GetAbility ():GetSpecialValueFor( "crit_chance" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "crit" )
	
end

function modifier_item_escalibur:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_escalibur:OnDestroy()
	if IsServer() then
		
	end
end
function modifier_item_escalibur:DeclareFunctions()
	local func = {	
					 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					 MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		
		}
	return func
end

function modifier_item_escalibur:GetModifierAttackSpeedBonus_Constant()
	 return 50
end
function modifier_item_escalibur:GetModifierBonusStats_Strength()
    return 20
end
function modifier_item_escalibur:GetModifierPreAttack_BonusDamage()
    return 180
end
 function modifier_item_escalibur:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			if not params.attacker:IsIllusion() then
			if self:GetCaster():HasModifier("modifier_item_escalibur_buff") then
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_escalibur_resist_debuff_2", {duration = 1.0 })
			else
			params.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_escalibur_resist_debuff", {duration = 1.0 })
			end
		end
	end
end
end
--------------------------------------------------------------------------------------------------------------------
modifier_item_escalibur_buff = class({})
function modifier_item_escalibur_buff:IsHidden() return false end
function modifier_item_escalibur_buff:IsDebuff() return false end
function modifier_item_escalibur_buff:IsPurgable() return true end
function modifier_item_escalibur_buff:IsPurgeException() return true end
function modifier_item_escalibur_buff:RemoveOnDeath() return true end
function modifier_item_escalibur_buff:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					}
	return func
end
function modifier_item_escalibur_buff:GetModifierPreAttack_BonusDamage()
    return 100
end

function modifier_item_escalibur_buff:GetModifierAttackSpeedBonus_Constant()
	return 50
end
function modifier_item_escalibur_buff:GetModifierMoveSpeedBonus_Constant()
	return 100
end
function modifier_item_escalibur_buff:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
     if not IsServer() then return end
    local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
    EmitSoundOnClient("escalibur.self", Player)
	
	self.as = self.ability:GetSpecialValueFor("as")
	self.bonus_ms = self.ability:GetSpecialValueFor("bonus_ms")
end
function modifier_item_escalibur_buff:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_escalibur_buff:GetEffectName()
	return "particles/escalibur_buff.vpcf"
end
function modifier_item_escalibur_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
modifier_item_escalibur_debuff= class({})

function modifier_item_escalibur_debuff:CheckState()
	local state = {
	[MODIFIER_STATE_MUTED] = true,
	}

	return state
end

function modifier_item_escalibur_debuff:GetStatusEffectName()
    return "particles/econ/items/effigies/status_fx_effigies/status_effect_effigy_gold.vpcf"
end

function modifier_item_escalibur_debuff:StatusEffectPriority()
    return 10
end
modifier_item_escalibur_resist_debuff = class({})
 
--------------------------------------------------------------------------------

function modifier_item_escalibur_resist_debuff:IsDebuff()
	return true
end

function modifier_item_escalibur_resist_debuff:IsStunDebuff()
	return false
end
function modifier_item_escalibur_resist_debuff:IsHidden()
	return false
end
function modifier_item_escalibur_resist_debuff:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
function modifier_item_escalibur_resist_debuff:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.armor = self.parent:GetPhysicalArmorValue(false)
	self.armor1 = self.armor * -0.30

end


--------------------------------------------------------------------------------

function modifier_item_escalibur_resist_debuff:DeclareFunctions()
    local funcs = {
        
       
        
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end


  function  modifier_item_escalibur_resist_debuff:GetModifierIncomingPhysicalDamage_Percentage()
return self:GetAbility():GetSpecialValueFor('phys_damage')
end  

--------------------------------------------------------------------------------
function modifier_item_escalibur_resist_debuff:GetModifierPhysicalArmorBonus()
	return self.armor1
end
function modifier_item_escalibur_resist_debuff:GetEffectName()
	return "particles/escalibur_armor_broke.vpcf"
end

function modifier_item_escalibur_resist_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

modifier_item_escalibur_resist_debuff_2 = class({})
 
--------------------------------------------------------------------------------

function modifier_item_escalibur_resist_debuff_2:IsDebuff()
	return true
end

function modifier_item_escalibur_resist_debuff_2:IsStunDebuff()
	return false
end
function modifier_item_escalibur_resist_debuff_2:IsHidden()
	return false
end
function modifier_item_escalibur_resist_debuff_2:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
function modifier_item_escalibur_resist_debuff_2:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.armor = self.parent:GetPhysicalArmorValue(false)
	self.armor1 = self.armor * -0.45

end


--------------------------------------------------------------------------------

function modifier_item_escalibur_resist_debuff_2:DeclareFunctions()
    local funcs = {
        
       
        
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end


  function  modifier_item_escalibur_resist_debuff_2:GetModifierIncomingPhysicalDamage_Percentage()
return self:GetAbility():GetSpecialValueFor('phys_damage')
end  

--------------------------------------------------------------------------------
function modifier_item_escalibur_resist_debuff_2:GetModifierPhysicalArmorBonus()
	return self.armor1
end
function modifier_item_escalibur_resist_debuff_2:GetEffectName()
	return "particles/escalibur_armor_broke.vpcf"
end

function modifier_item_escalibur_resist_debuff_2:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end