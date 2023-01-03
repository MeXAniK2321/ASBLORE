modifier_horn_truth_invul = class({})
function modifier_horn_truth_invul:IsHidden() return false end
function modifier_horn_truth_invul:IsDebuff() return true end
function modifier_horn_truth_invul:IsPurgable() return false end
function modifier_horn_truth_invul:IsPurgeException() return false end
function modifier_horn_truth_invul:RemoveOnDeath() return true end
function modifier_horn_truth_invul:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_STUNNED] = true,
		
	}

	return state
end
function modifier_horn_truth_invul:OnCreated()
if IsServer() then
        --self:SetStackCount(0)
self.screw_fx = 	ParticleManager:CreateParticle("particles/unknown_truth_start.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetCaster())
								ParticleManager:SetParticleControlEnt(self.screw_fx, 0, self:GetCaster(), 5, "attach_left_foot", Vector(0,0,0), true)
								ParticleManager:SetParticleControlEnt(self.screw_fx, 1, self:GetCaster(), 5, "attach_left_foot", Vector(0,0,0), true)
       
    end
end
function modifier_horn_truth_invul:OnDestroy()
local caster = self:GetCaster()
if self.screw_fx then
	    ParticleManager:DestroyParticle(self.screw_fx, false)
	    ParticleManager:ReleaseParticleIndex(self.screw_fx)
	end
end


modifier_horn_truth = class({})
function modifier_horn_truth:IsHidden() return false end
function modifier_horn_truth:IsDebuff() return true end
function modifier_horn_truth:IsPurgable() return false end
function modifier_horn_truth:IsPurgeException() return false end
function modifier_horn_truth:RemoveOnDeath() return true end
function modifier_horn_truth:AllowIllusionDuplicate() return false end

function modifier_horn_truth:DeclareFunctions()
    local func = {  
	                MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE,
                     MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
                    MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
					MODIFIER_EVENT_ON_TAKEDAMAGE,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                    				}
    return func
end


function modifier_horn_truth:GetModifierSpellAmplify_PercentageUnique()
    return 10
end

function modifier_horn_truth:GetModifierPreAttack_BonusDamage()
    return 10
end


function modifier_horn_truth:GetModifierBonusStats_Strength()
    return 15
end

function modifier_horn_truth:GetModifierBonusStats_Agility()
    return 15
end

function modifier_horn_truth:GetModifierBonusStats_Intellect()
    return 15
end
function modifier_horn_truth:GetModifierIncomingDamage_Percentage( params )
	

		return -25
	end
function modifier_horn_truth:OnTakeDamage(params)
	if IsServer() then
	local caster = self:GetParent()
		if params.attacker == caster then
		if not params.attacker:IsIllusion() then
		if params.unit == caster then return end
		if not self:GetParent():HasModifier("modifier_horn_truth_cd") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_horn_truth_cd", {duration = 6 })
		 local knockback = { should_stun = 1,
                        knockback_duration = 2,
                        duration = 2,
                        knockback_distance = 0,
                        knockback_height = -180,
                        center_x = caster:GetAbsOrigin().x,
                        center_y = caster:GetAbsOrigin().y,
                        center_z = caster:GetAbsOrigin().z }

    params.unit:AddNewModifier(caster, self, "modifier_knockback", knockback)
	
	local point = params.unit:GetOrigin()
	local radius = 300
	local debuffDuration = 2
	self:PlayEffects( point, radius, debuffDuration )
	EmitSoundOn("star.horn_unknown_stun", caster)
			end
		end
	end
end
end

function modifier_horn_truth:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/unknown_truth_stun.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_horn_truth:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.ability_level = self.ability:GetLevel()

    self.bonus_movespeed = self.ability:GetSpecialValueFor("bonus_movespeed")
    self.projectile_avoid_chance = self.ability:GetSpecialValueFor("projectile_avoid_chance")
    self.turn_rate = self.ability:GetSpecialValueFor("turn_rate")
    self.awake_mana = self.ability:GetSpecialValueFor("awake_mana")

    
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/unknown_truth.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                    
        end

      
		
		
        EmitGlobalSound("star.horn_unknown")
		
		end
        
self:StartIntervalThink(0.5)
        self.parent:Purge(false, true, false, true, true)
    end

function modifier_horn_truth:OnIntervalThink()
	local caster = self:GetCaster()
	
	
        for i = 1, 10  do
			StopGlobalSound("star.buff_"..i)
		end
		  for i = 1, 10  do
			StopGlobalSound("star.theme3_"..i)
		end
		 for i = 1, 10  do
			StopGlobalSound("star.debuff_"..i)
		end
		 for i = 1, 2  do
			StopGlobalSound("star.event_"..i)
		end
	for i = 1, 8 do
			StopGlobalSound("star.horn_special_"..i)
			end
		for i = 1, 50 do
			StopGlobalSound("star.theme2_"..i)
		end
		for i = 1, 5 do
			StopGlobalSound("star.horn_"..i)
		end
		for i = 1, 50 do
			StopGlobalSound("star.theme_"..i)
		end
			StopGlobalSound("spamton.theme")
StopGlobalSound("spamton.neo_theme")
end

function modifier_horn_truth:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_horn_truth:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() then
           
            end
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

             StopGlobalSound("star.horn_unknown")

          
            end
        end
   
   
   modifier_horn_truth_cd = class({})
function modifier_horn_truth_cd:IsHidden() return false end
function modifier_horn_truth_cd:IsDebuff() return false end
function modifier_horn_truth_cd:IsPurgable() return false end
function modifier_horn_truth_cd:IsPurgeException() return false end
function modifier_horn_truth_cd:RemoveOnDeath() return true end