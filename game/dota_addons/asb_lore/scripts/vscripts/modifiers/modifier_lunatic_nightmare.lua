modifier_lunatic_nightmare = class({})
function modifier_lunatic_nightmare:IsHidden() return false end
function modifier_lunatic_nightmare:IsDebuff() return true end
function modifier_lunatic_nightmare:IsPurgable() return false end
function modifier_lunatic_nightmare:IsPurgeException() return false end
function modifier_lunatic_nightmare:RemoveOnDeath() return true end
function modifier_lunatic_nightmare:AllowIllusionDuplicate() return true end

function modifier_lunatic_nightmare:DeclareFunctions()
    local func = {  
	                MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,	 }
    return func
end


function modifier_lunatic_nightmare:GetModifierSpellAmplify_PercentageUnique()
    return 50
end
function modifier_lunatic_nightmare:GetModifierBonusStats_Strength()
    return 100
end





function modifier_lunatic_nightmare:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["lunatic_nightmare"] = "taboo_and_there_will_be_nothing",
							
							
                            
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
		local ability2 = self:GetCaster():FindAbilityByName("taboo_eternal_hunting")
                if ability2 and not ability2:IsNull() and ability2:IsTrained() and ability2:GetCooldown(-1) > 0 then
                    ability2:EndCooldown()
                    ability2:RefreshCharges()
                end
            
        
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/nightmare_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
		
       
		
		end
        

        self.parent:Purge(false, true, false, true, true)
		self:StartIntervalThink(5.0 )
    end
end
function modifier_lunatic_nightmare:OnIntervalThink()
self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = 100,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		if enemy:HasModifier( "modifier_lunatic_nightmare_thinker_in" )  then	
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
		 local caster = self:GetCaster()
    local duration = 3.0
    local incoming = 100
    local outgoing = 100
    local clones = 1 



    for i = 1,clones do
        local clone = CreateIllusionForPlayer(caster, caster, caster, self, enemy:GetAbsOrigin() + RandomVector(100), duration, 1, incoming, outgoing)
    end
	end

		-- play effects
		
	end
end

function modifier_lunatic_nightmare:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_lunatic_nightmare:OnDestroy()
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
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("lunatic_nightmare_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end