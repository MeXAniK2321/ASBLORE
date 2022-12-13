LinkLuaModifier("modifier_authority_of_vainglory", "heroes/authority_of_vainglory", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_authority_thinker", "heroes/authority_of_vainglory", LUA_MODIFIER_MOTION_NONE )
authority_of_vainglory = class({})

function authority_of_vainglory:IsStealable() return true end
function authority_of_vainglory:IsHiddenWhenStolen() return false end

function authority_of_vainglory:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("world_negation")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function authority_of_vainglory:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function authority_of_vainglory:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
    local origin = caster:GetOrigin()
    caster:AddNewModifier(caster, self, "modifier_authority_of_vainglory", {duration = fixed_duration})
	
		
	 
	 
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})
    self:EndCooldown()

   

end
function authority_of_vainglory:OnProjectileHit(hTarget, vLocation)
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
modifier_authority_of_vainglory = class({})
function modifier_authority_of_vainglory:IsHidden() return false end
function modifier_authority_of_vainglory:IsDebuff() return true end
function modifier_authority_of_vainglory:IsPurgable() return false end
function modifier_authority_of_vainglory:IsPurgeException() return false end
function modifier_authority_of_vainglory:RemoveOnDeath() return true end
function modifier_authority_of_vainglory:AllowIllusionDuplicate() return true end
function modifier_authority_of_vainglory:CheckState()
    local state = { 
                }

    if IsServer() and self.parent and not self.parent:IsNull() and self.parent:GetMana() <= self.awake_mana + 10 then
        local awake = self.parent:FindAbilityByName("authority_of_vainglory_awake")
        if awake and not awake:IsNull() and awake:IsTrained() then
            awake:CastAbility()
        end
    end

    return state
end
function modifier_authority_of_vainglory:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_EVASION_CONSTANT,
	                MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end

function modifier_authority_of_vainglory:GetModifierSpellAmplify_Percentage()
if self:GetCaster():HasModifier( "modifier_item_ultimate_scepter" ) then
    return 50
	else
	return 50
	end
end
function modifier_authority_of_vainglory:GetModifierBonusStats_Strength()
    return 50
end


function modifier_authority_of_vainglory:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")
if self:GetCaster():HasModifier( "modifier_item_ultimate_scepter" ) then
 self.skills_table = {
                            ["authority_of_vainglory"] = "world_negation",
							 ["vainglory"] = "world_revolwing",
                      
                        }
else
    self.skills_table = {
                            ["authority_of_vainglory"] = "world_negation",
                           
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
        if IsServer() then
        if not self.particle_time then
		if self:GetCaster():HasModifier( "modifier_item_ultimate_scepter" ) then
		self.particle_time =    ParticleManager:CreateParticle("particles/vanity.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		else
            self.particle_time =    ParticleManager:CreateParticle("particles/authority_of_vainglory.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
		end

        
	  
        EmitSoundOn("Pandora.5", self.parent)
		
        
		end
self:PlayEffects()
        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_authority_of_vainglory:PlayEffects()
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
function modifier_authority_of_vainglory:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_authority_of_vainglory:OnDestroy()
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

            StopSoundOn("Pandora.5", self.parent)
       

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("authority_of_vainglory_awake")
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
authority_of_vainglory_awake = class({})

function authority_of_vainglory_awake:IsStealable() return true end
function authority_of_vainglory_awake:IsHiddenWhenStolen() return false end
function authority_of_vainglory_awake:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("authority_of_vainglory")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function authority_of_vainglory_awake:OnSpellStart()
    local caster = self:GetCaster()

    if caster:FindModifierByNameAndCaster("modifier_authority_of_vainglory", caster) then
        caster:RemoveModifierByNameAndCaster("modifier_authority_of_vainglory", caster)

        --return nil
    end

    caster:Purge(true, true, false, true, true)

    

    local ability = caster:FindAbilityByName("authority_of_vainglory")
    if ability and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
        ability:EndCooldown()

        print(self.authority_of_vainglory_awake_skills_used, "sss")
        if not self.authority_of_vainglory_awake_skills_used then
            ability:StartCooldown(self:GetSpecialValueFor("no_skills_cd") * caster:GetCooldownReduction())
        else
            ability:StartCooldown(ability:GetCooldown(-1) * caster:GetCooldownReduction())
        end
    end
    
    self.authority_of_vainglory_awake_skills_used = nil

    StopSoundOn("Zenitsu.Hear.Upgrade.Cast.1", caster)
    EmitSoundOn("Zenitsu.Awake.Cast.1", caster)
end
function IsZenitsuSleeping(parent, ability)
    if parent and not parent:IsNull() and ability and not ability:IsNull() then
        local ultimate = parent:FindModifierByNameAndCaster("modifier_authority_of_vainglory", parent)
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

    local authority_of_vainglory_awake = parent:FindAbilityByName("authority_of_vainglory_awake")
    if not authority_of_vainglory_awake:IsNull() and authority_of_vainglory_awake:IsTrained() then
        authority_of_vainglory_awake.authority_of_vainglory_awake_skills_used = true
    end
end


modifier_authority_thinker = class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_authority_thinker:OnCreated( kv )
	-- references

AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), 1, 30, false)
	if IsServer() then
		self:PlayEffects()
	end
	
end

function modifier_authority_thinker:OnRefresh( kv )
	
end

function modifier_authority_thinker:OnRemoved()
end
function modifier_authority_thinker:CheckState()
	local state = {	
					[MODIFIER_STATE_PROVIDES_VISION] = true,}
	return state
end

function modifier_authority_thinker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
			 MODIFIER_PROPERTY_BONUS_NIGHT_VISION,
					 MODIFIER_PROPERTY_BONUS_DAY_VISION,

	
	}

	return funcs
end
function modifier_authority_thinker:GetModifierProvidesFOWVision()
	return 1
end

function modifier_authority_thinker:GetBonusNightVision()
    return 1
end
function modifier_authority_thinker:GetBonusDayVision()

    return 1

end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_authority_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/test_land.vpcf"
	local sound_cast = ""

	-- Create Particle
	-- local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	local effect_cast = assert(loadfile("modifiers/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end