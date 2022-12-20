item_black_march = class({})
LinkLuaModifier("modifier_item_black_march", "items/item_black_march", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_march_attack", "items/modifier_march_attack", LUA_MODIFIER_MOTION_NONE)
function item_black_march:GetIntrinsicModifierName()
	return "modifier_item_black_march" 
end
function item_black_march:OnSpellStart()
	local caster = self:GetCaster()
	local duration = 4
	caster:AddNewModifier(caster, self, "modifier_march_attack", {duration = 4})
--EmitSoundOn("black.march", caster)
	caster:Purge(false, true, false, true, true)
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_black_march = class({})
function modifier_item_black_march:IsHidden() return true end
function modifier_item_black_march:IsDebuff() return false end
function modifier_item_black_march:IsPurgable() return false end
function modifier_item_black_march:IsPurgeException() return false end
function modifier_item_black_march:RemoveOnDeath() return false end
function modifier_item_black_march:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_black_march:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	
     if not IsServer() then return end
	 
	 self.damage = self:GetCaster():GetAttackDamage()
	 self.damage2 = self.damage * 0.55 
end
function modifier_item_black_march:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_black_march:OnDestroy()
	if IsServer() then
	end
end

function modifier_item_black_march:DeclareFunctions()
	local func = {	
					 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		
		
		}
	return func
end
function modifier_item_black_march:OnAttackLanded(params)
if IsServer() then
		if params.attacker == self:GetParent() then
			if not params.attacker:IsIllusion() then
	if IsServer() then
			local damageTable = {
		attacker = self:GetParent(),
		damage = self.damage2 + 300,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	local heal = self.damage2 + 300 
	damageTable.victim = params.target
		ApplyDamage(damageTable)
		if self:GetParent():HasItemInInventory("item_samehada") then
		self:GetParent():Heal(heal * 0.3, nil)
		end
			end
		end
		end
		end
		end
function modifier_item_black_march:GetModifierBonusStats_Strength()
    return 25
end
 function modifier_item_black_march:GetModifierEvasion_Constant()
	return 50
end

function modifier_item_black_march:GetModifierBonusStats_Agility()
    return 85
end

function modifier_item_black_march:GetModifierBonusStats_Intellect()
    return 25
end




