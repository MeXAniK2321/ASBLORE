LinkLuaModifier("nanaya_blood_modifier", "abilities/nanaya/nanaya_blood", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("nanaya_blood_modifier_animemode", "abilities/nanaya/nanaya_blood", LUA_MODIFIER_MOTION_NONE)


nanaya_blood = class ({})

function nanaya_blood:Spawn()
	if IsServer() then
	self:SetLevel(1)
end
end



function nanaya_blood:GetIntrinsicModifierName()
    return "nanaya_blood_modifier"
end	

nanaya_blood_modifier = class ({})
--[[function nanaya_blood_modifier:DeclareFunctions()
    return { MODIFIER_EVENT_ON_MANA_GAINED ,
	}
end]]

function nanaya_blood_modifier:IsHidden() return false end
function nanaya_blood_modifier:IsDebuff() return false end

function nanaya_blood_modifier:DeclareFunctions()
    local func = {  MODIFIER_EVENT_ON_TAKEDAMAGE, 
                    MODIFIER_PROPERTY_STATS_AGILITY_BONUS }
    return func
end

function nanaya_blood_modifier:GetModifierBonusStats_Agility()
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function nanaya_blood_modifier:OnCreated()
	self.parent = self:GetParent()
	self:SetStackCount(0)
end


function nanaya_blood_modifier:GetMaxStackCount()
	return self:GetAbility():GetSpecialValueFor("stack_max")
end

	function nanaya_blood_modifier:OnTakeDamage(keys)
		if IsServer() then
			if keys.attacker == self.parent and keys.unit and keys.unit:GetTeamNumber() ~= self.parent:GetTeamNumber() and not keys.unit:IsBuilding() then
				local stacks = self:GetStackCount()
				if self.nanaya ~= nil then 
				ParticleManager:DestroyParticle(self.nanaya, true)
	--ParticleManager:ReleaseParticleIndex(nanaya)
				end
				Timers:RemoveTimer("nanaya")
				if(stacks < self:GetMaxStackCount()) then
					self:SetStackCount(stacks+1)
				end
				self.nanaya = ParticleManager:CreateParticle("particles/nanaya_blood2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
				Timers:CreateTimer("nanaya", {
					endTime = 6, 
					callback = function()
						self:SetStackCount(0)
						if self.parent:HasModifier("nanaya_blood_modifier_animemode") then self.parent:RemoveModifierByName("nanaya_blood_modifier_animemode") end
					end})
			end			
		end
	end	
	
nanaya_blood_modifier_animemode = class ({})

function nanaya_blood_modifier_animemode:IsHidden() return false end
function nanaya_blood_modifier_animemode:IsDebuff() return false end

function nanaya_blood_modifier_animemode:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		}
		return func
end


--[[function nanaya_blood_modifier_animemode:GetEffectName()
    return "particles/nanaya_eyes_main.vpcf"
end


function nanaya_blood_modifier_animemode:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end]]

function nanaya_blood_modifier_animemode:OnCreated()
	self.parent = self:GetParent()
	self.nanaya_right_eye = ParticleManager:CreateParticle("particles/nanaya_eyes.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
ParticleManager:SetParticleControlEnt(self.nanaya_right_eye, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_right_eye", self.parent:GetAbsOrigin(), true)

    self.nanaya_left_eye = ParticleManager:CreateParticle("particles/nanaya_eyes.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(self.nanaya_left_eye, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_left_eye", self.parent:GetAbsOrigin(), true)
	--print (self.nanaya_right_eye)
	
end

function nanaya_blood_modifier_animemode:GetModifierMoveSpeed_Absolute()
    return 600
end

function nanaya_blood_modifier_animemode:OnRemoved()
	--print (self.nanaya_right_eye)
	ParticleManager:DestroyParticle(self.nanaya_left_eye, false)
	ParticleManager:ReleaseParticleIndex(self.nanaya_left_eye)
	ParticleManager:DestroyParticle(self.nanaya_right_eye, false)
	ParticleManager:ReleaseParticleIndex(self.nanaya_right_eye)

end
		