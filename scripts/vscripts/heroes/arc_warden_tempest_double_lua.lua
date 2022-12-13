  
LinkLuaModifier( "arc_warden_tempest_double_modifier", "heroes/arc_warden_tempest_double_lua.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)

arc_warden_tempest_double_lua = class({})

function arc_warden_tempest_double_lua:OnSpellStart()
	
	local caster = self:GetCaster()
	local spawn_location = caster:GetOrigin()
	local duration = self:GetSpecialValueFor("duration")
	local double = CreateUnitByName( caster:GetUnitName(), spawn_location, true, caster, caster:GetOwner(), caster:GetTeamNumber())
	double:SetControllableByPlayer(caster:GetPlayerID(), false)
	

	local caster_level = caster:GetLevel()
	for i = 2, caster_level do
		double:HeroLevelUp(false)
	end


	for ability_id = 0, 15 do
		local ability = double:GetAbilityByIndex(ability_id)
		if ability then
			
			ability:SetLevel(caster:GetAbilityByIndex(ability_id):GetLevel())
			if ability:GetName() == "arc_warden_tempest_double_lua" then
				ability:SetActivated(false)
			end
			if ability:GetName() == "kanade_wings" then
				ability:SetActivated(false)
			end
		end
	end


	for item_id = 0, 9 do
		local item_in_caster = caster:GetItemInSlot(item_id)
		if item_in_caster ~= nil then
			local item_name = item_in_caster:GetName()
			if not (item_name == "item_aegis" or item_name == "item_smoke_of_deceit" or item_name == "item_recipe_refresher" or item_name == "item_refresher" or item_name == "item_pandora_box" or item_name == "item_ward_sentry") then
				local item_created = CreateItem( item_in_caster:GetName(), double, double)
				double:AddItem(item_created)
				item_created:SetCurrentCharges(item_in_caster:GetCurrentCharges()) 
			end
		end
	end

	
	double:SetMaximumGoldBounty(0)
	double:SetMinimumGoldBounty(0)
	double:SetDeathXP(0)
	double:SetAbilityPoints(0) 

	double:SetHasInventory(false)
	double:SetCanSellItems(false)

	double:AddNewModifier(caster, self, "arc_warden_tempest_double_modifier", nil)
	double:AddNewModifier(caster, self, "modifier_star_tier2",{duration = 25})
	double:AddNewModifier(caster, self, "modifier_kill", {duration = 25})
	local sound_cast = "kanade.harmonic"
	EmitSoundOn( sound_cast, caster )
	
	
                                    
        
end

arc_warden_tempest_double_modifier = class({})

function arc_warden_tempest_double_modifier:DeclareFunctions()
	return {MODIFIER_PROPERTY_SUPER_ILLUSION, MODIFIER_PROPERTY_ILLUSION_LABEL, MODIFIER_PROPERTY_IS_ILLUSION, MODIFIER_EVENT_ON_TAKEDAMAGE,MODIFIER_EVENT_ON_DEATH, MODIFIER_PROPERTY_TEMPEST_DOUBLE}
end

function arc_warden_tempest_double_modifier:GetIsIllusion()
	return true
end
function arc_warden_tempest_double_modifier:OnTakeDamage( event )
if event.unit:HasModifier( "arc_warden_tempest_double_modifier" ) then
	if event.unit:IsAlive() == false then
		event.unit:MakeIllusion()
	end
	end
end






function arc_warden_tempest_double_modifier:GetModifierTempestDouble()
	return true
end

function arc_warden_tempest_double_modifier:GetModifierSuperIllusion()
	return true
end

function arc_warden_tempest_double_modifier:GetModifierIllusionLabel()
	return true
end

function arc_warden_tempest_double_modifier:IsHidden()
	return true
end

function arc_warden_tempest_double_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function arc_warden_tempest_double_modifier:GetEffectName()
	return "particles/generic_buff_11.vpcf"
end
function arc_warden_tempest_double_modifier:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end