LinkLuaModifier("modifier_rimuru_slime", "heroes/rimuru_slime.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
rimuru_slime = class({})

function rimuru_slime:IsStealable() return true end
function rimuru_slime:IsHiddenWhenStolen() return false end

function rimuru_slime:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rimuru_slime_awake")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--[[function rimuru_slime:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function rimuru_slime:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")+self:GetCaster():FindTalentValue("special_bonus_yoshino_20")

    caster:AddNewModifier(caster, self, "modifier_rimuru_slime", {duration = fixed_duration})

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_rimuru_slime = class({})
function modifier_rimuru_slime:IsHidden() return false end
function modifier_rimuru_slime:IsDebuff() return true end
function modifier_rimuru_slime:IsPurgable() return false end
function modifier_rimuru_slime:IsPurgeException() return false end
function modifier_rimuru_slime:RemoveOnDeath() return true end
function modifier_rimuru_slime:AllowIllusionDuplicate() return true end
function modifier_rimuru_slime:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("rimuru_slime_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_rimuru_slime:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,					}
    return func
end
function modifier_rimuru_slime:GetModifierModelChange()
    return "models/rimuru/rimuru_slime_real.vmdl"
end
function modifier_rimuru_slime:GetModifierModelScale()
	return -50
end
function modifier_rimuru_slime:GetModifierMagicalResistanceBonus()
    return self:GetAbility():GetSpecialValueFor("resist")
end


function modifier_rimuru_slime:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
	 if self:GetCaster():HasModifier("modifier_rimuru_harvest_festival") then
	 
	 
	 self.skills_table = {
                            
							["rimuru_slime"]="rimuru_slime_awake",
							["rimuru_black_lightning"]="rimuru_beelzebub",
							["rimuru_shield"]="rimuru_water_blade",
							["slime_shot"]="rimuru_spider",
                        }
						else

    self.skills_table = {
                            
							["rimuru_slime"]="rimuru_slime_awake",
							["gluttony"]="rimuru_spider",
							["rimuru_shield"]="rimuru_water_blade",
							["rimuru_flare_circle"]="rimuru_predator",
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
                  
                end
            end
        end
		 local HiddenAbilities = 
	{
	
		"rimuru_black_flame",
		"rimuru_merciless",
		"rimuru_harvest_festival",
		"rimuru_demon_lord",
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
    end
           
        local sleep_fx = ParticleManager:CreateParticle("particles/econ/courier/courier_greevil_blue/courier_greevil_blue_ambient_1.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)

        self:AddParticle(sleep_fx, false, false, -1, false, true)
		
        EmitSoundOn("rimuru.morph_1", self.parent)
        EmitSoundOn("", self.parent)

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_rimuru_slime:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_rimuru_slime:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

            StopSoundOn("rimuru.morph_1", self.parent)
			StopSoundOn("", self.parent)

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("rimuru_slime_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	 local hideit = 
	{
	"rimuru_black_flame",
	"rimuru_merciless",
	"rimuru_harvest_festival",
	"rimuru_demon_lord",
		
	}

	for _,hideability in pairs(hideit) do
	   	hideability = self:GetParent():FindAbilityByName(hideability)
		  if hideability and not hideability:IsActivated() then
            hideability:SetActivated(true)
        end
		end
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
rimuru_slime_awake = class({})

function rimuru_slime_awake:IsStealable() return true end
function rimuru_slime_awake:IsHiddenWhenStolen() return false end
function rimuru_slime_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("rimuru_slime")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function rimuru_slime_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_rimuru_slime", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_rimuru_slime", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("rimuru_slime")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.rimuru_slime_awake_skills_used, "sss")
        if not self.rimuru_slime_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.rimuru_slime_awake_skills_used = nil

    StopSoundOn("rimuru.morph_1", caster)
    EmitSoundOn("rimuru.morph_2", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_rimuru_slime", parent)
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

    local rimuru_slime_awake = parent:FindAbilityByName("rimuru_slime_awake")
    if not rimuru_slime_awake:IsNull() and rimuru_slime_awake:IsTrained() then
        rimuru_slime_awake.rimuru_slime_awake_skills_used = true
    end
end
