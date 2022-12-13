spirit_contract = class({})
LinkLuaModifier( "modifier_generic_silenced_lua", "modifiers/modifier_generic_silenced_lua", LUA_MODIFIER_MOTION_NONE )

function spirit_contract:OnSpellStart()
	if not IsServer() then return end
    local caster = self:GetCaster()
    local player = caster:GetPlayerID()
    local level = self:GetLevel()
    local origin = caster:GetAbsOrigin() + RandomVector(100)
	local duration = 30

    if self.beatrice and IsValidEntity(self.beatrice) and self.beatrice:IsAlive() then
	    self.beatrice:ForceKill(false)
        FindClearSpaceForUnit(self.beatrice, origin, true)
		self.beatrice = CreateUnitByName("npc_dota_betty_"..level, origin, true, caster, caster, caster:GetTeamNumber())
        self.beatrice:SetControllableByPlayer(player, true)
        
        
    else
        self.beatrice = CreateUnitByName("npc_dota_betty_"..level, origin, true, caster, caster, caster:GetTeamNumber())
        self.beatrice:SetControllableByPlayer(player, true)
		
        
    end
	self.beatrice:AddNewModifier(caster, ability, "modifier_generic_silenced_lua",{duration = 1.5})
	self:PlayEffects()
end
function spirit_contract:PlayEffects()
	-- Get Resources
	local sound_cast = "subaru.3"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end