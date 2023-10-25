LinkLuaModifier( "modifier_monster_energy", "items/item_monster_energy", LUA_MODIFIER_MOTION_NONE )
item_monster_energy = item_monster_energy or class({})

function item_monster_energy:OnSpellStart()
    if not IsServer() then return end
	-- unit identifier
	local caster = self:GetCaster()
    caster:Heal( self:GetSpecialValueFor("heal_amount"), self )
	
	caster:AddNewModifier(caster, self, "modifier_monster_energy", {} )
	EmitSoundOn("beer.monster_energy", caster)
    caster:CalculateStatBonus(true)
	self:SpendCharge()
end


modifier_monster_energy = modifier_monster_energy or class({})

--------------------------------------------------------------------------------

function modifier_monster_energy:IsHidden() return false end
function modifier_monster_energy:RemoveOnDeath() return false end
function modifier_monster_energy:IsDebuff() return false end
function modifier_monster_energy:IsStunDebuff() return false end
function modifier_monster_energy:IsPurgable() return false end
function modifier_monster_energy:GetTexture() 
    return "monster_energy"
end
function modifier_monster_energy:DeclareFunctions()
	local funcs = {
		              MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		              MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		              MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		              MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		              MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			      }
	return funcs
end
function modifier_monster_energy:OnCreated(hTable)
    self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.stacks = self:GetStackCount()
	
	self.damage_bonus = self.ability:GetSpecialValueFor("damage_bonus") * self:GetStackCount()
	self.stats_bonus = self.ability:GetSpecialValueFor("stats_bonus") * self:GetStackCount()
	self.spell_amplification = self.ability:GetSpecialValueFor("spell_amp") * self:GetStackCount()
	
    if not IsServer() then return end
	self:SetStackCount(self:GetStackCount() + 1)
end
function modifier_monster_energy:OnRefresh(hTable)
	self:OnCreated(hTable)
end
function modifier_monster_energy:GetModifierPreAttack_BonusDamage()
	return self.damage_bonus
end
function modifier_monster_energy:GetModifierBonusStats_Intellect()
	return self.stats_bonus
end
function modifier_monster_energy:GetModifierBonusStats_Agility()
	return self.stats_bonus
end
function modifier_monster_energy:GetModifierBonusStats_Strength()
	return self.stats_bonus
end
function modifier_monster_energy:GetModifierSpellAmplify_Percentage()
	return self.spell_amplification
end
