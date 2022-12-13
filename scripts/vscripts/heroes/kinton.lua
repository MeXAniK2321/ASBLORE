kinton = class({})
LinkLuaModifier( "modifier_kinton", "modifiers/modifier_kinton", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function kinton:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("kinton_lightning")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function kinton:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_kinton", {duration = 15})
	
	EmitSoundOn("mori.8", caster)
end


