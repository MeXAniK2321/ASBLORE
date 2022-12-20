if Round == nil then Round = class({}) end
nBasePrepareTotalTime=15

if IsInToolsMode() then
    nBasePrepareTotalTime=8
end

nRoundLimitTime=50
if IsInToolsMode() then
    --nRoundLimitTime=50
end
nRoundBaseBonus=300

function Round:Prepare(nRoundNumber)

    self.nRoundNumber=nRoundNumber
    
    if nRoundNumber>=1 then
       GameRules:SetSafeToLeave(true)
    end

    --玩家关卡排名
    self.nPlayerRank = 0
        
    self.nPrepareTotalTime = nBasePrepareTotalTime

    self.readyPlayers = {}

    --整理有效队伍
    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
      if bAlive then
          for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
            if PlayerResource:IsValidPlayer(nPlayerID) and  PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED  then
                self.readyPlayers[nPlayerID] = false
            end
          end
       end
    end
    
 

    if GetMapName()=="2x6" then
       nRoundBaseBonus = 320
    end

    if GetMapName()=="5v5" then
       nRoundBaseBonus = 350
    end

    --过关奖励第一名100% 第二名递减 ,65轮以上不再提高
    if tonumber(nRoundNumber)<65 then
       self.flBonus = nRoundBaseBonus * math.pow(1.031, (tonumber(nRoundNumber)-1))
    else
       self.flBonus = nRoundBaseBonus * math.pow(1.031, 65)
    end
    

    --1-10 Phase1  11-20 Phase2 21-30 Phase3.....
    local nPhase = math.ceil(nRoundNumber/10)

    -- 50 阶段以上未定义，从5-49轮里面随机抽取
    if GameMode.vRoundList[nPhase] ==nil then
       local nRandomPhase = RandomInt(5, 49)
       --随机取一份
       GameMode.vRoundList[nPhase] = table.deepcopy(GameMode.vRoundListFull[nRandomPhase])
    end

    self.sRoundName = table.random(GameMode.vRoundList[nPhase])
    for i,v in ipairs(GameMode.vRoundList[nPhase]) do
        if v == self.sRoundName then
            table.remove(GameMode.vRoundList[nPhase], i)
        end
    end
    
    --统计怪物数量
    for k,vData in pairs(GameMode.vRoundData[self.sRoundName]) do
       self.nCreatureNumber = tonumber(vData.UnitNumber)
    end
    
    --经验倍率
    self.flExpMulti = 1 
    
    if GetMapName()=="2x6" then
       self.flExpMulti = 2
    end

    if GetMapName()=="5v5" then
       self.flExpMulti = 5
    end

    --本轮进行PVP 进行PVP相关准备
    if self.nRoundNumber - PvpModule.nLastPvpRound >= PvpModule.nInterval then
       --肉山轮不进行PVP
       if self.sRoundName~="Round_Roshan" then

          --PVP轮延长准备时间
          if GetMapName()=="1x8" then
             self.nPrepareTotalTime = self.nPrepareTotalTime + 2
          end

          if GetMapName()=="2x6" then
             self.nPrepareTotalTime = self.nPrepareTotalTime + 5
          end

          PvpModule:RoundPrepare(self.nRoundNumber)
       end
    end
    
    --准备时间
    self.nPrepareTime = 0

    CustomGameEventManager:Send_ServerToAllClients("CreateQuest", { name = "RoundPrepare", text = "#round_prepare", svalue = 0, evalue = self.nPrepareTotalTime, text_value=self.nRoundNumber, text_value_2="#"..self.sRoundName })
    CustomGameEventManager:Send_ServerToAllClients("UpdateReadyButton", {visible=true})
    CustomGameEventManager:RegisterListener("PlayerReady",function(_, keys) self:PlayerReady(keys) end)


    Timers:CreateTimer(1, function()
           self.nPrepareTime = self.nPrepareTime+1
           CustomGameEventManager:Send_ServerToAllClients("RefreshQuest", { name = "RoundPrepare", text = "#round_prepare", svalue =self.nPrepareTime, evalue = self.nPrepareTotalTime, text_value=self.nRoundNumber,text_value_2="#"..self.sRoundName })
           CustomGameEventManager:Send_ServerToAllClients("UpdateConfirmButton", { currentTime =self.nPrepareTime, totalTime = self.nPrepareTotalTime })
           --如果关卡被强制结束
           if self.bEnd then
              CustomGameEventManager:Send_ServerToAllClients("RemoveQuest", { name = "RoundPrepare" })
              return nil
           end

           local bAllReady = true
           --遍历玩家是否准备成功
           for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
             if bAlive then
                for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                  if PlayerResource:IsValidPlayer(nPlayerID) and  PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED  then
                     if false==self.readyPlayers[nPlayerID] then
                         bAllReady = false
                     end
                  end
                end
             end
           end

           if bAllReady or (self.nPrepareTime >= self.nPrepareTotalTime) then
              self:Begin()
              return nil
           else
              return 1
           end
    end)
end
function Round:Prepare(nRoundNumber)
    
   
    self.bEnd = false
    self.nRoundNumber=nRoundNumber
    
    if nRoundNumber>=1 then
       GameRules:SetSafeToLeave(true)
    end

    --玩家关卡排名
    self.nPlayerRank = 0
        
    self.nPrepareTotalTime = nBasePrepareTotalTime

    self.readyPlayers = {}

    --整理有效队伍
    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
      if bAlive then
          for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
            if PlayerResource:IsValidPlayer(nPlayerID) and  PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED  then
                self.readyPlayers[nPlayerID] = false
            end
          end
       end
    end


 
       
      
    
    --统计存活玩家数量
    self.nAliveTeamNumber = 0 
    for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
      if bAlive then
        self.nAliveTeamNumber = self.nAliveTeamNumber+1
        --为玩家弹出选择技能
        if abilitySelectionRoundNumber[nRoundNumber] then
          for _,nPlayerID in ipairs(GameMode.vTeamPlayerMap[nTeamNumber]) do
              HeroBuilder:ShowRandomAbiliySelection(nPlayerID)
          end
        end
      end
    end

    if GetMapName()=="2x6" then
       nRoundBaseBonus = 320
    end

    if GetMapName()=="5v5" then
       nRoundBaseBonus = 350
    end

    --过关奖励第一名100% 第二名递减 ,65轮以上不再提高
    if tonumber(nRoundNumber)<65 then
       self.flBonus = nRoundBaseBonus * math.pow(1.031, (tonumber(nRoundNumber)-1))
    else
       self.flBonus = nRoundBaseBonus * math.pow(1.031, 65)
    end
    

    --1-10 Phase1  11-20 Phase2 21-30 Phase3.....
    local nPhase = math.ceil(nRoundNumber/10)

    -- 50 阶段以上未定义，从5-49轮里面随机抽取
    if GameMode.vRoundList[nPhase] ==nil then
       local nRandomPhase = RandomInt(5, 49)
       --随机取一份
       GameMode.vRoundList[nPhase] = table.deepcopy(GameMode.vRoundListFull[nRandomPhase])
    end

    self.sRoundName = table.random(GameMode.vRoundList[nPhase])
    for i,v in ipairs(GameMode.vRoundList[nPhase]) do
        if v == self.sRoundName then
            table.remove(GameMode.vRoundList[nPhase], i)
        end
    end
    
    
    
    --经验倍率
    self.flExpMulti = 1 
    
    if GetMapName()=="2x6" then
       self.flExpMulti = 2
    end

    if GetMapName()=="5v5" then
       self.flExpMulti = 5
    end


          --PVP轮延长准备时间
          if GetMapName()=="1x8" then
             self.nPrepareTotalTime = self.nPrepareTotalTime + 2
          end

          if GetMapName()=="2x6" then
             self.nPrepareTotalTime = self.nPrepareTotalTime + 5
          end

          PvpModule:RoundPrepare(self.nRoundNumber)
    
    
    --准备时间
    self.nPrepareTime = 0

           local bAllReady = true
           --遍历玩家是否准备成功
           for nTeamNumber,bAlive in pairs(GameMode.vAliveTeam) do
             if bAlive then
                for nPlayerID = 0, DOTA_MAX_TEAM_PLAYERS-1 do
                  if PlayerResource:IsValidPlayer(nPlayerID) and  PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED  then
                     if false==self.readyPlayers[nPlayerID] then
                         bAllReady = false
                     end
                  end
                end
             end
           end

           if bAllReady or (self.nPrepareTime >= self.nPrepareTotalTime) then
              self:Begin()
              return nil
           else
              return 1
           end
    end
	

function Round:End()
  self.bEnd = true
  if self.nRoundNumber then
     
  end
end
