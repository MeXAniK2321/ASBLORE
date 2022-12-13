modifier_horn_tier2 = class({})
function modifier_horn_tier2:IsHidden() return true end
function modifier_horn_tier2:IsDebuff() return false end
function modifier_horn_tier2:IsPurgable() return false end
function modifier_horn_tier2:IsPurgeException() return false end
function modifier_horn_tier2:RemoveOnDeath() return false end

function modifier_horn_tier2:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
		self.tier = 50
	local caster = self:GetCaster()
	local song  = RandomInt(1,3)
	
	if IsServer() then
		StopGlobalSound("spamton.theme")
		StopGlobalSound("spamton.neo_theme")
			for i = 1, 6 do
			StopGlobalSound("star.horn_"..i)
			for i = 1, 50 do
			StopGlobalSound("star.theme2_"..i)
		end
		end
	end
	
if song == 1 then
    	
		caster:AddNewModifier(caster, self, "modifier_horn_4", {duration = 60})
   	EmitGlobalSound("star.horn_4")
	
	elseif song == 2 then
    
		caster:AddNewModifier(caster, self, "modifier_horn_5", {duration = 60})
  	EmitGlobalSound("star.horn_5")
	elseif  song == 3 then
	caster:AddNewModifier(caster, self, "modifier_horn_6", {duration = 60})
  	EmitGlobalSound("star.horn_6")
	else
	
end
self:StartIntervalThink(2)
end

function modifier_horn_tier2:OnIntervalThink()
	local caster = self:GetCaster()
	
	
        for i = 1, 10  do
			StopGlobalSound("star.buff_"..i)
		end
		 for i = 1, 10  do
			StopGlobalSound("star.debuff_"..i)
		end
		for i = 1, 50 do
			StopGlobalSound("star.theme_"..i)
		end
				StopGlobalSound("spamton.theme")

	
end

function modifier_horn_tier2:OnRefresh(table)
	self:OnCreated(table)
end

function modifier_horn_tier2:GetTexture()
	return "note"
end