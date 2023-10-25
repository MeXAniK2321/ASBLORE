require('ai/core/ai_core')

AILineRadiantBehavior = class(GenericAIBehavior)

function AILineRadiantBehavior:IsCanRetreatToSpawnPosition()
    return false
end

function AILineRadiantBehavior:IsCanRespondToHelpCall()
	return false
end

function AILineRadiantBehavior:IsCanTargetNeutralCreeps()
	return false
end

function AILineRadiantBehavior:IsBindedToZone()
	return false
end

function AILineRadiantBehavior:IsCompletelyForgetAboutInvisibleEnemies()
	return true
end

-- They may be too smart and trigger bottom base shit too early
function AILineRadiantBehavior:IsCanAdjustPathToGoal()
	return false
end

function AILineRadiantBehavior:OnInit(thisEntity)
    local waypoint = AIBehaviors:GetRadiantLineInitialGoalEntity()
    AICore:SetInitialGoalEntity(thisEntity, waypoint)
end

function Spawn(entityKeyValues)
	if(not IsServer()) then
		return
	end
	if(thisEntity == nil) then
		return
	end
	AICore:Init(thisEntity, AILineRadiantBehavior)
end
