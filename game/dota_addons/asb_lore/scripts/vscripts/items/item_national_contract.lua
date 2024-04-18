LinkLuaModifier("modifier_national_contract", "items/item_national_contract", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_national_contract_stat", "items/item_national_contract", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_national_gachi_man", "items/item_national_contract", LUA_MODIFIER_MOTION_NONE)

item_national_contract = item_national_contract or class({})

function item_national_contract:GetIntrinsicModifierName()
    return "modifier_national_contract"
end
function item_national_contract:OnSpellStart()
    if not IsServer() then return end
    
    local hCaster 	= self:GetCaster()
    local vSpawnPos = hCaster:GetOrigin() + hCaster:GetForwardVector() * 150

    if IsNotNull(hCaster) then
        local hUnit = CreateUnitByName("npc_dota_makima_gachi", vSpawnPos, true, hCaster, hCaster, hCaster:GetTeamNumber())
        if IsNotNull(hUnit) then
            hUnit:AddNewModifier(hCaster, self, "modifier_national_gachi_man", {duration = 20.0})
            hUnit:AddNewModifier(hCaster, self, "modifier_kill", {duration = 20.0}) -- For timer icon only
            
            hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
            --===========================--
            hUnit:SetMaximumGoldBounty(0)
            hUnit:SetMinimumGoldBounty(0)
            hUnit:SetDeathXP(0)
            hUnit:SetAbilityPoints(0) 
            hUnit:SetHasInventory(false)
            hUnit:SetCanSellItems(false)
            --===========================--
            local iRandomNum = RandomInt(2, 3)
            EmitSoundOn("billy." .. iRandomNum, hUnit)
        end
    else
        return error("Makima Contract: Could not create unit because Player Unit does not exist !")
    end
end


modifier_national_contract = modifier_national_contract or class({})

function modifier_national_contract:IsHidden() return true end
function modifier_national_contract:RemoveOnDeath() return false end
function modifier_national_contract:IsPurgable() return false end
function modifier_national_contract:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_national_contract:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_national_contract:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('bonus_hp')
end
function modifier_national_contract:GetModifierBonusStats_Intellect()
    return self:GetAbility():GetSpecialValueFor('all_stats')
end
function modifier_national_contract:GetModifierSpellAmplify_Percentage()
return self:GetAbility():GetSpecialValueFor('amp')
end
function modifier_national_contract:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	if IsServer() then
		self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
	end
end






modifier_national_gachi_man = modifier_national_gachi_man or class({})

function modifier_national_gachi_man:IsHidden() return false end
function modifier_national_gachi_man:RemoveOnDeath() return true end
function modifier_national_gachi_man:IsPurgable() return false end
function modifier_national_gachi_man:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end
function modifier_national_gachi_man:DeclareFunctions()
    local funcs = {
                     MODIFIER_PROPERTY_SUPER_ILLUSION, 
                     MODIFIER_PROPERTY_ILLUSION_LABEL, 
                     MODIFIER_PROPERTY_IS_ILLUSION,
                     MODIFIER_PROPERTY_TEMPEST_DOUBLE,
                     MODIFIER_EVENT_ON_TAKEDAMAGE,
                  }

    return funcs
end
function modifier_national_gachi_man:GetModifierSuperIllusion()
    return true
end
function modifier_national_gachi_man:GetModifierIllusionLabel()
    return true
end
function modifier_national_gachi_man:GetIsIllusion()
    return true
end
function modifier_national_gachi_man:GetModifierTempestDouble()
    return true
end
function modifier_national_gachi_man:GetEffectName()
    return "particles/generic_buff_11.vpcf"
end
function modifier_national_gachi_man:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_national_gachi_man:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsServer() then
        if not IsNotNull(self.caster) or not IsNotNull(self.parent) then 
            self:Destroy() 
            return 
        end
        
        for iAbility = 0, self.parent:GetAbilityCount() - 1 do
            local hAbility = self.parent:GetAbilityByIndex(iAbility)
            if IsNotNull(hAbility) and hAbility:CanAbilityBeUpgraded() and hAbility:GetLevel() <= hAbility:GetMaxLevel() then
                hAbility:SetLevel(hAbility:GetMaxLevel())
            end
        end
    else
        self.iBuffParticle = ParticleManager:CreateParticle("particles/black_march.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
        self:AddParticle(self.iBuffParticle, false, false, -1, false, false)
        --==========================================--
        self:SetStackCount(math.ceil(tonumber(hTable.duration)) or 20)
        self.iStacks = self:GetStackCount()
        --==========================================--
        self:StartIntervalThink(1.0)
    end
end
function modifier_national_gachi_man:OnIntervalThink()
    self.iStacks = self.iStacks - 1
    
    self:SetStackCount(self.iStacks)
end
function modifier_national_gachi_man:OnTakeDamage(keys)
    if not keys.unit:IsAlive() and keys.unit:HasModifier("modifier_national_gachi_man") then
        keys.unit:MakeIllusion()
    end
end
function modifier_national_gachi_man:OnDestroy()
    if IsServer() then
        if IsNotNull(self.parent) and self.parent ~= self.caster then
            EmitSoundOn("anime_chatwheel_non_sorted_9_1", self.parent)
            UTIL_Remove(self.parent)
        end
    end
end



                  