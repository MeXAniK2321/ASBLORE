LinkLuaModifier("modifier_bad_time", "heroes/bad_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bad_time_thinker", "heroes/bad_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bad_time_thinker_in", "heroes/bad_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bad_time_thinker_out", "heroes/bad_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_last_breath_form", "heroes/bad_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_last_breath_death", "heroes/bad_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_last_breath_invul", "heroes/bad_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_last_breath_thinker", "heroes/bad_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_last_breath_thinker_in", "heroes/bad_time", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_last_breath_thinker_out", "heroes/bad_time", LUA_MODIFIER_MOTION_NONE)


bad_time = class({})

function bad_time:IsStealable() return true end
function bad_time:IsHiddenWhenStolen() return false end

function bad_time:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("gaster_blaster")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function bad_time:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function bad_time:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local point = caster:GetOrigin()
	local radius = 1000

    caster:AddNewModifier(caster, self, "modifier_bad_time", {duration = fixed_duration})
		
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
CreateModifierThinker(caster, self, "modifier_bad_time_thinker", {duration = fixed_duration}, point, caster:GetTeamNumber(), false)
    self:EndCooldown()

   

end
function bad_time:OnProjectileHit(hTarget, vLocation)
	if not hTarget then
		return nil
	end

	

	local damage_table = {	victim = hTarget,
							attacker = self:GetCaster(),
							damage = self.damage,
							damage_type = self:GetAbilityDamageType(),
							ability = self }

	ApplyDamage(damage_table)
end
function bad_time:GetAbilityTextureName()
	
	return "sans_5"
end
---------------------------------------------------------------------------------------------------------------------
modifier_bad_time = class({})
function modifier_bad_time:IsHidden() return false end
function modifier_bad_time:IsDebuff() return true end
function modifier_bad_time:IsPurgable() return false end
function modifier_bad_time:IsPurgeException() return false end
function modifier_bad_time:RemoveOnDeath() return true end
function modifier_bad_time:AllowIllusionDuplicate() return true end
function modifier_bad_time:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("bad_time_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_bad_time:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_EVASION_CONSTANT,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
 MODIFIER_PROPERTY_MANA_BONUS,
 MODIFIER_PROPERTY_HEALTH_BONUS, }
    return func
end

function modifier_bad_time:GetModifierEvasion_Constant()
    return 100
end


function modifier_bad_time:GetModifierSpellAmplify_Percentage()

	return 50
	end


function modifier_bad_time:GetModifierIncomingDamage_Percentage( params )
	local absorb = -100
	local caster = self:GetCaster()

	self.damage_per_mana = 0.5
	self.absorb_pct = 1
	local damage_absorbed = params.damage * self.absorb_pct
	local manacost = damage_absorbed/self.damage_per_mana
	local mana = self:GetParent():GetMana()

	-- if not enough mana, calculate damage blocked by remaining mana
	if mana<manacost then
	    if self:GetParent():HasItemInInventory("item_crucible_of_the_executioner") then
		
		 caster:RemoveModifierByName("modifier_bad_time")
	caster:RemoveModifierByName("modifier_star_tier2")
	self:GetCaster():GiveMana( 99999 )
		self:GetParent():AddNewModifier(
		params.attacker, -- player source
		self:GetAbility(), -- ability source
		"modifier_kill", -- modifier name
		{ duration = 19.1} )
		self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_last_breath_invul", -- modifier name
		{ duration = 7 } )
		self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_last_breath_form", -- modifier name
		{ duration = 19 } -- kv 
	)
	self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_star_tier3", -- modifier name
		{ duration = 19 } -- kv
	)
	
	local point = caster:GetOrigin()
	CreateModifierThinker(caster, self, "modifier_last_breath_thinker", {duration = 19}, point, caster:GetTeamNumber(), false)
		else
		   self:GetParent():Kill(self, params.attacker)
		   end
	end
	
	

	if not params.attacker:HasModifier("modifier_bad_time_thinker_out") then
	self:GetParent():SpendMana( manacost, self:GetAbility() )
	end


	return absorb
end

function modifier_bad_time:GetModifierManaBonus()
    return self.mana
end


function modifier_bad_time:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.mana = self.caster:GetMaxMana() * 2.5
	self.hp = self.caster:GetMaxHealth()


    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
if self:GetParent():HasItemInInventory("item_chomusuke") then
   self.skills_table = {
                            ["sans_bone_throw"] = "gaster_blaster",
                            ["skelejoke"] = "sans_punch",
							["boner"] = "sans_global_shortcut",
							["bad_time"] = "circle_gaster_blaster",
                        }
else
    self.skills_table = {
                            ["sans_bone_throw"] = "gaster_blaster",
                            ["skelejoke"] = "sans_evade",
							["boner"] = "sans_multiple_boner",
							["bad_time"] = "circle_gaster_blaster",
                        }
						end


    if IsServer() then
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
        if IsServer() then
       

    if self:GetParent():HasItemInInventory("item_chomusuke") then
	 if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/bad_tom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
	 EmitSoundOn("Sans.badtome", self.parent)
	 else
	  if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/bad_time.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
        EmitSoundOn("Sans.badtime", self.parent)
		end
        
	
self:PlayEffects()
        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_bad_time:PlayEffects()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/sans_eye_flame.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "sans_eye", self.parent:GetAbsOrigin(), true)
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
function modifier_bad_time:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_bad_time:OnDestroy()
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

            StopSoundOn("Sans.badtome", self.parent)
        StopGlobalSound("star.theme2_15")
        StopSoundOn("Sans.badtime", self.parent)
       

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("bad_time_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
modifier_bad_time_thinker = class({})
function modifier_bad_time_thinker:IsHidden() return true end
function modifier_bad_time_thinker:IsDebuff() return false end
function modifier_bad_time_thinker:IsPurgable() return false end
function modifier_bad_time_thinker:IsPurgeException() return false end
function modifier_bad_time_thinker:RemoveOnDeath() return true end
function modifier_bad_time_thinker:OnCreated()
    if IsServer() then
        self.radius = 1000

      

        self.center = self:GetParent():GetAbsOrigin()

       

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_bad_time_thinker:OnIntervalThink()
local caster = self:GetCaster()
    if IsServer() then
        if not self:GetCaster() or not self:GetCaster():IsAlive() or self:GetCaster():HasModifier("modifier_last_breath_form") then
self:Destroy()
end
        local units_resolve = FindUnitsInRadius(self:GetParent():GetTeam(),
                                                self:GetParent():GetAbsOrigin(), 
                                                nil, 
                                                99999, 
                                                self:GetAbility():GetAbilityTargetTeam(), 
                                                self:GetAbility():GetAbilityTargetType(), 
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                                                0, 
                                                false) 

        for _,unit in pairs(units_resolve) do
            if unit and not unit:IsNull() and IsValidEntity(unit) then
                local distance = (self:GetParent():GetAbsOrigin() - unit:GetAbsOrigin()):Length2D()
                local special_duration = self:GetDuration() - self:GetElapsedTime()
                if distance > self.radius then
                    if not unit:FindModifierByNameAndCaster("modifier_bad_time_thinker_out", self:GetParent()) and not unit:FindModifierByNameAndCaster("modifier_bad_time_thinker_in", self:GetParent()) then
                        unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bad_time_thinker_out", {duration = special_duration, radius = self.radius, main_altair = self:GetCaster():entindex()})
                    end
          
				   else
                    if not unit:FindModifierByNameAndCaster("modifier_bad_time_thinker_in", self:GetParent()) and not unit:FindModifierByNameAndCaster("modifier_bad_time_thinker_out", self:GetParent()) then
                        unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_bad_time_thinker_in", {duration = special_duration, radius = self.radius, main_altair = self:GetCaster():entindex()})

                       
					   end
                    end
                end
            end
        end
    

	if not self:GetCaster():HasModifier("modifier_bad_time_thinker_in")   then
            self:Destroy()
        
		end
end
function modifier_bad_time_thinker:OnDestroy()
    if IsServer() then
       

        if self.arena_barrier then
            ParticleManager:DestroyParticle(self.arena_barrier, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_barrier)
        end
        
        UTIL_Remove(self:GetParent())
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_bad_time_thinker_in = class({})
function modifier_bad_time_thinker_in:IsHidden() return true end
function modifier_bad_time_thinker_in:IsDebuff() return true end
function modifier_bad_time_thinker_in:IsPurgable() return false end
function modifier_bad_time_thinker_in:IsPurgeException() return false end
function modifier_bad_time_thinker_in:RemoveOnDeath() return true end
function modifier_bad_time_thinker_in:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_bad_time_thinker_in:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                }
    return func
end
function modifier_bad_time_thinker_in:GetModifierIncomingDamage_Percentage(keys)
    if IsServer() then
        if keys.attacker:HasModifier( "modifier_bad_time_thinker_out" )  then
           
            return -100
			else
			
        end

       
    end
end

function modifier_bad_time_thinker_in:OnCreated(params)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsServer() then
        self.main_altair = EntIndexToHScript(params.main_altair)

        self.damage_increase = self:GetAbility():GetSpecialValueFor("damage_increase")

        self.center = self:GetCaster():GetAbsOrigin()
        self.radius = params.radius + 100
        self.old_pos = self:GetParent():GetAbsOrigin()

        if self:GetParent():IsRealHero() and not self:GetParent():IsIllusion() and not self:GetParent():IsTempestDouble() then
            local player = PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID())
             

	-- Create Particle
	
	self.arena_barrier11 = "particles/test_sans_bad_time_arena.vpcf"
	
	self.arena_barrier = ParticleManager:CreateParticle( self.arena_barrier11, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.arena_barrier, 0, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( self.arena_barrier, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.arena_barrier, 2, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( self.arena_barrier, 3, self.caster:GetOrigin() )
	ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )

	-- buff particle
	self:AddParticle(
		self.arena_barrier,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
          end

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_bad_time_thinker_in:OnIntervalThink()
    if IsServer() then
        if not self.caster or self.caster:IsNull() or not self.parent or self.parent:IsNull() then
            self:Destroy()

            return nil
        end

        local distance = (self:GetParent():GetAbsOrigin() - self.center):Length2D()

         if distance > self.radius then
            if self:GetParent() == self:GetCaster():GetOwnerEntity() then
                self:Destroy()
                return nil
            end
           

            local direction = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
            self.old_pos = self.center + direction * self.radius

            self:GetParent():SetAbsOrigin(self.old_pos)
            FindClearSpaceForUnit(self:GetParent(), self.old_pos, true)
        end
    end
end
function modifier_bad_time_thinker_in:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end

        if self.arena_barrier then
            ParticleManager:DestroyParticle(self.arena_barrier, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_barrier)
        end
    end
end

modifier_bad_time_thinker_out = class({})
function modifier_bad_time_thinker_out:IsHidden() return true end
function modifier_bad_time_thinker_out:IsDebuff() return true end
function modifier_bad_time_thinker_out:IsPurgable() return false end
function modifier_bad_time_thinker_out:IsPurgeException() return false end
function modifier_bad_time_thinker_out:RemoveOnDeath() return true end
function modifier_bad_time_thinker_out:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_bad_time_thinker_out:OnCreated(params)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
        self.main_altair = EntIndexToHScript(params.main_altair)

        self.center = self:GetCaster():GetAbsOrigin()
        self.radius = params.radius + 150
        self.old_pos = self:GetParent():GetAbsOrigin()

        if self:GetParent():IsRealHero() and not self:GetParent():IsIllusion() and not self:GetParent():IsTempestDouble() then
            local player = PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID())

        end

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_bad_time_thinker_out:OnIntervalThink()
    if IsServer() then
        if not self.caster or self.caster:IsNull() or not self.parent or self.parent:IsNull() or self.parent:IsInvulnerable() then
            self:Destroy()

            return nil
        end

        local distance = (self:GetParent():GetAbsOrigin() - self.center):Length2D()

        if distance < self.radius then
            if self:GetParent() == self:GetCaster():GetOwnerEntity() then
                self:Destroy()
                return nil
            end

            local direction = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
            self.old_pos = self.center + direction * self.radius

            self:GetParent():SetAbsOrigin(self.old_pos)
            FindClearSpaceForUnit(self:GetParent(), self.old_pos, true)
        end
    end
end
function modifier_bad_time_thinker_out:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end

        if self.arena_place_black then
            ParticleManager:DestroyParticle(self.arena_place_black, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_place_black)
        end
    end
end















modifier_last_breath_invul = class({})
function modifier_last_breath_invul:IsHidden() return false end
function modifier_last_breath_invul:IsDebuff() return true end
function modifier_last_breath_invul:IsPurgable() return false end
function modifier_last_breath_invul:IsPurgeException() return false end
function modifier_last_breath_invul:RemoveOnDeath() return true end
function modifier_last_breath_invul:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end
function modifier_last_breath_invul:OnCreated()
if IsServer() then

self.screw_fx = 	ParticleManager:CreateParticle("particles/sans_last_breath_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
								
       
    end
end
function modifier_last_breath_invul:OnDestroy()
local caster = self:GetCaster()

if self.screw_fx then
	    ParticleManager:DestroyParticle(self.screw_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.screw_fx)
	end
end
function modifier_last_breath_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_last_breath_invul:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_7
end





modifier_last_breath_form = class({})
function modifier_last_breath_form:IsHidden() return false end
function modifier_last_breath_form:IsDebuff() return true end
function modifier_last_breath_form:IsPurgable() return false end
function modifier_last_breath_form:IsPurgeException() return false end
function modifier_last_breath_form:RemoveOnDeath() return true end
function modifier_last_breath_form:AllowIllusionDuplicate() return true end
function modifier_last_breath_form:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("bad_time_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_last_breath_form:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_EVASION_CONSTANT,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
 MODIFIER_PROPERTY_MANA_BONUS,
 MODIFIER_PROPERTY_HEALTH_BONUS,
MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, }
    return func
end


function modifier_last_breath_form:GetModifierEvasion_Constant()
    return 100
end

function modifier_last_breath_form:GetModifierConstantManaRegen()
    return 999
end
function modifier_last_breath_form:GetModifierSpellAmplify_Percentage()

	return 75
	end



function modifier_last_breath_form:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.mana = self.caster:GetMaxMana() * 2
	self.hp = self.caster:GetMaxHealth()


    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
    self.skills_table = {
                            ["sans_bone_throw"] = "gaster_blaster",
                            ["skelejoke"] = "sans_evade",
							["boner"] = "sans_multiple_boner",
							["bad_time"] = "circle_gaster_blaster",
                        }
						


    if IsServer() then
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
        if IsServer() then
       

   
	  if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/last_breath.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        EmitSoundOn("Sans.dying_is_gay", self.parent)
		end
        
	
self:PlayEffects()
        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_last_breath_form:PlayEffects()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/sans_last_breath_eye.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "sans_eye", self.parent:GetAbsOrigin(), true)
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
function modifier_last_breath_form:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_last_breath_form:OnDestroy()
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

            StopSoundOn("Sans.badtome", self.parent)
        StopGlobalSound("star.theme2_15")
        StopSoundOn("Sans.badtime", self.parent)
       

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("bad_time_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end











modifier_last_breath_thinker = class({})
function modifier_last_breath_thinker:IsHidden() return true end
function modifier_last_breath_thinker:IsDebuff() return false end
function modifier_last_breath_thinker:IsPurgable() return false end
function modifier_last_breath_thinker:IsPurgeException() return false end
function modifier_last_breath_thinker:RemoveOnDeath() return true end
function modifier_last_breath_thinker:OnCreated()
    if IsServer() then
        self.radius = 1000

      

        self.center = self:GetParent():GetAbsOrigin()

       

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_last_breath_thinker:OnIntervalThink()
local caster = self:GetCaster()
    if IsServer() then

        local units_resolve = FindUnitsInRadius(self:GetParent():GetTeam(),
                                                self:GetParent():GetAbsOrigin(), 
                                                nil, 
                                                99999, 
												DOTA_UNIT_TARGET_TEAM_BOTH, 
                                                DOTA_UNIT_TARGET_HERO, 
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                                                0, 
                                                false) 

        for _,unit in pairs(units_resolve) do
            if unit and not unit:IsNull() and IsValidEntity(unit) then
                local distance = (self:GetParent():GetAbsOrigin() - unit:GetAbsOrigin()):Length2D()
                local special_duration = self:GetDuration() - self:GetElapsedTime()
                if distance > self.radius then
                    if not unit:FindModifierByNameAndCaster("modifier_last_breath_thinker_out", self:GetParent()) and not unit:FindModifierByNameAndCaster("modifier_last_breath_thinker_in", self:GetParent()) then
                        unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_last_breath_thinker_out", {duration = special_duration, radius = self.radius, main_altair = self:GetCaster():entindex()})
                    end
          
				   else
                    if not unit:FindModifierByNameAndCaster("modifier_last_breath_thinker_in", self:GetParent()) and not unit:FindModifierByNameAndCaster("modifier_last_breath_thinker_out", self:GetParent()) then
                        unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_last_breath_thinker_in", {duration = special_duration, radius = self.radius, main_altair = self:GetCaster():entindex()})

                       
					   end
                    end
                end
            end
        end
    

	
end
function modifier_last_breath_thinker:OnDestroy()
    if IsServer() then
       

        if self.arena_barrier then
            ParticleManager:DestroyParticle(self.arena_barrier, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_barrier)
        end
        
        UTIL_Remove(self:GetParent())
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_last_breath_thinker_in = class({})
function modifier_last_breath_thinker_in:IsHidden() return true end
function modifier_last_breath_thinker_in:IsDebuff() return true end
function modifier_last_breath_thinker_in:IsPurgable() return false end
function modifier_last_breath_thinker_in:IsPurgeException() return false end
function modifier_last_breath_thinker_in:RemoveOnDeath() return true end
function modifier_last_breath_thinker_in:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_last_breath_thinker_in:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                }
    return func
end
function modifier_last_breath_thinker_in:GetModifierIncomingDamage_Percentage(keys)
    if IsServer() then
        if keys.attacker:HasModifier( "modifier_last_breath_thinker_out" )  then
           
            return -100
			else
			
        end

       
    end
end

function modifier_last_breath_thinker_in:OnCreated(params)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsServer() then
        self.main_altair = EntIndexToHScript(params.main_altair)

        self.damage_increase = 0

        self.center = self:GetCaster():GetAbsOrigin()
        self.radius = params.radius + 100
        self.old_pos = self:GetParent():GetAbsOrigin()

        if self:GetParent():IsRealHero() and not self:GetParent():IsIllusion() and not self:GetParent():IsTempestDouble() then
            local player = PlayerResource:GetPlayer(self.caster:GetPlayerOwnerID())
             

	-- Create Particle
	
	self.arena_barrier11 = "particles/last_breath_arena.vpcf"
	
	self.arena_barrier = ParticleManager:CreateParticle( self.arena_barrier11, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( self.arena_barrier, 0, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( self.arena_barrier, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:SetParticleControl( self.arena_barrier, 2, self.caster:GetOrigin() )
	ParticleManager:SetParticleControl( self.arena_barrier, 3, self.caster:GetOrigin() )
	ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )

	-- buff particle
	self:AddParticle(
		self.arena_barrier,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
          end

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_last_breath_thinker_in:OnIntervalThink()
    if IsServer() then
        if not self.caster or self.caster:IsNull() or not self.parent or self.parent:IsNull() then
            self:Destroy()

            return nil
        end

        local distance = (self:GetParent():GetAbsOrigin() - self.center):Length2D()

        if distance > self.radius then
           

            local direction = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
            self.old_pos = self.center + direction * self.radius

            self:GetParent():SetAbsOrigin(self.old_pos)
            FindClearSpaceForUnit(self:GetParent(), self.old_pos, true)
        end
    end
end
function modifier_last_breath_thinker_in:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end

        if self.arena_barrier then
            ParticleManager:DestroyParticle(self.arena_barrier, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_barrier)
        end
    end
end

modifier_last_breath_thinker_out = class({})
function modifier_last_breath_thinker_out:IsHidden() return true end
function modifier_last_breath_thinker_out:IsDebuff() return true end
function modifier_last_breath_thinker_out:IsPurgable() return false end
function modifier_last_breath_thinker_out:IsPurgeException() return false end
function modifier_last_breath_thinker_out:RemoveOnDeath() return true end
function modifier_last_breath_thinker_out:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_last_breath_thinker_out:OnCreated(params)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
        self.main_altair = EntIndexToHScript(params.main_altair)

        self.center = self:GetCaster():GetAbsOrigin()
        self.radius = params.radius + 150
        self.old_pos = self:GetParent():GetAbsOrigin()

        if self:GetParent():IsRealHero() and not self:GetParent():IsIllusion() and not self:GetParent():IsTempestDouble() then
            local player = PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID())

        end

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_last_breath_thinker_out:OnIntervalThink()
    if IsServer() then
        if not self.caster or self.caster:IsNull() or not self.parent or self.parent:IsNull() or self.parent:IsInvulnerable() then
            self:Destroy()

            return nil
        end

        local distance = (self:GetParent():GetAbsOrigin() - self.center):Length2D()

        if distance < self.radius then
            if self:GetParent() == self:GetCaster():GetOwnerEntity() then
                self:Destroy()
                return nil
            end

            local direction = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
            self.old_pos = self.center + direction * self.radius

            self:GetParent():SetAbsOrigin(self.old_pos)
            FindClearSpaceForUnit(self:GetParent(), self.old_pos, true)
        end
    end
end
function modifier_last_breath_thinker_out:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end

        if self.arena_place_black then
            ParticleManager:DestroyParticle(self.arena_place_black, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_place_black)
        end
    end
end


modifier_last_breath_death = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_last_breath_death:IsHidden()
	return false
end

function modifier_last_breath_death:IsDebuff()
	return true
end

function modifier_last_breath_death:IsStunDebuff()
	return false
end

function modifier_last_breath_death:IsPurgable()
	return true
end

function modifier_last_breath_death:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_last_breath_death:OnCreated( kv )
	self.attacker = kv.attacker
	
end

function modifier_last_breath_death:OnRefresh( kv )
	
end

function modifier_last_breath_death:OnRemoved()
end

function modifier_last_breath_death:OnDestroy()
 self:GetParent():Kill(self, self.attacker)
end



