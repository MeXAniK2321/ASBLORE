LinkLuaModifier("modifier_geass", "heroes/geass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_ohmygod", "heroes/geass.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)

geass = class({})

function geass:IsStealable() return true end
function geass:IsHiddenWhenStolen() return false end
function geass:GetIntrinsicModifierName()
    return "modifier_ohmygod"
end

function geass:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("geass_kill")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function geass:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function geass:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_geass", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_item_anime_boombox", {duration = 1})
	caster:AddNewModifier(caster, self, "modifier_star_tier1", {duration = fixed_duration})

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
function geass:OnProjectileHit(hTarget, vLocation)
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
modifier_geass = class({})
function modifier_geass:IsHidden() return false end
function modifier_geass:IsDebuff() return true end
function modifier_geass:IsPurgable() return false end
function modifier_geass:IsPurgeException() return false end
function modifier_geass:RemoveOnDeath() return true end
function modifier_geass:AllowIllusionDuplicate() return true end
function modifier_geass:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("geass_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_geass:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
					 MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end




function modifier_geass:GetModifierSpellAmplify_Percentage()
if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
return 25

else
    return 0
	end
end


function modifier_geass:GetModifierMoveSpeedBonus_Constant()

	return 40
	end


function modifier_geass:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["geass"] = "geass_kill",
							["lelouch_nightmare"] = "geass_command",
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/lelouch_geass.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
        EmitSoundOn("lelouch.geass", self.parent)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_geass:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_geass:OnDestroy()
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

            StopSoundOn("lelouch.geass", self.parent)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("geass_awake")
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
geass_awake = class({})

function geass_awake:IsStealable() return true end
function geass_awake:IsHiddenWhenStolen() return false end
function geass_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("geass")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function geass_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_geass", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_geass", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("geass")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.geass_awake_skills_used, "sss")
        if not self.geass_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.geass_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_geass", parent)
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

    local geass_awake = parent:FindAbilityByName("geass_awake")
    if not geass_awake:IsNull() and geass_awake:IsTrained() then
        geass_awake.geass_awake_skills_used = true
    end
end

modifier_ohmygod = class ({})
function modifier_ohmygod:IsHidden() return true end
function modifier_ohmygod:IsDebuff() return false end
function modifier_ohmygod:IsPurgable() return false end
function modifier_ohmygod:IsPurgeException() return false end
function modifier_ohmygod:RemoveOnDeath() return false end

function modifier_ohmygod:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_ohmygod:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_ohmygod:OnIntervalThink()
    if IsServer() then
        local simpboy = self:GetParent():FindAbilityByName("eternal_geass")
        if simpboy and not simpboy:IsNull() then
            if self:GetParent():HasScepter() then
                if simpboy:IsHidden() then
                    simpboy:SetHidden(false)
                end
            else
                if not simpboy:IsHidden() then
                    simpboy:SetHidden(true)
                end
            end
        end
    end
end
