LinkLuaModifier("modifier_heavenly_body_magic", "heroes/heavenly_body_magic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_eternity", "heroes/heavenly_body_magic.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)

heavenly_body_magic = class({})

function heavenly_body_magic:IsStealable() return true end
function heavenly_body_magic:IsHiddenWhenStolen() return false end
function heavenly_body_magic:GetIntrinsicModifierName()
    return "modifier_eternity"
end

function heavenly_body_magic:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("grand_chariot")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function heavenly_body_magic:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function heavenly_body_magic:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_heavenly_body_magic", {duration = fixed_duration+ self:GetCaster():FindTalentValue("special_bonus_lelouch_25")})
	caster:AddNewModifier(caster, self, "modifier_item_anime_boombox", {duration = 1})
	caster:AddNewModifier(caster, self, "modifier_star_tier1", {duration = fixed_duration})

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
function heavenly_body_magic:OnProjectileHit(hTarget, vLocation)
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
modifier_heavenly_body_magic = class({})
function modifier_heavenly_body_magic:IsHidden() return false end
function modifier_heavenly_body_magic:IsDebuff() return true end
function modifier_heavenly_body_magic:IsPurgable() return false end
function modifier_heavenly_body_magic:IsPurgeException() return false end
function modifier_heavenly_body_magic:RemoveOnDeath() return true end
function modifier_heavenly_body_magic:AllowIllusionDuplicate() return true end
function modifier_heavenly_body_magic:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("heavenly_body_magic_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_heavenly_body_magic:DeclareFunctions()
    local func = {  		
					MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    }
    return func
end



function modifier_heavenly_body_magic:GetModifierMagicalResistanceBonus()
    return 20
end



function modifier_heavenly_body_magic:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["heavenly_body_magic"] = "grand_chariot",
							["mirror_water"] = "pleades",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/heavenly_body_magic.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

        
		
        EmitSoundOn("jellal.4", self.parent)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_heavenly_body_magic:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_heavenly_body_magic:OnDestroy()
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

            StopSoundOn("jellal.4", self.parent)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("heavenly_body_magic_awake")
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
heavenly_body_magic_awake = class({})

function heavenly_body_magic_awake:IsStealable() return true end
function heavenly_body_magic_awake:IsHiddenWhenStolen() return false end
function heavenly_body_magic_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("heavenly_body_magic")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function heavenly_body_magic_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_heavenly_body_magic", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_heavenly_body_magic", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("heavenly_body_magic")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.heavenly_body_magic_awake_skills_used, "sss")
        if not self.heavenly_body_magic_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.heavenly_body_magic_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_heavenly_body_magic", parent)
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

    local heavenly_body_magic_awake = parent:FindAbilityByName("heavenly_body_magic_awake")
    if not heavenly_body_magic_awake:IsNull() and heavenly_body_magic_awake:IsTrained() then
        heavenly_body_magic_awake.heavenly_body_magic_awake_skills_used = true
    end
end

modifier_eternity = class ({})
function modifier_eternity:IsHidden() return true end
function modifier_eternity:IsDebuff() return false end
function modifier_eternity:IsPurgable() return false end
function modifier_eternity:IsPurgeException() return false end
function modifier_eternity:RemoveOnDeath() return false end

function modifier_eternity:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_eternity:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_eternity:OnIntervalThink()
    if IsServer() then
        local genius = self:GetParent():FindAbilityByName("eternal_heavenly_body_magic")
        if genius and not genius:IsNull() then
            if self:GetParent():HasScepter() then
                if genius:IsHidden() then
                    genius:SetHidden(false)
                end
            else
                if not genius:IsHidden() then
                    genius:SetHidden(true)
                end
            end
        end
    end
end
