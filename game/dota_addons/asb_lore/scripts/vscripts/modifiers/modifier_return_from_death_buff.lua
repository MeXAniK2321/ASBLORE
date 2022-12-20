


modifier_return_from_death_buff = class({})
function modifier_return_from_death_buff:IsHidden() return false end
function modifier_return_from_death_buff:IsDebuff() return true end
function modifier_return_from_death_buff:IsPurgable() return false end
function modifier_return_from_death_buff:IsPurgeException() return false end
function modifier_return_from_death_buff:RemoveOnDeath() return true end
function modifier_return_from_death_buff:AllowIllusionDuplicate() return false end

function modifier_return_from_death_buff:DeclareFunctions()
    local func = {  
    				
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,              
                    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,					}
    return func
end



function modifier_return_from_death_buff:GetModifierBonusStats_Strength()
    return 50
end
function modifier_return_from_death_buff:GetModifierBonusStats_Agility()
    return 50
end
function modifier_return_from_death_buff:GetModifierSpellAmplify_Percentage()
    return 50
end

function modifier_return_from_death_buff:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

if self:GetCaster():HasModifier("modifier_item_ultimate_scepter") then
    self.skills_table = {
                            ["return_from_death"] = "subaru_heart_crash",
							["cor_leonis"] = "second_hand",
							["spirit_contract"] = "unthinkable_present",
                            
                        }
						else
						 self.skills_table = {
                            ["return_from_death"] = "subaru_heart_crash",
							["spirit_contract"] = "unthinkable_present",
							
                            
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
					self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
					
                end
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/return_from_death_aura2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end
		self:StartIntervalThink( 0.8 )

        
		
        
       

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_return_from_death_buff:OnIntervalThink()
	-- find enemies
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = 250,
		damage_type = self:GetAbility():GetAbilityDamageType(),
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
function modifier_return_from_death_buff:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_return_from_death_buff:OnDestroy()
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

            
			

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("return_from_death_buff_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end