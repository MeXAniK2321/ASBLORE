require('ai/core/ai_core')

AILineDireFinalBossBehavior = class(GenericAIBehavior)

function AILineDireFinalBossBehavior:IsCanRetreatToSpawnPosition()
    return false
end

function AILineDireFinalBossBehavior:IsCanRespondToHelpCall()
	return false
end

function AILineDireFinalBossBehavior:IsCanTargetNeutralCreeps()
	return false
end

function AILineDireFinalBossBehavior:IsBindedToZone()
	return false
end

function AILineDireFinalBossBehavior:IsCanAdjustPathToGoal()
	return true
end

function AILineDireFinalBossBehavior:IsCompletelyForgetAboutInvisibleEnemies()
	return true
end

function AILineDireFinalBossBehavior:OnInit(thisEntity)
    local waypoint = AIBehaviors:GetDireFinalBossInitialGoalEntity()
    AICore:SetInitialGoalEntity(thisEntity, waypoint)
end

function Spawn(entityKeyValues)
	if(not IsServer()) then
		return
	end
	if(thisEntity == nil) then
		return
	end
	AICore:Init(thisEntity, AILineDireFinalBossBehavior)
end
