modifier_lelouch_strategy = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lelouch_strategy:IsHidden()
	return true
end

function modifier_lelouch_strategy:IsDebuff()
	return false
end

function modifier_lelouch_strategy:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lelouch_strategy:OnCreated( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
end

function modifier_lelouch_strategy:OnRefresh( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )	
end

function modifier_lelouch_strategy:OnRemoved()
end

function modifier_lelouch_strategy:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_lelouch_strategy:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}

	return funcs
end
function modifier_lelouch_strategy:GetModifierBaseAttackTimeConstant()
	return 5.0
end
function modifier_lelouch_strategy:GetModifierCastRangeBonus()
    return self:GetAbility():GetSpecialValueFor('cast')
end


function modifier_lelouch_strategy:OnTakeDamage(keys)
	if IsServer() then
		if keys.attacker == self.parent and keys.damage_category == 0 and keys.inflictor ~= self:GetAbility() then
			if keys.inflictor:IsItem() then return end
			if not self.parent.anime_stone_damage_copy then
				self.parent.anime_stone_damage_copy = self.ability
			end

			local flags = 0
			if keys.inflictor then
				flags = keys.inflictor:GetAbilityTargetFlags()
			end
			
			if self.parent.anime_stone_damage_copy == self.ability and  UnitFilter(	keys.unit,
																		DOTA_UNIT_TARGET_TEAM_BOTH,--keys.inflictor:GetAbilityTargetTeam(), 
																		DOTA_UNIT_TARGET_ALL,--keys.inflictor:GetAbilityTargetType(), 
																		flags + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES - DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
																		self.parent:GetTeamNumber()) == UF_SUCCESS then
																	if	self:GetParent():HasItemInInventory("item_crucible_of_the_executioner") then
																			self.damage_table = {  victim = keys.unit,
                                     	attacker = self.parent,
                                    	damage = (keys.damage * 0.1) + (self.copy_damage * 0.12) ,
                                   		damage_type = DAMAGE_TYPE_PURE,
                                      	ability = self.ability,
                                      	damage_flags = keys.damage_flags}
				elseif keys.attacker:HasModifier("modifier_item_crucible_of_the_executioner_buff") then
					self.damage_table = {  victim = keys.unit,
                                     	attacker = self.parent,
                                    	damage = (keys.damage * 0.1) + self.copy_damage,
                                   		damage_type = DAMAGE_TYPE_PURE,
                                      	ability = self.ability,
                                      	damage_flags = keys.damage_flags}
				else
               	self.damage_table = {  victim = keys.unit,
                                     	attacker = self.parent,
                                    	damage = (keys.damage * 0.1) + self.copy_damage,
                                   		damage_type = DAMAGE_TYPE_MAGICAL,
                                      	ability = self.ability,
                                      	damage_flags = keys.damage_flags}
										end

             	ApplyDamage(self.damage_table)
			end
		end
	end
end

function modifier_lelouch_strategy:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.int_mult = self.ability:GetSpecialValueFor("damage")

	if IsServer() then
		self.copy_damage = self.ability:GetSpecialValueFor("copy_damage")self:GetCaster():FindTalentValue("special_bonus_lelouch_20")
		
		

		--if not self.parent:HasModifier("modifier_item_bloodstone") then
			
		--end
	end
end