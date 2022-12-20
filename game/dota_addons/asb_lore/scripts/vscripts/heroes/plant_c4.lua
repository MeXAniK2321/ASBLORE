plant_c4 = class({})
LinkLuaModifier( "modifier_plant_c4", "heroes/plant_c4.lua", LUA_MODIFIER_MOTION_NONE )
function plant_c4:GetIntrinsicModifierName()
    return "modifier_plant_c4"
end
function plant_c4:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("homura_regenerate")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function plant_c4:OnSpellStart()
	if not IsServer() then return end
    local caster = self:GetCaster()
    local player = caster:GetPlayerID()
	local point = self:GetCursorPosition()
    local level = self:GetLevel()
    local origin = point
	local duration = 60
	
	
	

  
   
	    
        self.c4_bomb = CreateUnitByName("npc_dota_homurac4_"..level, origin, true, caster, caster, caster:GetTeamNumber())
		FindClearSpaceForUnit(self.c4_bomb, origin, true)
        self.c4_bomb:SetControllableByPlayer(player, true)
	
        
   EmitSoundOn("homura.1", caster)
	
end
modifier_plant_c4 = class ({})
function modifier_plant_c4:IsHidden() return true end
function modifier_plant_c4:IsDebuff() return false end
function modifier_plant_c4:IsPurgable() return false end
function modifier_plant_c4:IsPurgeException() return false end
function modifier_plant_c4:RemoveOnDeath() return false end

function modifier_plant_c4:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_plant_c4:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_plant_c4:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_plant_c4:GetModifierBaseAttackTimeConstant()
	return 2.5
end
function modifier_plant_c4:OnIntervalThink()
    if IsServer() then
        local vongolle = self:GetParent():FindAbilityByName("homura_regenerate")
        if vongolle and not vongolle:IsNull() then
            if self:GetParent():HasScepter() then
                if vongolle:IsHidden() then
                    vongolle:SetHidden(false)
                end
            else
                if not vongolle:IsHidden() then
                    vongolle:SetHidden(true)
                end
            end
        end
    end
end