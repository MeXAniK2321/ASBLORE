LinkLuaModifier("modifier_ultra_instinct", "heroes/ultra_instinct", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
ultra_instinct = class({})

function ultra_instinct:IsStealable() return true end
function ultra_instinct:IsHiddenWhenStolen() return false end

function ultra_instinct:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("goku_tp")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function ultra_instinct:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function ultra_instinct:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_ultra_instinct", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})

    self:EndCooldown()
if IsASBPatreon(self:GetCaster()) then
self:PlayEffects(500)
end
   
end
function ultra_instinct:PlayEffects( radius )

	local particle_cast = "particles/supreme_ultra_activation.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
---------------------------------------------------------------------------------------------------------------------
modifier_ultra_instinct = class({})
function modifier_ultra_instinct:IsHidden() return false end
function modifier_ultra_instinct:IsDebuff() return true end
function modifier_ultra_instinct:IsPurgable() return false end
function modifier_ultra_instinct:IsPurgeException() return false end
function modifier_ultra_instinct:RemoveOnDeath() return true end
function modifier_ultra_instinct:AllowIllusionDuplicate() return true end

function modifier_ultra_instinct:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
           MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
MODIFIER_PROPERTY_MODEL_CHANGE,	
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,	   }
    return func
end


function modifier_ultra_instinct:GetModifierModelChange()
if IsASBPatreon(self:GetCaster()) then
return "models/goku/drip/drip_goku_ultra.vmdl"
else
    return "models/goku/goku_ultra.vmdl"
	end
end
function modifier_ultra_instinct:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('str')
end

function modifier_ultra_instinct:GetModifierSpellAmplify_Percentage()

	return 50
	
end


function modifier_ultra_instinct:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    

    self.skills_table = {
                            ["ultra_instinct"] = "goku_tp",
							["super_saiyan"] = "true_kamehameha"
                            
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
		if IsASBPatreon(self:GetCaster()) then
		 self.particle_time =    ParticleManager:CreateParticle("particles/ultra_dripstinct.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		else
            self.particle_time =    ParticleManager:CreateParticle("particles/ultra_instinct.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    end
        end

        
		
        
		if IsServer() then
        local ability = self:GetParent():FindAbilityByName("super_saiyan")
        if ability:IsActivated() then
            ability:SetActivated(false)
        end
    end
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_ultra_instinct:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_ultra_instinct:OnDestroy()
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

            
			if IsServer() then
        local ability = self:GetParent():FindAbilityByName("super_saiyan")
        if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
    end
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                
            end
        end
    end
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
ultra_instinct_awake = class({})

function ultra_instinct_awake:IsStealable() return true end
function ultra_instinct_awake:IsHiddenWhenStolen() return false end
function ultra_instinct_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("ultra_instinct")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function ultra_instinct_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_ultra_instinct", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_ultra_instinct", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("ultra_instinct")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.ultra_instinct_awake_skills_used, "sss")
        if not self.ultra_instinct_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.ultra_instinct_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_ultra_instinct", parent)
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

    local ultra_instinct_awake = parent:FindAbilityByName("ultra_instinct_awake")
    if not ultra_instinct_awake:IsNull() and ultra_instinct_awake:IsTrained() then
        ultra_instinct_awake.ultra_instinct_awake_skills_used = true
    end
end


