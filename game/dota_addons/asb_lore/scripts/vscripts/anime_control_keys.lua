if bINITED_ANIME_CONTROL_KEYS then
    return 
end
---------------------------------------------------------------------------------------------------------------------
_G.bINITED_ANIME_CONTROL_KEYS = true
---------------------------------------------------------------------------------------------------------------------
VALVE_IsMoving = CDOTA_BaseNPC.IsMoving
CDOTA_BaseNPC.IsMoving = function(self)
    local bIsMoving      = VALVE_IsMoving(self)
    local hAE86Ability   = self:FindAbilityByName("ae86_drift")

    if IsNotNull(hAE86Ability)
        and hAE86Ability.bRacingMod then
        return  not ( self:IsChanneling() --NEW THING 23.10.2021, ADDED IN FUNCTIONS FOR CLIENT TOO
                      or self:IsStunned()
                      or self:IsRooted()
                      or self:HasModifier("modifier_teleporting") 
                      or self:HasModifier("modifier_teleporting_root_logic") )
                and ( self:GetModifierStackCount("modifier_ae86_gas", self) ~= 0 
                      or self:GetModifierStackCount("modifier_ae86_back", self) ~= 0 )
    end
    
    return bIsMoving
end
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
if IsServer() then
    local ACK_MoveCheck = function(bMoveUp, bMoveLeft, bMoveDown, bMoveRight, iPlayerID)
        local hEntity = PlayerResource:GetSelectedHeroEntity(iPlayerID)
        if IsNotNull(hEntity) then
        	local hModifier = nil
            if hEntity:GetUnitName() == "npc_dota_hero_skywrath_mage"
					and not ( hEntity:IsStunned() 
                 			or hEntity:IsRooted() 
                          	or hEntity:IsCommandRestricted()
                          	or IsNotNull(hEntity:GetForceAttackTarget()) ) then
            	hModifier = hEntity:FindModifierByNameAndCaster("modifier_ae86_gas", hEntity)
            end
            if IsNotNull(hModifier) then
                local hAbility = hModifier:GetAbility()
                if IsNotNull(hAbility) 
                    and hAbility.___bMovementButtonsControl or hAbility.bRacingMod then
                    if type(bMoveUp) == "boolean" then
                        hModifier.bMoveUp = bMoveUp
                        print("moveup")
                    end
                    if type(bMoveLeft) == "boolean" then
                        hModifier.bMoveLeft = bMoveLeft
                    end
                    if type(bMoveDown) == "boolean" then
                        hModifier.bMoveDown = bMoveDown
                    end
                    if type(bMoveRight) == "boolean" then
                        hModifier.bMoveRight = bMoveRight
                    end
                end
            end
        end
    end


    ------------------------------------------------------------------------------------------------------------------------------------------------------------
    RegisterCustomEventListener("ACK_MOVE_CHECK", function(args)
        local iPlayerID = args.PlayerID
        for k, v in pairs(args) do
            if v == -1 then
                args[k] = nil
            end
            if type(args[k]) ~= "nil" then
                args[k] = args[k] >= 1
            end
        end
        return ACK_MoveCheck(args.bACK_MOVE_UP, args.bACK_MOVE_LEFT, args.bACK_MOVE_DOWN, args.bACK_MOVE_RIGHT, iPlayerID)
    end)
    

    
end

--return true