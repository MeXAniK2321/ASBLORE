LinkLuaModifier("modifier_own_soul", "heroes/own_soul", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crystallize2", "modifiers/modifier_crystallize2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_the_one_ultimate_d", "heroes/the_one", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_the_one_ultimate_damage", "heroes/the_one", LUA_MODIFIER_MOTION_NONE)
own_soul = class({})

function own_soul:IsStealable() return true end
function own_soul:IsHiddenWhenStolen() return false end


function own_soul:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("puck_waning_rift_lua")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function own_soul:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function own_soul:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	
	for _,enemy in pairs(enemies) do
		-- damage
	

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_crystallize2", -- modifier name
			{ duration = 1 } -- kv
		)
	end
    caster:AddNewModifier(caster, self, "modifier_own_soul", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_the_one_ultimate_d", {duration = 35})

    self:EndCooldown()

end
---------------------------------------------------------------------------------------------------------------------
modifier_own_soul = class({})
function modifier_own_soul:IsHidden() return false end
function modifier_own_soul:IsDebuff() return true end
function modifier_own_soul:IsPurgable() return false end
function modifier_own_soul:IsPurgeException() return false end
function modifier_own_soul:RemoveOnDeath() return true end
function modifier_own_soul:AllowIllusionDuplicate() return true end
function modifier_own_soul:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("own_soul_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    

    
    return state
end
function modifier_own_soul:DeclareFunctions()
    local func = {  
    				
	                MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,					
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                   MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
				   MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
				   MODIFIER_PROPERTY_HEALTH_BONUS,
				   }
    return func
end

function modifier_own_soul:GetModifierHealthBonus()
return 2000
end

function modifier_own_soul:GetModifierSpellAmplify_PercentageUnique()
    return 50
end


function modifier_own_soul:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["own_soul"] = "puck_waning_rift_lua",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_sword", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
						
			end
		

        
		
        EmitSoundOn("shu.king", self.parent)
        
		self:PlayEffects()

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_own_soul:PlayEffects()
		-- Get Resources
	local particle_cast = "particles/juggernaut_blade_fury1.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/own_soul.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
                                   
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
function modifier_own_soul:PlayEffects2()
		-- Get Resources
	local particle_cast = "particles/juggernaut_blade_fury1.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/dev/library/base_fire_flame.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_left_arm", self.parent:GetAbsOrigin(), true)
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
function modifier_own_soul:OnRefresh(table)
    self:OnCreated(table)
end

function modifier_own_soul:OnDestroy()
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
local caster = self:GetCaster()
            StopSoundOn("shu.king", self.parent)
			
			
            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * caster:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("own_soul_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
				 local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = 9999999,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,		--Optional.
	}
	-- update damage
	self:GetParent():AddNewModifier(self:GetParent(), self, "modifier_the_one_ultimate_damage", {duration = 10})

	-- apply damage
	ApplyDamage( damageTable )
	EmitSoundOn("shu.king_end", self.parent)
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
own_soul_awake = class({})

function own_soul_awake:IsStealable() return true end
function own_soul_awake:IsHiddenWhenStolen() return false end
function own_soul_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("own_soul")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function own_soul_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_own_soul", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_own_soul", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("own_soul")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.own_soul_awake_skills_used, "sss")
        if not self.own_soul_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.own_soul_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_own_soul", parent)
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

    local own_soul_awake = parent:FindAbilityByName("own_soul_awake")
    if not own_soul_awake:IsNull() and own_soul_awake:IsTrained() then
        own_soul_awake.own_soul_awake_skills_used = true
    end
end


