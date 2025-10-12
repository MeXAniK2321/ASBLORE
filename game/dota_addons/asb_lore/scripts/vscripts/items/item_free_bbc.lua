item_free_bbc = item_free_bbc or class({})
LinkLuaModifier("modifier_item_asta_sword_buff", "items/item_asta_sword", LUA_MODIFIER_MOTION_NONE)

function item_free_bbc:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	local level = self:GetSpecialValueFor("max_level")

	if self:GetLevel() < level then
		self:SetLevel(self:GetLevel() + 1)

		if caster 
			and not caster:IsNull() 
			and self 
			and not self:IsNull()
			then

			caster.asta_sword_LEVELS_TABLE = caster.asta_sword_LEVELS_TABLE or {}
			caster.asta_sword_LEVELS_TABLE[self:GetName()] = self:GetLevel()
		end
	end

	EmitSoundOn("DOTA_Item.BlackKingBar.Activate", caster)
	
	local tSounds = {"gachi.ooo2", "gachi.mmm1", "gachi.ohyeah"}
	EmitSoundOn(tSounds[RandomInt(1, #tSounds)], caster)

	caster:Purge(false, true, false, true, true)

	caster:AddNewModifier(caster, self, "modifier_item_asta_sword_buff", {duration = duration})
	self:EndCooldown()
	self:StartCooldown(self:GetSpecialValueFor("cooldown"))
end