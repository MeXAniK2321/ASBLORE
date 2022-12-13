LinkLuaModifier("modifier_gods_arrival", "heroes/gods_arrival", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gods_arrival_invul", "heroes/gods_arrival", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)

gods_arrival = class({})

function gods_arrival:IsStealable() return true end
function gods_arrival:IsHiddenWhenStolen() return false end

function gods_arrival:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("thunder_tornado")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function gods_arrival:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
		return "jin_mori_5_5"
	end
	return "jin_mori_5"
end
--[[function gods_arrival:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function gods_arrival:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = self:GetSpecialValueFor("radius")
	local duration = 2.3
	local damage = 1000

	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_stunned_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end

	

    caster:AddNewModifier(caster, self, "modifier_gods_arrival", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_gods_arrival_invul", {duration = 1.8})
	if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
	  caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = fixed_duration})
	  
	  else
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
end
    self:EndCooldown()

    
end
function gods_arrival:OnProjectileHit(hTarget, vLocation)
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
modifier_gods_arrival_invul = class({})
function modifier_gods_arrival_invul:IsHidden() return false end
function modifier_gods_arrival_invul:IsDebuff() return true end
function modifier_gods_arrival_invul:IsPurgable() return false end
function modifier_gods_arrival_invul:IsPurgeException() return false end
function modifier_gods_arrival_invul:RemoveOnDeath() return true end
function modifier_gods_arrival_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_gods_arrival_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_gods_arrival_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_5
end


---------------------------------------------------------------------------------------------------------------------
modifier_gods_arrival = class({})
function modifier_gods_arrival:IsHidden() return false end
function modifier_gods_arrival:IsDebuff() return true end
function modifier_gods_arrival:IsPurgable() return false end
function modifier_gods_arrival:IsPurgeException() return false end
function modifier_gods_arrival:RemoveOnDeath() return true end
function modifier_gods_arrival:AllowIllusionDuplicate() return true end
function modifier_gods_arrival:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("gods_arrival_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_gods_arrival:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end


function modifier_gods_arrival:GetModifierModelChange()
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
    return "models/jin_mori/holy_mori.vmdl"
	else
	return "models/jin_mori/jin_mori.vmdl"
	end
end
function modifier_gods_arrival:GetModifierModelScale()
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
	return 1200
	else
	return end
end
function modifier_gods_arrival:GetModifierProcAttack_BonusDamage_Magical()
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
return 500
else
    return 350
end
end

function modifier_gods_arrival:GetModifierBonusStats_Strength()
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
    return 100
	else 
	return 75
	
end
end

function modifier_gods_arrival:GetModifierBonusStats_Agility()
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
    return 150
	else 
	
return 100
end
end




function modifier_gods_arrival:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
    self.skills_table = {
                            ["gods_arrival"] = "thunder_tornado",
							["triple_kick"] = "kinton",
							["muken"] = "kinton_lightning",
                            
                        }
						else
 self.skills_table = {
                            ["gods_arrival"] = "thunder_tornado",
							
                            
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
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/mori_gods_arrival.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then  
		EmitSoundOn("mori.5_5", self.parent)
		
		else
		
        EmitSoundOn("mori.theme_start", self.parent)
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_gods_arrival:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_gods_arrival:OnDestroy()
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

            StopGlobalSound("star.theme2_16")

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("gods_arrival_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
gods_arrival_awake = class({})

function gods_arrival_awake:IsStealable() return true end
function gods_arrival_awake:IsHiddenWhenStolen() return false end
function gods_arrival_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("gods_arrival")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function gods_arrival_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_gods_arrival", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_gods_arrival", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("gods_arrival")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.gods_arrival_awake_skills_used, "sss")
        if not self.gods_arrival_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.gods_arrival_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_gods_arrival", parent)
        if ultimate and not ultimate:IsNull() then
            return ultimate:GetAbility()
        end
    end

    return nil
end

function SetZenitsuAwakeLongCd(parent, ability)
    if not IsServer() or parent:IsNull() or ability:IsNull() then
        return nil
    end

    local gods_arrival_awake = parent:FindAbilityByName("gods_arrival_awake")
    if not gods_arrival_awake:IsNull() and gods_arrival_awake:IsTrained() then
        gods_arrival_awake.gods_arrival_awake_skills_used = true
    end
end


