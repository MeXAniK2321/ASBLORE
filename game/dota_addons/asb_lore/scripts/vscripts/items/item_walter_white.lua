item_walter_white = item_walter_white or class({})

function item_walter_white:GetIntrinsicModifierName()
    return "modifier_item_walter_white"
end
function item_walter_white:OnSpellStart()
    local hCaster = self:GetCaster()
    local hTarget = self:GetCursorTarget()

    hTarget:Purge(false, true, false, false, false)

    hTarget:AddNewModifier(hCaster, self, "modifier_item_walter_white_active", {duration = self:GetSpecialValueFor("active_duration")})

    local nCastPFX = ParticleManager:CreateParticle("particles/units/heroes/hero_alchemist/alchemist_berserk_potion_projectile_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
                     ParticleManager:SetParticleControl(nCastPFX, 3, hTarget:GetAbsOrigin() + Vector(0, 0, 128))
                     ParticleManager:ReleaseParticleIndex(nCastPFX)
end
	




LinkLuaModifier("modifier_item_walter_white", "items/item_walter_white", LUA_MODIFIER_MOTION_NONE)

modifier_item_walter_white = modifier_item_walter_white or class({})

function modifier_item_walter_white:IsHidden()                          return true end
function modifier_item_walter_white:RemoveOnDeath()                     return false end
function modifier_item_walter_white:IsPurgable()                        return false end
function modifier_item_walter_white:GetAttributes()                     return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_walter_white:DeclareFunctions()
    local tFunc =   {
                        MODIFIER_PROPERTY_HEALTH_BONUS,
                        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    }
    return tFunc
end
function modifier_item_walter_white:GetModifierHealthBonus(keys)
    return self.nBonusHP
end
function modifier_item_walter_white:GetModifierAttackSpeedBonus_Constant(keys)
    return self.nBonusAS
end
function modifier_item_walter_white:GetModifierMagicalResistanceBonus(keys)
    return self.nBonusMagicResist
end
function modifier_item_walter_white:OnCreated(table)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()

    self.nBonusHP = self.hAbility:GetSpecialValueFor("bonus_hp")
    self.nBonusAS = self.hAbility:GetSpecialValueFor("bonus_as")
    self.nBonusMagicResist = self.hAbility:GetSpecialValueFor("bonus_magic_resist")
end
function modifier_item_walter_white:OnRefresh(tTable)
    self:OnCreated(tTable)
end


LinkLuaModifier("modifier_item_walter_white_active", "items/item_walter_white", LUA_MODIFIER_MOTION_NONE)

modifier_item_walter_white_active = modifier_item_walter_white_active or class({})

function modifier_item_walter_white_active:IsHidden()                                   return false end
function modifier_item_walter_white_active:RemoveOnDeath()                              return true end
function modifier_item_walter_white_active:IsPurgable()                                 return true end
function modifier_item_walter_white_active:DeclareFunctions()
    local tFunc =   {
                        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
                    }
    return tFunc
end
function modifier_item_walter_white_active:GetModifierSpellAmplify_Percentage(keys)
    return self.nActiveSpellAmp
end
function modifier_item_walter_white_active:GetModifierPreAttack_BonusDamage(keys)
    return self.nActiveDamage
end
function modifier_item_walter_white_active:OnCreated(table)
    self.hCaster  = self:GetCaster()
    self.hParent  = self:GetParent()
    self.hAbility = self:GetAbility()

    self.nActiveSpellAmp = self.hAbility:GetSpecialValueFor("active_spell_amp")
    self.nActiveDamage   = self.hAbility:GetSpecialValueFor("active_damage")

    if IsServer() then
        self.sEmitSound = "item_walter_white_music"
        EmitSoundOn(self.sEmitSound, self.hParent)
    elseif not self.nParticlePFX then
        self.nParticlePFX = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_aurelian_weapon/alchemist_chemical_rage_aurelian.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.hParent)
                            ParticleManager:SetParticleControl(self.nParticlePFX, 60, Vector(0, 255, 0))
                            ParticleManager:SetParticleControl(self.nParticlePFX, 61, Vector(0, 255, 0))
                            ParticleManager:SetParticleControl(self.nParticlePFX, 62, Vector(0, 255, 0))

        self:AddParticle(self.nParticlePFX, false, false, -1, false, false)
    end
end
function modifier_item_walter_white_active:OnRefresh(tTable)
    self:OnCreated(tTable)
end
function modifier_item_walter_white_active:OnDestroy()
    if IsServer() and self.hParent then
        StopSoundOn(self.sEmitSound, self.hParent)
    end
end