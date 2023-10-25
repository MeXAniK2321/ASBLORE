require('ai/core/ai_core')

AILineDireBehavior = class(GenericAIBehavior)

function AILineDireBehavior:IsCanRetreatToSpawnPosition()
    return false
end

function AILineDireBehavior:IsCanRespondToHelpCall()
	return false
end

function AILineDireBehavior:IsCanTargetNeutralCreeps()
	return false
end

function AILineDireBehavior:IsBindedToZone()
	return false
end

function AILineDireBehavior:IsCanAdjustPathToGoal()
	return true
end

function AILineDireBehavior:IsCompletelyForgetAboutInvisibleEnemies()
	return true
end

function AILineDireBehavior:OnInit(thisEntity)
    local waypoint = AIBehaviors:GetDireLineInitialGoalEntity()
    AICore:SetInitialGoalEntity(thisEntity, waypoint)
end

function Spawn(entityKeyValues)
	if(not IsServer()) then
		return
	end
	if(thisEntity == nil) then
		return
	end
	AICore:Init(thisEntity, AILineDireBehavior)
end
