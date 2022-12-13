modifier_horn_7 = class({})

function modifier_horn_7:IsHidden()
	return false
end
function modifier_horn_7:RemoveOnDeath() return true end
function modifier_horn_7:AllowIllusionDuplicate()
	return false
end

function modifier_horn_7:IsPurgable()
    return false
end
function modifier_horn_7:OnCreated(table)
local interval = 1
	local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
 local arcana = 137775440 --My
self:StartIntervalThink( interval )
self.parent = self:GetParent()
self.radius = 300
 if not self.particle_time then
if id32 == arcana then


            self.particle_time =    ParticleManager:CreateParticle("particles/fuck_u.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_kanade_wings", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
        

else


            self.particle_time =    ParticleManager:CreateParticle("particles/black_horn.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_kanade_wings", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
        end
		end
end


function modifier_horn_7:DeclareFunctions()
    local funcs = {
    MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
MODIFIER_EVENT_ON_TAKEDAMAGE,
MODIFIER_PROPERTY_MIN_HEALTH	  
		
    }

    return funcs
end
function modifier_horn_7:GetMinHealth()

	
 return 1

	end
function modifier_horn_7:GetModifierBonusStats_Strength()
    return 50
end

function modifier_horn_7:GetModifierBonusStats_Agility()
    return 50
end

function modifier_horn_7:GetModifierBonusStats_Intellect()
    return 50
end
function modifier_horn_7:OnTakeDamage(params)
	if IsServer() then
	local caster = self:GetParent()
	if not self:GetParent():HasModifier("modifier_death_cd") then
	if params.unit == caster then
		if self:GetParent():GetHealth() <= 20 then
					self:GetParent():SetHealth(1)
					self:GetParent():AddNewModifier(params.attacker, self:GetAbility(), "modifier_death_cd", {duration = 20 })
					local delay = 4

	Timers:CreateTimer(delay,function()
	
	self:Destroy()
						
	
	end)
	end
	
	
	else
		if params.attacker == caster then
		if not params.attacker:IsIllusion() then
		if not self:GetParent():HasModifier("modifier_horn_truth_cd") then
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_horn_truth_cd", {duration = 1.0 })
		local hp = self:GetParent():GetMaxHealth()
		local damage = 100
		local damageTable = {
		victim = params.unit,
		attacker = self:GetParent(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, 
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
	}
	ApplyDamage(damageTable)
	local point = params.unit:GetOrigin()
	local radius = 300
	local debuffDuration = 2
	self:PlayEffects( point, radius, debuffDuration )
	EmitSoundOn("horn.slash", caster)
			end
		end
	end
end
end
end
end

function modifier_horn_7:PlayEffects( point, radius, duration )
	-- Get Resources
	local particle_cast = "particles/crit_red.vpcf"


	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )


end
function modifier_horn_7:OnDestroy()
	for i = 1, 8 do
			StopGlobalSound("star.horn_special_"..i)
	
end
ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
end
function modifier_horn_7:GetTexture()
	return "note"
end
function modifier_horn_7:OnRemoved()
ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
end
function modifier_horn_7:GetEffectName()

	return self.particle
end


modifier_death_cd= class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_death_cd:IsHidden()
	return false
end

function modifier_death_cd:IsDebuff()
	return false
end
function modifier_death_cd:RemoveOnDeath() return true end
function modifier_death_cd:IsStunDebuff()
	return false
end

function modifier_death_cd:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_death_cd:OnCreated( kv )
	-- references
	local damage = 99999
	

	if not IsServer() then return end


	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( 0.2 )
	
end

function modifier_death_cd:OnRefresh( kv )
	-- references
	local damage = 999999
	

	if not IsServer() then return end

	-- update damage
	self.damageTable.damage = damage	
end

function modifier_death_cd:OnRemoved()
end

function modifier_death_cd:OnDestroy()
end

-- Interval Effects
function modifier_death_cd:OnIntervalThink()
if not self:GetParent():HasModifier("modifier_horn_7") then
	ApplyDamage( self.damageTable )
end
end
function modifier_death_cd:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end
--------------------------------------------------------------------------------
-- Graphics & Animations
