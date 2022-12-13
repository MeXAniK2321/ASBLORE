modifier_debuff_chance = class({})
function modifier_debuff_chance:IsHidden() return true end
function modifier_debuff_chance:IsDedebuff() return false end
function modifier_debuff_chance:IsPurgable() return true end
function modifier_debuff_chance:IsPurgeException() return true end
function modifier_debuff_chance:RemoveOnDeath() return true end

function modifier_debuff_chance:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
		self.tier = 10
		self.tier1 = 5
	local caster = self:GetCaster()
	local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
 
	
if RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_1", {duration = 60})
   	     EmitSoundOnClient("star.debuff_1", Player)
	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_2", {duration = 60})
        EmitSoundOnClient("star.debuff_2", Player)

   	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_3", {duration = 60})
        EmitSoundOnClient("star.debuff_3", Player)

		
   	
	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_7", {duration = 60})
  EmitSoundOnClient("star.debuff_7", Player)

   	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_8", {duration = 60})
    EmitSoundOnClient("star.debuff_8", Player)
	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_9", {duration = 60})
		EmitSoundOnClient("star.debuff_9", Player)
   	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_10", {duration = 60})
		EmitSoundOnClient("star.debuff_10", Player)
		elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_1", {duration = 60})
   	     EmitSoundOnClient("star.debuff_1", Player)
	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_2", {duration = 60})
        EmitSoundOnClient("star.debuff_2", Player)

   	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_3", {duration = 60})
        EmitSoundOnClient("star.debuff_3", Player)

	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_7", {duration = 60})
  EmitSoundOnClient("star.debuff_7", Player)

   	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_8", {duration = 60})
    EmitSoundOnClient("star.debuff_8", Player)
	
	elseif RollPercentage(self.tier) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_9", {duration = 60})
		EmitSoundOnClient("star.debuff_9", Player)
   	
	elseif RollPercentage(self.tier1) then
    	self:Buff()
		caster:AddNewModifier(caster, self, "modifier_debuff_10", {duration = 30})
		EmitGlobalSound("star.let_me_die")
		else
	self:Buff()
	caster:AddNewModifier(caster, self, "modifier_debuff_1", {duration = 60})
   	EmitSoundOnClient("star.debuff_1", Player)
	

end
end

function modifier_debuff_chance:Buff()
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
function modifier_debuff_chance:OnDestroy()
	local caster = self:GetCaster()
	
	
	 local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
	
	
        for i = 1, 10  do
		    StopSoundOn( "star.buff_"..i, Player )
			
		end
		 for i = 1, 10  do
			StopSoundOn("star.debuff_"..i, Player )
		end
	
end


function modifier_debuff_chance:OnRefresh(table)
	self:OnCreated(table)
end

function modifier_debuff_chance:GetTexture()
	return "note"
end
