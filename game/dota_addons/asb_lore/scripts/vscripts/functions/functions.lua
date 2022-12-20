
function CDOTA_BaseNPC:HasTalent(talentName)
    talentName = string.lower(talentName)
    if self:HasAbility(talentName) then
        local ability = self:FindAbilityByName(talentName)
        if ability and ability:GetLevel() > 0 then
            local modifier = "modifier_star_"..talentName
            if not self:HasModifier(modifier) then
                LinkLuaModifier( modifier, "talents/modifiers.lua", LUA_MODIFIER_MOTION_NONE )
                self:AddNewModifier(self, ability, modifier, {})
            end
            return true
        end
    end
    return false
end
function CDOTA_BaseNPC:FindTalentValue(talentName, key)
    talentName = string.lower(talentName)
    if self:HasTalent(talentName) then
        local value_name = key or "value"
        return self:FindAbilityByName(talentName):GetSpecialValueFor(value_name)
    end
    return 0
end

----------
------------------------------------------------------------------------------------------------------------------------------------------------------------
