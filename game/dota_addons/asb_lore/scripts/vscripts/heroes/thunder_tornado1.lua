function torrent_bubble_allies( keys )
	local caster = keys.caster
	
	local allHeroes = HeroList:GetAllHeroes()
	local delay = keys.ability:GetLevelSpecialValueFor( "delay", keys.ability:GetLevel() - 1 )
	local particleName = ""
	local target = keys.target_points[1]
	
	for k, v in pairs( allHeroes ) do
		if v:GetPlayerID() and v:GetTeam() == caster:GetTeam() then
			local fxIndex = ParticleManager:CreateParticleForPlayer( particleName, PATTACH_ABSORIGIN, v, PlayerResource:GetPlayer( v:GetPlayerID() ) )
			ParticleManager:SetParticleControl( fxIndex, 0, target )
			
			EmitSoundOnClient( "mori.5", PlayerResource:GetPlayer( v:GetPlayerID() ) )
			
			-- Destroy particle after delay
			Timers:CreateTimer( delay, function()
					ParticleManager:DestroyParticle( fxIndex, false )
					return nil
				end
			)
		end
	end
end

--[[
	Author: kritth
	Date: 9.1.2015.
	Emit sound at location
]]
function torrent_emit_sound( keys )
	local dummy = CreateUnitByName( "npc_dummy_unit", keys.target_points[1], false, keys.caster, keys.caster, keys.caster:GetTeamNumber() )
	EmitSoundOn( "mori.5_1", dummy )
	dummy:ForceKill( true )
end

--[[
	Author: kritth, Pizzalol
	Date: February 24, 2016
	Provides obstructed vision of the area
]]
function torrent_vision( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target_points[1]
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor( "vision_duration", ability:GetLevel() - 1 )
	
	AddFOWViewer(caster:GetTeamNumber(),target,radius,duration,true)
end

-----------------------------------------------------------------------------------------------------------------------------------------------------------
function torrent_animation_fix( keys )
	local caster = keys.caster

    -- Animation Bug Fix
    Timers:CreateTimer(0.8, function()
        if caster then
            caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_5)
            caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_7)
        end
    end)
end