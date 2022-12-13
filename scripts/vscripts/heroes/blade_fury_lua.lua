juggernaut_blade_fury_lua = class({})
LinkLuaModifier( "modifier_blade_fury_lua", "modifiers/modifier_blade_fury_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_disarmed", "modifiers/modifier_generic_disarmed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_blabla", "heroes/blade_fury_lua.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function juggernaut_blade_fury_lua:GetIntrinsicModifierName()
    return "modifier_blabla"
end
function juggernaut_blade_fury_lua:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("lullaby")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end
function juggernaut_blade_fury_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	caster:StartGesture(ACT_DOTA_CAST_ABILITY_2)

	-- load data
	local bDuration = self:GetSpecialValueFor("duration")+self:GetCaster():FindTalentValue("special_bonus_rin_25")

	-- Add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_blade_fury_lua", -- modifier name
		{ duration = bDuration } -- kv
	)
		caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_disarmed", -- modifier name
		{ duration = bDuration } -- kv
	)
end
modifier_blabla = class ({})
function modifier_blabla:IsHidden() return true end
function modifier_blabla:IsDebuff() return false end
function modifier_blabla:IsPurgable() return false end
function modifier_blabla:IsPurgeException() return false end
function modifier_blabla:RemoveOnDeath() return false end

function modifier_blabla:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_blabla:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_blabla:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_blabla:GetModifierBaseAttackTimeConstant()
	return 2.5
end
function modifier_blabla:OnIntervalThink()
    if IsServer() then
        local music_girl = self:GetParent():FindAbilityByName("lullaby")
        if music_girl and not music_girl:IsNull() then
            if self:GetParent():HasScepter() then
                if music_girl:IsHidden() then
                    music_girl:SetHidden(false)
                end
            else
                if not music_girl:IsHidden() then
                    music_girl:SetHidden(true)
                end
            end
        end
    end
end