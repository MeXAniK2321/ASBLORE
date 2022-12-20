modifier_chocolate = class({})

--------------------------------------------------------------------------------
function modifier_chocolate:IsHidden() return false end
function modifier_chocolate:IsDebuff() return true end
function modifier_chocolate:IsPurgable() return false end
function modifier_chocolate:IsPurgeException() return false end
function modifier_chocolate:RemoveOnDeath() return true end
function modifier_chocolate:AllowIllusionDuplicate() return true end
function modifier_chocolate:OnCreated()
	self.heal = self:GetAbility():GetSpecialValueFor( "heal" )
	self.heal2 = self:GetAbility():GetSpecialValueFor( "heal" ) * 0.5
	if self:GetParent():GetUnitName()== "npc_dota_hero_spectre" then
   
	self:GetParent():Heal( self.heal2, self )
	else

	self:GetParent():Heal( self.heal, self )
	end
end