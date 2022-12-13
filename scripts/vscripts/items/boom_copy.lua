LinkLuaModifier("modifier_item_anime_boombox", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox_drop", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_anime_boombox_stop", "items/item_anime_boombox", LUA_MODIFIER_MOTION_NONE)

item_anime_boombox = class({})

function item_anime_boombox:IsStealable() return true end
function item_anime_boombox:IsHiddenWhenStolen() return false end
function item_anime_boombox:GetIntrinsicModifierName()
	return "modifier_item_anime_boombox_drop"
end
function item_anime_boombox:OnOwnerDied()
	local caster = self:GetCaster()
	local vPosition = caster:GetAbsOrigin()
	--print('ananna')
	if self and not self:IsNull() then--and self:IsDroppable() then
		--caster:DropItemAtPositionImmediate(self, vPosition)
		--print(vPosition)
	end
end
function item_anime_boombox:OnSpellStart()
	local caster = self:GetCaster()

	caster:AddNewModifier(caster, self, "modifier_item_anime_boombox", {})

	--[[local heroeskv = LoadKeyValues("scripts/npc/herolist.txt")
	for hero, _ in ipairs(heroeskv) do
		if _ > 0 then
			print(hero)
		end
	end]]

	
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_anime_boombox_drop = class({})
function modifier_item_anime_boombox_drop:IsHidden() return true end
function modifier_item_anime_boombox_drop:IsDebuff() return false end
function modifier_item_anime_boombox_drop:IsPurgable() return false end
function modifier_item_anime_boombox_drop:IsPurgeException() return false end
function modifier_item_anime_boombox_drop:RemoveOnDeath() return false end
function modifier_item_anime_boombox_drop:DeclareFunctions()
	local func = { MODIFIER_EVENT_ON_DEATH, }
	return func
end
function modifier_item_anime_boombox_drop:OnDeath(keys)
	if IsServer() then
		if keys.unit == self:GetParent() and keys.unit:IsRealHero() and not keys.unit:HasModifier("modifier_fountain_aura_buff") then
			self:GetParent():DropItemAtPositionImmediate(self:GetAbility(), self:GetParent():GetAbsOrigin())
		end
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_item_anime_boombox = class({})
function modifier_item_anime_boombox:IsHidden() return false end
function modifier_item_anime_boombox:IsDebuff() return false end
function modifier_item_anime_boombox:IsPurgable() return false end
function modifier_item_anime_boombox:IsPurgeException() return false end
function modifier_item_anime_boombox:RemoveOnDeath() return true end
--function modifier_item_anime_boombox:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_anime_boombox:CheckState()
	local state = { [MODIFIER_STATE_PROVIDES_VISION] = true, }

	return state
end
function modifier_item_anime_boombox:DeclareFunctions()
	local func = { MODIFIER_EVENT_ON_DEATH, }
	return func
end
function modifier_item_anime_boombox:OnDeath(keys)
	--print("NANI")
end
function modifier_item_anime_boombox:OnCreated(table)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	
	self.theme_chance = self.ability:GetSpecialValueFor("theme_chance")
	self.memes_chance = self.ability:GetSpecialValueFor("memes_chance")
	self.legends_chance = self.ability:GetSpecialValueFor("legends_chance")
	

	if not IsServer() or not self.parent:IsRealHero() then
		return nil
	end

	self:StopAllMusic()

	local SoundForEmit = "item_anime_boombox_"
	self.SoundForEmit = nil

    
    --for k,v in pairs(self.hero_table) do print(k,v) end

   

    if RollPercentage(self.theme_chance) then
    	self.SoundForEmit = SoundForEmit.."anime_themes_anime_theme_"..RandomInt(1, 49)
   	end

   	if RollPercentage(self.memes_chance) then
    	self.SoundForEmit = SoundForEmit.."anime_memes_anime_meme_"..RandomInt(1, 47)
    end
	
	if RollPercentage(self.legends_chance) then
    	self.SoundForEmit = SoundForEmit.."anime_legends_anime_legend_"..RandomInt(1, 26)
   	end

   

    self:StartIntervalThink(0.5)

    if not self.SoundFX then
	   self.SoundFX = ParticleManager:CreateParticle("particles/heroes/miku/miku_song_aura.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)

	    self:AddParticle(self.SoundFX, false, false, -1, false, true)
	end
end
function modifier_item_anime_boombox:OnIntervalThink()
	if not self or self:IsNull() or not self.SoundForEmit then
		self:Destroy()

		return nil
	end

	print(self.SoundForEmit)
	EmitGlobalSound(self.SoundForEmit)

	self:StartIntervalThink(-1)
end
function modifier_item_anime_boombox:OnRefresh(table)
	self:OnCreated(table)
end
function modifier_item_anime_boombox:OnDestroy()
	if IsServer() then
		self:StopAllMusic()
	end
end


function modifier_item_anime_boombox:StopAllMusic()
	if IsServer() then
		

		for i = 1, 49 do
			StopGlobalSound("item_anime_boombox_anime_themes_anime_theme_"..i)
		end

		for i = 1, 47 do
			StopGlobalSound("item_anime_boombox_anime_memes_anime_meme_"..i)
		end
		for i = 1, 26 do
			StopGlobalSound("item_anime_boombox_anime_legends_anime_legend_"..i)
		end

		

		EmitGlobalSound("item_anime_boombox_cast_"..RandomInt(1, 3))
	end
end
modifier_item_anime_boombox_stop = class({})

function modifier_item_anime_boombox_stop:StopAllMusic()
	if IsServer() then
	
	
		

		for i = 1, 49 do
			StopGlobalSound("item_anime_boombox_anime_themes_anime_theme_"..i)
		end

		for i = 1, 47 do
			StopGlobalSound("item_anime_boombox_anime_memes_anime_meme_"..i)
		end
		for i = 1, 26 do
			StopGlobalSound("item_anime_boombox_anime_legends_anime_legend_"..i)
		end

	

		
	end
end