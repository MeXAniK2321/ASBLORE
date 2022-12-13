triple_kick = class({})

function triple_kick:IsStealable() return true end
function triple_kick:IsHiddenWhenStolen() return false end
LinkLuaModifier("modifier_damage", "heroes/triple_kick", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_damage2", "heroes/triple_kick", LUA_MODIFIER_MOTION_NONE)
function triple_kick:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("young_tiger")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function triple_kick:GetChannelTime()
	return self:GetSpecialValueFor("duration")
end
function triple_kick:OnSpellStart()
	local caster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	

	if hTarget and not hTarget:IsNull() and hTarget:TriggerSpellAbsorb(self) then
		caster:Interrupt()
		
		return nil
	end
	if self:GetCaster():HasModifier("modifier_hidden_move") then
	caster:AddNewModifier(caster, self, "modifier_damage2", {duration = 5})
	else
	end
	caster:AddNewModifier(caster, self, "modifier_damage", {duration = 1})

	self.target = hTarget

	self.range 			= self:GetCastRange(caster:GetAbsOrigin(), caster) + 150--self:GetSpecialValueFor("range")
	self.slashes 		= self:GetSpecialValueFor("slashes") 
	self.stun_duration 	= self:GetSpecialValueFor("stun_duration")
	self.damage_pct 	= self:GetSpecialValueFor("damage_pct") 
	

	self.interval 		 = self:GetChannelTime() / (self.slashes or 1)
	self.channeling_time = self.interval - FrameTime()

	EmitSoundOn("mori.3", caster)
end
function triple_kick:OnChannelThink(flInterval)
	local caster = self:GetCaster()

	self.channeling_time = self.channeling_time + flInterval

	local UFilter = UnitFilter( self.target,
	                          	self:GetAbilityTargetTeam(),
	                        	self:GetAbilityTargetType(),
	                         	self:GetAbilityTargetFlags() + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
	                         	caster:GetTeamNumber() )

	if UFilter ~= UF_SUCCESS or self.target:IsNull()  then
		caster:Interrupt()

		return nil
	end

	if self.channeling_time >= self.interval then
		self.channeling_time = 0

		local damage = caster:GetAverageTrueAttackDamage(self.target) * 0.01 * self.damage_pct

		

		self.target:AddNewModifier(caster, self, "modifier_stunned", {duration = self.stun_duration})

		caster:PerformAttack(self.target, true,
				true,
				true,
				true,
				true,
				false,
				true)
	end
end
function triple_kick:OnChannelFinish(bInterrupted)

end
modifier_damage = class({})
function modifier_damage:IsHidden() return true end
function modifier_damage:IsDebuff() return false end
function modifier_damage:IsPurgable() return false end
function modifier_damage:IsPurgeException() return false end
function modifier_damage:RemoveOnDeath() return false end
function modifier_damage:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,
	                MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE  
                                                                      	}
    return func
end
function modifier_damage:GetModifierProcAttack_BonusDamage_Physical()
     local kick = self:GetAbility():GetSpecialValueFor('damage_pct') 
	return kick
	end
	function modifier_damage:GetModifierPreAttack_BonusDamage()
     local kick2 = self:GetAbility():GetSpecialValueFor('damage_pct2') 
	return kick2
	end
	
	modifier_damage2 = class({})
function modifier_damage2:IsHidden() return true end
function modifier_damage2:IsDebuff() return false end
function modifier_damage2:IsPurgable() return false end
function modifier_damage2:IsPurgeException() return false end
function modifier_damage2:RemoveOnDeath() return false end
function modifier_damage2:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    

    self.skills_table = {
                            ["triple_kick"] = "young_tiger",
                            
                        }


    if IsServer() then
        for k, v in pairs(self.skills_table) do
            if k and v then
                self.parent:SwapAbilities(k, v, false, true)
                --k:SetHidden(true)
                --v:SetHidden(false)

                local ability = self.parent:FindAbilityByName(v)
                if ability and not ability:IsNull() and ability:IsTrained() and ability:GetCooldown(-1) > 0 then
                    
                   
                end
            end
        end
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
       

        
		
       

        
    end
end

function modifier_damage2:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_damage2:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
            for k, v in pairs(self.skills_table) do
                if k and v then
                    self.parent:SwapAbilities(k, v, true, false)
                    --k:SetHidden(false)
                    --v:SetHidden(true)
                end
            end
			

           

            if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
                local ability = self.parent:FindAbilityByName("damage_awake")
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
        end
    end
end	