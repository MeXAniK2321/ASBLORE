
modifier_march_attack = class({})
function modifier_march_attack:IsHidden() return false end
function modifier_march_attack:IsDebuff() return false end
function modifier_march_attack:IsPurgable() return true end
function modifier_march_attack:IsPurgeException() return true end
function modifier_march_attack:RemoveOnDeath() return true end
function modifier_march_attack:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
     if not IsServer() then return end
	 
	 self.damage = self:GetCaster():GetAttackDamage()
	 self.damage2 = self.damage * 0.22
   
end
function modifier_march_attack:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_march_attack:DeclareFunctions()
	local func = {	
					MODIFIER_EVENT_ON_ATTACK_LANDED,
					MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
					 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					}
	return func
end
function modifier_march_attack:GetModifierPreAttack_BonusDamage()
    return 0
end
function modifier_march_attack:GetModifierAttackSpeedBonus_Constant()
	return 50
end
function modifier_march_attack:GetModifierMoveSpeed_AbsoluteMin()
	 return 540
end
function modifier_march_attack:OnAttackLanded(params)
if IsServer() then
		if params.attacker == self:GetParent() then
			if not params.attacker:IsIllusion() then
	if IsServer() then
			local damageTable = {
		attacker = self:GetParent(),
		damage = self.damage2,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		local heal = self.damage
		if self:GetParent():HasItemInInventory("item_samehada") then
		self:GetParent():Heal(heal * 0.3, nil)
		end
			end
		end
		end
		end
		end

function modifier_march_attack:GetEffectName()
	return "particles/black_march.vpcf"
end
function modifier_march_attack:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end