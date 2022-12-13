LinkLuaModifier("modifier_hopes_and_dreams", "heroes/hopes_and_dreams", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dreams_buff", "modifiers/modifier_dreams_buff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pacifist", "modifiers/modifier_pacifist", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
hopes_and_dreams = class({})

function hopes_and_dreams:IsStealable() return true end
function hopes_and_dreams:IsHiddenWhenStolen() return false end

function hopes_and_dreams:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rainbow_laser")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function hopes_and_dreams:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function hopes_and_dreams:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local buffDuration = 5
	local targets = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	if self:GetCaster():HasModifier( "modifier_pacifist" ) then
	else
	caster:AddNewModifier(caster, self, "modifier_pacifist", {})
	end

    caster:AddNewModifier(caster, self, "modifier_hopes_and_dreams", {duration = fixed_duration})
		
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})

    self:EndCooldown()
local allies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		targets,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,ally in pairs(allies) do
		-- Add modifier
		ally:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_dreams_buff", -- modifier name
			{ duration = buffDuration } -- kv
		)
	end
   

end
function hopes_and_dreams:OnProjectileHit(hTarget, vLocation)
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

---------------------------------------------------------------------------------------------------------------------
modifier_hopes_and_dreams = class({})
function modifier_hopes_and_dreams:IsHidden() return false end
function modifier_hopes_and_dreams:IsDebuff() return true end
function modifier_hopes_and_dreams:IsPurgable() return false end
function modifier_hopes_and_dreams:IsPurgeException() return false end
function modifier_hopes_and_dreams:RemoveOnDeath() return true end
function modifier_hopes_and_dreams:AllowIllusionDuplicate() return true end
function modifier_hopes_and_dreams:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("hopes_and_dreams_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_hopes_and_dreams:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_EVASION_CONSTANT,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
                    MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE					}
    return func
end




function modifier_hopes_and_dreams:GetModifierSpellAmplify_Percentage()
	return 50
end
function modifier_hopes_and_dreams:GetModifierHealthRegenPercentage()
	return 10
end





function modifier_hopes_and_dreams:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["hopes_and_dreams"] = "rainbow_laser",
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/hopes_and_dreams.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
        EmitSoundOn("frisk.5", self.parent)
        
	
self:PlayEffects()
        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_hopes_and_dreams:PlayEffects()
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
function modifier_hopes_and_dreams:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_hopes_and_dreams:OnDestroy()
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
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self:GetCaster():FindAbilityByName("devilovania")
	            ability:StartCooldown(180)
                end
            end
        end
    end

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
hopes_and_dreams_awake = class({})

function hopes_and_dreams_awake:IsStealable() return true end
function hopes_and_dreams_awake:IsHiddenWhenStolen() return false end
function hopes_and_dreams_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("hopes_and_dreams")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function hopes_and_dreams_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_hopes_and_dreams", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_hopes_and_dreams", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("hopes_and_dreams")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.hopes_and_dreams_awake_skills_used, "sss")
        if not self.hopes_and_dreams_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.hopes_and_dreams_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_hopes_and_dreams", parent)
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

    local hopes_and_dreams_awake = parent:FindAbilityByName("hopes_and_dreams_awake")
    if not hopes_and_dreams_awake:IsNull() and hopes_and_dreams_awake:IsTrained() then
        hopes_and_dreams_awake.hopes_and_dreams_awake_skills_used = true
    end
end


