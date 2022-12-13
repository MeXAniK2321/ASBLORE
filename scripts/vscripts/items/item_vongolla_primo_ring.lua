
LinkLuaModifier( "modifier_item_vongolla_primo_ring", "items/item_vongolla_primo_ring", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_vongolla_primo_ring_buff", "items/item_vongolla_primo_ring", LUA_MODIFIER_MOTION_NONE )
item_vongolla_primo_ring = class({})
function item_vongolla_primo_ring:GetIntrinsicModifierName()
    return "modifier_item_vongolla_primo_ring"
end
function item_vongolla_primo_ring:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration_buff")

	caster:AddNewModifier(caster, self, "modifier_item_vongolla_primo_ring_buff", {duration = duration})

	local cast_fx = ParticleManager:CreateParticle("", PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:ReleaseParticleIndex(cast_fx)
					
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cooldown"))

	
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_vongolla_primo_ring = class({})
function modifier_item_vongolla_primo_ring:IsHidden()
	return true
end

function modifier_item_vongolla_primo_ring:AllowIllusionDuplicate()
	return true
end

function modifier_item_vongolla_primo_ring:IsPurgable()
    return false
end

function modifier_item_vongolla_primo_ring:DeclareFunctions()
	local func = {  MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	                MODIFIER_PROPERTY_HEALTH_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, }
	return func
end

function modifier_item_vongolla_primo_ring:GetModifierSpellAmplify_Percentage()
if self:GetParent():HasItemInInventory("item_crucible_of_the_executioner") or self:GetParent():HasItemInInventory("item_yoru") or self:GetParent():HasItemInInventory("item_angel_halo")  then self.cd = 0 return end
 self.cd = self:GetAbility():GetSpecialValueFor('mag_ampf')
    return self.cd
end
function modifier_item_vongolla_primo_ring:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor('intellect')
end
function modifier_item_vongolla_primo_ring:GetModifierHealthBonus()
	return self:GetAbility():GetSpecialValueFor('health')
end
function modifier_item_vongolla_primo_ring:OnCreated(table)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	self.bonus_all_stats = self.ability:GetSpecialValueFor("bonus_all_stats")
	
	
end
function modifier_item_vongolla_primo_ring:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_vongolla_primo_ring:OnDestroy()
	if IsServer() then
	end
end



modifier_item_vongolla_primo_ring_buff = class({})
function modifier_item_vongolla_primo_ring_buff:IsHidden() return false end
function modifier_item_vongolla_primo_ring_buff:IsDebuff() return false end
function modifier_item_vongolla_primo_ring_buff:IsPurgable() return true end
function modifier_item_vongolla_primo_ring_buff:IsPurgeException() return true end
function modifier_item_vongolla_primo_ring_buff:RemoveOnDeath() return true end
function modifier_item_vongolla_primo_ring_buff:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					 }
	return func
end
function modifier_item_vongolla_primo_ring_buff:GetModifierSpellAmplify_Percentage()
	return 30
end

function modifier_item_vongolla_primo_ring_buff:OnCreated(table)
    
end
function modifier_item_vongolla_primo_ring_buff:OnRefresh(table)
	if IsServer() then
		self:OnCreated(table)
	end
end
function modifier_item_vongolla_primo_ring_buff:OnDestroy()
   local caster = self:GetCaster()


		

		
end

function modifier_item_vongolla_primo_ring_buff:GetEffectName()
	return "particles/generic_buff_2.vpcf"
end
function modifier_item_vongolla_primo_ring_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
---------------------------------------------------------------------------------------------------------------------

