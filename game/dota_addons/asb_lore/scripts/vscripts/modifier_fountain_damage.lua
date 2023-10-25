modifier_fountain_damage = class({})
function modifier_fountain_damage:IsHidden() return true end
function modifier_fountain_damage:IsDebuff() return false end
function modifier_fountain_damage:IsPurgable() return false end
function modifier_fountain_damage:IsPurgeException() return false end
function modifier_fountain_damage:RemoveOnDeath() return false end
function modifier_fountain_damage:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_fountain_damage:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		              MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE,
                  }

    return funcs
end
function modifier_fountain_damage:GetModifierPreAttack_BonusDamage()
    return 1000
end
function modifier_fountain_damage:GetModifierAttackRangeBonusUnique()
	return -500
end