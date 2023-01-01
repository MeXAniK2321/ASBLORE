nanaya_blood_attribute = class({})
function nanaya_blood_attribute:OnSpellStart()
local caster = self:GetCaster()
	local ply = caster:GetPlayerOwner()
	local hero = caster:GetPlayerOwner():GetAssignedHero()
    hero:FindAbilityByName("nanaya_blood"):SetLevel(2)
    local master = hero.MasterUnit
	master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
end
	

nanaya_d_attribute = class({})
function nanaya_d_attribute:OnSpellStart()
	local caster = self:GetCaster()
		local ply = caster:GetPlayerOwner()
		local hero = caster:GetPlayerOwner():GetAssignedHero()
		hero:SwapAbilities("nanaya_slashes", "nanaya_blood", true, false)
		local master = hero.MasterUnit
		master:SetMana(master:GetMana() - self:GetManaCost(self:GetLevel()))
	end
