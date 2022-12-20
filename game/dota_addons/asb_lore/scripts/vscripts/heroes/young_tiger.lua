young_tiger = class({})
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
function young_tiger:IsStealable() return true end
function young_tiger:IsHiddenWhenStolen() return false end
LinkLuaModifier("modifier_young_tiger", "heroes/young_tiger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_young_tiger_cd", "heroes/young_tiger", LUA_MODIFIER_MOTION_NONE)

function young_tiger:GetChannelTime()
	return self:GetSpecialValueFor("duration")
end
function young_tiger:OnSpellStart()
	local caster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	

	if hTarget and not hTarget:IsNull() and hTarget:TriggerSpellAbsorb(self) then
		caster:Interrupt()
		
		return nil
	end
	caster:AddNewModifier(caster, self, "modifier_young_tiger", {duration = 25})
	

	self.target = hTarget

	self.range 			= self:GetCastRange(caster:GetAbsOrigin(), caster) + 150--self:GetSpecialValueFor("range")
	self.slashes 		= self:GetSpecialValueFor("slashes") 
	self.stun_duration 	= self:GetSpecialValueFor("stun_duration")
	self.damage_pct 	= self:GetSpecialValueFor("damage_pct") 
	

	self.interval 		 = self:GetChannelTime() / (self.slashes or 1)
	self.channeling_time = self.interval - FrameTime()

	EmitSoundOn("", caster)
end
function young_tiger:OnChannelThink(flInterval)
	local caster = self:GetCaster()

	self.channeling_time = self.channeling_time + flInterval

	local UFilter = UnitFilter( self.target,
	                          	self:GetAbilityTargetTeam(),
	                        	self:GetAbilityTargetType(),
	                         	self:GetAbilityTargetFlags() + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
	                         	caster:GetTeamNumber() )

	if UFilter ~= UF_SUCCESS or self.target:IsNull() then
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
function young_tiger:OnChannelFinish(bInterrupted)

end
modifier_young_tiger = class({})
function modifier_young_tiger:IsHidden() return false end
function modifier_young_tiger:IsDebuff() return false end
function modifier_young_tiger:IsPurgable() return false end
function modifier_young_tiger:IsPurgeException() return false end
function modifier_young_tiger:RemoveOnDeath() return true end
function modifier_young_tiger:DeclareFunctions()                
    local func = {  MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                                                                      	}
    return func
end   
function modifier_young_tiger:GetModifierBaseDamageOutgoing_Percentage()
    return 125
end
function modifier_young_tiger:GetModifierAttackSpeedBonus_Constant()
    return 60
end
function modifier_young_tiger:OnCreated()
self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	
	if IsServer() then
        local ability = self:GetParent():FindAbilityByName("gods_arrival")
        if ability:IsActivated() then
            ability:SetActivated(false)
        end
    end
	EmitGlobalSound("star.theme2_17")
	
	self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
	
   
	if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/young_tiger.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "ikki2", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
        end
		end
	end
	function modifier_young_tiger:OnDestroy()
	self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	if IsServer() then
        local ability = self:GetParent():FindAbilityByName("gods_arrival")
        if ability and not ability:IsActivated() then
            ability:SetActivated(true)
        end
    end
	StopGlobalSound("star.theme2_17")
	self.ability:EndCooldown()
	self.ability:StartCooldown(110)

	self.caster:AddNewModifier(
			self.caster, -- player source
			self.ability, -- ability source
			"modifier_young_tiger_cd", -- modifier name
			{ duration = 110 } -- kv
		)
	
	ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)
	end
	
modifier_young_tiger_cd = class({})
function modifier_young_tiger_cd:IsHidden() return false end
function modifier_young_tiger_cd:IsDebuff() return false end
function modifier_young_tiger_cd:IsPurgable() return false end
function modifier_young_tiger_cd:IsPurgeException() return false end
function modifier_young_tiger_cd:RemoveOnDeath() return false end

function modifier_young_tiger_cd:GetAbilityTextureName()
	
	return "jin_mori_3_1"
end