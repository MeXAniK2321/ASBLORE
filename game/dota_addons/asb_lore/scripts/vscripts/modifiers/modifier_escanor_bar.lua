modifier_escanor_bar = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_escanor_bar:IsHidden()
	return false
end

function modifier_escanor_bar:IsDebuff()
	return false
end

function modifier_escanor_bar:IsPurgable()
	return false
end

function modifier_escanor_bar:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_escanor_bar:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_escanor_bar:OnCreated( kv )
	-- references
	self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" ) + self:GetCaster():FindTalentValue("special_bonus_escanor_20l")
	self:StartIntervalThink(1)
	 if not IsServer() then return end
    local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
    EmitSoundOnClient("escanor.bar", Player)
end

function modifier_escanor_bar:OnRefresh( kv )
		self.bonus_gold = self:GetAbility():GetSpecialValueFor( "bonus_gold" )+ self:GetCaster():FindTalentValue("special_bonus_escanor_20l")
end

function modifier_escanor_bar:OnRemoved()
 if not IsServer() then return end
 local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())
    StopSoundOn("escanor.bar", Player)
end

function modifier_escanor_bar:OnDestroyed()
local sound_cast = "escanor.bar"
	StopSoundOn( sound_cast, self:GetParent() )
end
function modifier_escanor_bar:OnIntervalThink()

	if self:GetParent():IsAlive() then
		PlayerResource:ModifyGold( self:GetParent():GetPlayerOwnerID(), self.bonus_gold, false, DOTA_ModifyGold_Unspecified )
	end
end
function modifier_escanor_bar:GetEffectName()
    return "particles/escanor_bar.vpcf"
end

function modifier_escanor_bar:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
