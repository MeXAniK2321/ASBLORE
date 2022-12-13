modifier_spd_chance = class({})
function modifier_spd_chance:IsHidden() return false end
function modifier_spd_chance:IsDebuff() return false end
function modifier_spd_chance:IsPurgable() return true end
function modifier_spd_chance:IsPurgeException() return true end
function modifier_spd_chance:RemoveOnDeath() return true end


function modifier_spd_chance:OnCreated(table)
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
		self.tier5 = self.ability:GetSpecialValueFor("tier1_chance")
	self.tier1 = self.ability:GetSpecialValueFor("tier2_chance")
	self.tier2 = self.ability:GetSpecialValueFor("tier3_chance")
	self.tier3 = self.ability:GetSpecialValueFor("tier4_chance")
	self.tier4 = self.ability:GetSpecialValueFor("tier5_chance")
	local caster = self:GetCaster()
	
	
	
if RollPercentage(self.tier5) then
    	self:Buff1()
		caster:AddNewModifier(caster, self, "modifier_spd_1", {duration = 60})
   	
	
	elseif RollPercentage(self.tier4) then
    	self:Buff2()
		caster:AddNewModifier(caster, self, "modifier_spd_2", {duration = 60})
   	

   	elseif RollPercentage(self.tier3) then
    	self:Buff3()
	
    caster:AddNewModifier(caster, self, "modifier_spd_3", {duration = 60})
	
	elseif RollPercentage(self.tier2) then
    	self:Buff4()
	caster:AddNewModifier(caster, self, "modifier_spd_4", {duration = 60})
   
	elseif RollPercentage(self.tier1) then
    	self:Buff5()
	caster:AddNewModifier(caster, self, "modifier_spd_5", {duration = 60})
	else
	self:Buff1()
	caster:AddNewModifier(caster, self, "modifier_spd_1", {duration = 60})
   	end
	

end

function modifier_spd_chance:Buff1()
self.stat = 10
	local caster = self:GetCaster()
	StopGlobalSound("attack.1")
	StopGlobalSound("spd.1")
	StopGlobalSound("armor.1")
	StopGlobalSound("diff.1")
    EmitGlobalSound("spd.1")
	
	
end
function modifier_spd_chance:Buff2()
self.stat = 20
	local caster = self:GetCaster()
	StopGlobalSound("attack.1")
	StopGlobalSound("spd.1")
	StopGlobalSound("armor.1")
	StopGlobalSound("diff.1")
	StopGlobalSound("attack.2")
	StopGlobalSound("spd.2")
	StopGlobalSound("armor.2")
	StopGlobalSound("diff.2")
    EmitGlobalSound("spd.2")
	self:StartIntervalThink(2)
	
end
function modifier_spd_chance:Buff3()
self.stat = 30
	local caster = self:GetCaster()
	StopGlobalSound("attack.1")
	StopGlobalSound("spd.1")
	StopGlobalSound("armor.1")
	StopGlobalSound("diff.1")
	StopGlobalSound("attack.2")
	StopGlobalSound("spd.2")
	StopGlobalSound("armor.2")
	StopGlobalSound("diff.2")
		StopGlobalSound("attack.3")
	StopGlobalSound("spd.3")
	StopGlobalSound("armor.3")
	StopGlobalSound("diff.3")
    EmitGlobalSound("spd.3")
	self:StartIntervalThink(2)
	
end
function modifier_spd_chance:Buff4()
self.stat = 40
	local caster = self:GetCaster()
	StopGlobalSound("attack.1")
	StopGlobalSound("spd.1")
	StopGlobalSound("armor.1")
	StopGlobalSound("diff.1")
	StopGlobalSound("attack.2")
	StopGlobalSound("spd.2")
	StopGlobalSound("armor.2")
	StopGlobalSound("diff.2")
		StopGlobalSound("attack.3")
	StopGlobalSound("spd.3")
	StopGlobalSound("armor.3")
	StopGlobalSound("diff.3")
			StopGlobalSound("attack.4")
	StopGlobalSound("spd.4")
	StopGlobalSound("armor.4")
	StopGlobalSound("diff.4")
    EmitGlobalSound("spd.4")
	
	
		for i = 1, 100 do
			StopGlobalSound("star.theme_"..i)
		end
	self:StartIntervalThink(2)
	
end
function modifier_spd_chance:Buff5()
    self.stat = 50
	local caster = self:GetCaster()
	StopGlobalSound("attack.1")
	StopGlobalSound("spd.1")
	StopGlobalSound("armor.1")
	StopGlobalSound("diff.1")
	StopGlobalSound("attack.2")
	StopGlobalSound("spd.2")
	StopGlobalSound("armor.2")
	StopGlobalSound("diff.2")
		StopGlobalSound("attack.3")
	StopGlobalSound("spd.3")
	StopGlobalSound("armor.3")
	StopGlobalSound("diff.3")
			StopGlobalSound("attack.4")
	StopGlobalSound("spd.4")
	StopGlobalSound("armor.4")
	StopGlobalSound("diff.4")
			StopGlobalSound("attack.5")
	StopGlobalSound("spd.5")
	StopGlobalSound("armor.5")
	StopGlobalSound("diff.5")
    EmitGlobalSound("spd.5")
	
		for i = 1, 100 do
			StopGlobalSound("star.theme2_"..i)
		end
		for i = 1, 100 do
			StopGlobalSound("star.theme_"..i)
		end
	self:StartIntervalThink(2)
	
end
function modifier_spd_chance:OnIntervalThink()
	if IsServer() then
		if self.stat > 0 and self.stat < 19 then
	elseif self.stat > 19 and self.stat < 29 then
		StopGlobalSound("attack.1")
	StopGlobalSound("spd.1")
	StopGlobalSound("armor.1")
	StopGlobalSound("diff.1")
	elseif self.stat > 29 and self.stat < 39  then
		StopGlobalSound("attack.1")
	StopGlobalSound("spd.1")
	StopGlobalSound("armor.1")
	StopGlobalSound("diff.1")
	StopGlobalSound("attack.2")
	StopGlobalSound("spd.2")
	StopGlobalSound("armor.2")
	StopGlobalSound("diff.2")
	elseif self.stat > 40 and self.stat < 49  then
		StopGlobalSound("attack.1")
	StopGlobalSound("spd.1")
	StopGlobalSound("armor.1")
	StopGlobalSound("diff.1")
	StopGlobalSound("attack.2")
	StopGlobalSound("spd.2")
	StopGlobalSound("armor.2")
	StopGlobalSound("diff.2")
		StopGlobalSound("attack.3")
	StopGlobalSound("spd.3")
	StopGlobalSound("armor.3")
	StopGlobalSound("diff.3")
	elseif self.stat > 49 then 
		StopGlobalSound("attack.1")
	StopGlobalSound("spd.1")
	StopGlobalSound("armor.1")
	StopGlobalSound("diff.1")
	StopGlobalSound("attack.2")
	StopGlobalSound("spd.2")
	StopGlobalSound("armor.2")
	StopGlobalSound("diff.2")
		StopGlobalSound("attack.3")
	StopGlobalSound("spd.3")
	StopGlobalSound("armor.3")
	StopGlobalSound("diff.3")
			StopGlobalSound("attack.4")
	StopGlobalSound("spd.4")
	StopGlobalSound("armor.4")
	StopGlobalSound("diff.4")
	
		for i = 1, 100 do
			StopGlobalSound("star.theme_"..i)
		end
	end
	end
end
function modifier_spd_chance:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_spd_chance:GetEffectName()
	return "particles/holy_lyre_aura_spd.vpcf"
end
function modifier_spd_chance:GetTexture()
	return "note"
end
function modifier_spd_chance:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end