LinkLuaModifier("modifier_anime_mechanic_ability_attack_autocast", "modifiers/modifier_anime_mechanic_ability_attack_autocast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_anime_mechanic_ability_attack_autocast_state", "modifiers/modifier_anime_mechanic_ability_attack_autocast", LUA_MODIFIER_MOTION_NONE)

modifier_anime_mechanic_ability_attack_autocast = class({})

function modifier_anime_mechanic_ability_attack_autocast:IsHidden() return true end
function modifier_anime_mechanic_ability_attack_autocast:IsDebuff() return false end
function modifier_anime_mechanic_ability_attack_autocast:IsPurgable() return false end
function modifier_anime_mechanic_ability_attack_autocast:IsPurgeException() return false end
function modifier_anime_mechanic_ability_attack_autocast:RemoveOnDeath() return false end
function modifier_anime_mechanic_ability_attack_autocast:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_ability_attack_autocast:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
                    MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
                  	MODIFIER_EVENT_ON_ATTACK_START,
                    MODIFIER_EVENT_ON_ATTACK,
                    --MODIFIER_EVENT_ON_ATTACK_LANDED,
			        MODIFIER_EVENT_ON_ATTACK_FAIL,
			        --MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
			        MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
			        --MODIFIER_EVENT_ON_ORDER,
			        --MODIFIER_PROPERTY_PROJECTILE_NAME,
			        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
			        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
			        MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE,
			        MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
			        MODIFIER_EVENT_ON_ORDER, }
    return func
end
function modifier_anime_mechanic_ability_attack_autocast:OnAttackStart(keys)
	if IsServer() then
		--print(keys.record, "1")
		if keys.attacker == self.parent and self.ability.GetAttackAutocastStart then
			self.CanAttackStart = self.CanAttackStart or self.ability:GetAttackAutocastStart(keys)

			if self.CanAttackStart then
				self.AttackAutocastCheckStateModifier = keys.attacker:AddNewModifier(keys.attacker, self.ability, "modifier_anime_mechanic_ability_attack_autocast_state", {})
			end
		end
	end
end
function modifier_anime_mechanic_ability_attack_autocast:GetActivityTranslationModifiers(keys)
	if IsServer() then
		--print(keys.record, "2")
		if self.CanAttackEffects and self.ability.GetAttackAutocastActivity then
			return self.ability:GetAttackAutocastActivity(keys)
		end
	end
end
function modifier_anime_mechanic_ability_attack_autocast:GetAttackSound(keys)
	if IsServer() then
		--print(keys.record, "2")
		if self.CanAttackEffects and self.ability.GetAttackAutocastSound then
			return self.ability:GetAttackAutocastSound(keys)
		end
	end
end
--[[function modifier_anime_mechanic_ability_attack_autocast:GetModifierProjectileName(keys)
	if IsServer() then
		--print(keys.record, "3")
		if self.CanAttackEffects and self.ability.GetAttackAutocastProjectile then
			return self.ability:GetAttackAutocastProjectile(keys)
		end
	end
end]]
function modifier_anime_mechanic_ability_attack_autocast:GetModifierPreAttack_CriticalStrike(keys)
	if IsServer() then
		if keys.attacker ~= self.parent then
			return nil
		end
		--print(keys.record, "4")
		--if self.ability.GetAttackAutocastStart then
			if not self.CanAttackStart and not self.ability.GetAttackAutocastCantStartAttack then
				self.CanAttackStart = self.ability:GetAttackAutocastStart(keys)
			end

			if self.CanAttackStart == true then
				self.CanAttack[keys.record] = self.CanAttackStart
				self.CanModifiers[keys.record] = self.AttackAutocastCheckStateModifier

				self.CanAttackStart = nil
				self.AttackAutocastCheckStateModifier = nil
			end
		--end

		if self.CanAttack[keys.record] or self.ability.GetAttackAutocastCantStartAttack then
			self.CanAttackEffects = true
			self.ability.GetAttackAutocastCantStartAttack = nil
			
			--self.old_proj_name = self.parent:GetRangedProjectileName()

			--if self.ability.GetAttackAutocastProjectile then
				--self.parent:SetRangedProjectileName(self.ability:GetAttackAutocastProjectile(keys))
			--end

			if self.ability.GetAttackAutocastCrit then
				return self.ability:GetAttackAutocastCrit(keys)
			end
		end
	end
end
function modifier_anime_mechanic_ability_attack_autocast:OnAttack(keys)
	if IsServer() then
		if keys.attacker ~= self.parent then
			return nil
		end

		--self.parent:SetRangedProjectileName(self.old_proj_name)

		--print(keys.record, "5")
		if self.CanAttack[keys.record] then
			if self.ability.GetAttackAutocastAttack then
				return self.ability:GetAttackAutocastAttack(keys)
			end
		end
	end
end
--[[function modifier_anime_mechanic_ability_attack_autocast:OnAttackLanded(keys)
	if IsServer() then
		print(keys.record, "6")
		if self.CanAttack then
			self.AttackAutocastCheckStateModifier = self.parent:AddNewModifier(self.parent, self.ability, "modifier_anime_mechanic_ability_attack_autocast_state", {})

			if self.ability.GetAttackAutocastAttackLanded then
				return self.ability:GetAttackAutocastAttackLanded(keys)
			end
		end
	end
end]]
function modifier_anime_mechanic_ability_attack_autocast:GetModifierProcAttack_BonusDamage_Physical(keys)
	if IsServer() then
		if keys.attacker ~= self.parent then
			return nil
		end
		--print(keys.record, "7")
		if self.CanAttack[keys.record] and self.ability.GetAttackAutocastBonusDamage then
			keys.damage_type = DAMAGE_TYPE_PHYSICAL

			return self.ability:GetAttackAutocastBonusDamage(keys, DAMAGE_TYPE_PHYSICAL)
		end
	end
end
function modifier_anime_mechanic_ability_attack_autocast:GetModifierProcAttack_BonusDamage_Magical(keys)
	if IsServer() then
		if keys.attacker ~= self.parent then
			return nil
		end
		--print(keys.record, "8")
		if self.CanAttack[keys.record] and self.ability.GetAttackAutocastBonusDamage then
			keys.damage_type = DAMAGE_TYPE_MAGICAL

			return self.ability:GetAttackAutocastBonusDamage(keys, DAMAGE_TYPE_MAGICAL)
		end
	end
end
function modifier_anime_mechanic_ability_attack_autocast:GetModifierProcAttack_BonusDamage_Pure(keys)
	if IsServer() then
		if keys.attacker ~= self.parent then
			return nil
		end
		--print(keys.record, "9")
		if self.CanAttack[keys.record] and self.ability.GetAttackAutocastBonusDamage then
			keys.damage_type = DAMAGE_TYPE_PURE

			return self.ability:GetAttackAutocastBonusDamage(keys, DAMAGE_TYPE_PURE)
		end
	end
end
function modifier_anime_mechanic_ability_attack_autocast:OnAttackFail(keys)
	if IsServer() then
		if keys.attacker ~= self.parent then
			return nil
		end
		--print(keys.record, "10")
		if self.CanAttack[keys.record] and self.ability.GetAttackAutocastAttackFail then
			return self.ability:GetAttackAutocastAttackFail(keys)
		end
	end
end
function modifier_anime_mechanic_ability_attack_autocast:OnAttackRecordDestroy(keys)
	if IsServer() then
		if keys.attacker ~= self.parent then
			return nil
		end
		--print(keys.record, "11")
		if self.CanAttack[keys.record] then
			self.CanAttack[keys.record] = nil
			--self.CanAttackStart = nil
			self.CanAttackEffects = nil 

			local modifier = self.CanModifiers[keys.record]
			--print(modifier)
			if modifier and not modifier:IsNull() then
				modifier:Destroy()
			end
		end
	end
end
function modifier_anime_mechanic_ability_attack_autocast:OnOrder(keys)
    if IsServer() then
        if keys.unit == self.parent then
        	--print(keys.ability:GetName(), keys.order_type)
			if keys.ability == self.ability and keys.order_type == DOTA_UNIT_ORDER_CAST_TARGET then
			                
				self.CanAttackStart = true

			  	self.current_target = keys.target

			  	return nil
			end

            if keys.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET 
                and keys.target 
                and IsValidEntity(keys.target)
                and keys.target == self.current_target then

        		return nil
        	end

            if keys.ability 
                and not keys.ability:IsNull() 
                and bit.band(keys.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 
                and bit.band(keys.ability:GetBehavior(), DOTA_ABILITY_BEHAVIOR_IMMEDIATE) ~= 0 then

                return nil
            end

            self.CanAttackStart = nil
            self.current_target = nil
        end
    end
end
function modifier_anime_mechanic_ability_attack_autocast:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.CanAttack = {}
    self.CanModifiers = {}

    if self.ability.GetAttackAutocastOnIntervalThink then
    	self:StartIntervalThink(self.ability:GetAttackAutocastOnIntervalThink(true, false) or -1)
    end
end
function modifier_anime_mechanic_ability_attack_autocast:OnIntervalThink()
	self.ability:GetAttackAutocastOnIntervalThink(false, true)
end
function modifier_anime_mechanic_ability_attack_autocast:OnRefresh(hTable)
	self:OnCreated(hTable)
end
---------------------------------------------------------------------------------------------------------------------
modifier_anime_mechanic_ability_attack_autocast_state = class({})
function modifier_anime_mechanic_ability_attack_autocast_state:IsHidden() return true end
function modifier_anime_mechanic_ability_attack_autocast_state:IsDebuff() return false end
function modifier_anime_mechanic_ability_attack_autocast_state:IsPurgable() return false end
function modifier_anime_mechanic_ability_attack_autocast_state:IsPurgeException() return false end
function modifier_anime_mechanic_ability_attack_autocast_state:RemoveOnDeath() return false end
function modifier_anime_mechanic_ability_attack_autocast_state:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_anime_mechanic_ability_attack_autocast_state:CheckState()
	local ability = self:GetAbility()
	if ability and ability.GetAttackAutocastCheckState then
		return ability:GetAttackAutocastCheckState()
	end
end