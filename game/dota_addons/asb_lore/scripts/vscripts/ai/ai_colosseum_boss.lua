require('ai/core/ai_core')

AIColosseumBehavior = class(GenericAIBehavior)

function AIColosseumBehavior:IsCanRetreatToSpawnPosition()
    return true
end

function AIColosseumBehavior:IsCanRespondToHelpCall()
	return true
end

function AIColosseumBehavior:IsCanTargetNeutralCreeps()
	return false
end

function AIColosseumBehavior:IsBindedToZone()
	return true
end

function AIColosseumBehavior:IsCompletelyForgetAboutInvisibleEnemies()
	return true
end

function AIColosseumBehavior:EnemyUnitFilterCustom(thisEntity, target)
    if(ColosseumGame:IsGateClosed() == false) then
        return false
    end
    return true
end

function Spawn(entityKeyValues)
	if(not IsServer()) then
		return
	end
	if(thisEntity == nil) then
		return
	end
	AICore:Init(thisEntity, AIColosseumBehavior)
end