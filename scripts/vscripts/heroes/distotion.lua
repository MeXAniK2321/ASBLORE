LinkLuaModifier("modifier_distotion", "heroes/distotion", LUA_MODIFIER_MOTION_NONE)


distotion = class({})




function distotion:OnSpellStart()
    local caster = self:GetCaster()
    local fixed_duration = self:GetSpecialValueFor("fixed_duration")
	  if not IsServer() then return nil end
  
   


    caster:AddNewModifier(caster, self, "modifier_distotion", {duration = fixed_duration})
	

    

    EmitSoundOn("kanade_distotion", caster)
end


modifier_distotion = class({})
function modifier_distotion:IsHidden() return false end
function modifier_distotion:IsDebuff() return false end
function modifier_distotion:IsPurgable() return false end
function modifier_distotion:IsPurgeException() return false end
function modifier_distotion:RemoveOnDeath() return true end
function modifier_distotion:DeclareFunctions()
	local func = {	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
					}
	return func
end
function modifier_distotion:GetModifierIncomingDamage_Percentage( params )
	

		return -100
	end
	function modifier_distotion:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end
	function modifier_distotion:GetEffectName()
	return "particles/distotion.vpcf"
end
function modifier_distotion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end