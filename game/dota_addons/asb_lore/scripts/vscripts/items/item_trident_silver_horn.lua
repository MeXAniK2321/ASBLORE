LinkLuaModifier("modifier_trident_silver_horn", "items/item_trident_silver_horn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_trident_silver_horn_stat", "items/item_trident_silver_horn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silver_horn", "items/item_trident_silver_horn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
item_trident_silver_horn = class({})

function item_trident_silver_horn:GetIntrinsicModifierName()
    return "modifier_trident_silver_horn"
	end

function item_trident_silver_horn:OnSpellStart()
 local caster = self:GetCaster()
if not caster:HasModifier("modifier_tatsuya_seal_off") then
self:PlayEffects(600)
    caster:AddNewModifier(caster, self, "modifier_silver_horn", {duration = 25})
	-- if not _G.MusicBox:HasModifier("modifier_star_tier2") then
	-- if not _G.MusicBox:HasModifier("modifier_star_tier3") then
	-- if _G.MusicBox:HasModifier("modifier_star_tier1") then
	--  _G.MusicBox:RemoveModifierByName("modifier_star_tier1")
	-- end
	--_G.TicketTrack = "shiba.more_theme"
	-- _G.MusicBox:AddNewModifier(caster, self, "modifier_star_tier1", {duration = 25})
	-- end
	-- end
    end
	
	end
	function item_trident_silver_horn:PlayEffects( radius )
	local particle_cast = "particles/tatsuya_combo_flash.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end
modifier_silver_horn = class({})
function modifier_silver_horn:IsHidden() return false end
function modifier_silver_horn:IsDebuff() return true end
function modifier_silver_horn:IsPurgable() return false end
function modifier_silver_horn:IsPurgeException() return false end
function modifier_silver_horn:RemoveOnDeath() return true end
function modifier_silver_horn:AllowIllusionDuplicate() return true end

function modifier_silver_horn:DeclareFunctions()
    local func = {  
    				
					MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,					}
    return func
end

function modifier_silver_horn:GetModifierBonusStats_Intellect()

    return 100


	
end


function modifier_silver_horn:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.skills_table = {
                            ["tatsuya_seal_off"] = "deep_mist_disparsion",
						
							
                            
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
            self.particle_time =    ParticleManager:CreateParticle("particles/tatsuya_combo_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

   
		
        
		
		
        

        self.parent:Purge(false, true, false, true, true)
    end
end
end

function modifier_silver_horn:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_silver_horn:OnDestroy()
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


           
        end
    end
end

modifier_trident_silver_horn = class({})


function modifier_trident_silver_horn:IsHidden()
    return true
end
function modifier_trident_silver_horn:RemoveOnDeath() return false end
function modifier_trident_silver_horn:IsPurgable()
    return false
end
function modifier_trident_silver_horn:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_trident_silver_horn:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_trident_silver_horn:DeclareFunctions()
    local funcs = {
       MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }

    return funcs
end

function modifier_trident_silver_horn:GetModifierBaseAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_trident_silver_horn:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_trident_silver_horn:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end