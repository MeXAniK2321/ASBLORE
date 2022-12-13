
LinkLuaModifier( "modifier_item_ultra_instinct", "items/item_ultra_instinct", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_ultra_instinct_buff", "items/item_ultra_instinct", LUA_MODIFIER_MOTION_NONE )
item_ultra_instinct = class({})
function item_ultra_instinct:GetIntrinsicModifierName()
    return "modifier_item_ultra_instinct"
end
function item_ultra_instinct:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration_buff")

	caster:AddNewModifier(caster, self, "modifier_item_ultra_instinct_buff", {duration = duration})

	local cast_fx = ParticleManager:CreateParticle("", PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:ReleaseParticleIndex(cast_fx)
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cooldown"))

	
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_ultra_instinct = class({})
function modifier_item_ultra_instinct:IsHidden() return true end
function modifier_item_ultra_instinct:IsDebuff() return false end
function modifier_item_ultra_instinct:IsPurgable() return false end
function modifier_item_ultra_instinct:IsPurgeException() return false end
function modifier_item_ultra_instinct:RemoveOnDeath() return false end
function modifier_item_ultra_instinct:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_ultra_instinct:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, }
	return func
end

function modifier_item_ultra_instinct:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end
function modifier_item_ultra_instinct:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end
function modifier_item_ultra_instinct:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end
function modifier_item_ultra_instinct:OnCreated(table)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_all_stats = self.ability:GetSpecialValueFor("bonus_all_stats")
end
function modifier_item_ultra_instinct:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_ultra_instinct:OnDestroy()
	if IsServer() then
	end
end



modifier_item_ultra_instinct_buff = class({})
function modifier_item_ultra_instinct_buff:IsHidden() return false end
function modifier_item_ultra_instinct_buff:IsDebuff() return false end
function modifier_item_ultra_instinct_buff:IsPurgable() return true end
function modifier_item_ultra_instinct_buff:IsPurgeException() return true end
function modifier_item_ultra_instinct_buff:RemoveOnDeath() return true end
function modifier_item_ultra_instinct_buff:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, }
	return func
end
function modifier_item_ultra_instinct_buff:GetModifierBonusStats_Strength()
	return self.multiplier_buff * self:GetParent():GetBaseStrength()
end
function modifier_item_ultra_instinct_buff:GetModifierBonusStats_Agility()
	return self.multiplier_buff * self:GetParent():GetBaseAgility()
end
function modifier_item_ultra_instinct_buff:GetModifierBonusStats_Intellect()
	return self.multiplier_buff * self:GetParent():GetBaseIntellect()
end
function modifier_item_ultra_instinct_buff:OnCreated(table)
     local caster = self:GetCaster()
	if IsServer() then
		self.ability = self:GetAbility()

		self.multiplier_buff = self.ability:GetSpecialValueFor("multiplier_buff") - 1
		

		EmitSoundOn("ultra.instinct", caster)

		
	end
end
function modifier_item_ultra_instinct_buff:OnRefresh(table)
	if IsServer() then
		self:OnCreated(table)
	end
end
function modifier_item_ultra_instinct_buff:OnDestroy()
   local caster = self:GetCaster()
	if IsServer() then
		
			StopSoundOn("ultra.instinct", caster)
		end

		

		
end

function modifier_item_ultra_instinct_buff:GetEffectName()
	return "particles/generic_buff_11.vpcf"
end
function modifier_item_ultra_instinct_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
---------------------------------------------------------------------------------------------------------------------

