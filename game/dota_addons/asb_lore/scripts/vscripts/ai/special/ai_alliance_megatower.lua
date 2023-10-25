
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity.location = Vector(thisEntity:Attribute_GetFloatValue("pos_x", 0), thisEntity:Attribute_GetFloatValue("pos_y", 0), thisEntity:Attribute_GetFloatValue("pos_z", 0))
    thisEntity.crystal = CreateUnitByName("npc_alliance_megatower_crystal", thisEntity.location, false, thisEntity, thisEntity, thisEntity:GetTeamNumber())
	thisEntity.crystal:SetIsBuilding(true)

    thisEntity:AddNewModifier(thisEntity, nil, "modifier_megatower", {crystal = thisEntity.crystal:entindex()})
end

if modifier_megatower == nil then modifier_megatower = class({}) end

function modifier_megatower:IsHidden() return true end
function modifier_megatower:RemoveOnDeath() return true end
function modifier_megatower:IsPurgable() return false end
function modifier_megatower:GetPriority() return MODIFIER_PRIORITY_SUPER_ULTRA end

function modifier_megatower:OnCreated(params)
	if IsServer() then
        self.parent = self:GetParent()
        self.crystal = EntIndexToHScript(params.crystal)
        self:StartIntervalThink(0.1)
    end
end

function modifier_megatower:OnIntervalThink()
    if(not self.particle and GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME) then
        local parent = self:GetParent()
        local nFXIndex = ParticleManager:CreateParticle("particles/custom/units/alliance_megatower/projectile/laser_head.vpcf", PATTACH_CUSTOMORIGIN, parent)
        ParticleManager:SetParticleControlEnt(nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0, 0, 0), true)
        self:AddParticle(nFXIndex, false, false, 1, false, false)
        self.particle = nFXIndex
    end
    if (not self.crystal) or (not self.crystal:IsAlive()) then
        self:StartIntervalThink(-1)

        self:Destroy()

        return
    end
end

function modifier_megatower:RegisterFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}

	return funcs
end
	
function modifier_megatower:GetActivityTranslationModifiers(params)
    if self.crystal and (not self.crystal:IsNull()) and self.crystal:IsAlive() then
        return "level6"
    end

	return 
end

function modifier_megatower:OnDeath(kv)
    if(kv.unit == self.parent) then
        Timers:CreateTimer(0.5, function()
			if(thisEntity and thisEntity:IsNull() == false) then
				UTIL_Remove(thisEntity)
			end
        end)
    end
    if(kv.unit == self.crystal) then
        self.parent:SetBaseHealthRegen(0)
    end
end

function modifier_megatower:IsAura() return true end
function modifier_megatower:GetAuraRadius() return self:GetParent():Script_GetAttackRange() end
function modifier_megatower:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_megatower:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_megatower:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS end
function modifier_megatower:GetModifierAura() return "modifier_megatower_target" end

modifier_megatower_target = class({
    GetTexture = function()
        return "tinker_laser"
    end
})

local INCREMENTER = 2
local INTERVAL = 0.03
local PARTICLE_INTERVAL = 0.25

modifier_megatower_target.m_flMult = 1

function modifier_megatower_target:IsPurgable() return false end
function modifier_megatower_target:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end 

function modifier_megatower_target:OnCreated(params)
	if IsServer() then
        self:StartIntervalThink(INTERVAL)

        if self:GetCaster().m_hTarget == nil then
            self:GetCaster().m_hTarget = self:GetParent() 
        end
        self.currentProjectileParticleCD = PARTICLE_INTERVAL
        self.damageTable = {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            ability = nil,
            damage = 0,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL
        }
    end
end

function modifier_megatower_target:OnDestroy()
	if IsServer() then
        if self:GetCaster().m_hTarget == self:GetParent() then
            self:GetCaster().m_hTarget = nil
            local enemies = FindUnitsInRadius(
                self:GetCaster():GetTeamNumber(), 
                self:GetCaster():GetAbsOrigin(), 
                nil, 
                self:GetCaster():Script_GetAttackRange(), 
                DOTA_UNIT_TARGET_TEAM_ENEMY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
                FIND_ANY_ORDER, 
                false
            )
            for _, enemy in pairs(enemies) do
                local modifier = enemy:FindModifierByNameAndCaster(self:GetName(), self:GetCaster())
                if(modifier) then
                    modifier:Destroy()
                end
            end
        end
    end
end

function modifier_megatower_target:OnIntervalThink()
    if self:GetCaster().m_hTarget == self:GetParent() and self:GetCaster():IsStunned() == false then
        self.m_flMult = self.m_flMult + (INCREMENTER * INTERVAL)
        self.currentProjectileParticleCD = self.currentProjectileParticleCD + INTERVAL
        if(self.currentProjectileParticleCD >= PARTICLE_INTERVAL) then
            local nFXIndex = ParticleManager:CreateParticle( self:GetCaster():GetRangedProjectileName(), PATTACH_CUSTOMORIGIN, nil )
            ParticleManager:SetParticleControlEnt( nFXIndex, 9, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
            ParticleManager:SetParticleControlEnt( nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true )
            ParticleManager:ReleaseParticleIndex( nFXIndex )
            self.currentProjectileParticleCD = 0
        end
        self:SetStackCount(self.m_flMult)
        self.damageTable.damage = (self.m_flMult / 100 * self:GetCaster():GetAttackDamage()) * (1 - self.damageTable.victim:GetReductionFromPhysicalArmor())
        ApplyDamage(self.damageTable)
  end
end

LinkLuaModifier("modifier_megatower", "ai/special/ai_alliance_megatower", LUA_MODIFIER_MOTION_NONE, modifier_megatower)
LinkLuaModifier("modifier_megatower_target", "ai/special/ai_alliance_megatower", LUA_MODIFIER_MOTION_NONE, modifier_megatower_target)