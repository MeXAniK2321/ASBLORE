function Spawn( entityKeyValues )
	--- We want our dummy ability to be sync with delay of animation
	thisEntity.m_flTeleportDelay = thisEntity:Attribute_GetFloatValue("teleport_delay", 5.0)

	Teleports:RegisterTeleport(thisEntity)

    if IsServer() then
        thisEntity:AddNewModifier(thisEntity, nil, "modifier_invulnerable", nil)
    end

    thisEntity.telport_ability = thisEntity:GetAbilityByIndex(0)
    
	thisEntity:SetContextThink( "TeleportThink", TeleportThink, 1 )
end

function TeleportThink()
    if (not IsValidEntity(thisEntity) or thisEntity:IsAlive() == false) then
        return nil 
    end 

    if thisEntity:Attribute_GetIntValue("teleport_enabled", 0) == 1 then
        thisEntity:AddActivityModifier("active")
        thisEntity:SetMaterialGroup("active")
    else 
        thisEntity:ClearActivityModifiers()
        thisEntity:SetMaterialGroup("default")
    end

    return 1
end
