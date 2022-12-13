function CreateIllusionForPlayer(caster, owner, target, ability, origin, duration, illusion_type, incoming, outgoing)
    if not IsServer() then
        return nil
    end

    if caster:IsCreep() or owner:IsCreep() or target:IsCreep() then
        return nil
    end

    if not caster:IsRealHero() or not owner:IsRealHero() or not target:IsRealHero() then
        return nil
    end

    if not origin then
        origin = target:GetAbsOrigin() + RandomVector(200)
    end

    if not illusion_type then
        modifier_illusion = "modifier_illusion"
    elseif illusion_type == 1 then
        modifier_illusion = "modifier_illusion"
    elseif illusion_type == 2 then
        modifier_illusion = "modifier_illusion"
    end

    local illusions = CreateIllusions( owner, target, {duration = duration, outgoing_damage = outgoing - 100, incoming_damage = incoming - 100}, 1, 50, true, true )
    FindClearSpaceForUnit(illusions[1], origin, true)
    return illusions[1]
end
function CreateIllusionForPlayer2(caster, owner, target, ability, origin, duration, illusion_type, incoming, outgoing)
    if not IsServer() then
        return nil
    end

    if caster:IsCreep() or owner:IsCreep() or target:IsCreep() then
        return nil
    end

    if not caster:IsRealHero() or not owner:IsRealHero() or not target:IsRealHero() then
        return nil
    end

    if not origin then
        origin = target:GetAbsOrigin() + RandomVector(200)
    end

    if not illusion_type then
        modifier_illusion = "modifier_illusion"
    elseif illusion_type == 1 then
        modifier_illusion = "modifier_illusion"
    elseif illusion_type == 2 then
        modifier_illusion = "modifier_illusion"
    end

    local illusions = CreateIllusions( owner, target, {duration = duration, outgoing_damage = outgoing - 100, incoming_damage = incoming - 100}, 1, 50, false, false )
    FindClearSpaceForUnit(illusions[1], origin, true)
    return illusions[1]
end

IsWoman = function(hero)
    local womans = 
        {
             "npc_dota_hero_sven",
             "npc_dota_hero_tusk",
             "npc_dota_hero_ember_spirit",
             "npc_dota_hero_terrorblade",
             "npc_dota_hero_drow_ranger",
             "npc_dota_hero_obsidian_destroyer",
             "npc_dota_hero_dark_willow",
             "npc_dota_hero_nevermore",
             "npc_dota_hero_spectre",
             "npc_dota_hero_elder_titan",
             "npc_dota_hero_chaos_knight",
             "npc_dota_hero_legion_commander",
             "npc_dota_hero_ancient_apparition"
             
            
        }
        for _,woman in pairs(womans) do
           if hero:GetUnitName()== woman then
            return true
        end
    end
    end
function FlipUnitShareMaskBit(targetPlayerID, otherPlayerID, bitVal)
	local currentUnitShareMask = PlayerResource:GetUnitShareMaskForPlayer(targetPlayerID, otherPlayerID)
	if bit.band(currentUnitShareMask, bitVal) == bitVal then
		PlayerResource:SetUnitShareMaskForPlayer(targetPlayerID, otherPlayerID, bitVal, false)
	else
		PlayerResource:SetUnitShareMaskForPlayer(targetPlayerID, otherPlayerID, bitVal, true)
	end
end


 RotateVector2D = function(vVector, fAngle, bIsDegreeNotRad)
        fAngle = bIsDegreeNotRad and math.rad(fAngle) or fAngle
        local sinA = math.sin(fAngle)
        local cosA = math.cos(fAngle)
        local vXP = ( vVector.x * cosA ) - ( vVector.y * sinA )
        local vYP = ( vVector.x * sinA ) + ( vVector.y * cosA )
        return Vector(vXP, vYP, vVector.z):Normalized()
    end
	
	
Speacial_ProjectileCreation = function(hCaster, hAbility, vStartPoint, vEndPoint, fSpeed, fWidthStart, fWidthEnd, jParticleName )
    local fDistance    = GetDistance(vEndPoint, vStartPoint)
    local fDistance3D  = GetDistance(vEndPoint, vStartPoint, true)
    local vDirection   = GetDirection(vEndPoint, vStartPoint)
    local vDirection3D = GetDirection(vEndPoint, vStartPoint, true)

    local sBladeParticle = "particles/mars_spear1.vpcf"

    local iBladeParticle =  ParticleManager:CreateParticle( sBladeParticle, PATTACH_WORLDORIGIN, nil )
                            ParticleManager:SetParticleShouldCheckFoW( iBladeParticle, false )
                            ParticleManager:SetParticleControl( iBladeParticle, 0, vStartPoint )
                            ParticleManager:SetParticleControl( iBladeParticle, 1, vDirection3D * fSpeed )

    local hBladeProjectile =    {
                                    Ability             = hAbility,
                                    vSpawnOrigin        = vStartPoint,
                                    vVelocity           = vDirection * ( fDistance / fDistance3D * fSpeed ),
                                    fDistance           = fDistance,
                                    fStartRadius        = fWidthStart,
                                    fEndRadius          = fWidthEnd or fWidthStart,
                                    Source              = hCaster,

                                    iUnitTargetTeam     = hAbility:GetAbilityTargetTeam(),
                                    iUnitTargetType     = hAbility:GetAbilityTargetType(),
                                    iUnitTargetFlags    = hAbility:GetAbilityTargetFlags(),

                                    --bProvidesVision     = false,
                                    --iVisionRadius       = 0,
                                    --iVisionTeamNumber   = hCaster:GetTeamNumber(),
                                    ExtraData           =   {
                                                                iBladeParticle = iBladeParticle
                                                            } 
                                }

    return ProjectileManager:CreateLinearProjectile(hBladeProjectile)
end

IsNotNull = function(hScript) 
    local sType = type(hScript)
    if sType ~= "nil" then
        if sType == "table" and type(hScript.IsNull) == "function" then
            return not hScript:IsNull()
        end
        return true
    end
    return false
end
IsASBPatreon = function(player)
local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	local hero = PlayerResource:GetSelectedHeroEntity(PID) 
local patreon = 
	{
		418417801, -- Chumba
		167912041, -- Miku
		117795030, -- Tlen
		174719954, -- Pidor(Sanya)
		894464571, -- DayDream
		110726052,	-- DOG_WATER
		137775440,  -- LifeIsShit
		375296401, -- Механик блядь
		234665362, -- Fater БЛЯДЬ!
		305018207, -- Madoka БЛЯДЬ!
        368667162,
        1012891301, 
        1021938563,
		234665362,
		300839238,
		76561198141859539,
        76561198100237957,
        1815983811,
        82664205,
	}
	for _,patr in pairs(patreon) do
       if id32 == patr then
        return true
  end
	end
	end

IsASBAdmin = function(player)
local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	local hero = PlayerResource:GetSelectedHeroEntity(PID) 
local patreon = 
	{
		137775440,
		418417801,
		167912041,
		117795030,
		174719954,
		1012891301, 
        1021938563,
		234665362,
		300839238,
		76561198141859539,
        76561198100237957,
        1815983811,
        82664205,
	}
	for _,patr in pairs(patreon) do
       if id32 == patr then
        return true
	end
end
end
GetDirection = function(hEnt1, hEnt2, b3D)
    hEnt1 = hEnt1.GetAbsOrigin and hEnt1:GetAbsOrigin() or hEnt1
    hEnt2 = hEnt2.GetAbsOrigin and hEnt2:GetAbsOrigin() or hEnt2

    local iEnt1 = hEnt1.z
    local iEnt2 = hEnt2.z
    
    hEnt1.z = b3D and iEnt1 or 0
    hEnt2.z = b3D and iEnt2 or 0

    local vReturn = (hEnt1 - hEnt2):Normalized()

    hEnt1.z = iEnt1
    hEnt2.z = iEnt2

    return vReturn
end

TableLength = function(hTable)
    local i = 0
    if type(hTable) == "table" then
        for _, hV in pairs(hTable) do
            i = i + 1
        end
    end
    return i
end

GetDistance = function(hEnt1, hEnt2, b3D)
    hEnt1 = hEnt1.GetAbsOrigin and hEnt1:GetAbsOrigin() or hEnt1
    hEnt2 = hEnt2.GetAbsOrigin and hEnt2:GetAbsOrigin() or hEnt2
    return b3D and (hEnt1 - hEnt2):Length() or (hEnt1 - hEnt2):Length2D()
end