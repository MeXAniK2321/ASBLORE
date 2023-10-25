LinkLuaModifier("modifier_all_fiction", "heroes/all_fiction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_all_fiction_fount_debugg", "heroes/all_fiction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_all_fiction_debuff", "heroes/all_fiction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_all_fiction_invul", "heroes/all_fiction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_all_fiction_stunned", "heroes/all_fiction", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)


all_fiction = all_fiction or class({})

function all_fiction:IsStealable() return true end
function all_fiction:IsHiddenWhenStolen() return false end
function all_fiction:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("april_fiction")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function all_fiction:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = self:GetSpecialValueFor("radius")

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	
	for _,enemy in pairs(enemies) do
		-- damage
		
		-- silence
		enemy:AddNewModifier(caster, -- player source
			                 self, -- ability source
			                 "modifier_all_fiction_debuff", -- modifier name
			                 { duration = 1.6 } -- kv
		                    )
	end

	
    caster:AddNewModifier(caster, self, "modifier_all_fiction", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_all_fiction_invul", {duration = 1.6})	
    caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
    self:EndCooldown()
end

modifier_all_fiction_invul = modifier_all_fiction_invul or class({})
function modifier_all_fiction_invul:IsHidden() return false end
function modifier_all_fiction_invul:IsDebuff() return true end
function modifier_all_fiction_invul:IsPurgable() return false end
function modifier_all_fiction_invul:IsPurgeException() return false end
function modifier_all_fiction_invul:RemoveOnDeath() return true end
function modifier_all_fiction_invul:CheckState()
	local state = {
		              [MODIFIER_STATE_INVULNERABLE] = true,
		              [MODIFIER_STATE_STUNNED] = true,
	              }

	return state
end
function modifier_all_fiction_invul:OnCreated()
    if IsServer() then
        --self:SetStackCount(0)
        self.screw_fx = 	ParticleManager:CreateParticle("particles/all_fiction_screw.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
							ParticleManager:SetParticleControlEnt(self.screw_fx, 0, self:GetCaster(), 5, "attach_left_foot", Vector(0,0,0), true)
							ParticleManager:SetParticleControlEnt(self.screw_fx, 1, self:GetCaster(), 5, "attach_left_foot", Vector(0,0,0), true)
       
    end
end
function modifier_all_fiction_invul:OnDestroy()
    local caster = self:GetCaster()
    caster:StartGesture(ACT_DOTA_CAST_ABILITY_6)
    if self.screw_fx then
	    ParticleManager:DestroyParticle(self.screw_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.screw_fx)
	end
end
function modifier_all_fiction_invul:DeclareFunctions()
    local func = {  
				     MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                 }
    return func
end
function modifier_all_fiction_invul:GetOverrideAnimation()
	return ACT_DOTA_CHANNEL_ABILITY_5
end


modifier_all_fiction_stunned = modifier_all_fiction_stunned or class({})
function modifier_all_fiction_stunned:IsHidden() return false end
function modifier_all_fiction_stunned:IsDebuff() return true end
function modifier_all_fiction_stunned:IsPurgable() return false end
function modifier_all_fiction_stunned:IsPurgeException() return false end
function modifier_all_fiction_stunned:RemoveOnDeath() return true end
function modifier_all_fiction_stunned:CheckState()
	local state = {
		              [MODIFIER_STATE_INVULNERABLE] = true,
		              [MODIFIER_STATE_STUNNED] = true,
	              }

	return state
end


---------------------------------------------------------------------------------------------------------------------
modifier_all_fiction = modifier_all_fiction or class({})
function modifier_all_fiction:IsHidden() return false end
function modifier_all_fiction:IsDebuff() return true end
function modifier_all_fiction:IsPurgable() return false end
function modifier_all_fiction:IsPurgeException() return false end
function modifier_all_fiction:RemoveOnDeath() return true end
function modifier_all_fiction:AllowIllusionDuplicate() return true end
function modifier_all_fiction:CheckState()
    local state = { 
                  }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("all_fiction_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_all_fiction:DeclareFunctions()
    local func = {  
	                 MODIFIER_PROPERTY_EVASION_CONSTANT,
	                 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	                 MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	                 MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	                 MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	                 MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	                 MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,	
	                 MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
	                 MODIFIER_PROPERTY_PROJECTILE_NAME,
	                 MODIFIER_EVENT_ON_TAKEDAMAGE,
	                 MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	                 MODIFIER_PROPERTY_MIN_HEALTH
		         }
    return func
end
function modifier_all_fiction:GetMinHealth()
    return self:GetParent():HasModifier( "modifier_all_fiction_fount_debugg" )
           and 0
		   or 1
end
function modifier_all_fiction:GetModifierPreAttack_BonusDamage()
	return 400
end
function modifier_all_fiction:GetModifierAttackSpeedBonus_Constant()
	return 100
end
function modifier_all_fiction:OnTakeDamage(keys)
	if IsServer() then
      local caster = self:GetCaster()
      local attacker = keys.attacker
	  local target = keys.unit
	
	   if attacker:HasModifier( "modifier_fountain_damage" ) then 
          self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_all_fiction_fount_debugg", {duration = 1.0})			
	   else
	      if self:GetParent():GetHealth() <= 20 and not self:GetParent():IsIllusion() then
	        local hp = self:GetParent():GetMaxHealth() * 0.8
		    self:GetParent():SetHealth(hp)
		    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_all_fiction_stunned", {duration = 4})
		    EmitSoundOn("kumagawa.5_death", self.parent)
		    self:PlayEffects()

		    self:Destroy()
            self:GetParent():RemoveModifierByName("modifier_star_tier2")
						
		    return
          end
	   end
    end
end
function modifier_all_fiction:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
	
	 

    self.skills_table = {
                            ["all_fiction"] = "april_fiction",
							
                            
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
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/all_fiction.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        EmitSoundOn("kumagawa.5", self.parent)
        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_all_fiction:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_all_fiction:OnDestroy()
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

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("all_fiction_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
function modifier_all_fiction:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/all_fiction_invul.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

modifier_all_fiction_debuff = modifier_all_fiction_debuff or class({})

--------------------------------------------------------------------------------

function modifier_all_fiction_debuff:IsHidden() return false end
function modifier_all_fiction_debuff:IsPurgable() return false end
function modifier_all_fiction_debuff:OnCreated()
    self:PlayEffects()
end
function modifier_all_fiction_debuff:OnDestroy()
    if self:GetParent():HasModifier("modifier_bookmaker") then
	  self:GetParent():Kill(self, self:GetCaster())
	  EmitSoundOn("kumagawa.5_alter", self:GetParent())
	  self:PlayEffects1()
	end
end
function modifier_all_fiction_debuff:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/kumagawa_all_fiction_death.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
--------------------------------------------------------------------------------

function modifier_all_fiction_debuff:CheckState()
	local state = {
		              [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	              }

	return state
end
function modifier_all_fiction_debuff:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/all_fiction_screen.vpcf"
	if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
      local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	  -- Create Particle
	  local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	end
end

-- ?????
modifier_all_fiction_fount_debugg = class({})
