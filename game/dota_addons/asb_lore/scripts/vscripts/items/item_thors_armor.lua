item_thors_armor = item_thors_armor or class({})

LinkLuaModifier("modifier_item_thors_armor", "items/item_thors_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_thors_armor_active", "items/item_thors_armor", LUA_MODIFIER_MOTION_NONE)

function item_thors_armor:GetIntrinsicModifierName()
    return "modifier_item_thors_armor"
end
function item_thors_armor:OnSpellStart()
    local hCaster = self:GetCaster()
    local vCasterLoc = hCaster:GetAbsOrigin()
    local vCasterGnd = GetGroundPosition(vCasterLoc, hCaster)

    hCaster:AddNewModifier(hCaster, self, "modifier_item_thors_armor_active", {duration = self:GetSpecialValueFor("active_duration")})
	EmitSoundOn("baal.1_1", hCaster)
	
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_WORLDORIGIN, nil)
                            ParticleManager:SetParticleShouldCheckFoW(particle, false)
                            ParticleManager:SetParticleControl(particle, 0, vCasterGnd + Vector(0, 0, 1500))
                            ParticleManager:SetParticleControl(particle, 1, vCasterGnd + Vector(0, 0, 100))
                            ParticleManager:ReleaseParticleIndex(particle)
end

-- Item stats
---------------------------------------------------------------------------------------------------------------
modifier_item_thors_armor = modifier_item_thors_armor or class({})

function modifier_item_thors_armor:IsHidden()                          return false end
function modifier_item_thors_armor:RemoveOnDeath()                     return true end
function modifier_item_thors_armor:IsPurgable()                        return false end
function modifier_item_thors_armor:GetAttributes()                     return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_thors_armor:DeclareFunctions()
    local tFunc =   {
	
                        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
						MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
						MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
						MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
						
                    }
    return tFunc
end
function modifier_item_thors_armor:GetTexture() 
    return "thors_armor"
end
function modifier_item_thors_armor:GetModifierPhysicalArmorBonus(keys)
    return self.nBonusArmor
end
function modifier_item_thors_armor:GetModifierBonusStats_Strength(keys)
    return self.nBonusAllStats
end
function modifier_item_thors_armor:GetModifierBonusStats_Agility(keys)
    return self.nBonusAllStats
end
function modifier_item_thors_armor:GetModifierBonusStats_Intellect(keys)
    return self.nBonusAllStats
end
function modifier_item_thors_armor:OnCreated(table)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()

    self.nBonusAllStats = self.hAbility:GetSpecialValueFor("bonus_allstats")
    self.nBonusArmor = self.hAbility:GetSpecialValueFor("bonus_armor")
	
	-- Begin Interval Think
	self:StartIntervalThink(1.0)
	
end
function modifier_item_thors_armor:OnRefresh(tTable)
    self:OnCreated(tTable)
end
function modifier_item_thors_armor:OnIntervalThink()
    if not IsServer() then return end
    -- Increment charges per second
	if self:GetStackCount() < 10 then
	self:IncrementStackCount()
	end
	
	local radius = self:GetAbility():GetSpecialValueFor("radius")
	
	if self:GetStackCount() == 10 and not self:GetParent():IsOutOfGame() and self:GetParent():IsAlive() then
	 for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY + DOTA_UNIT_TARGET_TEAM_CUSTOM, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)) do
	  		

			-- This ability should not affect channeling units, prevent TP cancel
			if enemy:IsChanneling() then return else end
			
			-- Apply Damage to the closest visible enemy hero
			ApplyDamage({
			victim 			= enemy,
			damage 			= self:GetAbility():GetSpecialValueFor("damage"),
			damage_type		= DAMAGE_TYPE_MAGICAL,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self:GetAbility()
		})
		
		   -- Apply stun
		   enemy:AddNewModifier(enemy, self:GetAbility(), "modifier_generic_stunned_lua", {duration = self:GetAbility():GetSpecialValueFor("stun_duration")})
		   
	      -- Get Resources
	      local particle_cast = "particles/kinton_lightning.vpcf"
	      local sound_cast = "kumagawa.lightning"

	      -- Create Lightning Particle
	      local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, enemy )
	      ParticleManager:ReleaseParticleIndex( effect_cast )
		  
	     -- Create Sound
	     EmitSoundOn( "kumagawa.lightning", enemy )
		 
        -- Start the counter again
		 self:SetStackCount(1)
		 break
	 
	 end
	end
end

-- Modifier for 100% Dmg Reduction
---------------------------------------------------------------------------------------------------------
modifier_item_thors_armor_active = modifier_item_thors_armor_active or class({})

function modifier_item_thors_armor_active:IsHidden()                                   return false end
function modifier_item_thors_armor_active:RemoveOnDeath()                              return true end
function modifier_item_thors_armor_active:IsPurgable()                                 return false end
function modifier_item_thors_armor_active:DeclareFunctions()
    local tFunc =   {
						MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                    }
    return tFunc
end
function modifier_item_thors_armor_active:GetModifierIncomingDamage_Percentage(keys)
    return -100
end
function modifier_item_thors_armor_active:OnCreated(tTable)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()

    if IsServer() then
    else
        if not self.nParticlePFX then
            self.nParticlePFX = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_repel_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hParent)
                                ParticleManager:SetParticleControl(self.nParticlePFX, 60, Vector(0, 255, 0))
                                ParticleManager:SetParticleControl(self.nParticlePFX, 61, Vector(0, 255, 0))
                                ParticleManager:SetParticleControl(self.nParticlePFX, 62, Vector(0, 255, 0))

            self:AddParticle(self.nParticlePFX, false, false, -1, false, false)
        end
    end
end
function modifier_item_thors_armor_active:OnRefresh(tTable)
    self:OnCreated(tTable)
end
function modifier_item_thors_armor_active:OnDestroy()
    if IsServer() and self.hParent then
        StopSoundOn(self.sEmitSound, self.hParent)
    end
end