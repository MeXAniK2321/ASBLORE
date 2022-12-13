item_avalon = class({})
LinkLuaModifier("modifier_item_avalon", "items/item_avalon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_avalon_buff", "items/item_avalon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_avalon_passive_buff", "items/item_avalon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_avalon_cooldown", "items/item_avalon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_avalon_flash", "items/item_avalon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_avalon", "items/item_avalon", LUA_MODIFIER_MOTION_NONE)
function item_avalon:GetIntrinsicModifierName()
	return "modifier_item_avalon"
end

function item_avalon:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_item_avalon_buff", {duration = 1})
	EmitSoundOn("avalon.cast", caster)
	self:PlayEffects( radius )

end
function item_avalon:PlayEffects( radius )
	local particle_cast = "particles/avalon.vpcf"
	local sound_cast = ""

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
modifier_item_avalon_cooldown = class({})
function modifier_item_avalon_cooldown:IsHidden() return false end
function modifier_item_avalon_cooldown:IsDebuff() return false end
function modifier_item_avalon_cooldown:IsPurgable() return false end
function modifier_item_avalon_cooldown:IsPurgeException() return false end
function modifier_item_avalon_cooldown:RemoveOnDeath() return false end


modifier_item_avalon_buff = class({})
function modifier_item_avalon_buff:IsHidden() return false end
function modifier_item_avalon_buff:IsDebuff() return false end
function modifier_item_avalon_buff:IsPurgable() return false end
function modifier_item_avalon_buff:IsPurgeException() return false end
function modifier_item_avalon_buff:RemoveOnDeath() return true end
function modifier_item_avalon_buff:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_item_avalon_buff:OnDestroy()
if self:GetParent():HasModifier("modifier_item_avalon_passive_buff") then
self.damage = 1500
else
	self.damage = 1000
	end
	self.radius = 500
	
local caster = self:GetCaster()
	if not IsServer() then return end
	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	if not IsServer() then return end
	-- find enemies
	local heroes = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,hero in pairs(heroes) do
		-- apply damage
		self.damageTable.victim = hero
		ApplyDamage( self.damageTable )

		hero:AddNewModifier(self:GetParent(), self, "modifier_avalon_flash", {duration = 1})
			local knockback = { should_stun = 1,
                        knockback_duration = 1,
                        duration = 1,
                        knockback_distance = 250,
                        knockback_height = 0,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    hero:AddNewModifier(caster, self, "modifier_knockback", knockback)
	end
	self:PlayEffects()
	
end
function modifier_item_avalon_buff:PlayEffects()
	-- stop sound
	local sound_end = ""
	StopSoundOn( sound_end, self:GetParent() )
	
	-- Get Resources
	local particle_cast = "particles/avalon_exp.vpcf"
	local sound_target = "avalon.effect"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self:GetParent() )
end

modifier_avalon_flash = class({})

--------------------------------------------------------------------------------

function modifier_avalon_flash:IsHidden()
    return false
end

function modifier_avalon_flash:IsPurgable()
    return false
end
function modifier_avalon_flash:OnCreated()

	self:PlayEffects()
end


function modifier_avalon_flash:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/avalon_flash.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end
---------------------------------------------------------------------------------------------------------------------
modifier_item_avalon = class({})
function modifier_item_avalon:IsHidden() return true end
function modifier_item_avalon:IsDebuff() return false end
function modifier_item_avalon:IsPurgable() return false end
function modifier_item_avalon:IsPurgeException() return false end
function modifier_item_avalon:RemoveOnDeath() return false end
function modifier_item_avalon:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_avalon:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		  MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					}
	return func
end
function modifier_item_avalon:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_item_avalon:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end
function modifier_item_avalon:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_avalon:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_item_avalon:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
  function modifier_item_avalon:GetModifierPhysicalArmorBonus()
return self:GetAbility():GetSpecialValueFor('armor')
end

 function modifier_item_avalon:OnTakeDamage(keys)
	if IsServer() then
    local caster = self:GetCaster()
	
		local attacker = keys.attacker
	local target = keys.unit
	
	
			
			
		   
			
				local hp = self:GetParent():GetMaxHealth() * 0.5
				if self:GetParent():GetHealth() <= hp then
				if not self:GetParent():IsIllusion() then
				
			     
				 
				
				
					if not self:GetParent():HasModifier("modifier_item_avalon_cooldown") then
				
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_avalon_cooldown", {duration = 80.0 })
					self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_avalon_passive_buff", {duration = 10})
				
			
					
					
					
					return
				end
               
		end
			end
		end
	end
	
modifier_item_avalon_passive_buff = class({})

function modifier_item_avalon_passive_buff:IsPurgable()
    return false
end
function modifier_item_avalon_passive_buff:OnCreated(table)
    self.caster = self:GetCaster()
	self.hp = self.caster:GetMaxHealth() * 0.05
	end
function modifier_item_avalon_passive_buff:DeclareFunctions()
    local funcs = {
        
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }

    return funcs
end

function modifier_item_avalon_passive_buff:GetModifierConstantHealthRegen()
    return self.hp
end

function modifier_item_avalon_passive_buff:GetEffectName()
    return "particles/econ/items/juggernaut/jugg_fortunes_tout/jugg_healling_ward_fortunes_tout_gold_hero_heal.vpcf"
end

function modifier_item_avalon_passive_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_avalon_passive_buff:StatusEffectPriority()
    return 5
end
	



