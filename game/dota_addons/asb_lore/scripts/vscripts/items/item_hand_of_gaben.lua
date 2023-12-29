item_hand_of_gaben = item_hand_of_gaben or class({})

function item_hand_of_gaben:OnSpellStart()
    if not IsServer() then return end
	
	local hCaster = self:GetCaster()
    -- Sounds Table
    local hSounds = {
        "Gaben.1",
        "Gaben.2",
        "Gaben.3",
        "Gaben.4",
    }

    -- Emit the sound
    EmitSoundOn(hSounds[RandomInt(1, #hSounds)], hCaster)
    EmitSoundOn("DOTA_Item.Hand_Of_Midas", hCaster)
	 
	 -- Apply the gold gain effect particle
	 local particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	                  ParticleManager:SetParticleControl(particle, 1, hCaster:GetAbsOrigin())
     ParticleManager:ReleaseParticleIndex(particle)
	
	 -- Gain the gold
     hCaster:ModifyGold(self:GetSpecialValueFor("gold"), true, DOTA_ModifyGold_Unspecified)
end
