LinkLuaModifier("modifier_item_six_eyes", "items/item_gojo_six_eyes", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_six_eyes_active", "items/item_gojo_six_eyes", LUA_MODIFIER_MOTION_NONE)

item_gojo_six_eyes = item_gojo_six_eyes or class({})

function item_gojo_six_eyes:GetIntrinsicModifierName()
    return "modifier_item_six_eyes"
end
function item_gojo_six_eyes:CastFilterResult()
    if IsServer() then
	    local hCaster         = self:GetCaster()
	    local iTotalKills     = hCaster:GetKills() or 0
        local iRequired       = self:GetSpecialValueFor("required")

        return ( iTotalKills >= iRequired and not hCaster:HasModifier("modifier_item_six_eyes_active") )
               and UF_SUCCESS
               or UF_FAIL_CUSTOM
    end
end
function item_gojo_six_eyes:GetCustomCastError()
	return "#gojo_six_eyes_cast_error"
end
function item_gojo_six_eyes:OnSpellStart()
	local hCaster 	= self:GetCaster()
	--local fDuration = 100

    hCaster:AddNewModifier(hCaster, self, "modifier_item_six_eyes_active", {})
end


modifier_item_six_eyes = modifier_item_six_eyes or class({})

function modifier_item_six_eyes:IsHidden()return true end
function modifier_item_six_eyes:RemoveOnDeath() return false end
function modifier_item_six_eyes:IsPurgable() return false end
function modifier_item_six_eyes:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_six_eyes:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_HEALTH_BONUS,
                      MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                      MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                      MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                      MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                  }

    return funcs
end
function modifier_item_six_eyes:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    self.iBonusDmg      = self.ability:GetSpecialValueFor("bonus_attk_damage")
    self.iBonusHealth   = self.ability:GetSpecialValueFor("bonus_health")
    self.iBonusAllStats = self.ability:GetSpecialValueFor("bonus_allstats")
    self.iBonusSpellAmp = self.ability:GetSpecialValueFor("bonus_spell_amp")
    
    if IsServer() then
        self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
    end
end
function modifier_item_six_eyes:GetModifierPreAttack_BonusDamage()
    return self.iBonusDmg
end
function modifier_item_six_eyes:GetModifierHealthBonus()
    return self.iBonusHealth
end
function modifier_item_six_eyes:GetModifierBonusStats_Strength()
    return self.iBonusAllStats
end
function modifier_item_six_eyes:GetModifierBonusStats_Agility()
    return self.iBonusAllStats
end
function modifier_item_six_eyes:GetModifierBonusStats_Intellect()
    return self.iBonusAllStats
end
function modifier_item_six_eyes:GetModifierSpellAmplify_Percentage()
    return self.iBonusSpellAmp
end


---------------------------------------------------------------------------------------------------------------
-- Gojo Six Eyes Active Modifier
---------------------------------------------------------------------------------------------------------------
modifier_item_six_eyes_active = modifier_item_six_eyes_active or class({})

function modifier_item_six_eyes_active:IsHidden() return false end
function modifier_item_six_eyes_active:RemoveOnDeath() return true end
function modifier_item_six_eyes_active:IsDebuff() return false end
function modifier_item_six_eyes_active:IsPurgable() return false end
function modifier_item_six_eyes_active:CheckState()
    local func = {
                     [MODIFIER_STATE_INVULNERABLE] = true,
                     [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
                     [MODIFIER_STATE_STUNNED] = true,
                     [MODIFIER_STATE_NO_HEALTH_BAR] = true,
                 }
    return not self.bIsActive and func
end
function modifier_item_six_eyes_active:OnCreated(hTable)
    self.caster  = self:GetCaster()
    self.parent  = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsServer() then
        if not IsNotNull(self.parent) then self:Destroy() return end
        
        self.ability:EndCooldown()
        self.parent:StartGesture(ACT_DOTA_TINKER_REARM2)
        EmitGlobalSound("Gojo.six_eyes")
        self.parent:SetBodygroupByName("eye_area", 1)
        
        self.hDomainAbility = self.parent:FindAbilityByName("goju_domain_expansion")
        if IsNotNull(self.hDomainAbility) then
            self.hDomainAbility:SetActivated(true)
        end
        
        local particle_cast = "particles/heroes/anime_hero_gojo/dimension/six_eyes_buff.vpcf"

        -- Create Particle
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            1,
            self:GetParent(),
            PATTACH_POINT_FOLLOW,
            "ATTACH_EYEOFLIE1",
            Vector(0,0,0), -- unknown
            true -- unknown, true
        )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            2,
            self:GetParent(),
            PATTACH_POINT_FOLLOW,
            "ATTACH_EYEOFLIE2",
            Vector(0,0,0), -- unknown
            true -- unknown, true
        )

        -- buff particle
        self:AddParticle(
            effect_cast,
            false, -- bDestroyImmediately
            false, -- bStatusEffect
            -1, -- iPriority
            false, -- bHeroEffect
            false -- bOverheadEffect
        )
        
        self:StartIntervalThink(1.0)
    end
end
function modifier_item_six_eyes_active:OnIntervalThink()
    self.bIsActive = true
    self:StartIntervalThink(-1)
end
function modifier_item_six_eyes_active:OnDestroy()
    self.bIsActive = false
    if IsServer() then
        self.parent:SetBodygroupByName("eye_area", 0)
        self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
        if IsNotNull(self.hDomainAbility) then
            self.hDomainAbility:SetActivated(false)
        end
    end
end
                 