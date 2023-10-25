require('ai/core/ai_core')

AIRadiantRoshanBehavior = class(GenericAIBehavior)

function AIRadiantRoshanBehavior:IsCanRetreatToSpawnPosition()
    return true
end

function AIRadiantRoshanBehavior:IsCanRespondToHelpCall()
	return true
end

function AIRadiantRoshanBehavior:IsCanTargetNeutralCreeps()
	return false
end

function AIRadiantRoshanBehavior:IsBindedToZone()
	return false
end

function Spawn(entityKeyValues)
	if(not IsServer()) then
		return
	end
	if(thisEntity == nil) then
		return
	end
	AICore:Init(thisEntity, AIRadiantRoshanBehavior)
end
