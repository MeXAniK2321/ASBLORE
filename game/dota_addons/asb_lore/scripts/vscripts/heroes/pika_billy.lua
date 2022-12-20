LinkLuaModifier("modifier_pika_billy", "heroes/pika_billy.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
pika_billy = class({})

function pika_billy:IsStealable() return true end
function pika_billy:IsHiddenWhenStolen() return false end

function pika_billy:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("pika_billy_awake")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--[[function pika_billy:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function pika_billy:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")+self:GetCaster():FindTalentValue("special_bonus_yoshino_20")

    caster:AddNewModifier(caster, self, "modifier_pika_billy", {duration = fixed_duration})

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
---------------------------------------------------------------------------------------------------------------------
modifier_pika_billy = class({})
function modifier_pika_billy:IsHidden() return false end
function modifier_pika_billy:IsDebuff() return true end
function modifier_pika_billy:IsPurgable() return false end
function modifier_pika_billy:IsPurgeException() return false end
function modifier_pika_billy:RemoveOnDeath() return true end
function modifier_pika_billy:AllowIllusionDuplicate() return true end
function modifier_pika_billy:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("pika_billy_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_pika_billy:DeclareFunctions()
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
function modifier_pika_billy:GetModifierModelChange()
    return "models/pikapika/billy.vmdl"
end
function modifier_pika_billy:GetModifierModelScale()
	return 1
end



function modifier_pika_billy:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
	
	 
	 
	 self.skills_table = {
                            
							["pika_billy"]="pika_billy_awake",
							["pika_casino"]="billy_flex",
							["pikachu_nit"]="billy_fuck_u",
							["pika_futbol"]="billy_fisting",
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
		 local HiddenAbilities = 
	{
	
	
		"pukachu_pukachu",
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
function modifier_pika_billy:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_pika_billy:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("pika_billy_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
	 local hideit = 
	{
	"pukachu_pukachu",
		
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
pika_billy_awake = class({})

function pika_billy_awake:IsStealable() return true end
function pika_billy_awake:IsHiddenWhenStolen() return false end
function pika_billy_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("pika_billy")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function pika_billy_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_pika_billy", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_pika_billy", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("pika_billy")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.pika_billy_awake_skills_used, "sss")
        if not self.pika_billy_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.pika_billy_awake_skills_used = nil

    StopSoundOn("rimuru.morph_1", caster)
    EmitSoundOn("rimuru.morph_2", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_pika_billy", parent)
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

    local pika_billy_awake = parent:FindAbilityByName("pika_billy_awake")
    if not pika_billy_awake:IsNull() and pika_billy_awake:IsTrained() then
        pika_billy_awake.pika_billy_awake_skills_used = true
    end
end
