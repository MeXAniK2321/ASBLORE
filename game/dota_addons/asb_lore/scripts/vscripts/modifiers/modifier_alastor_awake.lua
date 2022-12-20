modifier_alastor_awake = class({})
function modifier_alastor_awake:IsHidden() return false end
function modifier_alastor_awake:IsDebuff() return true end
function modifier_alastor_awake:IsPurgable() return false end
function modifier_alastor_awake:IsPurgeException() return false end
function modifier_alastor_awake:RemoveOnDeath() return true end
function modifier_alastor_awake:AllowIllusionDuplicate() return true end
function modifier_alastor_awake:CheckState()
   
	local state = { [MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,}

    return state
end
function modifier_alastor_awake:DeclareFunctions()
    local func = {  
    				MODIFIER_PROPERTY_MODEL_SCALE,
	                MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,                   
                    MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
                    MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
    return func
end



function modifier_alastor_awake:GetModifierMagicalResistanceBonus()
    return 20
end
function modifier_alastor_awake:GetModifierSpellAmplify_Percentage()
    return 25
end

function modifier_alastor_awake:OnCreated(table)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()




    


  
            --self.parent:SwapAbilities(v, pAbilityName2, bEnable1, bEnable2)
        if IsServer() then
        if not self.particle_time then
            self.particle_time =    ParticleManager:CreateParticle("particles/ember_spirit_ambient_head.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                                    ParticleManager:SetParticleControlEnt(self.particle_time, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_weapon_l", self.parent:GetAbsOrigin(), true)
                                    ParticleManager:SetParticleControl(self.particle_time, 1, Vector(self.radius, self.radius, self.radius))
        end

        
		
        EmitSoundOn("shana.6_1", self.parent)
      

        self.parent:Purge(false, true, false, true, true)
    end
end

function modifier_alastor_awake:GetEffectName()

	return "particles/shana_wings_josai.vpcf"
	end
function modifier_alastor_awake:OnRefresh(table)
    self:OnCreated(table)
end
function modifier_alastor_awake:OnDestroy()
    if IsServer() then
       
			ParticleManager:DestroyParticle(self.particle_time, false)
        ParticleManager:ReleaseParticleIndex(self.particle_time)

    
			

            if self.parent:IsRealHero() then
			
               
            end
        end
    end
