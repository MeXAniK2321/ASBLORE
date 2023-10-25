require('ai/core/ai_core')

AINeutralBehavior = class(GenericAIBehavior)

function AINeutralBehavior:IsCanRetreatToSpawnPosition()
    return true
end

function AINeutralBehavior:IsCanRespondToHelpCall()
	return true
end

function AINeutralBehavior:IsCanTargetNeutralCreeps()
	return true
end

function AINeutralBehavior:IsBindedToZone()
	return true
end

function Spawn(entityKeyValues)
	if(not IsServer()) then
		return
	end
	if(thisEntity == nil) then
		return
	end
	AICore:Init(thisEntity, AINeutralBehavior)
end