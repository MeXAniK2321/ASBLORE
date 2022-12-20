LinkLuaModifier("modifier_zayac", "heroes/zayac.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3", LUA_MODIFIER_MOTION_NONE)
zayac = class({})

function zayac:IsStealable() return true end
function zayac:IsHiddenWhenStolen() return false end

function zayac:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("lina_dragon_slave_lua")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

--[[function zayac:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function zayac:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_zayac", {duration = fixed_duration})
	if self:GetCaster():HasModifier( "modifier_yoshino_state_inversion" ) then
	caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = fixed_duration})
	else
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_5)
end
    self:EndCooldown()
    
    
end
function zayac:GetAbilityTextureName()
	if self:GetCaster():HasModifier("modifier_yoshino_state_inversion") then
		return "yoshino/yoshino_inverse_zayac"
	end
	return "zayac"
end
---------------------------------------------------------------------------------------------------------------------
modifier_zayac = class({})
function modifier_zayac:IsHidden() return false end
function modifier_zayac:IsDebuff() return true end
function modifier_zayac:IsPurgable() return false end
function modifier_zayac:IsPurgeException() return false end
function modifier_zayac:RemoveOnDeath() return true end
function modifier_zayac:AllowIllusionDuplicate() return true end
function modifier_zayac:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("zayac_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_zayac:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MODEL_CHANGE,
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                    MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,					}
    return func
end
function modifier_zayac:GetModifierModelChange()
if self:GetCaster():HasModifier( "modifier_yoshino_state_inversion" ) then
return "models/zayac/zayac.vmdl"
else
    return "models/yoshinon/yoshino_angel.vmdl"
end
end
function modifier_zayac:GetModifierModelScale()
if self:GetCaster():HasModifier( "modifier_yoshino_state_inversion" ) then 
return  -80
else
	return 0
end
end
function modifier_zayac:GetModifierBonusStats_Agility()
    return 6
end
function modifier_zayac:GetModifierBaseAttack_BonusDamage()
    return 0
end
function modifier_zayac:GetModifierBonusStats_Intellect()
    return 60
end
function modifier_zayac:GetModifierBonusStats_Strength()
if self:GetCaster():HasModifier( "modifier_yoshino_state_inversion" ) then
    return 75
	else
	return 60
	end
end
function modifier_zayac:GetModifierSpellAmplify_Percentage()
    return 50
end

function modifier_zayac:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
if self:GetCaster():HasModifier( "modifier_yoshino_state_inversion" ) then
 self.skills_table = {
                           
							["zayac"]="yoshino_black_age"
                        }
else
    self.skills_table = {
                           
							["zayac"]="lina_dragon_slave_lua"
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
			if self:GetCaster():HasModifier( "modifier_yoshino_state_inversion" ) then
			self:StartIntervalThink( 0.8 )
			  self.sleep_fx = ParticleManager:CreateParticle("particles/yoshino_black_rabbit.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
			else
        self.sleep_fx = ParticleManager:CreateParticle("particles/yoshino_zayac.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)
		end
           
        self:AddParticle(self.sleep_fx, false, false, -1, false, true)
		
        EmitSoundOn("yoshino.zayac", self.parent)
        

        self.parent:Purge(false, true, false, true, true)
    end
end
function modifier_zayac:OnIntervalThink()
	-- find enemies
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = 400,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		400,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
       
		-- play effects
		
	end
end
function modifier_zayac:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_zayac:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end

            StopSoundOn("yoshino.zayac", self.parent)
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("zayac_awake")
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
zayac_awake = class({})

function zayac_awake:IsStealable() return true end
function zayac_awake:IsHiddenWhenStolen() return false end
function zayac_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("zayac")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function zayac_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_zayac", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_zayac", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("zayac")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.zayac_awake_skills_used, "sss")
        if not self.zayac_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.zayac_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_zayac", parent)
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

    local zayac_awake = parent:FindAbilityByName("zayac_awake")
    if not zayac_awake:IsNull() and zayac_awake:IsTrained() then
        zayac_awake.zayac_awake_skills_used = true
    end
end
modifier_yoshirite = class ({})
function modifier_yoshirite:IsHidden() return true end
function modifier_yoshirite:IsDebuff() return false end
function modifier_yoshirite:IsPurgable() return false end
function modifier_yoshirite:IsPurgeException() return false end
function modifier_yoshirite:RemoveOnDeath() return false end

function modifier_yoshirite:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_yoshirite:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_yoshirite:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_yoshirite:GetModifierBaseAttackTimeConstant()
	return 5.0
end
function modifier_yoshirite:OnIntervalThink()
    if IsServer() then
        local snow_loli = self:GetParent():FindAbilityByName("bloodseeker_blood_rite_lua")
        if snow_loli and not snow_loli:IsNull() then
            if self:GetParent():HasScepter() then
                if snow_loli:IsHidden() then
                    snow_loli:SetHidden(false)
                end
            else
                if not snow_loli:IsHidden() then
                    snow_loli:SetHidden(true)
                end
            end
        end
    end
end