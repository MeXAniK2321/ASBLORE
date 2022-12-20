modifier_throw_money = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_throw_money:IsHidden()
	return false
end
function modifier_throw_money:OnCreated()
self.bonus_gold =  self:GetAbility():GetSpecialValueFor( "gold" ) + self:GetCaster():FindTalentValue("special_bonus_daisuke_20")

local caster = self:GetCaster()
if self:GetParent() == caster then
else
PlayerResource:ModifyGold( self:GetParent():GetPlayerOwnerID(), self.bonus_gold, false, DOTA_ModifyGold_GameTick )
end
end

function modifier_throw_money:IsDebuff()
	return true
end

function modifier_throw_money:IsStunDebuff()
	return false
end

function modifier_throw_money:IsPurgable()
	return true
end

function modifier_throw_money:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

--------------------------------------------------------------------------------


function modifier_throw_money:OnRefresh( kv )
	
end

function modifier_throw_money:OnRemoved()
end

function modifier_throw_money:OnDestroy()
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_throw_money:CheckState()
 if self:GetParent():GetTeamNumber() == self:GetCaster():GetTeamNumber()then
 local state = {}
 return state
 else
	local state = {
		[MODIFIER_STATE_INVISIBLE] = false,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
	}

	return state
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_throw_money:GetEffectName()
	return "particles/money_mark.vpcf"
end

function modifier_throw_money:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end