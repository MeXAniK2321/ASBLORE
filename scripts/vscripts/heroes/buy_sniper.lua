buy_sniper = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "modifiers/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_buy_sniper", "modifiers/modifier_buy_sniper", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_money_money", "heroes/buy_sniper.lua", LUA_MODIFIER_MOTION_NONE )

function buy_sniper:GetIntrinsicModifierName()
    return "modifier_money_money"
end
function buy_sniper:OnUpgrade()
    local ability = self:GetCaster():FindAbilityByName("wad_of_money")
    if ability and ability:GetLevel() < self:GetLevel() then
        ability:SetLevel(self:GetLevel())
    end
end

function buy_sniper:CastFilterResultTarget(target)
local caster = self:GetCaster()
local gold = self:GetSpecialValueFor("gold")
   local gold1 = caster:GetGold()
   if gold > gold1  then
        return UF_FAIL_CUSTOM
    end
       if target:GetTeamNumber() == self:GetCaster():GetTeamNumber() or target:IsMagicImmune() then
        return UF_FAIL_ENEMY
    end
end 
function buy_sniper:GetCustomCastErrorTarget(target)
local caster = self:GetCaster()
   local gold = self:GetSpecialValueFor("gold")
   local gold1 = caster:GetGold()
   if gold > gold1  then
        return "#dota_hud_error_not_enough_gold"
    end
end
--------------------------------------------------------------------------------
-- Ability Start
function buy_sniper:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	if target:TriggerSpellAbsorb( self ) then return end
local gold = self:GetSpecialValueFor("gold_self")
	PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), gold, false, DOTA_ModifyGold_Unspecified )
	-- load data
	local duration = self:GetSpecialValueFor( "duration1" )

	-- add debuff
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_buy_sniper", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	self:PlayEffects1()
end
function buy_sniper:PlayEffects1()
	-- Get Resources
	local sound_cast = "daisuke_3"

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
modifier_money_money = class ({})
function modifier_money_money:IsHidden() return true end
function modifier_money_money:IsDebuff() return false end
function modifier_money_money:IsPurgable() return false end
function modifier_money_money:IsPurgeException() return false end
function modifier_money_money:RemoveOnDeath() return false end

function modifier_money_money:OnCreated()
    if IsServer() then
    

        self:StartIntervalThink(FrameTime())
    end
end
function modifier_money_money:OnRefresh()
    if IsServer() then
       
    end
end
function modifier_money_money:DeclareFunctions()
    local funcs = {

		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	
    }

    return funcs
end
function modifier_money_money:GetModifierBaseAttackTimeConstant()
	return 5.0
end
function modifier_money_money:OnIntervalThink()
    if IsServer() then
        local rich_geu = self:GetParent():FindAbilityByName("wad_of_money")
        if rich_geu and not rich_geu:IsNull() then
            if self:GetParent():HasScepter() then
                if rich_geu:IsHidden() then
                    rich_geu:SetHidden(false)
                end
            else
                if not rich_geu:IsHidden() then
                    rich_geu:SetHidden(true)
                end
            end
        end
    end
	end
