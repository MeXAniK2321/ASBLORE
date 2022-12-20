LinkLuaModifier("modifier_vocaloids_concert_delay", "heroes/vocaloids_concert", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_vocaloids_concert_duration", "heroes/vocaloids_concert", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier1", "modifiers/modifier_star_tier1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)
vocaloids_concert = class({})

function vocaloids_concert:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function vocaloids_concert:GetManaCost(level)
    return self.BaseClass.GetManaCost(self, level)
end

function vocaloids_concert:OnAbilityPhaseStart()
   
    return true
end

function vocaloids_concert:OnAbilityPhaseInterrupted()
    
end

function vocaloids_concert:OnSpellStart()
    local caster = self:GetCaster()
    
    if not IsServer() then return end
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_vocaloids_concert_delay", {duration = 0.65})
	caster:AddNewModifier(caster, self, "modifier_star_tier2", {duration = 25})
end

modifier_vocaloids_concert_delay = class({})

function modifier_vocaloids_concert_delay:IsHidden()   return true end
function modifier_vocaloids_concert_delay:IsPurgable() return false end

function modifier_vocaloids_concert_delay:OnCreated()
    if not IsServer() then return end
    local split_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_primal_split.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
    ParticleManager:SetParticleControl(split_particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControlForward(split_particle, 0, self:GetParent():GetForwardVector())
    self:AddParticle(split_particle, false, false, -1, false, false)
end

function modifier_vocaloids_concert_delay:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE]   = true,
        [MODIFIER_STATE_OUT_OF_GAME]    = true,
        [MODIFIER_STATE_STUNNED]            = true,
        [MODIFIER_STATE_NO_HEALTH_BAR]      = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION]  = true
    }
end

function modifier_vocaloids_concert_delay:OnDestroy()
    if not IsServer() then return end
    local duration = self:GetAbility():GetSpecialValueFor("duration")
    self.vocaloids = {}
    self.vocaloids_entindexes = {}
	

    if self:GetParent():IsAlive() and self:GetAbility() then
        self:GetCaster():EmitSound("ns2")
        local split_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_vocaloids_concert_duration", {duration = duration})
        local earth_panda   = CreateUnitByName("npc_dota_miku_"..self:GetAbility():GetLevel(), self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100, true, self:GetParent(), self:GetParent(), self:GetCaster():GetTeamNumber())
        local storm_panda   = CreateUnitByName("npc_dota_yukari_"..self:GetAbility():GetLevel(), RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, 120, 0), self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
        local fire_panda    = CreateUnitByName("npc_dota_mayu_"..self:GetAbility():GetLevel(), RotatePosition(self:GetParent():GetAbsOrigin(), QAngle(0, -120, 0), self:GetParent():GetAbsOrigin() + self:GetParent():GetForwardVector() * 100), true, self:GetCaster(), self:GetCaster(), self:GetCaster():GetTeamNumber())
        

        
        table.insert(self.vocaloids, earth_panda)
        table.insert(self.vocaloids, storm_panda)
        table.insert(self.vocaloids, fire_panda)
        table.insert(self.vocaloids_entindexes, earth_panda:entindex())
        
        if self:GetCaster() == self:GetParent() then
            table.insert(self.vocaloids_entindexes, storm_panda:entindex())
            table.insert(self.vocaloids_entindexes, fire_panda:entindex())
        end
        
        self:GetParent():FollowEntity(earth_panda, true)
        
        if split_modifier then
            split_modifier.vocaloids               = self.vocaloids
            split_modifier.pandas_entindexes    = self.vocaloids_entindexes
        end
        
        for _, panda in pairs(self.vocaloids) do
            panda:SetForwardVector(self:GetParent():GetForwardVector())
            panda:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_vocaloids_concert_duration", {duration = duration, parent_entindex = self:GetParent():entindex()})
            panda:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_kill", {duration = duration})
            panda:SetControllableByPlayer(self:GetCaster():GetPlayerID(), true)
        end
        self:GetParent():AddNoDraw()
    end
end

modifier_vocaloids_concert_duration = class({})

function modifier_vocaloids_concert_duration:IsPurgable()    return false end

function modifier_vocaloids_concert_duration:OnCreated(keys)
    if not IsServer() then return end

    if keys and keys.parent_entindex then
        self.parent = EntIndexToHScript(keys.parent_entindex)
    end
end

function modifier_vocaloids_concert_duration:OnDestroy()
    if not IsServer() then return end
    
    if self:GetParent():IsHero() then
	   
        
        self:GetParent():FollowEntity(nil, false)
        self:GetParent():RemoveNoDraw()
    end
	self.parent = self:GetParent()
    self.ability = self:GetAbility()
	
	 if self.parent:IsRealHero() then
                self.ability:StartCooldown(self.ability:GetCooldown(-1) * self.parent:GetCooldownReduction())
        
                if ability and not ability:IsNull() and ability:IsTrained() then
                    --SetZenitsuAwakeLongCd(self.parent, self.ability)
                    --ability:CastAbility()
                end
            end
end
        
function modifier_vocaloids_concert_duration:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE]       = self:GetParent():IsHero(),
        [MODIFIER_STATE_OUT_OF_GAME]        = self:GetParent():IsHero(),
    
        [MODIFIER_STATE_STUNNED]            = self:GetParent():IsHero(),
        [MODIFIER_STATE_NOT_ON_MINIMAP]     = self:GetParent():IsHero(),
        [MODIFIER_STATE_NO_UNIT_COLLISION]  = self:GetParent():IsHero(),
        [MODIFIER_STATE_UNSELECTABLE]       = self:GetParent():IsHero(),
    }
end

function modifier_vocaloids_concert_duration:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH,
    }
end

function modifier_vocaloids_concert_duration:OnDeath(keys)
    if keys.unit == self:GetParent() and not self:GetParent():IsHero() then
        if self:GetRemainingTime() > 0 then
            if self.parent and not self.parent:IsNull() and self.parent:HasModifier("modifier_vocaloids_concert_duration") and self.parent:FindModifierByName("modifier_vocaloids_concert_duration").pandas_entindexes then
                local bNoneAlive    = true
                
                for _, panda in pairs(self.parent:FindModifierByName("modifier_vocaloids_concert_duration").vocaloids) do
                    if not panda:IsNull() and panda:IsAlive() then
                        bNoneAlive = false
                        self.parent:FollowEntity(panda, false)
                        
                        if self.parent ~= self:GetCaster() then
                            table.insert(self.parent:FindModifierByName("modifier_vocaloids_concert_duration").vocaloids_entindexes, panda:entindex())
                            panda:SetOwner(self.parent)
                            panda:SetControllableByPlayer(self.parent:GetPlayerID(), true)
                        end
                        
                        break
                    end
                end
                
                if bNoneAlive then
                    self.parent:RemoveModifierByName("modifier_vocaloids_concert_duration")
                    if keys.attacker ~= self:GetParent() then
                        local damageTable = {
                            victim = self.parent,
                            attacker = keys.attacker,
                            damage = 100000000,
                            damage_type = DAMAGE_TYPE_PURE,
                            ability = self:GetAbility(),
                            damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
                        }
                        ApplyDamage(damageTable)
                    end
                end
            end
        end
    end
	
end