LinkLuaModifier("modifier_item_dress", "items/item_dress", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_hood_of_defiance_barrier", "items/item_dress", LUA_MODIFIER_MOTION_NONE)

item_dress = class({})

function item_dress:GetIntrinsicModifierName()
    return "modifier_item_dress"
end
function item_dress:OnSpellStart()
    local caster = self:GetCaster()
    local particle = "particles/items2_fx/pipe_of_insight_launch.vpcf"
	self.duration = self:GetSpecialValueFor("barrier_duration") or 20
	
    caster:AddNewModifier(caster, self, "modifier_item_imba_hood_of_defiance_barrier", { duration = self.duration })
	local particle_create = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
	ParticleManager:ReleaseParticleIndex(particle_create)
    EmitSoundOn("DOTA_Item.Pipe.Activate", caster)
end


modifier_item_dress = class({})

function modifier_item_dress:IsHidden() return true end
function modifier_item_dress:AllowIllusionDuplicate() return true end
function modifier_item_dress:IsPurgable() return false end
function modifier_item_dress:OnCreated()
	self.ability = self:GetAbility()
end
function modifier_item_dress:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, 
                      MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
                      MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		          }

    return funcs
end
function modifier_item_dress:GetModifierMagicalResistanceBonus()
    return self:GetParent():HasItemInInventory("item_serp_molot")
           and 0
		   or 15
end
function modifier_item_dress:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor('hp_regen')
end
function modifier_item_dress:GetModifierConstantManaRegen()
    return self:GetAbility():GetSpecialValueFor('mp_regen')
end

-----------------------------------------------------------------------------------------------------------
--	Hood of Defiance active shield that protects from spell damage
-----------------------------------------------------------------------------------------------------------
modifier_item_imba_hood_of_defiance_barrier = modifier_item_imba_hood_of_defiance_barrier or class({})

function modifier_item_imba_hood_of_defiance_barrier:IsDebuff() return false end
function modifier_item_imba_hood_of_defiance_barrier:IsHidden() return false end
function modifier_item_imba_hood_of_defiance_barrier:IsPurgable() return false end
function modifier_item_imba_hood_of_defiance_barrier:IsPurgeException() return false end

function modifier_item_imba_hood_of_defiance_barrier:OnCreated( params )
	if not self:GetAbility() then self:Destroy() return end

	self.ability                = self:GetAbility()
	self.barrier_block			= self.ability:GetSpecialValueFor("barrier_block") or 250
	self.barrier_health			= self.barrier_block
	
	self.particle = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(self.particle, 2, Vector(self:GetParent():GetModelRadius() * 1.2, 0, 0))
	self:AddParticle(self.particle, false, false, -1, false, false)
end
function modifier_item_imba_hood_of_defiance_barrier:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT}
end
function modifier_item_imba_hood_of_defiance_barrier:GetModifierIncomingSpellDamageConstant(keys)
	if IsClient() then
		return self.barrier_block
	else
		if keys.damage_type == DAMAGE_TYPE_MAGICAL then
			if keys.original_damage >= self.barrier_health then
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self:GetParent(), self.barrier_health, nil)
			
				self:Destroy()
				return self.barrier_health * (-1)
			else
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self:GetParent(), keys.original_damage, nil)
			
				self.barrier_health = self.barrier_health - keys.original_damage
				return keys.original_damage * (-1)
			end
		end
	end
end