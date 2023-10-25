require('ai/core/ai_core')

AILineAllianceBehavior = class(GenericAIBehavior)

function AILineAllianceBehavior:IsCanRetreatToSpawnPosition()
    return false
end

function AILineAllianceBehavior:IsCanRespondToHelpCall()
	return false
end

function AILineAllianceBehavior:IsCanTargetNeutralCreeps()
	return false
end

function AILineAllianceBehavior:IsBindedToZone()
	return false
end

function AILineAllianceBehavior:IsCanAdjustPathToGoal()
	return true
end

function AILineAllianceBehavior:IsCompletelyForgetAboutInvisibleEnemies()
	return true
end

function AILineAllianceBehavior:OnInit(thisEntity)
    local waypoint = AIBehaviors:GetAllianceInitialGoalEntity()
    AICore:SetInitialGoalEntity(thisEntity, waypoint)
end

function Spawn(entityKeyValues)
	if(not IsServer()) then
		return
	end
	if(thisEntity == nil) then
		return
	end
	AICore:Init(thisEntity, AILineAllianceBehavior)
end