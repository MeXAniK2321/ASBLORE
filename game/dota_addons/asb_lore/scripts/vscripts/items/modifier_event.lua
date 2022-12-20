modifier_event = class({})
function modifier_event:IsHidden() return true end
function modifier_event:IsDebuff() return false end
function modifier_event:IsPurgable() return true end
function modifier_event:IsPurgeException() return true end
function modifier_event:RemoveOnDeath() return true end

function modifier_event:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
		self.tier = 50
	local caster = self:GetCaster()
	
	if IsServer() then
		
			for i = 1, 2 do
			StopGlobalSound("star.event_"..i)
		end
	end
	
if RollPercentage(self.tier) then
    	
		caster:AddNewModifier(caster, self, "modifier_event_1", {duration = 60})
   	EmitGlobalSound("star.event_1")
	
	else
    
		caster:AddNewModifier(caster, self, "modifier_event_2", {duration = 60})
  	EmitGlobalSound("star.event_2")
end
self:StartIntervalThink(2)
end

function modifier_event:OnIntervalThink()
	local caster = self:GetCaster()
	
	
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
		for i = 1, 8 do
			StopGlobalSound("star.horn_special_"..i)
			end
	StopGlobalSound("spamton.theme")
StopGlobalSound("spamton.neo_theme")
end

function modifier_event:OnRefresh(table)
	self:OnCreated(table)
end

function modifier_event:GetTexture()
	return "note"
end