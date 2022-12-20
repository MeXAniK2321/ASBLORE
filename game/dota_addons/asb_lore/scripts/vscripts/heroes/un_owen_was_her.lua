LinkLuaModifier("modifier_un_owen_was_her", "heroes/un_owen_was_her", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_un_owen_was_her_invul", "heroes/un_owen_was_her", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_willow_terrorize_lua", "modifiers/modifier_dark_willow_terrorize_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE)

un_owen_was_her = class({})

function un_owen_was_her:IsStealable() return true end
function un_owen_was_her:IsHiddenWhenStolen() return false end

function un_owen_was_her:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("taboo_and_there_will_be_nothing")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function un_owen_was_her:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = self:GetSpecialValueFor("radius")
	local duration = 2.4
	local damage = 1000
EmitSoundOn("flandr.5", caster)
	-- logic
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		-- silence
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_generic_silenced_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end

	

    caster:AddNewModifier(caster, self, "modifier_un_owen_was_her", {duration = fixed_duration})
	
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})

    self:EndCooldown()
	local ability = self:GetCaster():FindAbilityByName("lunatic_nightmare")
	ability:StartCooldown(180)

    
end
function un_owen_was_her:OnProjectileHit(hTarget, vLocation)
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
modifier_un_owen_was_her = class({})
function modifier_un_owen_was_her:IsHidden() return false end
function modifier_un_owen_was_her:IsDebuff() return true end
function modifier_un_owen_was_her:IsPurgable() return false end
function modifier_un_owen_was_her:IsPurgeException() return false end
function modifier_un_owen_was_her:RemoveOnDeath() return true end
function modifier_un_owen_was_her:AllowIllusionDuplicate() return true end

function modifier_un_owen_was_her:DeclareFunctions()
    local func = {  
	                MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,					}
    return func
end


function modifier_un_owen_was_her:GetModifierSpellAmplify_PercentageUnique()
    return 50
end
function modifier_un_owen_was_her:GetModifierBonusStats_Strength()
    return 50
end






function modifier_un_owen_was_her:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["un_owen_was_her"] = "taboo_and_there_will_be_nothing",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/un_owen_was_her.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
		
        
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_un_owen_was_her:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_un_owen_was_her:OnDestroy()
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

            StopSoundOn("chara.5_1", self.parent)

            if self.parent:IsRealHero() then
               self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self:GetCaster():FindAbilityByName("lunatic_nightmare")
	            ability:StartCooldown(180)
                   
                end
            end
        end
    end
