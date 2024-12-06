item_jetstream_sam_muramasa = item_jetstream_sam_muramasa or class({})
LinkLuaModifier("modifier_item_jetstream_sam_muramasa", "items/item_jetstream_sam_muramasa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_jetstream_sam_muramasa_buff", "items/item_jetstream_sam_muramasa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_jetstream_sam_muramasa_neco", "items/item_jetstream_sam_muramasa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_jetstream_sam_muramasa_armor", "items/item_jetstream_sam_muramasa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_chain_lightning", "items/item_jetstream_sam_muramasa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_neko_arc", "items/item_earth", LUA_MODIFIER_MOTION_NONE)

function item_jetstream_sam_muramasa:GetIntrinsicModifierName()
    return "modifier_item_jetstream_sam_muramasa"
end
function item_jetstream_sam_muramasa:OnSpellStart()
    local hCaster = self:GetCaster()
    local iDuration = self:GetSpecialValueFor("bloodshed_duration") or 2.5
    local rNecoChance = RollPseudoRandom(self:GetSpecialValueFor("neco_chance"), self)
    
    if rNecoChance or hCaster:GetUnitName()== "npc_dota_hero_slark" then
        hCaster:EmitSound("jetstream."..RandomInt(7, 12))
        if hCaster:GetUnitName() == "npc_dota_hero_slark" then
            hCaster:AddNewModifier(hCaster, self, "modifier_neko_arc", {duration = iDuration})
        end
        hCaster:AddNewModifier(hCaster, self, "modifier_item_jetstream_sam_muramasa_neco", {duration = iDuration})
    else
        hCaster:EmitSound("jetstream."..RandomInt(1, 6))
        hCaster:AddNewModifier(hCaster, self, "modifier_item_jetstream_sam_muramasa_buff", {duration = iDuration})
    end
end

modifier_item_jetstream_sam_muramasa_buff = modifier_item_jetstream_sam_muramasa_buff or class({})

function modifier_item_jetstream_sam_muramasa_buff:IsHidden() return false end
function modifier_item_jetstream_sam_muramasa_buff:IsDebuff() return false end
function modifier_item_jetstream_sam_muramasa_buff:IsPurgable() return false end
function modifier_item_jetstream_sam_muramasa_buff:IsPurgeException() return false end
function modifier_item_jetstream_sam_muramasa_buff:RemoveOnDeath() return true end
function modifier_item_jetstream_sam_muramasa_buff:OnCreated( kv )
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
end
function modifier_item_jetstream_sam_muramasa_buff:GetEffectName()
    return "particles/jetstream_sam_buff.vpcf"
end
function modifier_item_jetstream_sam_muramasa_buff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

modifier_item_jetstream_sam_muramasa_neco = modifier_item_jetstream_sam_muramasa_neco or class({})

function modifier_item_jetstream_sam_muramasa_neco:IsHidden() return false end
function modifier_item_jetstream_sam_muramasa_neco:IsDebuff() return false end
function modifier_item_jetstream_sam_muramasa_neco:IsPurgable() return false end
function modifier_item_jetstream_sam_muramasa_neco:IsPurgeException() return false end
function modifier_item_jetstream_sam_muramasa_neco:RemoveOnDeath() return true end
function modifier_item_jetstream_sam_muramasa_neco:DeclareFunctions()
    local func = {  
                     MODIFIER_PROPERTY_MODEL_SCALE,
                     MODIFIER_PROPERTY_MODEL_CHANGE,
                 }
    return func
end
function modifier_item_jetstream_sam_muramasa_neco:OnCreated( kv )
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
end
function modifier_item_jetstream_sam_muramasa_neco:GetModifierModelChange()
    return "models/arcueid/neko_arc.vmdl"
end
function modifier_item_jetstream_sam_muramasa_neco:GetModifierModelScale()
    return -20
end
function modifier_item_jetstream_sam_muramasa_neco:GetEffectName()
    return "particles/jetstream_sam_buff.vpcf"
end
function modifier_item_jetstream_sam_muramasa_neco:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

---------------------------------------------------------------------------------------------------------------------
modifier_item_jetstream_sam_muramasa = modifier_item_jetstream_sam_muramasa or class({})

function modifier_item_jetstream_sam_muramasa:IsHidden() return true end
function modifier_item_jetstream_sam_muramasa:IsDebuff() return false end
function modifier_item_jetstream_sam_muramasa:IsPurgable() return false end
function modifier_item_jetstream_sam_muramasa:IsPurgeException() return false end
function modifier_item_jetstream_sam_muramasa:RemoveOnDeath() return false end
function modifier_item_jetstream_sam_muramasa:DeclareFunctions()
    local func = {
                     MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
                     MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
                     MODIFIER_EVENT_ON_ATTACK_LANDED,
                 }
    return func
end
function modifier_item_jetstream_sam_muramasa:OnCreated( kv )
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    self.fLightningBaseDmg = self.ability:GetSpecialValueFor("lightning_base_damage")
    self.fLightningPercDmg = (self.ability:GetSpecialValueFor("lightning_percent_damage") / 100) or 0.17
    self.fLightningFullDmg = self.fLightningBaseDmg + self.parent:GetAttackDamage() * self.fLightningPercDmg
end
function modifier_item_jetstream_sam_muramasa:GetModifierPreAttack_CriticalStrike()
    -- For Server and Client
    if IsServer() then
        local bIsBuffed   = self.parent:HasModifier("modifier_item_jetstream_sam_muramasa_buff") or self.parent:HasModifier("modifier_item_jetstream_sam_muramasa_neco")
        local fCritChance = bIsBuffed and self.ability:GetSpecialValueFor("bloodshed_crit_chance") or self.ability:GetSpecialValueFor("high_freq_chance")
        local fRandFloat  = RandomFloat(0, 1) <= fCritChance / 100
        
        self.bAttackSuccess = fRandFloat
        
        -- If the Server returns then the Client does too
        -- NOTE: Client Side is only for Visual Crit Numbers Effect
        if not fRandFloat then return end
    end
    return self.ability:GetSpecialValueFor("high_freq_crit")
end
function modifier_item_jetstream_sam_muramasa:OnAttackLanded(params)
    if IsServer() then
        --Check for buff
        local bIsBuffed = self.parent:HasModifier("modifier_item_jetstream_sam_muramasa_buff") or self.parent:HasModifier("modifier_item_jetstream_sam_muramasa_neco")
        -- Sword Slash Effect
        if params.attacker == self:GetParent() and params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK and bIsBuffed then
            local SlashParticle = ParticleManager:CreateParticle("particles/jetstream_sam_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
                                  ParticleManager:ReleaseParticleIndex(SlashParticle)
            self.parent:EmitSound("jetstream.swing"..RandomInt(1, 4))				 
        end
        -- Armor reduction + critical strike
        if params.attacker == self:GetParent() 
            and params.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK 
            and params.target and params.target:IsAlive()
            and self.bAttackSuccess then
            
            params.target:AddNewModifier(self.parent, self.ability, "modifier_item_jetstream_sam_muramasa_armor", {duration = 0.3})
            self.parent:EmitSound("jetstream.crit"..RandomInt(1, 2))
            self.bAttackSuccess = false -- Adding just in case
        end
        -- Chain Lightning
        local iLightningChance = bIsBuffed and self.ability:GetSpecialValueFor("bloodshed_lightning_chance") or self.ability:GetSpecialValueFor("lightning_chance")
        if params.attacker == self:GetParent() and self:GetParent():IsAlive() and not self.bChainCooldown and not self:GetParent():IsIllusion() and not params.target:IsMagicImmune() and not params.target:IsBuilding() and not params.target:IsOther() and self:GetParent():GetTeamNumber() ~= params.target:GetTeamNumber() and RollPseudoRandom(iLightningChance, self:GetAbility()) then
        -- -- This line is if you don't want multiple of any Chain Lightning items stacking
        -- if self:GetCaster():HasModifier("modifier_item_imba_chain_lightning_cooldown") then return end
		
        self:GetParent():EmitSound("Item.Maelstrom.Chain_Lightning")
	
        --self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_imba_chain_lightning", {
            --starting_unit_entindex	= params.target:entindex(), chainDmg = self.ability:GetSpecialValueFor("lightning_base_damage")
        --})
        
        -- My New Bounce Function, avoid modifier and just use timer
        BounceLightning(self.parent, self.ability, nil, 10, 1000, self.fLightningFullDmg, nil, params.target)
       end
    end
end
function modifier_item_jetstream_sam_muramasa:GetModifierAttackSpeedBonus_Constant()
    return self:GetAbility():GetSpecialValueFor('bonus_attack_speed')
end 


---------------------------------------------------------------------------------------------------------------------

modifier_item_jetstream_sam_muramasa_armor = modifier_item_jetstream_sam_muramasa_armor or class({})

function modifier_item_jetstream_sam_muramasa_armor:IsHidden() return false end
function modifier_item_jetstream_sam_muramasa_armor:IsPurgable() return false end
function modifier_item_jetstream_sam_muramasa_armor:DeclareFunctions()
    local func = { 	
                     MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
                 }
    return func
end
function modifier_item_jetstream_sam_muramasa_armor:OnCreated(hTable)
    self.reduction = -math.abs(self:GetParent():GetPhysicalArmorValue(false))
end
--[[function modifier_item_jetstream_sam_muramasa_armor:OnRefresh(hTable)
    self:OnRefresh(hTable)
end]]--
function modifier_item_jetstream_sam_muramasa_armor:GetModifierPhysicalArmorBonus()
    return self.reduction
end

---------------------------------------------------------------------------------------------------------------------
-- MY BOUNCE FUNCTION TEST
---------------------------------------------------------------------------------------------------------------------

function BounceLightning(hCaster, hAbility, hPrevTarget, nBounces, iRadius, fDamage, tEnemiesHit, hFirstBounceTarget)
    if not IsNotNull(hCaster) or not IsNotNull(hAbility) or nBounces <= 0 then
        return nil
    end
    
    local hCurrentUnit = hPrevTarget or hCaster
    fDamage     = fDamage or 500
    tEnemiesHit = tEnemiesHit or {}

    for _, hEnemy in pairs(FindClosest(hCaster, hCurrentUnit, iRadius, hFirstBounceTarget)) do
        if IsNotNull(hEnemy) and not tEnemiesHit[tostring(hEnemy:entindex())] then
            hEnemy:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
            
            local nLightningFX = ParticleManager:CreateParticle("particles/jetstream_sam_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCurrentUnit)
                                 ParticleManager:SetParticleControlEnt(nLightningFX, 1, hEnemy, PATTACH_POINT_FOLLOW, "attach_hitloc", hEnemy:GetAbsOrigin(), true)
                                 ParticleManager:SetParticleControl(nLightningFX, 2, Vector(1, 1, 1))
                                 ParticleManager:ReleaseParticleIndex(nLightningFX)
                                 
            ApplyDamage({
                victim          = hEnemy,
                damage          = fDamage,
                damage_type     = DAMAGE_TYPE_MAGICAL,
                damage_flags    = DOTA_DAMAGE_FLAG_NONE,
                attacker        = hCaster,
                ability         = hAbility
            })
                                 
            tEnemiesHit[tostring(hEnemy:entindex())] = true
            
            --=====================--
            nBounces = nBounces - 1
            --=====================--
            
            Timers:CreateTimer(0.2, function()
                BounceLightning(hCaster, hAbility, hEnemy, nBounces, iRadius, fDamage, tEnemiesHit, nil)
            end)
            
            break
        end
    end
end

function FindClosest(hCaster, hCurrentTarget, iRadius, hFirstBounceTarget)
    -- First attack should bounce to initial target
    if hFirstBounceTarget then
        return {hFirstBounceTarget}
    end
    
    -- If the target is the caster again but not first bounce, no other units found (stop bouncing)
    -- Because hCurrentUnit = hPrevTarget or hCaster will always have a unit
    -- if hCurrentTarget == hCaster and not hFirstBounceTarget then -- I leave this here for readability
    if hCurrentTarget == hCaster then
        return {}
    end
    
    -- If the current target is NULL then return empty table (stop bouncing)
    --if not IsNotNull(hCurrentTarget) then
        --return {}
    --end

    iRadius = iRadius or 1000
    local hEnemies = FindUnitsInRadius( hCaster:GetTeamNumber(),  -- int, your team number
                                        hCurrentTarget:GetOrigin(),  -- point, center point
                                        nil,  -- handle, cacheUnit. (not known)
                                        iRadius,  -- float, radius. or use FIND_UNITS_EVERYWHERE
                                        DOTA_UNIT_TARGET_TEAM_ENEMY,  -- int, team filter
                                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  -- int, type filter
                                        0,  -- int, flag filter
                                        FIND_CLOSEST,  -- int, order filter
                                        false  -- bool, can grow cache
                                    )
    return hEnemies
end


---------------------------------------------------------------------------------------------------------------------
-- DOTA IMBA MAELSTROM MODIFIER
---------------------------------------------------------------------------------------------------------------------
----------------------------------------
-- MODIFIER_ITEM_IMBA_CHAIN_LIGHTNING --
----------------------------------------

--[[modifier_item_imba_chain_lightning = modifier_item_imba_chain_lightning or class({})

function modifier_item_imba_chain_lightning:IsHidden()		return true end
function modifier_item_imba_chain_lightning:IsPurgable()	return false end
function modifier_item_imba_chain_lightning:RemoveOnDeath()	return false end
function modifier_item_imba_chain_lightning:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_item_imba_chain_lightning:OnCreated(keys)
	if IsServer() then
        if not self:GetAbility() then self:Destroy() end
    end

	if not IsServer() then return end

	if self:GetAbility() then
		self.bonus_damage	= 0
		self.chain_damage	= keys.chainDmg or 125
		self.chain_damagea  = (self:GetAbility():GetSpecialValueFor("lightning_percent_damage") / 100) or 0.17
		self.chain_damage2  = self.chain_damage + self:GetParent():GetAttackDamage() * self.chain_damagea
		self.chain_strikes	= 10
		self.chain_radius	= 1000
		self.chain_delay	= 0.2
	else
		self.bonus_damage	= 0
		self.chain_damage	= 0
		self.chain_strikes	= 0
		self.chain_radius	= 0
		self.chain_delay	= 0
	end
	
	self.starting_unit_entindex	= keys.starting_unit_entindex
	
	if self.starting_unit_entindex and EntIndexToHScript(self.starting_unit_entindex) then
		self.current_unit						= EntIndexToHScript(self.starting_unit_entindex)
	else
		self:Destroy()
		return
	end

	self.units_affected			= {}
	self.unit_counter			= 0
	
	self:OnIntervalThink()
	self:StartIntervalThink(self.chain_delay)
end

function modifier_item_imba_chain_lightning:OnIntervalThink()
	self.zapped = false

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.current_unit:GetAbsOrigin(), nil, self.chain_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)) do
		if not self.units_affected[enemy] then
			enemy:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
			
			self.zap_particle = ParticleManager:CreateParticle("particles/jetstream_sam_lightning.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.current_unit)
			
			if self.unit_counter == 0 then
				ParticleManager:SetParticleControlEnt(self.zap_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
			else
				ParticleManager:SetParticleControlEnt(self.zap_particle, 0, self.current_unit, PATTACH_POINT_FOLLOW, "attach_hitloc", self.current_unit:GetAbsOrigin(), true)
			end
			
			ParticleManager:SetParticleControlEnt(self.zap_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy:GetAbsOrigin(), true)
			ParticleManager:SetParticleControl(self.zap_particle, 2, Vector(1, 1, 1))
			ParticleManager:ReleaseParticleIndex(self.zap_particle)
		
			self.unit_counter						= self.unit_counter + 1
			self.current_unit						= enemy
			self.units_affected[self.current_unit]	= true
			self.zapped								= true
			
			ApplyDamage({
				victim 			= enemy,
				damage 			= self.chain_damage2,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self:GetAbility()
			})
			
			break
		end
	end
	
	if (self.unit_counter >= self.chain_strikes and self.chain_strikes > 0) or not self.zapped then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end
]]--
