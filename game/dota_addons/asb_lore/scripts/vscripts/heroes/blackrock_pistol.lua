blackrock_pistol = class({})
LinkLuaModifier("modifier_blackrock_pistol_slow", "heroes/blackrockpistol", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_blue_glue", "heroes/blackrock_pistol", LUA_MODIFIER_MOTION_NONE )

function blackrock_pistol:GetIntrinsicModifierName()
    return "modifier_blue_glue"
end


function blackrock_pistol:IsStealable() return true end
function blackrock_pistol:IsHiddenWhenStolen() return false end
function blackrock_pistol:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function blackrock_pistol:OnAbilityPhaseStart()
	
	return true
end
function blackrock_pistol:OnAbilityPhaseInterrupted()
	
end
function blackrock_pistol:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	EmitSoundOn("Pistol.shoot", caster)

	local projectile = {Target = target,
						Source = caster,
						Ability = self,
						EffectName = "particles/brs_pistol_shot_new.vpcf",
						iMoveSpeed = self:GetSpecialValueFor("speed"),
						bDodgeable = true,
						bVisibleToEnemies = true,
						bReplaceExisting = false,
						bProvidesVision = false }

	ProjectileManager:CreateTrackingProjectile(projectile)
end
function blackrock_pistol:OnProjectileHit(hTarget, vLocation)
	if not hTarget then
		return nil
	end

	if hTarget:IsMagicImmune() then
		return nil
	end
	
	if hTarget:TriggerSpellAbsorb(self) then
		return nil
	end

	

	if self:GetCaster() then
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self:GetSpecialValueFor("duration")+self:GetCaster():FindTalentValue("special_bonus_brs_25")})
		end
	

	local damage_table = {	victim = hTarget,
							attacker = self:GetCaster(),
							damage = self:GetSpecialValueFor("damage"),
							damage_type = self:GetAbilityDamageType(),
							ability = self }

	ApplyDamage(damage_table)
end
---------------------------------------------------------------------------------------------------------------------
modifier_blackrock_pistol_slow = class({})
function modifier_blackrock_pistol_slow:IsHidden() return false end
function modifier_blackrock_pistol_slow:IsDebuff() return true end
function modifier_blackrock_pistol_slow:IsPurgable() return true end
function modifier_blackrock_pistol_slow:IsPurgeException() return true end
function modifier_blackrock_pistol_slow:RemoveOnDeath() return true end
function modifier_blackrock_pistol_slow:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,}
	return func
end
function modifier_blackrock_pistol_slow:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("slow")
end
function modifier_blackrock_pistol_slow:GetEffectName()
	return ""
end
function modifier_blackrock_pistol_slow:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
modifier_blue_glue = class ({})
function modifier_blue_glue:IsHidden() return true end
function modifier_blue_glue:IsDebuff() return false end
function modifier_blue_glue:IsPurgable() return false end
function modifier_blue_glue:IsPurgeException() return false end
function modifier_blue_glue:RemoveOnDeath() return false end

function modifier_blue_glue:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_blue_glue:OnRefresh()
    if IsServer() then
       
    end
end

function modifier_blue_glue:OnIntervalThink()
    if IsServer() then
        local blue_girl = self:GetParent():FindAbilityByName("brs_skattershot")
        if blue_girl and not blue_girl:IsNull() then
            if self:GetParent():HasScepter() then
                if blue_girl:IsHidden() then
                    blue_girl:SetHidden(false)
                end
            else
                if not blue_girl:IsHidden() then
                    blue_girl:SetHidden(true)
                end
            end
        end
    end
end