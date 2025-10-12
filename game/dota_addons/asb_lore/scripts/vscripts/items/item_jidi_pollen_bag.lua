---------------------------------------------------------------------------------
-- JIDI POLLEN BAG --------------------------------------------------------------
---------------------------------------------------------------------------------
LinkLuaModifier("modifier_jidi_poison_nova", "items/item_jidi_pollen_bag.lua", LUA_MODIFIER_MOTION_NONE)
item_jidi_pollen_bag = item_jidi_pollen_bag or class({})

function item_jidi_pollen_bag:OnSpellStart()
    local hCaster   = self:GetCaster()
	local vLocation = hCaster:GetOrigin()
	local fRadius   = self:GetSpecialValueFor("radius")
	local fDuration = self:GetSpecialValueFor("duration")
	
	local hEnemies = FindUnitsInRadius( hCaster:GetTeamNumber(),  -- int, your team number
									   vLocation,  -- point, center point
									   nil,  -- handle, cacheUnit. (not known)
									   fRadius,  -- float, radius. or use FIND_UNITS_EVERYWHERE
									   DOTA_UNIT_TARGET_TEAM_ENEMY,  -- int, team filter
									   DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  -- int, type filter
									   DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES,  -- int, flag filter
									   FIND_ANY_ORDER,  -- int, order filter
									   false  -- bool, can grow cache
									)
	EmitSoundOn("mayuribag.cast", hCaster)								
	
	local nParticle = ParticleManager:CreateParticle("particles/items5_fx/jidi_pollen_bag.vpcf", PATTACH_WORLDORIGIN, nil)
	                  ParticleManager:SetParticleControl(nParticle, 0, vLocation)
					  ParticleManager:SetParticleControl(nParticle, 1, Vector(fRadius, 255, 255))
					  ParticleManager:SetParticleControl(nParticle, 2, Vector(200, 1000, 0))
					  
	local nParticle2 = ParticleManager:CreateParticle("particles/item/mayuri_nova.vpcf", PATTACH_WORLDORIGIN, nil)
	                   ParticleManager:SetParticleControl(nParticle2, 0, vLocation)
					   ParticleManager:SetParticleControl(nParticle2, 1, Vector(25, 1, fRadius))
					  
	for _, hEnemy in pairs(hEnemies) do
        hEnemy:AddNewModifier(hEnemy, self, "modifier_jidi_poison_nova", { duration = fDuration })
		EmitSoundOn("mayuribag.hit", hEnemy)
	end
end

---------------------------------------------------------------------------------------------------------------
modifier_jidi_poison_nova = modifier_jidi_poison_nova or class ({})

function modifier_jidi_poison_nova:IsHidden() return false end
function modifier_jidi_poison_nova:IsDebuff() return true end
function modifier_jidi_poison_nova:IsPurgeable() return true end
function modifier_jidi_poison_nova:IsPurgeException() return true end
function modifier_jidi_poison_nova:RemoveOnDeath() return true end
function modifier_jidi_poison_nova:OnCreated(hTable)
    self.caster   = self:GetCaster()
    self.parent   = self:GetParent()
    self.ability  = self:GetAbility()
	
	self.fInterval = self.ability:GetSpecialValueFor("interval")
	self.fPercent  = self.ability:GetSpecialValueFor("percent_damage") / 1000
    
	if IsServer() then
		self:StartIntervalThink(self.fInterval)
    end
end
function modifier_jidi_poison_nova:OnIntervalThink()
	if not IsNotNull(self.caster) or not IsNotNull(self.parent) then return end
	
	local damage = {
					 victim = self.parent,
					 attacker = self.caster,
					 damage = self.parent:GetMaxHealth() * self.fPercent,
					 damage_type = DAMAGE_TYPE_MAGICAL,
					 ability = self.ability
				   }
	
	ApplyDamage(damage)
end
function modifier_jidi_poison_nova:GetEffectName()
    return "particles/decompiled_particles/units/heroes/hero_venomancer/venomancer_poison_debuff_nova.vpcf"
end

