LinkLuaModifier("modifier_devil_trigger", "heroes/devil_trigger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
devil_trigger = class({})

function devil_trigger:IsStealable() return true end
function devil_trigger:IsHiddenWhenStolen() return false end

function devil_trigger:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("end_cut")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function devil_trigger:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function devil_trigger:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_devil_trigger", {duration = fixed_duration})
    caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
    self:EndCooldown()

    
end
---------------------------------------------------------------------------------------------------------------------
modifier_devil_trigger = class({})
function modifier_devil_trigger:IsHidden() return false end
function modifier_devil_trigger:IsDebuff() return true end
function modifier_devil_trigger:IsPurgable() return false end
function modifier_devil_trigger:IsPurgeException() return false end
function modifier_devil_trigger:RemoveOnDeath() return true end
function modifier_devil_trigger:AllowIllusionDuplicate() return true end
function modifier_devil_trigger:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("devil_trigger_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}
    

    return state
end
function modifier_devil_trigger:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_HEALTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, }
    return func
end
function modifier_devil_trigger:GetModifierModelChange()
    return "models/vergil/devil_trigger/devil_trigger_test.vmdl"
end
function modifier_devil_trigger:GetModifierModelScale()
	return -20
end
function modifier_devil_trigger:GetModifierHealthBonus()
    return 1000
end
function modifier_devil_trigger:GetModifierBonusStats_Agility()

    return 100
	
end
function modifier_devil_trigger:GetModifierPreAttack_BonusDamage()
    return 300
end

function modifier_devil_trigger:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {                          
                            ["devil_trigger"] = "end_cut",
							["judgment_cut_end"] = "hell_on_earth",
                        }


    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
               
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
         if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/devil_trigger.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
       	local delay = 0.2

	Timers:CreateTimer(delay,function()
        self:PlayEffects2()
		self:PlayEffects()
		self:PlayEffects3()
		end)

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_devil_trigger:PlayEffects()
		-- Get Resources

	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/test_vergil_body_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_body", self.parent:GetAbsOrigin(), true)
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
function modifier_devil_trigger:PlayEffects2()
		-- Get Resources

	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/test_vergil_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_blade2", self.parent:GetAbsOrigin(), true)
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
function modifier_devil_trigger:PlayEffects3()
		-- Get Resources
	local particle_cast = "particles/juggernaut_blade_fury1.vpcf"
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/test_vergil_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_blade1", self.parent:GetAbsOrigin(), true)
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
function modifier_devil_trigger:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_devil_trigger:OnDestroy()
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
            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * caster:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("devil_trigger_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end
