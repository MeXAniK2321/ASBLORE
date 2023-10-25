
LinkLuaModifier("arc_warden_tempest_double_modifier", "heroes/arc_warden_tempest_double_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_star_tier2", "modifiers/modifier_star_tier2", LUA_MODIFIER_MOTION_NONE)

arc_warden_tempest_double_lua = arc_warden_tempest_double_lua or class({})

function arc_warden_tempest_double_lua:OnSpellStart()
	local caster = self:GetCaster()
	local spawn_location = caster:GetOrigin()
	local duration = self:GetSpecialValueFor("duration")
	
	-- List of items that the clone should not copy
    local Items_Excluded = {
        "item_aegis",
        "item_smoke_of_deceit",
        "item_recipe_refresher",
        "item_refresher",
        "item_pandora_box",
        "item_ward_sentry",
    }
	
	-- Create Tachibane Kanade clones
	local double = CreateUnitByName( caster:GetUnitName(), spawn_location, true, caster, caster:GetOwner(), caster:GetTeamNumber())
	double:SetControllableByPlayer(caster:GetPlayerID(), false)
	
    -- Set clone level to caster level
	local caster_level = caster:GetLevel()
	for i = 2, caster_level do
		double:HeroLevelUp(false)
	end

    -- Copy abilities from caster
	for ability_id = 0, caster:GetAbilityCount() - 1 do
		local ability = double:GetAbilityByIndex(ability_id)
		if ability then
		   ability:SetLevel(caster:GetAbilityByIndex(ability_id):GetLevel())
		   -- Disable certain abilities
		    local ability_name = ability:GetName()
		    if ability_name == "arc_warden_tempest_double_lua" or ability_name == "kanade_wings" then
			   ability:SetActivated(false)
			end
		end
	end

    -- Copy the appropriate items for the clone
	for item_id = 0, 9 do
		local item_in_caster = caster:GetItemInSlot(item_id)
		if item_in_caster then
			local item_name = item_in_caster:GetName()
			if not table_check(Items_Excluded, item_name) then
				local item_created = CreateItem( item_in_caster:GetName(), double, double)
				double:AddItem(item_created)
				item_created:SetCurrentCharges(item_in_caster:GetCurrentCharges()) 
			end
		end
	end

	-- Set certain properties for the clone
	double:SetMaximumGoldBounty(0)
	double:SetMinimumGoldBounty(0)
	double:SetDeathXP(0)
	double:SetAbilityPoints(0) 
    double:SetHasInventory(false)
	double:SetCanSellItems(false)

	-- Set certain modifiers for the clone
	double:AddNewModifier(caster, self, "arc_warden_tempest_double_modifier", nil)
	double:AddNewModifier(caster, self, "modifier_star_tier2",{duration = 25})
	double:AddNewModifier(caster, self, "modifier_kill", {duration = 25}) -- Keep this because it has a fancy dynamic timer icon
	
	-- Sound effects
	local sound_cast = "kanade.harmonic"
	EmitSoundOn( sound_cast, caster )
end

-----------------------------------------------------------------------------------------------
arc_warden_tempest_double_modifier = arc_warden_tempest_double_modifier or class({})

-- QUICK FIX FOR CLONES HAVING RESPAWN TIMES AND RESPAWNING LIKE HEROES
-- SINCE GABEN CHANGED CERTAIN PROPERTIES DO THIS FOR NOW, MAYBE THERE IS AN EASIER FIX FOR IT
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
function arc_warden_tempest_double_modifier:OnCreated(kv)
    if IsServer() then
        -- Duration to remove the clones after
        self.duration = 30

        -- Use interval think as a timer to remove the clones
        self:StartIntervalThink(self.duration)
    end
end
function arc_warden_tempest_double_modifier:OnIntervalThink()
    if IsServer() then
        -- Remove the clones after the duration
        if not self:GetParent():IsNull() then
            UTIL_Remove(self:GetParent())
        end
    end
end
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
function arc_warden_tempest_double_modifier:DeclareFunctions()
    local func = {
	                 MODIFIER_PROPERTY_SUPER_ILLUSION, 
				     MODIFIER_PROPERTY_ILLUSION_LABEL, 
				     MODIFIER_PROPERTY_IS_ILLUSION, 
				     MODIFIER_EVENT_ON_TAKEDAMAGE,
				     MODIFIER_EVENT_ON_DEATH, 
				     MODIFIER_PROPERTY_TEMPEST_DOUBLE
	             }
	return func
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

-- Custom Function to check if a value exists in a table
-----------------------------------------------------------------------------------------------
function table_check(table_name, value)
    for _, v in pairs(table_name) do
        if v == value then
            return true
        end
    end
    return false
end