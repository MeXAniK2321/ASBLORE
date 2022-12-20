LinkLuaModifier("modifier_ittou_shura", "heroes/ittou_shura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)

ittou_shura = class({})

function ittou_shura:IsStealable() return true end
function ittou_shura:IsHiddenWhenStolen() return false end

function ittou_shura:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("ikki_invisible_step")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function ittou_shura:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function ittou_shura:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")

    caster:AddNewModifier(caster, self, "modifier_ittou_shura", {duration = fixed_duration})
	caster:AddNewModifier(caster, self, "modifier_star_tier1", {duration = fixed_duration})

    self:EndCooldown()

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
end
function ittou_shura:OnProjectileHit(hTarget, vLocation)
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
modifier_ittou_shura = class({})
function modifier_ittou_shura:IsHidden() return false end
function modifier_ittou_shura:IsDebuff() return true end
function modifier_ittou_shura:IsPurgable() return false end
function modifier_ittou_shura:IsPurgeException() return false end
function modifier_ittou_shura:RemoveOnDeath() return true end
function modifier_ittou_shura:AllowIllusionDuplicate() return true end
function modifier_ittou_shura:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("ittou_shura_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_ittou_shura:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_DISABLE_HEALING,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, }
    return func
end



function modifier_ittou_shura:GetModifierAttackSpeedBonus_Constant()
    return 50
end

function modifier_ittou_shura:GetModifierPreAttack_BonusDamage()
    return self.damage
end

	


function modifier_ittou_shura:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()
	self.hp = self.caster:GetMaxHealth()
		self.damage = self.hp * 0.025

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["ittou_shura"] = "ikki_invisible_step",
                            
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
             self.particle_time =    ParticleManager:CreateParticle("particles/ittou_shura_sfx1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        end

        
		
        EmitSoundOn("ittou.shura", self.parent)
        local interval = 1
self:StartIntervalThink( interval )
        self.parent:Purge(false, true, false, true, true)
		self:PlayEffects()
		self:PlayEffects2()
		self:PlayEffects3()
		self:PlayEffects4()
		local hideit = 
	{
	"ittou_shura_raiko",
		
	}

	for _,hideability in pairs(hideit) do
	   	hideability = self:GetParent():FindAbilityByName(hideability)
		  if hideability and not hideability:IsActivated() then
            hideability:SetActivated(true)
        end
		end
    end
end
end
function modifier_ittou_shura:PlayEffects( )
	-- Get Resources
	self.particle_cast = "particles/ittou_shura_screen.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticleForPlayer( self.particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end
function modifier_ittou_shura:PlayEffects2( )
	-- Get Resources
	 if not self.particle_time2 then
            self.particle_time2 =    ParticleManager:CreateParticle("particles/test_ittou_shura_blood_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time2, 0, self.parent, PATTACH_POINT_FOLLOW, "ikki1", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time2, 1, Vector(self.radius, self.radius, self.radius))
        end
	
	
end
function modifier_ittou_shura:PlayEffects3( )
	-- Get Resources
	 if not self.particle_time3 then
            self.particle_time3 =    ParticleManager:CreateParticle("particles/test_ittou_shura_blood_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time3, 0, self.parent, PATTACH_POINT_FOLLOW, "ikki2", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time3, 1, Vector(self.radius, self.radius, self.radius))
        end
	
	
end
function modifier_ittou_shura:PlayEffects4( )
	-- Get Resources
	 if not self.particle_time4 then
            self.particle_time4 =    ParticleManager:CreateParticle("particles/test_ittou_shura_blood_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time4, 0, self.parent, PATTACH_POINT_FOLLOW, "ikki3", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time4, 1, Vector(self.radius, self.radius, self.radius))
        end
	
	
end


function modifier_ittou_shura:OnIntervalThink()
self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
	}
	-- update damage
	self.damageTable.damage = 5/100*self:GetParent():GetHealth()

	-- apply damage
	ApplyDamage( self.damageTable )
end
function modifier_ittou_shura:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_ittou_shura:OnDestroy()
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
		ParticleManager:DestroyParticle(self.particle_time2, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time2)
		ParticleManager:DestroyParticle(self.particle_time3, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time3)
		ParticleManager:DestroyParticle(self.particle_time4, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time4)

            StopSoundOn("ittou.shura", self.parent)
			
ParticleManager:DestroyParticle(self.effect_cast, false)
        ParticleManager:ReleaseParticleIndex(self.effect_cast)
            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("ittou_shura_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    
                end
				if self:GetCaster():HasScepter() then
	else
				local HiddenAbilities = 
	{
	
		"ittou_shura_raiko",
	}

	for _,HiddenAbility in pairs(HiddenAbilities) do
	   	HiddenAbility = self:GetParent():FindAbilityByName(HiddenAbility)
        if HiddenAbility:IsActivated() then
            HiddenAbility:SetActivated(false)
        end
            end
			end
			end
        end
    end
	end

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
ittou_shura_awake = class({})

function ittou_shura_awake:IsStealable() return true end
function ittou_shura_awake:IsHiddenWhenStolen() return false end
function ittou_shura_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("ittou_shura")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function ittou_shura_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_ittou_shura", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_ittou_shura", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("ittou_shura")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.ittou_shura_awake_skills_used, "sss")
        if not self.ittou_shura_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.ittou_shura_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_ittou_shura", parent)
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

    local ittou_shura_awake = parent:FindAbilityByName("ittou_shura_awake")
    if not ittou_shura_awake:IsNull() and ittou_shura_awake:IsTrained() then
        ittou_shura_awake.ittou_shura_awake_skills_used = true
    end
end


LinkLuaModifier("modifier_kotori_ring", "heroes/ittou_shura", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kotori_ring_buff", "heroes/ittou_shura", LUA_MODIFIER_MOTION_NONE)

kotori_ring = class({})

function kotori_ring:IsStealable() return true end
function kotori_ring:IsHiddenWhenStolen() return false end
function kotori_ring:OnAbilityPhaseStart()
	self.pre_ring_fx = 	ParticleManager:CreateParticle("", PATTACH_WORLDORIGIN, nil)
	                    ParticleManager:SetParticleControl(self.pre_ring_fx, 0, self:GetCaster():GetAbsOrigin())
	                    ParticleManager:SetParticleControl(self.pre_ring_fx, 1, Vector(self:GetAOERadius(), 1, 1))

	return true
end
function kotori_ring:OnAbilityPhaseInterrupted()
	ParticleManager:DestroyParticle(self.pre_ring_fx, false)
	ParticleManager:ReleaseParticleIndex(self.pre_ring_fx)
end
function kotori_ring:GetAOERadius()
	return self:GetSpecialValueFor("ring_radius") 
end
function kotori_ring:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("ring_duration")

    CreateModifierThinker(caster, self, "modifier_kotori_ring", {duration = duration}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
end
---------------------------------------------------------------------------------------------------------------------
modifier_kotori_ring = class({})
function modifier_kotori_ring:IsHidden() return true end
function modifier_kotori_ring:IsDebuff() return false end
function modifier_kotori_ring:IsPurgable() return false end
function modifier_kotori_ring:IsPurgeException() return false end
function modifier_kotori_ring:RemoveOnDeath() return true end
function modifier_kotori_ring:IsAura() return true end
function modifier_kotori_ring:IsAuraActiveOnDeath() return false end
function modifier_kotori_ring:GetAuraDuration()
	return self.ring_dot_duration
end
function modifier_kotori_ring:GetAuraEntityReject(hEntity)
end
function modifier_kotori_ring:GetAuraRadius()
    return self.ring_radius
end
function modifier_kotori_ring:GetAuraSearchFlags()
    return self:GetAbility():GetAbilityTargetFlags()
end
function modifier_kotori_ring:GetAuraSearchTeam()
    return self:GetAbility():GetAbilityTargetTeam()
end
function modifier_kotori_ring:GetAuraSearchType()
    return self:GetAbility():GetAbilityTargetType()
end
function modifier_kotori_ring:GetModifierAura()
    return "modifier_kotori_ring_buff"
end
function modifier_kotori_ring:OnCreated(table)
    if IsServer() then
        self.caster = self:GetCaster()
        self.parent = self:GetParent()
        self.ability = self:GetAbility()

        self.ring_radius = self.ability:GetAOERadius()

      	self.ring_dot_duration = self.ability:GetSpecialValueFor("ring_dot_duration")

		EmitSoundOn("ember_spirit_embr_fireremrun_01", self.parent)
		EmitSoundOn("Shana.Hien", self.parent)

      	if not self.ring_fx then
		    self.ring_fx = ParticleManager:CreateParticle("particles/hien.vpcf", PATTACH_WORLDORIGIN, nil)
		                    ParticleManager:SetParticleControl(self.ring_fx, 0, self.parent:GetAbsOrigin())
		                    ParticleManager:SetParticleControl(self.ring_fx, 1, Vector(self.ring_radius, 1, 1))
		                    ParticleManager:SetParticleControl(self.ring_fx, 2, Vector(self:GetDuration(), 0, 0))

	        self:AddParticle(self.ring_fx, false, false, -1, true, true)
	    end
    end
end
function modifier_kotori_ring:OnRefresh(table)
	if IsServer() then
		self:OnCreated(table)
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_kotori_ring_buff = class({})
function modifier_kotori_ring_buff:IsHidden() return false end
function modifier_kotori_ring_buff:IsDebuff() return true end
function modifier_kotori_ring_buff:IsPurgable() return true end
function modifier_kotori_ring_buff:IsPurgeException() return true end
function modifier_kotori_ring_buff:RemoveOnDeath() return true end
function modifier_kotori_ring_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_kotori_ring_buff:OnCreated(table)
    if IsServer() then
        self.caster = self:GetCaster()
        self.parent = self:GetParent()
        self.ability = self:GetAbility()

        self.ring_dot_interval  = self.ability:GetSpecialValueFor("ring_dot_interval")
        self.ring_dot_damage    = self.ring_dot_interval * (self.ability:GetSpecialValueFor("ring_dot_damage"))

        local burn_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        
        self:AddParticle(burn_fx, false, false, -1, true, true)

        self:StartIntervalThink(self.ring_dot_interval)
    end
end
function modifier_kotori_ring_buff:OnRefresh(table)
	if IsServer() then
		self:OnCreated(table)
	end
end
function modifier_kotori_ring_buff:OnIntervalThink()
    if IsServer() then
        local damage_table = {  victim = self.parent,
                                attacker = self.caster,
                                damage = self.ring_dot_damage,
                                damage_type = self.ability:GetAbilityDamageType(),
                                ability = self.ability }

        ApplyDamage(damage_table)
    end
end