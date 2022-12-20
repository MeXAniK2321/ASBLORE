LinkLuaModifier("modifier_lunatic_nightmare_thinker", "heroes/lunatic_nightmare.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lunatic_nightmare_thinker_out", "heroes/lunatic_nightmare.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lunatic_nightmare_thinker_in", "heroes/lunatic_nightmare.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lunatic_nightmare", "modifiers/modifier_lunatic_nightmare.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier3", "modifiers/modifier_star_tier3.lua", LUA_MODIFIER_MOTION_NONE)
lunatic_nightmare = class({})


function lunatic_nightmare:IsStealable() return true end
function lunatic_nightmare:IsHiddenWhenStolen() return false end
function lunatic_nightmare:IsRefreshable() return true end
function lunatic_nightmare:GetManaCost(level)
    local manacost = self.BaseClass.GetManaCost(self, level)
    local manacost_percent = ( manacost / 100 ) * self:GetCaster():GetMaxMana()
    return self.BaseClass.GetManaCost(self, level)
end
function lunatic_nightmare:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end
function lunatic_nightmare:OnSpellStart()
    local caster = self:GetCaster()
    local point = caster:GetOrigin()
    local radius = self:GetAOERadius()

    local duration = self:GetSpecialValueFor("duration") 
  
    caster:AddNewModifier(caster, self, "modifier_lunatic_nightmare", {duration = 32})
	
caster:AddNewModifier(caster, self, "modifier_star_tier3", {duration = 32})

    CreateModifierThinker(caster, self, "modifier_lunatic_nightmare_thinker", {duration = duration}, point, caster:GetTeamNumber(), false)
end
---------------------------------------------------------------------------------------------------------------------
modifier_lunatic_nightmare_thinker = class({})
function modifier_lunatic_nightmare_thinker:IsHidden() return true end
function modifier_lunatic_nightmare_thinker:IsDebuff() return false end
function modifier_lunatic_nightmare_thinker:IsPurgable() return false end
function modifier_lunatic_nightmare_thinker:IsPurgeException() return false end
function modifier_lunatic_nightmare_thinker:RemoveOnDeath() return true end
function modifier_lunatic_nightmare_thinker:OnCreated()
    if IsServer() then
        self.radius = self:GetAbility():GetAOERadius()

        EmitSoundOn("flandr.8", self:GetParent())

        self.center = self:GetParent():GetAbsOrigin()

       

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_lunatic_nightmare_thinker:OnIntervalThink()
    if IsServer() then
        if not self:GetCaster() or not self:GetCaster():IsAlive() then
            self:Destroy()
        end

        local units_resolve = FindUnitsInRadius(self:GetParent():GetTeam(),
                                                self:GetParent():GetAbsOrigin(), 
                                                nil, 
                                                99999, 
                                                self:GetAbility():GetAbilityTargetTeam(), 
                                                self:GetAbility():GetAbilityTargetType(), 
                                                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
                                                0, 
                                                false) 

        for _,unit in pairs(units_resolve) do
            if unit and not unit:IsNull() and IsValidEntity(unit) then
                local distance = (self:GetParent():GetAbsOrigin() - unit:GetAbsOrigin()):Length2D()
                local special_duration = self:GetDuration() - self:GetElapsedTime()
                if distance > self.radius then
                    if not unit:FindModifierByNameAndCaster("modifier_lunatic_nightmare_thinker_out", self:GetParent()) and not unit:FindModifierByNameAndCaster("modifier_lunatic_nightmare_thinker_in", self:GetParent()) then
                        unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lunatic_nightmare_thinker_out", {duration = special_duration, radius = self.radius, main_altair = self:GetCaster():entindex()})
                    end
                else
                    if not unit:FindModifierByNameAndCaster("modifier_lunatic_nightmare_thinker_in", self:GetParent()) and not unit:FindModifierByNameAndCaster("modifier_lunatic_nightmare_thinker_out", self:GetParent()) then
                        unit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lunatic_nightmare_thinker_in", {duration = special_duration, radius = self.radius, main_altair = self:GetCaster():entindex()})

                       
                    end
                end
            end
        end
    end
		if not self:GetCaster():HasModifier("modifier_lunatic_nightmare_thinker_in") then
            self:Destroy()
        end
end
function modifier_lunatic_nightmare_thinker:OnDestroy()
    if IsServer() then
       

        if self.arena_barrier then
            ParticleManager:DestroyParticle(self.arena_barrier, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_barrier)
        end
        
        UTIL_Remove(self:GetParent())
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_lunatic_nightmare_thinker_in = class({})
function modifier_lunatic_nightmare_thinker_in:IsHidden() return true end
function modifier_lunatic_nightmare_thinker_in:IsDebuff() return true end
function modifier_lunatic_nightmare_thinker_in:IsPurgable() return false end
function modifier_lunatic_nightmare_thinker_in:IsPurgeException() return false end
function modifier_lunatic_nightmare_thinker_in:RemoveOnDeath() return true end
function modifier_lunatic_nightmare_thinker_in:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_lunatic_nightmare_thinker_in:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
                }
    return func
end
function modifier_lunatic_nightmare_thinker_in:GetModifierIncomingDamage_Percentage(keys)
    if IsServer() then
        if keys.attacker:HasModifier( "modifier_lunatic_nightmare_thinker_out" )  then
           
            return -100
			else
			
        end

       
    end
end

function modifier_lunatic_nightmare_thinker_in:OnCreated(params)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    if IsServer() then
        self.main_altair = EntIndexToHScript(params.main_altair)

        self.damage_increase = self:GetAbility():GetSpecialValueFor("damage_increase")

        self.center = self:GetCaster():GetAbsOrigin()
        self.radius = params.radius - 50
        self.old_pos = self:GetParent():GetAbsOrigin()

        if self:GetParent():IsRealHero() and not self:GetParent():IsIllusion() and not self:GetParent():IsTempestDouble() then
            local player = PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID())

            self.arena_barrier =  ParticleManager:CreateParticleForPlayer("particles/lunatic_nightmare.vpcf", PATTACH_WORLDORIGIN, nil, player)
                                ParticleManager:SetParticleControl(self.arena_barrier, 0, Vector(self.center.x, self.center.y, self.center.z))
                                ParticleManager:SetParticleControl(self.arena_barrier, 1, Vector(self.radius + 50, 1, 1))
                                ParticleManager:SetParticleControl(self.arena_barrier, 2, Vector(self:GetDuration(), 0, 0))
                                ParticleManager:SetParticleShouldCheckFoW( self.arena_barrier, false )
        end

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_lunatic_nightmare_thinker_in:OnIntervalThink()
    if IsServer() then
        if not self.caster or self.caster:IsNull() or not self.parent or self.parent:IsNull() then
            self:Destroy()

            return nil
        end

        local distance = (self:GetParent():GetAbsOrigin() - self.center):Length2D()

        if distance > self.radius then
            if self:GetParent() == self:GetCaster():GetOwnerEntity() then
                self:Destroy()
                return nil
            end

            local direction = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
            self.old_pos = self.center + direction * self.radius

            self:GetParent():SetAbsOrigin(self.old_pos)
            FindClearSpaceForUnit(self:GetParent(), self.old_pos, true)
        end
    end
end
function modifier_lunatic_nightmare_thinker_in:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end

        if self.arena_barrier then
            ParticleManager:DestroyParticle(self.arena_barrier, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_barrier)
        end
    end
end
---------------------------------------------------------------------------------------------------------------------
modifier_lunatic_nightmare_thinker_out = class({})
function modifier_lunatic_nightmare_thinker_out:IsHidden() return true end
function modifier_lunatic_nightmare_thinker_out:IsDebuff() return true end
function modifier_lunatic_nightmare_thinker_out:IsPurgable() return false end
function modifier_lunatic_nightmare_thinker_out:IsPurgeException() return false end
function modifier_lunatic_nightmare_thinker_out:RemoveOnDeath() return true end
function modifier_lunatic_nightmare_thinker_out:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_lunatic_nightmare_thinker_out:OnCreated(params)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    if IsServer() then
        self.main_altair = EntIndexToHScript(params.main_altair)

        self.center = self:GetCaster():GetAbsOrigin()
        self.radius = params.radius + 75
        self.old_pos = self:GetParent():GetAbsOrigin()

        if self:GetParent():IsRealHero() and not self:GetParent():IsIllusion() and not self:GetParent():IsTempestDouble() then
            local player = PlayerResource:GetPlayer(self:GetParent():GetPlayerOwnerID())

            self.arena_place_black =  ParticleManager:CreateParticleForPlayer("particles/lunatic_nightmare_out.vpcf", PATTACH_WORLDORIGIN, nil, player)
                                    ParticleManager:SetParticleControl(self.arena_place_black, 0, self.center)
                                    ParticleManager:SetParticleControl(self.arena_place_black, 1, Vector(self.radius/2, self.radius/2, self.radius/2))
                                    ParticleManager:SetParticleShouldCheckFoW( self.arena_place_black, false )
        end

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_lunatic_nightmare_thinker_out:OnIntervalThink()
    if IsServer() then
        if not self.caster or self.caster:IsNull() or not self.parent or self.parent:IsNull() then
            self:Destroy()

            return nil
        end

        local distance = (self:GetParent():GetAbsOrigin() - self.center):Length2D()

        if distance < self.radius then
            if self:GetParent() == self:GetCaster():GetOwnerEntity() then
                self:Destroy()
                return nil
            end

            local direction = (self:GetParent():GetAbsOrigin() - self.center):Normalized()
            self.old_pos = self.center + direction * self.radius

            self:GetParent():SetAbsOrigin(self.old_pos)
            FindClearSpaceForUnit(self:GetParent(), self.old_pos, true)
        end
    end
end
function modifier_lunatic_nightmare_thinker_out:OnDestroy()
    if IsServer() then
        if self.parent and not self.parent:IsNull() and self.parent:IsAlive() then
            self.parent:AddNewModifier(self.caster, self.ability, "modifier_phased", {duration = FrameTime()})
        end

        if self.arena_place_black then
            ParticleManager:DestroyParticle(self.arena_place_black, true) 
            ParticleManager:ReleaseParticleIndex(self.arena_place_black)
        end
    end
end