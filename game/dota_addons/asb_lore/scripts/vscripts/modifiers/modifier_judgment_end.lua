modifier_judgment_end = class({})

--------------------------------------------------------------------------------

function modifier_judgment_end:IsHidden()
    return false
end

function modifier_judgment_end:IsPurgable()
    return false
end
function modifier_judgment_end:OnDestroy()

	self:PlayEffects()
end

--------------------------------------------------------------------------------


function modifier_judgment_end:PlayEffects( target, dragonform )
	-- Get Resources
	local particle_cast = "particles/cutted_screen.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end