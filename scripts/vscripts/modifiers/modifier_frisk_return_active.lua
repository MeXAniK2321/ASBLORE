
modifier_frisk_return_active = class({})

function modifier_frisk_return_active:GetEffectName()
	return "particles/frisk_return_shield.vpcf"
end
function modifier_frisk_return_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_frisk_return_active:OnCreated()
    if not IsServer() then return end
    self.carapaced_units = {}
    self.caster_stun = true
end

function modifier_frisk_return_active:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }

    return funcs
end
function modifier_frisk_return_active:GetModifierIncomingDamage_Percentage( params )
	

		return -100
	end
function modifier_frisk_return_active:OnTakeDamage( params )
    if not IsServer() then return end
    if params.unit == self:GetParent() then
	    local damageTaken = params.original_damage
		local damage = self:GetAbility():GetSpecialValueFor('damage')
		if params.attacker == self:GetParent() then return end
		if bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION then
			if not self.carapaced_units[ params.attacker:entindex() ] then
		        local damageTable = {
		            victim = params.attacker,
		            attacker = self:GetCaster(),
		            damage = damage,
		            damage_type = params.damage_type,
		            ability = self:GetAbility(),
		            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
		        }
		        ApplyDamage(damageTable)
				self:GetParent():Purge( false, true, false, true, false)
			end
			local stun_duration = self:GetAbility():GetSpecialValueFor('stun_duration')
			if self:GetParent():HasModifier( "modifier_true_hero" ) then
			else
			params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_frisk_return_debuff", {duration = stun_duration})
			end
			self.caster_stun = false
			self:GetParent():Purge( false, true, false, true, false)
			self:Destroy()
			self.carapaced_units[ params.attacker:entindex() ] = params.attacker
			self.parent = self:GetParent()
EmitSoundOn("frisk.8_1", self.parent)
		end
    end
end
