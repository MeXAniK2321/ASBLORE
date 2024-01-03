LinkLuaModifier("modifier_item_anime_boombox_ticket", "items/item_concert_ticket", LUA_MODIFIER_MOTION_NONE)

-- Sounds for all tickets
--[[local TicketSounds = {
    -- Sounds for item_concert_ticket_1
	item_concert_ticket_1 = {
        {SoundName = "new.year_theme_1", duration = 100.000000},
        {SoundName = "new.year_theme_2", duration = 100.000000},
    },
	
    -- Sounds for item_concert_ticket_2
    item_concert_ticket_2 = {
        {SoundName = "new.year_theme_3", duration = 100.000000},
        {SoundName = "new.year_theme_4", duration = 100.000000},
    },
	
    -- Sounds for item_concert_ticket_3
    item_concert_ticket_3 = {
        {SoundName = "new.year_theme_5", duration = 100.000000},
        {SoundName = "new.year_theme_6", duration = 100.000000},
    },
	
    -- Sounds for item_concert_ticket_4
    item_concert_ticket_4 = {
        {SoundName = "new.year_theme_7", duration = 100.000000},
        {SoundName = "new.year_theme_8", duration = 100.000000},
    },
}]]--
-- Create all 4 tickets without repeating the same code 4 times
for i = 1, 4 do
 local item_name = "item_concert_ticket_" .. i
 _G[item_name] = _G[item_name] or class({})

 _G[item_name].OnSpellStart = function(self)
   local caster = self:GetCaster()

   -- Set Gold
   self.bonus_gold = 1250 * i
   -- Spend item charge
   self:SpendCharge()
   -- Give Gold to player
   PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), self.bonus_gold, false, DOTA_ModifyGold_Unspecified)

   -- Play music based on ticket
   --local ticketSounds = TicketSounds[item_name]
   --if ticketSounds then
     --caster:AddNewModifier(caster, self, "modifier_item_anime_boombox_ticket", ticketSounds[RandomInt(1, #ticketSounds)])
   caster:AddNewModifier(caster, self, "modifier_item_anime_boombox_ticket", {SoundName = "new.year_theme_1", duration = 100.000000})
   --end
 end
end



---------------------------------------------------------------------------------------------------------------------
modifier_item_anime_boombox_ticket = modifier_item_anime_boombox_ticket or class({})
function modifier_item_anime_boombox_ticket:IsHidden() return false end
function modifier_item_anime_boombox_ticket:IsDebuff() return false end
function modifier_item_anime_boombox_ticket:IsPurgable() return false end
function modifier_item_anime_boombox_ticket:IsPurgeException() return false end
function modifier_item_anime_boombox_ticket:RemoveOnDeath() return true end
--function modifier_item_anime_boombox_ticket:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_anime_boombox_ticket:CheckState()
	local state = { [MODIFIER_STATE_PROVIDES_VISION] = true, }

	return state
end
function modifier_item_anime_boombox_ticket:DeclareFunctions()
	local func = { MODIFIER_EVENT_ON_DEATH,
                   MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,    
                   MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT }
	return func
end
function modifier_item_anime_boombox_ticket:GetModifierIncomingDamage_Percentage() 
    if IsServer() then        
        return -15
    end
end		
function modifier_item_anime_boombox_ticket:GetModifierMoveSpeedBonus_Constant(keys)
    return 50
end
function modifier_item_anime_boombox_ticket:OnDeath(keys)
	--print("NANI")
end
function modifier_item_anime_boombox_ticket:OnCreated(keys)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.music = keys.SoundName or nil
	

	if not IsServer() or not self.parent:IsRealHero() then
		return nil
	end

	-- Stop the music playing on this hero
	self:StopAllMusic()
	-- Stop the music playing on all other heroes
    self:RemoveAllElse()
    self:StartIntervalThink(0.5)

    if not self.SoundFX then
	   self.SoundFX = ParticleManager:CreateParticle("particles/heroes/miku/miku_song_aura.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent)

	    self:AddParticle(self.SoundFX, false, false, -1, false, true)
	end
end
function modifier_item_anime_boombox_ticket:OnIntervalThink()
	if not self or self:IsNull() or not self.music then
		self:Destroy()

		return nil
	end

	EmitSoundOn(self.music, self.parent)

	self:StartIntervalThink(-1)
end
function modifier_item_anime_boombox_ticket:OnRefresh(keys)
	self:OnCreated(keys)
end
function modifier_item_anime_boombox_ticket:OnDestroy()
	if IsServer() then
		self:StopAllMusic()
	end
end
function modifier_item_anime_boombox_ticket:StopAllMusic()
    if IsServer() then
        --[[for _, ticketSounds in pairs(TicketSounds) do
            for _, soundData in ipairs(ticketSounds) do
                StopSoundOn(soundData.SoundName, self.parent)
            end
        end]]--
        StopSoundOn(self.music, self.parent)
    end
end
function modifier_item_anime_boombox_ticket:RemoveAllElse()
	if IsServer() then
	  local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		self.caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		FIND_UNITS_EVERYWHERE,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY + DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE,	-- int, flag filter
		FIND_ANY_ORDER,	-- int, order filter
		false	-- bool, can grow cache
	  )
	  -- There should be only one concert playing at the same time
	  for _,enemy in pairs(enemies) do
        if enemy:HasModifier("modifier_item_anime_boombox_ticket") and enemy ~= self.caster then
          enemy:RemoveModifierByName("modifier_item_anime_boombox_ticket")		
        end
	  end
    end
end