function C_DOTA_BaseNPC:HasTalent(talentName)
    talentName = string.lower(talentName)   
    if self:HasModifier("modifier_star_"..talentName) then
        return true 
    end
    return false
end

function C_DOTA_BaseNPC:FindTalentValue(talentName, key)
    talentName = string.lower(talentName)
    if self:HasModifier("modifier_star_"..talentName) then
        local value_name = key or "value"
        local specialVal = AbilityKV[talentName]["AbilitySpecial"]
        for l,m in pairs(specialVal) do
            if m[value_name] then
                return m[value_name]
            end
        end
    end  
    return 0
end