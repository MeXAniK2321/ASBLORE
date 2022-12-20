LinkLuaModifier("modifier_hogyoku_evolution", "heroes/hogyoku_evolution", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hogyoku_evolution_invul", "heroes/hogyoku_evolution", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)


hogyoku_evolution = class({})

function hogyoku_evolution:IsStealable() return true end
function hogyoku_evolution:IsHiddenWhenStolen() return false end

function hogyoku_evolution:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("aizen_sonido")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function hogyoku_evolution:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function hogyoku_evolution:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = 400
	local duration = 2.4
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

		enemy:AddNewModifier(caster, self, "modifier_generic_stunned_lua", {duration = 1.2})
	
	end

	

    caster:AddNewModifier(caster, self, "modifier_hogyoku_evolution", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_hogyoku_evolution_invul", {duration = 1.3})
	
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})

    self:EndCooldown()

    
end
function hogyoku_evolution:OnProjectileHit(hTarget, vLocation)
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
modifier_hogyoku_evolution_invul = class({})
function modifier_hogyoku_evolution_invul:IsHidden() return false end
function modifier_hogyoku_evolution_invul:IsDebuff() return true end
function modifier_hogyoku_evolution_invul:IsPurgable() return false end
function modifier_hogyoku_evolution_invul:IsPurgeException() return false end
function modifier_hogyoku_evolution_invul:RemoveOnDeath() return true end
function modifier_hogyoku_evolution_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_hogyoku_evolution_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_hogyoku_evolution_invul:GetOverrideAnimation()
	return ACT_DOTA_CAST_ABILITY_5
end


---------------------------------------------------------------------------------------------------------------------
modifier_hogyoku_evolution = class({})
function modifier_hogyoku_evolution:IsHidden() return false end
function modifier_hogyoku_evolution:IsDebuff() return true end
function modifier_hogyoku_evolution:IsPurgable() return false end
function modifier_hogyoku_evolution:IsPurgeException() return false end
function modifier_hogyoku_evolution:RemoveOnDeath() return true end
function modifier_hogyoku_evolution:AllowIllusionDuplicate() return true end

function modifier_hogyoku_evolution:DeclareFunctions()
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


function modifier_hogyoku_evolution:GetModifierModelChange()
	return "models/aizen/aizen_final.vmdl"
end
function modifier_hogyoku_evolution:GetModifierModelScale()

	return 10
	end

function modifier_hogyoku_evolution:GetModifierSpellAmplify_Percentage()
	return 50
end
function modifier_hogyoku_evolution:GetModifierBonusStats_Strength()

    return 50
	
	
end






function modifier_hogyoku_evolution:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["hogyoku_evolution"] = "aizen_sonido",
							["aizen_kyouka_suigetsu"] = "hollow_blast",

                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/hogyoku_evolution.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
        EmitSoundOn("aizen.5", self.parent)
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_hogyoku_evolution:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_hogyoku_evolution:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("hogyoku_evolution_awake")
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
hogyoku_evolution_awake = class({})

function hogyoku_evolution_awake:IsStealable() return true end
function hogyoku_evolution_awake:IsHiddenWhenStolen() return false end
function hogyoku_evolution_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("hogyoku_evolution")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function hogyoku_evolution_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_hogyoku_evolution", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_hogyoku_evolution", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("hogyoku_evolution")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.hogyoku_evolution_awake_skills_used, "sss")
        if not self.hogyoku_evolution_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.hogyoku_evolution_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_hogyoku_evolution", parent)
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

    local hogyoku_evolution_awake = parent:FindAbilityByName("hogyoku_evolution_awake")
    if not hogyoku_evolution_awake:IsNull() and hogyoku_evolution_awake:IsTrained() then
        hogyoku_evolution_awake.hogyoku_evolution_awake_skills_used = true
    end
end


