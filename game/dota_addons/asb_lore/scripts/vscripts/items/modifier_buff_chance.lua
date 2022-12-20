modifier_buff_chance = class({})
function modifier_buff_chance:IsHidden() return true end
function modifier_buff_chance:IsDebuff() return false end
function modifier_buff_chance:IsPurgable() return true end
function modifier_buff_chance:IsPurgeException() return true end
function modifier_buff_chance:RemoveOnDeath() return true end

function modifier_buff_chance:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
		self.tier = 10
	local caster = self:GetCaster()
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	
if RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_1", {duration = 60})
   	     EmitSoundOnClient("star.buff_1", Player)
	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_2", {duration = 60})
        EmitSoundOnClient("star.buff_2", Player)

   	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_3", {duration = 60})
        EmitSoundOnClient("star.buff_3", Player)
	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_4", {duration = 60})
		EmitSoundOnClient("star.buff_4", Player)
   	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_5", {duration = 60})
		EmitSoundOnClient("star.buff_5", Player)
		elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_6", {duration = 60})
		EmitSoundOnClient("star.buff_6", Player)
   	
	
	

   	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_8", {duration = 60})
    EmitSoundOnClient("star.buff_8", Player)
	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_9", {duration = 60})
		EmitSoundOnClient("star.buff_9", Player)
   	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_10", {duration = 60})
		EmitSoundOnClient("star.buff_10", Player)
		elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_1", {duration = 60})
   	     EmitSoundOnClient("star.buff_1", Player)
	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_2", {duration = 60})
        EmitSoundOnClient("star.buff_2", Player)

   	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_3", {duration = 60})
        EmitSoundOnClient("star.buff_3", Player)
	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_4", {duration = 60})
		EmitSoundOnClient("star.buff_4", Player)
   	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_5", {duration = 60})
		EmitSoundOnClient("star.buff_5", Player)
		elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_6", {duration = 60})
		EmitSoundOnClient("star.buff_6", Player)
   	


   	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_8", {duration = 60})
    EmitSoundOnClient("star.buff_8", Player)
	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_9", {duration = 60})
		EmitSoundOnClient("star.buff_9", Player)
   	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_buff_10", {duration = 60})
		EmitSoundOnClient("star.buff_10", Player)
		else
	self:Buff()
	caster:AddNewModifier(caster, self, "modifier_buff_1", {duration = 60})
   	EmitSoundOnClient("star.buff_1", Player)
	

end
end

function modifier_buff_chance:Buff()
	local caster = self:GetCaster()
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	
        for i = 1, 10  do
			StopSoundOn("star.buff_"..i, Player)
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
StopSoundOn("spamton.neo_theme", Player)
	
end
function modifier_buff_chance:OnDestroy()
	local caster = self:GetCaster()
	 local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	
	
        for i = 1, 10  do
		    StopSoundOn( "star.buff_"..i, Player )
			
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player )
		end
	
end


function modifier_buff_chance:OnRefresh(table)
	self:OnCreated(table)
end

function modifier_buff_chance:GetTexture()
	return "note"
end
