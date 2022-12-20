LinkLuaModifier("modifier_index_chan", "items/item_index_chan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_index_chan_stat", "items/item_index_chan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_touma_gender_equality_combo_true", "items/item_index_chan", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_touma_gender_equality_combo_true_check", "items/item_index_chan", LUA_MODIFIER_MOTION_NONE)

item_index_chan = class({})

function item_index_chan:GetIntrinsicModifierName()
    return "modifier_index_chan"
	end

function item_index_chan:OnSpellStart()
 local caster = self:GetCaster()
if not caster:HasModifier("modifier_touma_arm_loss") and caster:HasModifier("modifier_item_aghanims_shard") then
    caster:AddNewModifier(caster, self, "modifier_touma_gender_equality_combo_true", {duration = 10})
	caster:AddNewModifier(caster, self, "modifier_touma_gender_equality_combo_true_check", {duration = 30})
	EmitSoundOn("touma.gender_rech", caster)
	EmitSoundOn("touma.gender_theme", caster)
	end
	end
	
	modifier_touma_gender_equality_combo_true = class({})


function modifier_touma_gender_equality_combo_true:IsHidden()
    return true
end
function modifier_touma_gender_equality_combo_true:RemoveOnDeath() return false end
function modifier_touma_gender_equality_combo_true:IsPurgable()
    return false
end
function modifier_touma_gender_equality_combo_true:OnCreated()
 self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
      self.skills_table = {
                            ["touma_gender_equality_combo"] = "touma_true_gender_equality_combo",
							
                            
                        }
						
					
					
	
 

    if IsServer() then
	self.ability:StartCooldown(3)
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

            end
        end
	end
end
function modifier_touma_gender_equality_combo_true:OnDestroy()
    	StopSoundOn( "touma.gender_rech", self:GetCaster() )
	StopSoundOn( "touma.gender_theme", self:GetCaster() )
	 if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			end
			end
end
-----------------------


	modifier_touma_gender_equality_combo_true_check = class({})


function modifier_touma_gender_equality_combo_true_check:IsHidden()
    return true
end
function modifier_touma_gender_equality_combo_true_check:RemoveOnDeath() return false end
function modifier_touma_gender_equality_combo_true_check:IsPurgable()
    return false
end

modifier_index_chan = class({})


function modifier_index_chan:IsHidden()
    return true
end
function modifier_index_chan:RemoveOnDeath() return false end
function modifier_index_chan:IsPurgable()
    return false
end
function modifier_index_chan:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end

function modifier_index_chan:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_index_chan:DeclareFunctions()
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

function modifier_index_chan:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('attack')
end

function modifier_index_chan:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end

function modifier_index_chan:GetModifierHealthBonus()
return self:GetAbility():GetSpecialValueFor('health')
end
                     