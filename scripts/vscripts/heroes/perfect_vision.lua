perfect_vision = class({})
LinkLuaModifier("modifier_perfect_vision","heroes/perfect_vision", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_perfect_vision_sight","heroes/perfect_vision", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_perfect_vision1","heroes/perfect_vision", LUA_MODIFIER_MOTION_NONE)


function perfect_vision:IsStealable() return true end
function perfect_vision:IsHiddenWhenStolen() return false end
function perfect_vision:IsLearned() return true end

function perfect_vision:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function perfect_vision:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level)
end
function perfect_vision:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local radius = self:GetSpecialValueFor("radius")

	caster:AddNewModifier(caster, self, "modifier_perfect_vision", {duration = duration})


		caster:AddNewModifier(caster, self, "modifier_truesight_aura", {duration = duration, radius = self:GetSpecialValueFor("radius")})
		local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- precache damage
	
	for _,enemy in pairs(enemies) do
	
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_perfect_vision1", -- modifier name
			{ duration = 3 } -- kv
		)
	end
	EmitSoundOn("perfect.vision", caster)
     
								
	end



---------------------------------------------------------------------------------------------------------------------
modifier_perfect_vision = class({})
function modifier_perfect_vision:IsHidden() return false end
function modifier_perfect_vision:IsDebuff() return false end
function modifier_perfect_vision:IsPurgable() return false end
function modifier_perfect_vision:IsPurgeException() return false end
function modifier_perfect_vision:RemoveOnDeath() return true end
function modifier_perfect_vision:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_perfect_vision:OnIntervalThink()
	if IsServer() then
		AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), FrameTime(), false)

		
		
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_perfect_vision_sight = class({})
function modifier_perfect_vision_sight:IsHidden() return false end
function modifier_perfect_vision_sight:IsDebuff() return true end
function modifier_perfect_vision_sight:IsPurgable() return false end
function modifier_perfect_vision_sight:IsPurgeException() return false end
function modifier_perfect_vision_sight:RemoveOnDeath() return true end
function modifier_perfect_vision_sight:CheckState()
	local state = {	[MODIFIER_STATE_INVISIBLE] = false,
					[MODIFIER_STATE_PROVIDES_VISION] = true,}
	return state
end
function modifier_perfect_vision_sight:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_perfect_vision_sight:GetEffectName()
	return "particles/ikki_perfect_vision_shockwave.vpcf"
end
function modifier_perfect_vision_sight:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
modifier_perfect_vision1 = class({})
function modifier_perfect_vision1:IsHidden() return false end
function modifier_perfect_vision1:IsDebuff() return true end
function modifier_perfect_vision1:IsPurgable() return true end
function modifier_perfect_vision1:IsPurgeException() return false end
function modifier_perfect_vision1:RemoveOnDeath() return true end
