-- Creator:
--	   AltiV, March 31st, 2020


LinkLuaModifier("modifier_imba_treant_overgrowth", "components/abilities/heroes/hero_treant", LUA_MODIFIER_MOTION_NONE)


imba_treant_overgrowth									= imba_treant_overgrowth or class({})
modifier_imba_treant_overgrowth							= modifier_imba_treant_overgrowth or class({})
----------------------------
-- IMBA_TREANT_OVERGROWTH --
----------------------------

function imba_treant_overgrowth:GetCastRange(location, target)
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

function imba_treant_overgrowth:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Treant.Overgrowth.CastAnim")
	
	return true
end

function imba_treant_overgrowth:OnSpellStart()
	-- Using one variable to track total number of units hit (allows overlapping), and a table for the standard logic (cannot stack the damage/root/disarm modifier)
	local enemies_hit = 0
	local enemies_hit_table = {}
	
	self:GetCaster():EmitSound("Hero_Treant.Overgrowth.Cast")

	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:ReleaseParticleIndex(cast_particle)
	enemies_hit = enemies_hit 
	
	for _, enemy in pairs(enemy) do
		-- "Forces a stop command onto the targets upon cast, so that their current move, attack and spell cast orders get canceled."
		enemy:Stop()
	
		enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_treant_overgrowth", {duration = self:GetSpecialValueFor("duration") * (1 - enemy:GetStatusResistance())})
		
		enemies_hit_table[enemy:entindex()] = true
	end
	
	
	
end

-------------------------------------
-- MODIFIER_IMBA_TREANT_OVERGROWTH --
-------------------------------------

function modifier_imba_treant_overgrowth:GetEffectName()
	return "particles/units/heroes/hero_treant/treant_overgrowth_vines.vpcf"
end

function modifier_imba_treant_overgrowth:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	
	self.damage	= self:GetAbility():GetTalentSpecialValueFor("damage")
	
	if not IsServer() then return end
	
	self.damage_type	= self:GetAbility():GetAbilityDamageType()
	
	self:StartIntervalThink(1 - self:GetParent():GetStatusResistance())
end

function modifier_imba_treant_overgrowth:OnIntervalThink()
	ApplyDamage({
		victim 			= self:GetParent(),
		damage 			= self.damage,
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= self:GetCaster(),
		ability 		= self:GetAbility()
	})
end

-- "Roots and disarms the targets, preventing them from moving, attacking and casting certain mobility spells. "
function modifier_imba_treant_overgrowth:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_INVISIBLE] = false
	}
end



