LinkLuaModifier("modifier_item_dress", "items/item_dress", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_dress_barrier", "items/item_dress", LUA_MODIFIER_MOTION_NONE)

item_dress = item_dress or class({})

function item_dress:GetIntrinsicModifierName()
    return "modifier_item_dress"
end
function item_dress:OnSpellStart()
    local hCaster   = self:GetCaster()
    local fDuration = self:GetSpecialValueFor("barrier_duration") or 20
	
    local nDressLaunchFX = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight_launch.vpcf", PATTACH_ABSORIGIN, hCaster)
                           ParticleManager:ReleaseParticleIndex(nDressLaunchFX)
    EmitSoundOn("DOTA_Item.Pipe.Activate", hCaster)
    
    hCaster:AddNewModifier(hCaster, self, "modifier_item_dress_barrier", { duration = fDuration })
end


modifier_item_dress = modifier_item_dress or class({})

function modifier_item_dress:IsHidden() return true end
function modifier_item_dress:AllowIllusionDuplicate() return true end
function modifier_item_dress:IsPurgable() return false end
function modifier_item_dress:OnCreated()
	self.ability = self:GetAbility()
end
function modifier_item_dress:DeclareFunctions()
    local funcs = {
                      MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, 
                      MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
                      MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		          }

    return funcs
end
function modifier_item_dress:GetModifierMagicalResistanceBonus()
    return self:GetParent():HasItemInInventory("item_serp_molot")
           and 0
		   or 15
end
function modifier_item_dress:GetModifierConstantHealthRegen()
    return self:GetAbility():GetSpecialValueFor('hp_regen')
end
function modifier_item_dress:GetModifierConstantManaRegen()
    return self:GetAbility():GetSpecialValueFor('mp_regen')
end

-----------------------------------------------------------------------------------------------------------
--	Index Dress active shield that protects from spell damage
-----------------------------------------------------------------------------------------------------------
modifier_item_dress_barrier = modifier_item_dress_barrier or class({})

function modifier_item_dress_barrier:IsDebuff() return false end
function modifier_item_dress_barrier:IsHidden() return false end
function modifier_item_dress_barrier:IsPurgable() return false end
function modifier_item_dress_barrier:IsPurgeException() return false end

function modifier_item_dress_barrier:OnCreated(hTable)
    self.caster          = self:GetCaster()
    self.parent          = self:GetParent()
	self.ability         = self:GetAbility()
    
    -- Why does the modifier keep refreshing ?????
    --if not self.bSetInitialStacks then
        --self:SetStackCount(self.nBarrierHealth)
        --self.bSetInitialStacks = true
    --end
    
    -- Client keeps refreshing when taking dmg here why ?????
    --[[if IsServer() then
        print("Server: IT REFRESHES ON HIT ?????")
    else
        print("Client: IT REFRESHES ON HIT ?????")
    end]]--
    
    -----------------------------------------------------------------------
    -- Simplified Formula here if somebody doesn't understand
    
    -- Get the difference between the damages (magic resist)
    -- f1 = fOriginalDamage / fReducedDamage
    
    -- Subtract the barrier health from the Original Damage
    -- f2 = fOriginalDamage - fBarrierHealth
    
    -- Apply the magic resistance value by dividing (ex. / 2 = 50%)
    -- f3 = f2 / f1
    
    -- Subtract the reduced damage by the new one (gives us the value)
    -- f4 = fReducedDamage - f3
    
    -- This formula is the same thing but simpler
    -- fBarrierHealth = (fBarrierHealth / fOriginalDamage) * fReducedDamage
    -----------------------------------------------------------------------
    
	if IsServer() then
        self.nBarrierBlock   = self.ability:GetSpecialValueFor("barrier_block")
	    self.nBarrierHealth  = self.nBarrierBlock
        self:SetStackCount(self.nBarrierHealth)
    else
        if not self.nBarrierFX then
            self.nBarrierFX = ParticleManager:CreateParticle("particles/items2_fx/pipe_of_insight.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
                              ParticleManager:SetParticleControl(self.nBarrierFX, 0, self:GetParent():GetAbsOrigin())
                              ParticleManager:SetParticleControlEnt(self.nBarrierFX, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_origin", self:GetParent():GetAbsOrigin(), true)
                              ParticleManager:SetParticleControl(self.nBarrierFX, 2, Vector(self:GetParent():GetModelRadius() * 1.2, 0, 0))
            self:AddParticle(self.nBarrierFX, false, false, -1, false, false)
        end
    end
end
function modifier_item_dress_barrier:DeclareFunctions()
	return {MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT}
end
function modifier_item_dress_barrier:GetModifierIncomingSpellDamageConstant(keys)
    if IsServer() then
        -- Not like OnTakeDamage, only checks this player, but do this just in case
        -- NOTE: keys.attacker == self.parent can return but... 
        -- If your spell is like Pudge Rot then it wont block the self damage
        if keys.target ~= self.parent then
            return
        end
        
        -- If this item is destroyed then stop the barrier ?
        -- NOTE: In original Dota 2 barrier still continues if item destroyed
        --if not IsNotNull(self.ability) then
            --return self:Destroy()
        --end
        
        
        if keys.damage_type == DAMAGE_TYPE_MAGICAL then
            -- Handle cases where original_damage is lower than keys.damage
            -- EXAMPLE: Enemy has -400% magic resist, orig_dmg = 200, keys.damage = 1000
            -- NOTE: Original Damage affected by Spell Amp
            local fDamageFix = math.max(keys.original_damage, keys.damage)
            if fDamageFix >= self.nBarrierHealth then
                -- Send the remaining barrier health as an overhead number for the damage blocked
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self:GetParent(), self.nBarrierHealth, nil)

                -- Cache the Barrier Health and remove any remaining block(This is optional)
                local fBarrierHealth  = self.nBarrierHealth
                local fOriginalDamage = keys.original_damage > 1 and keys.original_damage or 1
                local fReducedDamage  = keys.damage > 1 and keys.damage or 1
                
                -- Fix values for cases where original_damage is lower than keys.damage 
                fOriginalDamage = math.max(fOriginalDamage, fReducedDamage)
                fReducedDamage  = math.min(fOriginalDamage, fReducedDamage)
                --=====================--
                self.nBarrierHealth = 0
                self:SetStackCount(0)
                --=====================--
                
                --self:StartIntervalThink(0.001)
                
                self:Destroy()
                
                --print("HMMMMM")
                
                -- The barrier absorbs key.original_damage which is before reductions
                -- When the original damage exceeds the barrier we need to make sure that
                -- some of the keys.damage(after reductions) goes through.
                -- So we get a ratio by dividing and then multiplying it by keys.damage
                
                -- If we return the Barrier Health directly then we are PEPEGA
                -- EXAMPLE: barrier = 800, orig_dmg = 1000, keys.dmg = 500
                -- return barrier -800 (keys.dmg - 800) and target takes no dmg
                fBarrierHealth = (fBarrierHealth / fOriginalDamage) * fReducedDamage
            
                -- Return the barrier result and set minimum damage reduced to 1.
                return math.max(fBarrierHealth, 1) * -1
            else
                -- Send the original damage as an overhead number for the damage blocked
                SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, self:GetParent(), fDamageFix, nil)
            
                -- We are using keys.original_damage because it's before all reductions
                local fDamageBlock = fDamageFix > 0 and fDamageFix or 0
                
                -- If you want negative numbers to reduce the barrier use this instead
                --local fDamageBlock = math.abs(fDamageFix)
                
                -- Reduce the barrier's health
                self.nBarrierHealth = self.nBarrierHealth - fDamageBlock
                
                -- Send Barrier Health to the Client using SetStackCount
                self:SetStackCount(self.nBarrierHealth)
                
                return -fDamageBlock
            end
        end
    end
    -- Will trigger on all damage but maybe not a problem ?
    return IsClient() and self:GetStackCount() or 0
end
--[[function modifier_item_dress_barrier:OnIntervalThink()
    self:Destroy()
    self:StartIntervalThink(-1)
end]]--
function modifier_item_dress_barrier:OnRefresh(hTable)
    self:OnCreated(hTable)
end