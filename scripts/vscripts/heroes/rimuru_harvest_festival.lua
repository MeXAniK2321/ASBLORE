LinkLuaModifier("modifier_rimuru_harvest_festival", "heroes/rimuru_harvest_festival", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rimuru_harvest_festival_invul", "heroes/rimuru_harvest_festival", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)



rimuru_harvest_festival = class({})

function rimuru_harvest_festival:IsStealable() return true end
function rimuru_harvest_festival:IsHiddenWhenStolen() return false end

function rimuru_harvest_festival:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("aizen_sonido")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
--[[function rimuru_harvest_festival:GetBehavior()
    return self:GetCaster():HasTalent("special_bonus_anime_zenitsu_25R") and (self.BaseClass.GetBehavior(self) + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) or self.BaseClass.GetBehavior(self)
end]]
function rimuru_harvest_festival:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	local radius = self:GetSpecialValueFor("radius")
	
 EmitSoundOn("rimuru.7", caster)
    
	caster:AddNewModifier(caster, self, "modifier_rimuru_harvest_festival_invul", {duration = 35})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = 35})


    self:EndCooldown()

    
end
function rimuru_harvest_festival:OnProjectileHit(hTarget, vLocation)
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
modifier_rimuru_harvest_festival_invul = class({})
function modifier_rimuru_harvest_festival_invul:IsHidden() return false end
function modifier_rimuru_harvest_festival_invul:IsDebuff() return true end
function modifier_rimuru_harvest_festival_invul:IsPurgable() return false end
function modifier_rimuru_harvest_festival_invul:IsPurgeException() return false end
function modifier_rimuru_harvest_festival_invul:RemoveOnDeath() return true end
function modifier_rimuru_harvest_festival_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_rimuru_harvest_festival_invul:DeclareFunctions()
    local func = {  
    				
	                
					MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
                   
                    
                     }
    return func
end

function modifier_rimuru_harvest_festival_invul:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end
function modifier_rimuru_harvest_festival_invul:OnDestroy()
local caster = self:GetCaster()
caster:AddNewModifier(caster, self, "modifier_rimuru_harvest_festival", {})
EmitSoundOn("rimuru.9", self:GetParent())
end
function modifier_rimuru_harvest_festival_invul:GetEffectName()
	return "particles/rimuru_harvest_festival.vpcf"
end

function modifier_rimuru_harvest_festival_invul:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

---------------------------------------------------------------------------------------------------------------------
modifier_rimuru_harvest_festival = class({})
function modifier_rimuru_harvest_festival:IsHidden() return true end
function modifier_rimuru_harvest_festival:IsDebuff() return false end
function modifier_rimuru_harvest_festival:IsPurgable() return false end
function modifier_rimuru_harvest_festival:IsPurgeException() return false end
function modifier_rimuru_harvest_festival:RemoveOnDeath() return false end
function modifier_rimuru_harvest_festival:AllowIllusionDuplicate() return true end

function modifier_rimuru_harvest_festival:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                MODIFIER_PROPERTY_EVASION_CONSTANT,
                    MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end


function modifier_rimuru_harvest_festival:GetModifierModelChange()
	return "models/rimuru/rimuru_demon_lord.vmdl"
end
function modifier_rimuru_harvest_festival:GetModifierModelScale()

	return 1
	end

function modifier_rimuru_harvest_festival:GetModifierSpellAmplify_Percentage()
	return 25
end







function modifier_rimuru_harvest_festival:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()



    self.skills_table = {
                            ["rimuru_harvest_festival"] = "rimuru_demon_lord",
							["gluttony"] = "slime_shot",
							["rimuru_flare_circle"] = "rimuru_black_lightning",

                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/rimuru_harvest_festival_ended.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
        
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_rimuru_harvest_festival:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_rimuru_harvest_festival:OnDestroy()
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
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("rimuru_harvest_festival_awake")
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



