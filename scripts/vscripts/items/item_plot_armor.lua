
LinkLuaModifier( "modifier_item_plot_armor", "items/item_plot_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_plot_armor_buff", "items/item_plot_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_plot_armor_buff2", "items/item_plot_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ne_vmerla", "items/item_plot_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_plot_armor_buff5", "items/item_plot_armor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_power_of_youth_aura", "items/item_power_of_youth", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_power_of_youth_aura_debuff", "items/item_power_of_youth", LUA_MODIFIER_MOTION_NONE)
item_plot_armor = class({})
function item_plot_armor:GetIntrinsicModifierName()
    return "modifier_item_plot_armor"
end
function item_plot_armor:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration_buff")

	caster:AddNewModifier(caster, self, "modifier_item_plot_armor_buff", {duration = duration})
	caster:AddNewModifier(caster, self, "modifier_item_plot_armor_buff2", {duration = duration})

	local cast_fx = ParticleManager:CreateParticle("", PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:ReleaseParticleIndex(cast_fx)
caster:EmitSound("tryme.bitch")
self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cooldown"))

end
---------------------------------------------------------------------------------------------------------------------
modifier_item_plot_armor = class({})
function modifier_item_plot_armor:IsHidden() return true end
function modifier_item_plot_armor:IsDebuff() return false end
function modifier_item_plot_armor:IsPurgable() return false end
function modifier_item_plot_armor:IsPurgeException() return false end
function modifier_item_plot_armor:RemoveOnDeath() return false end
function modifier_item_plot_armor:DeclareFunctions()
	local func = {	
					 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					 MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                    				}
	return func
end
function modifier_item_plot_armor:GetModifierBonusStats_Strength()
    return 20
end
  function modifier_item_plot_armor:GetModifierPhysicalArmorBonus()
return 20
end      

function modifier_item_plot_armor:GetModifierBonusStats_Agility()
    return 20
end
function modifier_item_plot_armor:GetModifierBonusStats_Intellect()
    return 20
end

function modifier_item_plot_armor:GetModifierIncomingDamage_Percentage( params )
	

		return -15
	end

modifier_item_plot_armor_buff = class({})
function modifier_item_plot_armor_buff:IsHidden() return false end
function modifier_item_plot_armor_buff:IsDebuff() return false end
function modifier_item_plot_armor_buff:IsPurgable() return false end
function modifier_item_plot_armor_buff:IsPurgeException() return true end
function modifier_item_plot_armor_buff:RemoveOnDeath() return true end
function modifier_item_plot_armor_buff:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	
					
					}
	return func
end
function modifier_item_plot_armor_buff:GetModifierIncomingDamage_Percentage( params )
	

		return -20
	end

function modifier_item_plot_armor_buff:OnTakeDamage(keys)
	if not IsServer() then return end
	
	local attacker = keys.attacker
	local target = keys.unit
	local original_damage = keys.original_damage
	local damage_type = keys.damage_type
	local damage_flags = keys.damage_flags
	if keys.unit == self:GetParent() and not keys.attacker:IsBuilding() and keys.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then	
		if not keys.unit:IsOther() then
			EmitSoundOnClient("DOTA_Item.BladeMail.Damage", keys.attacker:GetPlayerOwner())
			local damageTable = {
				victim			= keys.attacker,
				damage			= keys.original_damage,
				damage_type		= keys.damage_type,
				damage_flags 	= DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				attacker		= self:GetParent(),
				ability			= self:GetAbility()
			}
			ApplyDamage(damageTable)
		end
	end
end
function modifier_item_plot_armor_buff:OnRefresh(table)
	if IsServer() then
		self:OnCreated(table)
	end
end


function modifier_item_plot_armor_buff:GetEffectName()
	return "particles/plot_armor.vpcf"
end
function modifier_item_plot_armor_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_plot_armor_buff2 = class({})
function modifier_item_plot_armor_buff2:IsHidden() return true end
function modifier_item_plot_armor_buff2:IsDebuff() return false end
function modifier_item_plot_armor_buff2:IsPurgable() return false end
function modifier_item_plot_armor_buff2:IsPurgeException() return true end
function modifier_item_plot_armor_buff2:RemoveOnDeath() return true end
function modifier_item_plot_armor_buff2:DeclareFunctions()
	local func = {	
	MODIFIER_EVENT_ON_TAKEDAMAGE,
	
					
					}
	return func
end


function modifier_item_plot_armor_buff2:OnTakeDamage(params)
	if IsServer() then
	if self:GetParent():HasModifier("modifier_plot_armor_buff5") then
	else
		if params.unit == self:GetParent() then
			
			
		   
			
				
				
				if self:GetParent():GetHealth() <= 50 then
				
				
					
					self:GetParent():SetHealth(100)
					self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ne_vmerla", {duration = 0.2})
					self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_plot_armor_buff5", {duration = 10})
					return
				end
               
		
			end
		end
	end
	end

modifier_ne_vmerla = class({})

function modifier_ne_vmerla:OnCreated()
   EmitSoundOn( "ne.vmerla", self:GetParent() )
	end
function modifier_ne_vmerla:IsHidden() return false end

function modifier_ne_vmerla:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW end

function modifier_ne_vmerla:DeclareFunctions()
	local funcs = {	MODIFIER_PROPERTY_MIN_HEALTH}
	return funcs
end

function modifier_ne_vmerla:GetMinHealth()
	return 1 
end
function modifier_ne_vmerla:GetEffectName()
	return "particles/plot_armor_ne_vmerla.vpcf"
end
function modifier_ne_vmerla:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_plot_armor_buff5 = class({})
function modifier_plot_armor_buff5:IsHidden() return false end
function modifier_plot_armor_buff5:IsDebuff() return false end
function modifier_plot_armor_buff5:IsPurgable() return false end