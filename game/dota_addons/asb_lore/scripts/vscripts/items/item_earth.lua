LinkLuaModifier("modifier_earth", "items/item_earth", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_earth_stat", "items/item_earth", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_neko_arc", "items/item_earth", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
item_earth = class({})

function item_earth:GetIntrinsicModifierName()
    return "modifier_earth"
	end
function item_earth:OnSpellStart()
 local caster = self:GetCaster()
local modifier = caster:FindModifierByNameAndCaster("modifier_valera",caster)
if modifier == nil then return end
	local current = modifier:GetStackCount()
	if current == 10 then
	if not caster:HasModifier("modifier_red_arcueid")  then
    caster:AddNewModifier(caster, self, "modifier_neko_arc", {duration = 30})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = 30})
	EmitSoundOn("arcueid.neko", caster)
	modifier:SetStackCount(0)
	end
	end
	end
	
modifier_neko_arc = class({})
function modifier_neko_arc:IsHidden() return false end
function modifier_neko_arc:IsDebuff() return true end
function modifier_neko_arc:IsPurgable() return false end
function modifier_neko_arc:IsPurgeException() return false end
function modifier_neko_arc:RemoveOnDeath() return true end
function modifier_neko_arc:AllowIllusionDuplicate() return true end

function modifier_neko_arc:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,					}
    return func
end

function modifier_neko_arc:GetModifierSpellAmplify_PercentageUnique()
    return 50
end
function modifier_neko_arc:GetModifierModelChange()

	return "models/arcueid/neko_arc.vmdl"
	end

function modifier_neko_arc:GetModifierModelScale()

	return -10
	
end


function modifier_neko_arc:GetModifierBonusStats_Strength()

    return 100


	
end


function modifier_neko_arc:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()


if self.caster:HasModifier("modifier_archetype_earth") then
 self.skills_table = {
                            ["archetype_last_arc"] = "chibi_army",
							["chain_phantasm"] = "neko_punch",
							["moon_fall"] = "neko_jump",
							["archetype_light_collumn"] = "blood_combo",
							
                            
                        }
elseif self.caster:HasModifier("modifier_earth_princess_awakened") then
self.skills_table = {
                            ["archetype_earth"] = "chibi_army",
							["chain_phantasm"] = "neko_punch",
							["moon_fall"] = "neko_jump",
							
                            
                        }

else
    self.skills_table = {
                            ["red_arcueid"] = "chibi_army",
							["chain_phantasm"] = "neko_punch",
							["moon_fall"] = "neko_jump",
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/neko_arc.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

   
		
        
		
		
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end
function modifier_neko_arc:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_neko_arc:OnDestroy()
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
                local ability = self.parent:FindAbilityByName("red_arcueid_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end


modifier_earth = class({})


function modifier_earth:IsHidden()
    return true
end
function modifier_earth:RemoveOnDeath() return false end
function modifier_earth:IsPurgable()
    return false
end
function modifier_earth:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_earth:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_earth:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
    }

    return funcs
end

function modifier_earth:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_earth:GetModifierManaBonus()
    return self:GetAbility():GetSpecialValueFor('mana')
end

function modifier_earth:GetModifierBonusStats_Strength()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_earth:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_earth:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_earth:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
                     