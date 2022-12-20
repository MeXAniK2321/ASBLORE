LinkLuaModifier("modifier_aegis_activate_buff_block", "heroes/aegis_activate", LUA_MODIFIER_MOTION_NONE)

aegis_activate = class({})

function aegis_activate:IsHiddenWhenStolen()	return false end

function aegis_activate:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()

		-- Play Sound
		caster:EmitSound("ikaros.5_3")
		

		-- Check health cost required due to over channel
		

		-- Strong Dispel


		local modifier_name_aphotic_shield = "modifier_aegis_activate_buff_block"

		-- Remove previous aphotic shield
		-- Did not use RemoveModifierByNameAndCaster because it will not destroy the shield if it was stolen by rubick from another rubick who stole from abaddon
		target:RemoveModifierByName(modifier_name_aphotic_shield)

		local duration = self:GetSpecialValueFor("duration")
		-- Add new modifier
		target:AddNewModifier(caster, self, modifier_name_aphotic_shield, { duration = duration })
	end
end

modifier_aegis_activate_buff_block = modifier_aegis_activate_buff_block or class({
	IsHidden				= function(self) return false end,
	IsPurgable	  			= function(self) return true end,
	IsDebuff	  			= function(self) return false end
})

function modifier_aegis_activate_buff_block:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end

function modifier_aegis_activate_buff_block:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local shield_size = target:GetModelRadius() * 0.7
		local ability = self:GetAbility()
		local ability_level = ability:GetLevel()
		local target_origin = target:GetAbsOrigin()
		local attach_hitloc = "attach_hitloc"

		self.shield_init_value = self:GetAbility():GetSpecialValueFor("damage_absorb")
		self.shield_remaining = self.shield_init_value
		self.target_current_health = target:GetHealth()

		-- Talent : During the first second of Aphotic Shield, it absorbs all damage done to it and adds it to it's health/damage
		

		local particle = ParticleManager:CreateParticle("particles/aegis_activated.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		local common_vector = Vector(shield_size,0,shield_size)
		ParticleManager:SetParticleControl(particle, 1, common_vector)
		ParticleManager:SetParticleControl(particle, 2, common_vector)
		ParticleManager:SetParticleControl(particle, 4, common_vector)
		ParticleManager:SetParticleControl(particle, 5, Vector(shield_size,0,0))

		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, attach_hitloc, target_origin, true)
		self:AddParticle(particle, false, false, -1, false, false)

	
		
	end
end

function modifier_aegis_activate_buff_block:OnDestroy()
	if IsServer() then
		local target 				= self:GetParent()
		local caster 				= self:GetCaster()
		local ability 				= self:GetAbility()
		local ability_level 		= ability:GetLevel()
		local radius 				= 400
		local explode_target_team 	= DOTA_UNIT_TARGET_TEAM_BOTH
		local explode_target_type 	= DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_vector			= target:GetAbsOrigin()

		target:EmitSound("Hero_Abaddon.AphoticShield.Destroy")

		-- Explosion particle is shown by default when the particle is to be removed, however that does not work for illusions. Hence this added explosion is to make the particle show when illusions die
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, target_vector)
		ParticleManager:ReleaseParticleIndex(particle)

		
	
	end
end


--Block damage
function modifier_aegis_activate_buff_block:GetModifierTotal_ConstantBlock(kv)
	if IsServer() then
		local target 					= self:GetParent()
		local original_shield_amount	= self.shield_remaining
		local shield_hit_particle 		= "particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_hit.vpcf"
		-- Avoid blocking when borrowed time is active						--No need for block when there is no damage
		if not target:HasModifier("modifier_imba_borrowed_time_buff_hot_caster")  and kv.damage > 0 and bit.band(kv.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then

			if self.has_talent and not self.invulnerability_expired then
				-- damage_absorbtion_end is calculated in OnCreated
				if GameRules:GetGameTime() <= self.damage_absorption_end then
					self.shield_remaining = self.shield_remaining + kv.damage
					original_shield_amount = self.shield_remaining
					-- Increase the max capacity. The if check is just for sanity
					if self.shield_remaining > self.shield_init_value then
						self.shield_init_value = self.shield_remaining
					end
				else
					-- copy-paste of code, but that allows skipping on GetGameTime calls in the if
					self.shield_remaining = self.shield_remaining - kv.damage
					self.invulnerability_expired = true
				end
			else
				--Reduce the amount of shield remaining
				self.shield_remaining = self.shield_remaining - kv.damage
			end


			--If there is enough shield to block everything, then block everything.
			if kv.damage < original_shield_amount then
				--Emit damage blocking effect
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, kv.damage, nil)
				return kv.damage
					--Else, reduce what you can and blow up the shield
			else
				--Emit damage block effect
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, target, original_shield_amount, nil)
				self:Destroy()
				return original_shield_amount
			end

		end
	end

end

function modifier_aegis_activate_buff_block:ResetAndExtendBy(seconds)
	self.shield_remaining = self.shield_init_value
	self:SetDuration(self:GetRemainingTime() + seconds, true)
end