item_estus_flask = item_estus_flask or class({})

function item_estus_flask:OnSpellStart()
    if not IsServer() then return end
	-- unit identifier
	local caster = self:GetCaster()
	local nRand  = RandomInt(1,3) > 1 and 3 or 1
    caster:Heal( self:GetSpecialValueFor("heal_amount"), self )
					 
	local nParticlePFX = ParticleManager:CreateParticle("particles/item/estus_flask/estus_trails.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
						 ParticleManager:SetParticleControl(nParticlePFX, 60, Vector(0, 255, 0))
						 ParticleManager:SetParticleControl(nParticlePFX, 61, Vector(0, 255, 0))
						 ParticleManager:SetParticleControl(nParticlePFX, 62, Vector(0, 255, 0))
						 ParticleManager:ReleaseParticleIndex( nParticlePFX )

	EmitSoundOn("estusflask.drink" .. nRand, caster)
end
