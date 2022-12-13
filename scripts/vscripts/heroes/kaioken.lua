LinkLuaModifier("modifier_kaioken", "heroes/kaioken", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_chichi", "heroes/kaioken.lua", LUA_MODIFIER_MOTION_NONE )

kaioken = class({})

function kaioken:GetIntrinsicModifierName()
    return "modifier_chichi"
end
function kaioken:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("ki_blast")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end



function kaioken:OnSpellStart()
    if not IsServer() then return end
    local caster = self:GetCaster()

    local duration = self:GetSpecialValueFor("duration") 
    caster:EmitSound("goku.2")
    caster:AddNewModifier(caster, self, "modifier_kaioken", { duration = duration } )
end

modifier_kaioken = class({})

function modifier_kaioken:IsPurgable()
    return true
end

function modifier_kaioken:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }

    return funcs
end
function modifier_kaioken:OnCreated( kv )
	local caster = self:GetParent()
	if IsASBPatreon(caster) then
	self:PlayEffects()
	end
end
function modifier_kaioken:PlayEffects( )
self.parent = self:GetParent()
	 if not self.particle_time2 then
            self.particle_time2 =    ParticleManager:CreateParticle("particles/supreme_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                   
        end
	
	
end
function modifier_kaioken:OnDestroy()
if self.particle_time2 then
		ParticleManager:DestroyParticle(self.particle_time2, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time2)
end
end
function modifier_kaioken:GetModifierMoveSpeedBonus_Percentage()
    return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end
function modifier_kaioken:GetModifierHealthRegenPercentage()
    return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") + self:GetCaster():FindTalentValue("special_bonus_goku_25")
end

function modifier_kaioken:GetEffectName()
    return "particles/kaioken.vpcf"
end

function modifier_kaioken:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_kaioken:StatusEffectPriority()
    return 5
end
modifier_chichi = class ({})
function modifier_chichi:IsHidden() return true end
function modifier_chichi:IsDebuff() return false end
function modifier_chichi:IsPurgable() return false end
function modifier_chichi:IsPurgeException() return false end
function modifier_chichi:RemoveOnDeath() return false end

function modifier_chichi:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_chichi:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_chichi:OnIntervalThink()
    if IsServer() then
        local angry_women = self:GetParent():FindAbilityByName("ki_blast")
        if angry_women and not angry_women:IsNull() then
            if self:GetParent():HasScepter() then
                if angry_women:IsHidden() then
                    angry_women:SetHidden(false)
                end
            else
                if not angry_women:IsHidden() then
                    angry_women:SetHidden(true)
                end
            end
        end
    end
end