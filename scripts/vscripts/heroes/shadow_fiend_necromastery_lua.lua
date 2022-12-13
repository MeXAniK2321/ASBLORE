shadow_fiend_necromastery_lua = class({})
LinkLuaModifier( "modifier_shadow_fiend_necromastery_lua", "modifiers/modifier_shadow_fiend_necromastery_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rumia_awake", "heroes/shadow_fiend_necromastery_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rumia_pre_awaken", "heroes/shadow_fiend_necromastery_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function shadow_fiend_necromastery_lua:GetIntrinsicModifierName()
	return "modifier_shadow_fiend_necromastery_lua"
end
modifier_rumia_pre_awaken = class({})
function modifier_rumia_pre_awaken:IsHidden() return false end
function modifier_rumia_pre_awaken:IsDebuff() return true end
function modifier_rumia_pre_awaken:IsPurgable() return false end
function modifier_rumia_pre_awaken:IsPurgeException() return false end
function modifier_rumia_pre_awaken:RemoveOnDeath() return false end
function modifier_rumia_pre_awaken:AllowIllusionDuplicate() return true end

function modifier_rumia_pre_awaken:DeclareFunctions()
    local funcs = {
       
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
 
    }

    return funcs
end
function modifier_rumia_pre_awaken:GetModifierPreAttack_BonusDamage()
    return 75
end

modifier_rumia_awake = class({})
function modifier_rumia_awake:IsHidden() return false end
function modifier_rumia_awake:IsDebuff() return true end
function modifier_rumia_awake:IsPurgable() return false end
function modifier_rumia_awake:IsPurgeException() return false end
function modifier_rumia_awake:RemoveOnDeath() return false end
function modifier_rumia_awake:AllowIllusionDuplicate() return true end
function modifier_rumia_awake:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
					MODIFIER_PROPERTY_MODEL_CHANGE,
					MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
					MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	                				}
    return func
end

function modifier_rumia_awake:GetModifierModelScale()

	return 50
	
end
function modifier_rumia_awake:GetAttackSound()
	return "rumia.ex_attack"
end
function modifier_rumia_awake:GetModifierModelChange()

    
	return "models/rumia_ex/rumia_ex.vmdl"

end
function modifier_rumia_awake:GetModifierAttackRangeBonus()
	return -375
end
function modifier_rumia_awake:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	self.parent:SetAttackCapability( DOTA_UNIT_CAP_MELEE_ATTACK )

    self.ability_level = self.ability:GetLevel()

    self.skills_table = {
                            ["rumia_energy_blast"] = "rumia_guilty",
                            ["night_sign_night_bird"] = "rumia_step_of_darkness",
							["shadow_fiend_necromastery_lua"] = "rumia_ex_slash",							
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
           local delay = 0.2

	Timers:CreateTimer(delay,function()
        self:PlayEffects()
self:PlayEffects2()
self:PlayEffects3()
end)
end
end
function modifier_rumia_awake:PlayEffects()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/rumia_black_sword_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "rumia_sword", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Emit sound
	
end
function modifier_rumia_awake:PlayEffects2()
		-- Get Resources
	
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/rumia_black_sword_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "rumia_sword2", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Emit sound
	
end
function modifier_rumia_awake:PlayEffects3()
		-- Get Resources

	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle("particles/rumia_black_sword_sfx.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent())
                                    ParticleManager:SetParticleControlEnt(effect_cast, 0, self.parent, PATTACH_POINT_FOLLOW, "rumia_sword3", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(effect_cast, 1, Vector(self.radius, self.radius, self.radius))

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Emit sound
	
end
function modifier_rumia_awakeOnRefresh(table)
    self:OnCreated(table)
end

