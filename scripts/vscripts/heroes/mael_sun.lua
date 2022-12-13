LinkLuaModifier("modifier_mael_sun", "heroes/mael_sun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_escanor_weak", "heroes/mael_sun", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_escanor_weak_stop", "heroes/mael_sun", LUA_MODIFIER_MOTION_NONE)
mael_sun = class({})

function mael_sun:IsStealable() return true end
function mael_sun:IsHiddenWhenStolen() return false end
function mael_sun:GetIntrinsicModifierName()
    return "modifier_mael_sun"
end

function mael_sun:OnSpellStart()
    local caster = self:GetCaster()
    caster:AddNewModifier(caster, self, "modifier_escanor_weak_stop", {duration = 60})
	self:StartCooldown(self:GetCooldown(-1))
	local sound_cast = "escanor.2"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
---------------------------------------------------------------------------------------------------------------------
modifier_mael_sun = class({})
function modifier_mael_sun:IsHidden() return true end
function modifier_mael_sun:IsDebuff() return false end
function modifier_mael_sun:IsPurgable() return false end
function modifier_mael_sun:IsPurgeException() return false end
function modifier_mael_sun:RemoveOnDeath() return false end
function modifier_mael_sun:OnCreated(hTable)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()


        self:StartIntervalThink(FrameTime())
    end

function modifier_mael_sun:OnIntervalThink()
    if IsServer() then
	 if self:GetParent():HasModifier( "modifier_escanor_weak" ) then
       if self:GetParent():HasModifier( "modifier_escanor_weak_stop" ) then
	   self:GetParent():RemoveModifierByName("modifier_escanor_weak")
	   else
	   end
	   end
        if not GameRules:IsDaytime() then
		if self:GetParent():HasModifier( "modifier_escanor_weak_stop" ) then
		else
		if self:GetParent():HasModifier( "modifier_escanor_weak" ) then
		else
		self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_escanor_weak", -- modifier name
		{} -- kv
	)
     end
	 end
	 else
	 self:GetParent():RemoveModifierByName("modifier_escanor_weak")
	 
	 
	 end
	 end
	 end

modifier_escanor_weak = class({})
function modifier_escanor_weak:IsHidden() return false end
function modifier_escanor_weak:IsDebuff() return true end
function modifier_escanor_weak:IsPurgable() return false end
function modifier_escanor_weak:IsPurgeException() return false end
function modifier_escanor_weak:RemoveOnDeath() return true end
function modifier_escanor_weak:AllowIllusionDuplicate() return true end

function modifier_escanor_weak:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
	                MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, }
    return func
end


function modifier_escanor_weak:GetModifierModelChange()

    
	return "models/escanor/escanor_night.vmdl"

end

function modifier_escanor_weak:GetModifierPreAttack_BonusDamage()
    return -500
end
function modifier_escanor_weak:GetModifierBonusStats_Strength()
    return -200
end

function modifier_escanor_weak:GetModifierBonusStats_Agility()

    return -200
	
end


function modifier_escanor_weak:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    self.skills_table = {
                            ["super_slash"] = "escanor_fear",
							["escanor_sunshine"] = "escanor_bar",
							["cruel_sun"] = "dryahliy_udar",
						
							
                            
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
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

     
		     if IsServer() then
        local ability3 = self:GetParent():FindAbilityByName("exploding_dignity")
        if ability3:IsActivated() then
            ability3:SetActivated(false)
        end
    end
		
		
       
		
		end
        

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_escanor_weak:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_escanor_weak:OnDestroy()
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

            


	if IsServer() then
        local ability3 = self:GetParent():FindAbilityByName("exploding_dignity")
        if ability3 and not ability3:IsActivated() then
            ability3:SetActivated(true)
        end
    end
           
        end
    end
end
modifier_escanor_weak_stop = class({})
function modifier_escanor_weak_stop:IsHidden() return true end
function modifier_escanor_weak_stop:IsDebuff() return false end
function modifier_escanor_weak_stop:IsPurgable() return false end
function modifier_escanor_weak_stop:IsPurgeException() return false end
function modifier_escanor_weak_stop:RemoveOnDeath() return false end