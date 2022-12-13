shinichi_hear = class({})
LinkLuaModifier("modifier_shinichi_hear","heroes/shinpon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shinichi_hear_sight","heroes/shinpon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shinichi_hear1","heroes/shinpon", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_urusai","heroes/shinpon", LUA_MODIFIER_MOTION_NONE)

function shinichi_hear:IsStealable() return true end
function shinichi_hear:IsHiddenWhenStolen() return false end
function shinichi_hear:IsLearned() return true end
function shinichi_hear:GetIntrinsicModifierName()
    return "modifier_urusai"
end
function shinichi_hear:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("queenofpain_scream_of_pain_datadriven")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function shinichi_hear:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function shinichi_hear:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level)
end
function shinichi_hear:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	caster:AddNewModifier(caster, self, "modifier_shinichi_hear", {duration = duration+self:GetCaster():FindTalentValue("special_bonus_shana_25")})
	caster:AddNewModifier(caster, self, "modifier_shinichi_hear1", {duration = duration+self:GetCaster():FindTalentValue("special_bonus_shana_25")})


		caster:AddNewModifier(caster, self, "modifier_truesight_aura", {duration = duration, radius = self:GetSpecialValueFor("radius")})
     
								
	end



---------------------------------------------------------------------------------------------------------------------
modifier_shinichi_hear = class({})
function modifier_shinichi_hear:IsHidden() return true end
function modifier_shinichi_hear:IsDebuff() return false end
function modifier_shinichi_hear:IsPurgable() return false end
function modifier_shinichi_hear:IsPurgeException() return false end
function modifier_shinichi_hear:RemoveOnDeath() return true end
function modifier_shinichi_hear:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_shinichi_hear:OnIntervalThink()
	if IsServer() then
		AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), FrameTime(), false)

		
			--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_truesight_aura", {duration = 1, radius = self:GetAbility():GetSpecialValueFor("radius")})
			--[[local enemies = FindUnitsInRadius(	self:GetParent():GetTeamNumber(),
			                            		self:GetParent():GetAbsOrigin(),
						                    	nil,
						                    	self:GetAbility():GetSpecialValueFor("radius"),
						         				self:GetAbility():GetAbilityTargetTeam(),
						            			self:GetAbility():GetAbilityTargetType(),
						                        self:GetAbility():GetAbilityTargetFlags(),
						                        FIND_ANY_ORDER,
						                        false)

			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_shinichi_hear_sight", {duration = 1})
			end]]
		end
	end
function modifier_shinichi_hear:OnCreated(table)
 self.caster = self:GetCaster()
        self.parent = self:GetParent()
        self.ability = self:GetAbility()
		self.agility = self.ability:GetSpecialValueFor("bonus_agility")
		local hear_fx = ParticleManager:CreateParticle("particles/earthshaker_arcana_stunned_orbit_halo3.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)

        self:AddParticle(hear_fx, false, false, -1, false, true)
		self:StartIntervalThink(0.5)

        EmitSoundOn("ember_spirit_embr_flameguard_01", self.parent)
self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = self.ability:GetSpecialValueFor("damage"),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
        end
		function modifier_shinichi_hear:OnIntervalThink()
	-- find enemies
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		450,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- play effects
		
	end
end
    

function modifier_shinichi_hear:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_EVASION_CONSTANT,
	                MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL,
	}
    return func
end
function modifier_shinichi_hear:GetModifierEvasion_Constant()
    return 50
end
function modifier_shinichi_hear:GetModifierProcAttack_BonusDamage_Magical()
    return self.agility
end



---------------------------------------------------------------------------------------------------------------------
modifier_shinichi_hear_sight = class({})
function modifier_shinichi_hear_sight:IsHidden() return true end
function modifier_shinichi_hear_sight:IsDebuff() return true end
function modifier_shinichi_hear_sight:IsPurgable() return false end
function modifier_shinichi_hear_sight:IsPurgeException() return false end
function modifier_shinichi_hear_sight:RemoveOnDeath() return true end
function modifier_shinichi_hear_sight:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end

function modifier_shinichi_hear_sight:OnIntervalThink()
	if IsServer() then
		AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), FrameTime(), false)

		
			--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_truesight_aura", {duration = 1, radius = self:GetAbility():GetSpecialValueFor("radius")})
			--[[local enemies = FindUnitsInRadius(	self:GetParent():GetTeamNumber(),
			                            		self:GetParent():GetAbsOrigin(),
						                    	nil,
						                    	self:GetAbility():GetSpecialValueFor("radius"),
						         				self:GetAbility():GetAbilityTargetTeam(),
						            			self:GetAbility():GetAbilityTargetType(),
						                        self:GetAbility():GetAbilityTargetFlags(),
						                        FIND_ANY_ORDER,
						                        false)

			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_shinichi_hear_sight", {duration = 1})
			end]]
		end
	end
function modifier_shinichi_hear_sight:CheckState()
	local state = {	[MODIFIER_STATE_INVISIBLE] = false,
					[MODIFIER_STATE_PROVIDES_VISION] = true,}
	return state
end
function modifier_shinichi_hear_sight:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_shinichi_hear_sight:GetEffectName()
	
end
function modifier_shinichi_hear_sight:GetEffectAttachType()
	
end
modifier_shinichi_hear1 = class({})
function modifier_shinichi_hear1:IsHidden() return true end
function modifier_shinichi_hear1:IsDebuff() return false end
function modifier_shinichi_hear1:IsPurgable() return false end
function modifier_shinichi_hear1:IsPurgeException() return false end
function modifier_shinichi_hear1:RemoveOnDeath() return true end
function modifier_shinichi_hear1:OnCreated()
	if IsServer() then
		self:StartIntervalThink(FrameTime())
	end
end
function modifier_shinichi_hear1:OnIntervalThink()
	if IsServer() then
		AddFOWViewer(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), self:GetAbility():GetSpecialValueFor("radius"), FrameTime(), false)

		
			--self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_truesight_aura", {duration = 1, radius = self:GetAbility():GetSpecialValueFor("radius")})
			--[[local enemies = FindUnitsInRadius(	self:GetParent():GetTeamNumber(),
			                            		self:GetParent():GetAbsOrigin(),
						                    	nil,
						                    	self:GetAbility():GetSpecialValueFor("radius"),
						         				self:GetAbility():GetAbilityTargetTeam(),
						            			self:GetAbility():GetAbilityTargetType(),
						                        self:GetAbility():GetAbilityTargetFlags(),
						                        FIND_ANY_ORDER,
						                        false)

			for _,enemy in pairs(enemies) do
				enemy:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_shinichi_hear_sight", {duration = 1})
			end]]
		end
	end
modifier_urusai = class ({})
function modifier_urusai:IsHidden() return true end
function modifier_urusai:IsDebuff() return false end
function modifier_urusai:IsPurgable() return false end
function modifier_urusai:IsPurgeException() return false end
function modifier_urusai:RemoveOnDeath() return false end

function modifier_urusai:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_urusai:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_urusai:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_urusai:GetModifierBaseAttackTimeConstant()
	return 2.5
end
function modifier_urusai:OnIntervalThink()
    if IsServer() then
        local angry_loli = self:GetParent():FindAbilityByName("angry_loli_urusai")
        if angry_loli and not angry_loli:IsNull() then
            if self:GetParent():HasScepter() then
                if angry_loli:IsHidden() then
                    angry_loli:SetHidden(false)
                end
            else
                if not angry_loli:IsHidden() then
                    angry_loli:SetHidden(true)
                end
            end
        end
    end
end
