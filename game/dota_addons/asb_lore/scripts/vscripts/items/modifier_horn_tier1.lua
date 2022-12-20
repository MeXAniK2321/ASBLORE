modifier_horn_tier1 = class({})
function modifier_horn_tier1:IsHidden() return true end
function modifier_horn_tier1:IsDebuff() return false end
function modifier_horn_tier1:IsPurgable() return false end
function modifier_horn_tier1:IsPurgeException() return false end
function modifier_horn_tier1:RemoveOnDeath() return false end

function modifier_horn_tier1:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
		self.tier = 45
	local caster = self:GetCaster()
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	local song  = RandomInt(1,7)
	

if song == 1 then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_horn_1", {duration = 60})
        EmitSoundOnClient("star.horn_1", Player)


		elseif  song == 2 then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_horn_5", {duration = 60})
        EmitSoundOnClient("star.horn_5", Player)

   	elseif  song == 3 then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_horn_1_2", {duration = 60})
        EmitSoundOnClient("star.debuff_5", Player)
		 	elseif  song == 4 then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_horn_4", {duration = 60})
        EmitSoundOnClient("star.horn_4", Player)
		 	elseif  song == 5 then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_horn_6", {duration = 60})
        EmitSoundOnClient("star.horn_6", Player)
				 	elseif  song == 6 then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_horn_3", {duration = 60})
        EmitSoundOnClient("star.horn_3", Player)
				 	elseif  song == 7 then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_horn_2", {duration = 60})
        EmitSoundOnClient("star.horn_2", Player)
		
	
	else
    	
	end

end


function modifier_horn_tier1:Buff()
	local caster = self:GetCaster()
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	for i = 1, 6 do
			StopSoundOn("star.horn_"..i, Player)
			end
        for i = 1, 10  do
			StopSoundOn("star.buff_"..i, Player)
		end
		  for i = 1, 3  do
			StopSoundOn("star.horn_"..i, Player)
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player)
		end
	
		for i = 1, 50 do
			StopSoundOn("star.theme2_"..i, Player)
		end
		for i = 1, 50 do
			StopSoundOn("star.theme_"..i, Player)
		end
	StopSoundOn("spamton.theme", Player)
end
function modifier_horn_tier1:OnDestroy()
	local caster = self:GetCaster()
	 local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	for i = 1, 6 do
			StopSoundOn("star.horn_"..i, Player)
			end
	
        for i = 1, 10  do
		    StopSoundOn( "star.buff_"..i, Player )
			
		end
		 for i = 1, 3  do
			StopSoundOn("star.horn_"..i, Player)
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player )
		end
	
end


function modifier_horn_tier1:OnRefresh(table)
	self:OnCreated(table)
end

function modifier_horn_tier1:GetTexture()
	return "note"
end
