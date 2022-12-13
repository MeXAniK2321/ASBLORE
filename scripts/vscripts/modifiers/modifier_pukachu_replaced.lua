modifier_pukachu_replaced = class({})

function modifier_pukachu_replaced:OnCreated()

	local target = self:GetParent()
	

	local items = {}
	for i = DOTA_ITEM_SLOT_1, DOTA_STASH_SLOT_6 + 2 do
		local item = target:GetItemInSlot(i)
		if item and item ~= self then
			table.insert(items, i, item)
			target:TakeItem(item)
		end
	end

	local gold = target:GetGold()
	local xp = target:GetCurrentXP()

	local player = self:GetParent()
	local PID = player:GetPlayerOwnerID()
    local id32 = PlayerResource:IsFakeClient(PID) and PID * 32 or PlayerResource:GetSteamAccountID(PID)
	if self:GetParent():GetUnitName()== "npc_dota_hero_pudge" then
	self:Destroy()
	else
	local hero = PlayerResource:ReplaceHeroWith(self:GetParent():GetPlayerOwnerID(), "npc_dota_hero_pudge", 0, 0)
		



	local cast_fx = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
					ParticleManager:ReleaseParticleIndex(cast_fx)

	self:StartIntervalThink( 0.06 )
end
end
function modifier_pukachu_replaced:OnIntervalThink()
	
	self:OnCreated()
end
