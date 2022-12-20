LinkLuaModifier("modifier_devilovania", "heroes/devilovania", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_devilovania_invul", "heroes/devilovania", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_willow_terrorize_lua", "modifiers/modifier_dark_willow_terrorize_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dreams_buff2", "modifiers/modifier_dreams_buff2", LUA_MODIFIER_MOTION_NONE)


devilovania = class({})

function devilovania:IsStealable() return true end
function devilovania:IsHiddenWhenStolen() return false end

function devilovania:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("critical_error")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function devilovania:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local buffDuration = 5
	local targets = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	

    caster:AddNewModifier(caster, self, "modifier_devilovania", {duration = fixed_duration})
		
caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = fixed_duration})

    self:EndCooldown()
local allies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		targets,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,ally in pairs(allies) do
		-- Add modifier
		ally:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_dreams_buff2", -- modifier name
			{ duration = buffDuration } -- kv
		)
	end
   

end
function devilovania:OnProjectileHit(hTarget, vLocation)
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
modifier_devilovania = class({})
function modifier_devilovania:IsHidden() return false end
function modifier_devilovania:IsDebuff() return true end
function modifier_devilovania:IsPurgable() return false end
function modifier_devilovania:IsPurgeException() return false end
function modifier_devilovania:RemoveOnDeath() return true end
function modifier_devilovania:AllowIllusionDuplicate() return true end

function modifier_devilovania:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
					MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,					}
    return func
end


function modifier_devilovania:GetModifierModelChange()

    
	return "models/frisk/chara.vmdl"

end

function modifier_devilovania:GetModifierPreAttack_BonusDamage()
    return 200
end
function modifier_devilovania:GetModifierBonusStats_Strength()
    return 100
end

function modifier_devilovania:GetModifierSpellAmplify_Percentage()
return 50
end




function modifier_devilovania:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["devilovania"] = "true_fear",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/chara_pacifist_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
		
        EmitSoundOn("frisk.5", self.parent)
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_devilovania:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_devilovania:OnDestroy()
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

            StopSoundOn("frisk.5", self.parent)

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1)* self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("devilovania_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end