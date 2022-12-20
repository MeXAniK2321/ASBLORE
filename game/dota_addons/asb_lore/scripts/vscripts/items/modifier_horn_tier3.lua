modifier_horn_tier3 = class({})
function modifier_horn_tier3:IsHidden() return true end
function modifier_horn_tier3:IsDebuff() return false end
function modifier_horn_tier3:IsPurgable() return false end
function modifier_horn_tier3:IsPurgeException() return false end
function modifier_horn_tier3:RemoveOnDeath() return false end

function modifier_horn_tier3:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	
	local caster = self:GetCaster()
	
	
	if IsServer() then
		
			for i = 1, 6 do
			StopGlobalSound("star.horn_"..i)
			end
			for i = 1, 50 do
			StopGlobalSound("star.theme2_"..i)
			end
			for i = 1, 8 do
			StopGlobalSound("star.horn_special_"..i)
			end
			self:StartIntervalThink(3)
			
		
		
	
	local player = self:GetCaster()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	    local arcana = 137775440 --My
		local arcana1 = 418417801   --Chumba
		local arcana3 = 174719954  --PIDOR
	local arcana2 = 167912041	--Miku
    local arcana6 = 222299685	--Kepchila
	local arcana7 = 117795030   --Tlen
	local arcana8 = 413962327 --WOMAN
    

	caster:AddNewModifier(caster, self, "modifier_horn_7", {duration = 60})
	 if id32 == arcana then
	 EmitGlobalSound("star.horn_special_8")
	 elseif id32 == arcana1 then
	 EmitGlobalSound("star.horn_special_2")
	 elseif id32 == arcana2 then
	 EmitGlobalSound("star.horn_special_3")
	 elseif id32 == arcana3 then
	 EmitGlobalSound("star.horn_special_4")
	 elseif id32 == arcana6 then
    EmitGlobalSound("star.horn_special_5")	 
	 elseif id32 == arcana7 then
	 EmitGlobalSound("star.horn_special_6")
	 elseif id32 == arcana8 then
	 EmitGlobalSound("star.horn_special_7")
	 else
  	EmitGlobalSound("star.horn_special_1")
	
	


end
end
end

function modifier_horn_tier3:OnIntervalThink()
	local caster = self:GetCaster()
	StopGlobalSound("spamton.theme")
	StopGlobalSound("spamton.neo_theme")
	
        for i = 1, 10  do
			StopGlobalSound("star.buff_"..i)
		end
		 for i = 1, 10  do
			StopGlobalSound("star.debuff_"..i)
		end
		for i = 1, 50 do
			StopGlobalSound("star.theme2_"..i)
		end
		for i = 1, 5 do
			StopGlobalSound("star.horn_"..i)
		end
		for i = 1, 50 do
			StopGlobalSound("star.theme_"..i)
		end
	
end

function modifier_horn_tier3:OnRefresh(table)
	self:OnCreated(table)
end

function modifier_horn_tier3:GetTexture()
	return "note"
end