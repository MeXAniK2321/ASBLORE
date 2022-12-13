pika_casino = class({})
function pika_casino:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
local random = RandomFloat(0,10)
local chance = random 
if chance > 5 then
self.gold = self:GetSpecialValueFor("gold") * random
self:PlayEffects1()
else
self.gold = (-1 *(self:GetSpecialValueFor("gold"))) * random 
self:PlayEffects2()
end
	PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), self.gold, false, DOTA_ModifyGold_Unspecified )


	
	
end
function pika_casino:PlayEffects1()
	-- Get Resources
	local sound_cast = "anime_chatwheel_non_sorted_6_7"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function pika_casino:PlayEffects2()
	-- Get Resources
	local sound_cast = "chatwheel.81"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end