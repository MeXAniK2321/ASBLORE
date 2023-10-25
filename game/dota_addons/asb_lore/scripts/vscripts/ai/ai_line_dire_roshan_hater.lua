require('ai/core/ai_core')

AILineDireRoshanHaterBehavior = class(GenericAIBehavior)

function AILineDireRoshanHaterBehavior:IsCanRetreatToSpawnPosition()
    return false
end

function AILineDireRoshanHaterBehavior:IsCanRespondToHelpCall()
	return false
end

function AILineDireRoshanHaterBehavior:IsCanTargetNeutralCreeps()
	return false
end

function AILineDireRoshanHaterBehavior:IsBindedToZone()
	return false
end

function AILineDireRoshanHaterBehavior:IsCanAdjustPathToGoal()
	return true
end

function AILineDireRoshanHaterBehavior:EnemyUnitFilterCustom(thisEntity, target)
    if(target:GetUnitLabel() == "roshan") then
        return true
    end
	return false
end

function AILineDireRoshanHaterBehavior:IsCompletelyForgetAboutInvisibleEnemies()
	return true
end

function AILineDireRoshanHaterBehavior:OnInit(thisEntity)
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
	AICore:Init(thisEntity, AILineDireRoshanHaterBehavior)
end
