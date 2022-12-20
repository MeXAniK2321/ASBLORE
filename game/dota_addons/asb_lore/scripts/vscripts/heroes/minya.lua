minya = class({})
LinkLuaModifier( "modifier_minya", "modifiers/modifier_minya", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function minya:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("minya_lightning")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function minya:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_minya", {duration = 6})
	
	EmitSoundOn("betty.1", caster)
end


