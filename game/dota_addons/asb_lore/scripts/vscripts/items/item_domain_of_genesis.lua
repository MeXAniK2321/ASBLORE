LinkLuaModifier("modifier_domain_of_genesis", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_domain_of_genesis_stat", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_upgrade_core", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_sirin_awakening", "heroes/kiana/kiana", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_core_upgrade_2", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_core_upgrade_3", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_finality_herrsher_form", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_flameshion_herrsher_form", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sirin_herrsher_form", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drifter_core", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_herrsher_mode_cooldown", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_finality_aquired", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ultimate_start", "items/item_domain_of_genesis", LUA_MODIFIER_MOTION_NONE)
item_domain_of_genesis = class({})

function item_domain_of_genesis:GetIntrinsicModifierName()
    return "modifier_domain_of_genesis"
	end
function item_domain_of_genesis:OnSpellStart()
 local caster = self:GetCaster()
local modifier = caster:FindModifierByName("modifier_will_of_the_herrsher")
if modifier then
if caster:HasModifier("modifier_form_change") then
caster:RemoveModifierByName("modifier_form_change")
end
local stack = modifier:GetStackCount()
	caster:AddNewModifier(caster, self, "modifier_ultimate_start", {duration = 20})
	end
	end
	
	
function item_domain_of_genesis:HerrsherForm()
 local caster = self:GetCaster()
local modifier = caster:FindModifierByName("modifier_will_of_the_herrsher")
if modifier then
if caster:HasModifier("modifier_form_change") then
caster:RemoveModifierByName("modifier_form_change")
end
local stack = modifier:GetStackCount()
if caster:HasModifier("modifier_core_upgrade_3") then
if not caster:HasModifier("modifier_herrsher_mode_cooldown") then
EmitSoundOn("kiana.final_words", caster)
		_G.MusicBox:RemoveModifierByName("modifier_star_tier3")
	 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")	
	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	_G.CurrentMusicUltima = "kiana.finality_theme"
_G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 60})
	caster:AddNewModifier(caster, self, "modifier_finality_herrsher_form", {duration = 60})
		caster:AddNewModifier(caster, self, "modifier_herrsher_mode_cooldown", {duration = 220 * caster:GetCooldownReduction()})
end
elseif caster:HasModifier("modifier_core_upgrade_2") then
if not caster:HasModifier("modifier_herrsher_mode_cooldown") then

	caster:AddNewModifier(caster, self, "modifier_flameshion_herrsher_form", {duration = 60})
		caster:AddNewModifier(caster, self, "modifier_herrsher_mode_cooldown", {duration = 220 * caster:GetCooldownReduction()})
		_G.MusicBox:RemoveModifierByName("modifier_star_tier3")
	 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")	
	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	_G.CurrentMusicUltima = "flameshion.base_theme"
_G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 60})

end
elseif caster:HasModifier("modifier_upgrade_core") then
if not caster:HasModifier("modifier_herrsher_mode_cooldown") then
	caster:AddNewModifier(caster, self, "modifier_drifter_core", {duration = 30})
		caster:AddNewModifier(caster, self, "modifier_herrsher_mode_cooldown", {duration = 140})
			_G.MusicBox:RemoveModifierByName("modifier_star_tier3")
	 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")	
	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	_G.CurrentMusicUltima = "kiana.drifter_theme"
_G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 30})
end
elseif  caster:HasModifier("modifier_sirin_awakening") then
	if not caster:HasModifier("modifier_herrsher_mode_cooldown") then
			caster:AddNewModifier(caster, self, "modifier_herrsher_mode_cooldown", {duration = 200 * caster:GetCooldownReduction()})
		caster:AddNewModifier(caster, self, "modifier_sirin_herrsher_form", {duration = 60})
				_G.MusicBox:RemoveModifierByName("modifier_star_tier3")
	 _G.MusicBox:RemoveModifierByName("modifier_star_tier2")	
	_G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	_G.CurrentMusicUltima = "sirin.base_theme"
_G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 60})
else
self:EndCooldown()
end
end
end
end

		
		modifier_ultimate_start = class({})
function modifier_ultimate_start:IsHidden() return true end
function modifier_ultimate_start:IsDebuff() return false end
function modifier_ultimate_start:IsPurgable() return false end
function modifier_ultimate_start:IsPurgeException() return false end
function modifier_ultimate_start:RemoveOnDeath() return false end
function modifier_ultimate_start:AllowIllusionDuplicate() return false end

	
		modifier_finality_aquired = class({})
function modifier_finality_aquired:IsHidden() return true end
function modifier_finality_aquired:IsDebuff() return false end
function modifier_finality_aquired:IsPurgable() return false end
function modifier_finality_aquired:IsPurgeException() return false end
function modifier_finality_aquired:RemoveOnDeath() return false end
function modifier_finality_aquired:AllowIllusionDuplicate() return false end

	
	
	modifier_drifter_core = class({})
function modifier_drifter_core:IsHidden() return false end
function modifier_drifter_core:IsDebuff() return true end
function modifier_drifter_core:IsPurgable() return false end
function modifier_drifter_core:IsPurgeException() return false end
function modifier_drifter_core:RemoveOnDeath() return true end
function modifier_drifter_core:AllowIllusionDuplicate() return true end

function modifier_drifter_core:DeclareFunctions()
    local func = { 
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					 MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
					  -- MODIFIER_EVENT_ON_TAKEDAMAGE,
					         MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
							
			}
    return func
end
function modifier_drifter_core:OnTakeDamage(keys)
	if IsServer() then
	local caster = self:GetCaster()
	local rng = 100
	local damage = keys.original_damage
	if damage > 250 and self:GetCaster():IsAlive() then
	
		if keys.attacker == self.parent and keys.damage_category == 0 and keys.inflictor ~= self:GetAbility() then
			if not self.parent.bullshit_copy then
				self.parent.bullshit_copy = self.ability
			end

			local flags = 0
			if keys.inflictor then
				flags = keys.inflictor:GetAbilityTargetFlags()
			end
			
			if self.parent.bullshit_copy == self.ability and  UnitFilter(	keys.unit,
																		DOTA_UNIT_TARGET_TEAM_BOTH,--keys.inflictor:GetAbilityTargetTeam(), 
																		DOTA_UNIT_TARGET_ALL,--keys.inflictor:GetAbilityTargetType(), 
																		flags + DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES - DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
																		self.parent:GetTeamNumber()) == UF_SUCCESS then
				--print(keys.original_damage, "STONE ORIG, DAMAGE")
               
               local damage_type = keys.damage_type
			   if damage_type == DAMAGE_TYPE_PHYSICAL then
			  local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		keys.unit:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

local str = caster:GetAverageTrueAttackDamage(keys.unit)
local damage =str 
	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		--caster:Heal(damage, nil)
	end
			local target = keys.unit
					--EmitSoundOn("fallen.slash", target)

			   -- caster:AddNewModifier(caster, self:GetAbility(), "modifier_will_of_the_fallen_cd", {duration = 2.5})
				--keys.unit:AddNewModifier(caster, self:GetAbility(), "modifier_will_of_the_fallen_int_overflow", {duration = 5.0})
				self:PlayEffects(target)
			   end
			   end
			end
		end
		end
	end

function modifier_drifter_core:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/void_drifter_activation_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( 500, 1, 500 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end

function modifier_drifter_core:GetModifierIncomingDamage_Percentage( params )
	

		return -25
	
	end
function modifier_drifter_core:GetModifierPreAttack_BonusDamage()
    return 200
end
function modifier_drifter_core:GetModifierPercentageCooldown()
    return 50
end

function modifier_drifter_core:OnCreated(table)
 if IsServer() then
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self:PlayEffects(600)
       if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/void_drifter_activation_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
	

        
		
       -- EmitSoundOn("kiana.sirin_herrsher_form", self.parent)

        

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_drifter_core:PlayEffects( radius )

	local particle_cast = "particles/void_drifter_activation_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_drifter_core:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_drifter_core:OnDestroy()
    if IsServer() then
if self.particle_time then
           ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		end
			

          end

    end

	modifier_upgrade_core = class({})
function modifier_upgrade_core:IsHidden() return false end
function modifier_upgrade_core:IsDebuff() return true end
function modifier_upgrade_core:IsPurgable() return false end
function modifier_upgrade_core:IsPurgeException() return false end
function modifier_upgrade_core:RemoveOnDeath() return false end
function modifier_upgrade_core:AllowIllusionDuplicate() return true end

function modifier_upgrade_core:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
						MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,

	                }
    return func
end

function modifier_upgrade_core:GetModifierBonusStats_Strength()
	return 0
end
function modifier_upgrade_core:GetModifierBonusStats_Agility()
	return 0
end
function modifier_upgrade_core:GetModifierModelChange()
	return "models/kiana/kiana_void_drifter/kiana_void_drifter.vmdl"
end
function modifier_upgrade_core:GetModifierModelScale()

	return 1
	end

function modifier_upgrade_core:GetModifierPreAttack_BonusDamage()
    return 0
end

function modifier_upgrade_core:OnDestroy()
    if IsServer() then
local ability = self:GetParent():FindAbilityByName("kiana_drifter_form")
if ability then
ability:StartCooldown(ability:GetCooldown(-1))
		end
			

          end

    end
modifier_herrsher_mode_cooldown = class({})


function modifier_herrsher_mode_cooldown:IsHidden()
    return false
end
function modifier_herrsher_mode_cooldown:RemoveOnDeath() return false end
function modifier_herrsher_mode_cooldown:IsPurgable()
    return false
end


modifier_domain_of_genesis = class({})


function modifier_domain_of_genesis:IsHidden()
    return true
end
function modifier_domain_of_genesis:RemoveOnDeath() return false end
function modifier_domain_of_genesis:IsPurgable()
    return false
end
function modifier_domain_of_genesis:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_domain_of_genesis:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_domain_of_genesis:DeclareFunctions()
    local funcs = {
          MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }

    return funcs
end

function modifier_domain_of_genesis:GetModifierBaseAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end


function modifier_domain_of_genesis:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_domain_of_genesis:GetModifierBonusStats_Intellect()

    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_domain_of_genesis:GetModifierBonusStats_Strength()

    return self:GetAbility():GetSpecialValueFor('all_stats')
end


function modifier_domain_of_genesis:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end














modifier_sirin_herrsher_form = class({})
function modifier_sirin_herrsher_form:IsHidden() return false end
function modifier_sirin_herrsher_form:IsDebuff() return true end
function modifier_sirin_herrsher_form:IsPurgable() return false end
function modifier_sirin_herrsher_form:IsPurgeException() return false end
function modifier_sirin_herrsher_form:RemoveOnDeath() return true end
function modifier_sirin_herrsher_form:AllowIllusionDuplicate() return true end

function modifier_sirin_herrsher_form:DeclareFunctions()
    local func = { 
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					 MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
							
			}
    return func
end



function modifier_sirin_herrsher_form:GetModifierPreAttack_BonusDamage()
    return 150
end

function modifier_drifter_core:GetModifierPercentageCooldown()
    if self:GetParent():HasItemInInventory("item_watch") then
	return 15
	else
    return 30
	end
end
function modifier_sirin_herrsher_form:OnCreated(table)
 if IsServer() then
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

self:PlayEffects(600)
  

    self.skills_table = {
                           
							["will_of_the_herrsher"] = "sirin_spear_barrage",
                            
                        }


   
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
       if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/sirin_awakening_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
	

        
		
        EmitSoundOn("kiana.sirin_herrsher_form", self.parent)

        

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_sirin_herrsher_form:PlayEffects( radius )

	local particle_cast = "particles/sirin_awakening_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_sirin_herrsher_form:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_sirin_herrsher_form:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
		
           ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		
			StopSoundOn("kiana.sirin_herrsher_form", self.parent)

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("zenitsu_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end

    end
end
                     
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 
					 	modifier_flameshion_herrsher_form = class({})
function modifier_flameshion_herrsher_form:IsHidden() return false end
function modifier_flameshion_herrsher_form:IsDebuff() return true end
function modifier_flameshion_herrsher_form:IsPurgable() return false end
function modifier_flameshion_herrsher_form:IsPurgeException() return false end
function modifier_flameshion_herrsher_form:RemoveOnDeath() return true end
function modifier_flameshion_herrsher_form:AllowIllusionDuplicate() return true end

function modifier_flameshion_herrsher_form:DeclareFunctions()
    local func = { 
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					 MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
					           MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
							
			}
    return func
end


function modifier_flameshion_herrsher_form:GetModifierIncomingDamage_Percentage( params )
	

		return -30

	end
function modifier_flameshion_herrsher_form:GetModifierPreAttack_BonusDamage()
    return 200
end
function modifier_flameshion_herrsher_form:GetModifierPercentageCooldown()
    if self:GetParent():HasItemInInventory("item_watch") then
	return 35
	else
    return 50
	end
end

function modifier_flameshion_herrsher_form:OnCreated(table)
 if IsServer() then
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self:PlayEffects(600)
       if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/kiana_flameshion_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
	

           self.skills_table = {
                           
							["will_of_the_herrsher"] = "kiana_final_slash",
                            
                        }


   
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
		
        EmitSoundOn("kiana.flameshion_activation", self.parent)

        

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_flameshion_herrsher_form:PlayEffects( radius )

	local particle_cast = "particles/kiana_flameshion_activation.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_flameshion_herrsher_form:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_flameshion_herrsher_form:OnDestroy()

	 if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			end
if self.particle_time then
           ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		end
			
  StopSoundOn("kiana.flameshion_activation", self.parent)
          end

    end

	modifier_core_upgrade_2 = class({})
function modifier_core_upgrade_2:IsHidden() return false end
function modifier_core_upgrade_2:IsDebuff() return true end
function modifier_core_upgrade_2:IsPurgable() return false end
function modifier_core_upgrade_2:IsPurgeException() return false end
function modifier_core_upgrade_2:RemoveOnDeath() return false end
function modifier_core_upgrade_2:AllowIllusionDuplicate() return true end

function modifier_core_upgrade_2:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
						MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                }
    return func
end

function modifier_core_upgrade_2:GetModifierBonusStats_Strength()
	return 30
end
function modifier_core_upgrade_2:GetModifierModelChange()
	return "models/kiana/kiana_herrsher_of_flameshion/kiana_herrsher_of_flameshion.vmdl"
end
function modifier_core_upgrade_2:GetModifierModelScale()

	return 1
	end


function modifier_core_upgrade_2:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

        
self:PlayEffects()
self:PlayEffects2()
self:PlayEffects3()

end

function modifier_core_upgrade_2:PlayEffects()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/base_fire_flame1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "sword", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Emit sound
	
end
function modifier_core_upgrade_2:PlayEffects2()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/base_fire_flame1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "sword3", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Emit sound
	
end
function modifier_core_upgrade_2:PlayEffects3()
		-- Get Resources
	local particle_cast = "particles/juggernaut_blade_fury1.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/base_fire_flame1.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "sword2", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Emit sound
	
end

function modifier_core_upgrade_2:OnDestroy()
    if IsServer() then
local ability = self:GetParent():FindAbilityByName("kiana_flameshion_form")
if ability then
ability:StartCooldown(ability:GetCooldown(-1))
		end
			

          end

    end








	modifier_core_upgrade_3 = class({})
function modifier_core_upgrade_3:IsHidden() return false end
function modifier_core_upgrade_3:IsDebuff() return true end
function modifier_core_upgrade_3:IsPurgable() return false end
function modifier_core_upgrade_3:IsPurgeException() return false end
function modifier_core_upgrade_3:RemoveOnDeath() return false end
function modifier_core_upgrade_3:AllowIllusionDuplicate() return true end

function modifier_core_upgrade_3:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
					 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					 MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                }
    return func
end


function modifier_core_upgrade_3:GetModifierBonusStats_Agility()
    return 15
end
function modifier_core_upgrade_3:GetModifierBonusStats_Intellect()

    return 15
end
function modifier_core_upgrade_3:GetModifierBonusStats_Strength()

    return 15
end

function modifier_core_upgrade_3:GetModifierModelChange()
	return "models/kiana/kiana_final/kiana_final.vmdl"
end
function modifier_core_upgrade_3:GetModifierModelScale()

	return 1
	end


function modifier_core_upgrade_3:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
self.radius = 400
    
self:PlayEffects()

   self.skills_table = {
                           
							["kiana_ultimate"] = "kiana_global_kick",
	
                            
                        }
						



   
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                  --  ability:EndCooldown()
                  --  ability:RefreshCharges()
                end
            end
        end
end

function modifier_core_upgrade_3:OnDestroy()

	 if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			end
if self.particle_time then
           ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		end
			
 if IsServer() then
local ability = self:GetParent():FindAbilityByName("kiana_final_form")
if ability then
ability:StartCooldown(ability:GetCooldown(-1))
		end
			

          end
          end

    end
function modifier_core_upgrade_3:PlayEffects()
		-- Get Resources
	
	self.radius = 300

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/kiana_final_wing_trail.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_wing", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)


	local effect_cast2 = ParticleManager:CreateParticle("particles/kiana_final_wing_trail.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast2, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_wing_2", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast2, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast2,
		false,
		false,
		-1,
		false,
		false
	)
	-- Emit sound
	
end







				 	modifier_finality_herrsher_form = class({})
function modifier_finality_herrsher_form:IsHidden() return false end
function modifier_finality_herrsher_form:IsDebuff() return true end
function modifier_finality_herrsher_form:IsPurgable() return false end
function modifier_finality_herrsher_form:IsPurgeException() return false end
function modifier_finality_herrsher_form:RemoveOnDeath() return true end
function modifier_finality_herrsher_form:AllowIllusionDuplicate() return true end

function modifier_finality_herrsher_form:DeclareFunctions()
    local func = { 
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					 MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
					           MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
							   MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
							
			}
    return func
end

function modifier_finality_herrsher_form:OnAbilityFullyCast( params )
	if not IsServer() then return end
	local caster = self:GetCaster()
	if params.unit~=self:GetParent() then return end
	if params.ability:IsItem() then return end
	local level = params.ability:GetLevel()
	local manacost = params.ability:GetManaCost(level)
	local ability = params.ability
	if manacost > 50 then
		-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		500,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage

	for _,enemy in pairs(enemies) do
		-- damage
			local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = caster:GetAverageTrueAttackDamage(enemy) * 0.3,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(), --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
	
		self:PlayEffects2(enemy)
	end
	end
end
function modifier_finality_herrsher_form:PlayEffects2( target )
	-- Load effects
	local particle_cast = "particles/test_random_crit_finality.vpcf"



	
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		target:GetOrigin(), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, (self:GetCaster():GetOrigin()-target:GetOrigin()):Normalized() )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_finality_herrsher_form:GetModifierPreAttack_BonusDamage()
    return 400
end
function modifier_finality_herrsher_form:GetModifierPercentageCooldown()
    return 30
end

function modifier_finality_herrsher_form:OnCreated(table)
 if IsServer() then
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self:PlayEffects(600)
       if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/halo_stage_10_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
	

           self.skills_table = {
                           
							["will_of_the_herrsher"] = "kiana_perfect_timestop",
	
                            
                        }
						



   
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    ability:EndCooldown()
                    ability:RefreshCharges()
                end
            end
        end
		
        EmitSoundOn("kiana.final_activation", self.parent)

        

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_finality_herrsher_form:PlayEffects( radius )

	local particle_cast = "particles/halo_stage_10_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
function modifier_finality_herrsher_form:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_finality_herrsher_form:OnDestroy()

	 if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			end
if self.particle_time then
           ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
		end
			

          end

    end