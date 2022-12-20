modifier_world_revolwing = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_world_revolwing:IsHidden()
	return false
end

function modifier_world_revolwing:IsDebuff()
	return self:GetCaster():GetTeamNumber()~=self:GetParent():GetTeamNumber()
end

function modifier_world_revolwing:IsStunDebuff()
	return true
end

function modifier_world_revolwing:IsPurgable()
	return true
end

function modifier_world_revolwing:RemoveOnDeath()
	return false
end


-- Initializations
function modifier_world_revolwing:OnCreated( kv )
	
	self:PlayEffects()

end




-- Graphics & Animations

function modifier_world_revolwing:PlayEffects( )
	-- Get Resources
	local particle_cast = "particles/pandora_screen.vpcf"
	 if not IsServer() then return end
    if not self:GetParent():IsIllusion() then
        local Player = PlayerResource:GetPlayer(self:GetParent():GetPlayerID())

	-- Get Data
	

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticleForPlayer( particle_cast, PATTACH_ABSORIGIN_FOLLOW, Player,Player )
	
	
end

end