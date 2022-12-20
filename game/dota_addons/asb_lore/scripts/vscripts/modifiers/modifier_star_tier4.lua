modifier_star_tier4 = class({})
function modifier_star_tier4:IsHidden() return true end
function modifier_star_tier4:IsDebuff() return false end
function modifier_star_tier4:IsPurgable() return false end
function modifier_star_tier4:IsPurgeException() return false end
function modifier_star_tier4:RemoveOnDeath() return true end
function modifier_star_tier4:OnCreated(table)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
	
	
	
	
	
	if IsServer() then
		self:StopAllMusic()
	end
	
	if caster:GetUnitName()== "npc_dota_hero_monkey_king" then
	EmitGlobalSound("star.theme2_17")
	else 
	end

	
	
	

	if not IsServer() or not self.parent:IsRealHero() then
		return nil
	end
	

	
end

function modifier_star_tier4:OnIntervalThink()
	if not self or self:IsNull()  then
		self:Destroy()

		return nil
	end

	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_item_anime_boombox", -- modifier name
		{ duration = 0.1 } -- kv
	)
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_star_tier1", -- modifier name
		{ duration = 0.1 } -- kv
	)
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_star_tier2", -- modifier name
		{ duration = 0.1 } -- kv
	)

	
end
function modifier_star_tier4:OnDestroy()
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	local caster = self:GetCaster()
if caster:GetUnitName()== "npc_dota_hero_monkey_king" then
	StopGlobalSound("star.theme2_17")
	else 
	end
end
function modifier_star_tier4:StopAllMusic()
	if IsServer() then
		

		for i = 1, 17 do
			StopGlobalSound("star.theme2_"..i)
		end

	
end
end