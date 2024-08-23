item_stando_powa = item_stando_powa or class({})
LinkLuaModifier("modifier_item_stando_powa", "items/item_stando_powa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_stando_powa_bash", "items/item_stando_powa", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_stando_powa_cd", "items/item_stando_powa", LUA_MODIFIER_MOTION_NONE)

function item_stando_powa:GetIntrinsicModifierName()
    return "modifier_item_stando_powa"
end

---------------------------------------------------------------------------------------------------------------------
modifier_item_stando_powa = modifier_item_stando_powa or class({})

function modifier_item_stando_powa:IsHidden() return true end
function modifier_item_stando_powa:IsDebuff() return false end
function modifier_item_stando_powa:IsPurgable() return false end
function modifier_item_stando_powa:IsPurgeException() return false end
function modifier_item_stando_powa:RemoveOnDeath() return false end
function modifier_item_stando_powa:DeclareFunctions()
    local func = {
                     MODIFIER_EVENT_ON_TAKEDAMAGE,
                     MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
                 }
    return func
end
function modifier_item_stando_powa:OnCreated( kv )
    if not IsServer() then return end
	
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
	
    self.chance = self.ability:GetSpecialValueFor('stando_powa_chance') or 17
    self.duration = self.ability:GetSpecialValueFor('stando_powa_stun_duration') or 0.32
    self.multiplier = self.ability:GetSpecialValueFor('stando_powa_spell_amp_mult') or 1
    self.cooldown = self.ability:GetSpecialValueFor('stando_powa_cooldown') or 0.5
	
    self.hDamageTable = {
                         victim = nil,
                         attacker = self.parent,
                         damage = self.damage,
                         damage_type = DAMAGE_TYPE_MAGICAL,
                         damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE,
                        }
end
function modifier_item_stando_powa:OnTakeDamage(params)
    if IsServer() then
        if params.attacker == self.parent 
            and not params.unit:IsOther()
            and not params.unit:IsBuilding()
            and self.parent:GetTeamNumber() ~= params.unit:GetTeamNumber()
            and params.unit and params.unit:IsAlive() then
		   
            if RollPseudoRandom(self.chance, self) and not self.parent:HasModifier("modifier_item_stando_powa_cd") then
                local fDamage = (self.parent:GetSpellAmplification(false) * 100) * self.multiplier
                params.unit:AddNewModifier(self.parent, self.ability, "modifier_item_stando_powa_bash", { duration = self.duration})
                self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_stando_powa_cd", { duration = self.cooldown})
                --====================================--
                self.hDamageTable.victim = params.unit
                self.hDamageTable.damage = fDamage
                --====================================--
                ApplyDamage(self.hDamageTable)
                EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", params.unit)
			end
		end
	end
end
function modifier_item_stando_powa:GetModifierSpellAmplify_Percentage()
    return self:GetAbility():GetSpecialValueFor('stando_powa_spell_amp')
end

---------------------------------------------------------------------------------------------------------------------
modifier_item_stando_powa_bash = modifier_item_stando_powa_bash or class({})

function modifier_item_stando_powa_bash:IsPurgable() return false end
function modifier_item_stando_powa_bash:IsDebuff() return true end
function modifier_item_stando_powa_bash:IsHidden() return true end
function modifier_item_stando_powa_bash:IsStunDebuff() return true end
function modifier_item_stando_powa_bash:IsPurgeException() return true end
function modifier_item_stando_powa_bash:CheckState()
    return {
               [MODIFIER_STATE_STUNNED] = true,
               [MODIFIER_STATE_FROZEN] = true,
           }
end
function modifier_item_stando_powa_bash:OnCreated()
	if IsServer() then
		self:GetParent():SetRenderColor(128,128,255)
		if RandomInt(1, 2) == 1 then ParticleName = "particles/stando_powa_bash.vpcf" else ParticleName = "particles/stando_powa_bash2.vpcf" end

		local particle = ParticleManager:CreateParticle(ParticleName, PATTACH_ABSORIGIN, self:GetParent())
		                 ParticleManager:SetParticleControl(particle, 1, self:GetParent():GetOrigin())
		                 ParticleManager:ReleaseParticleIndex(particle)
	end
end
function modifier_item_stando_powa_bash:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end
function modifier_item_stando_powa_bash:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW 
end
function modifier_item_stando_powa_bash:OnDestroy()
	if IsServer() then self:GetParent():SetRenderColor(255,255,255) end 
end

---------------------------------------------------------------------------------------------------------------------
modifier_item_stando_powa_cd = modifier_item_stando_powa_cd or class({})

function modifier_item_stando_powa_cd:IsPurgable() return false end
function modifier_item_stando_powa_cd:IsDebuff() return true end
function modifier_item_stando_powa_cd:IsHidden() return true end
function modifier_item_stando_powa_cd:IsStunDebuff() return false end
function modifier_item_stando_powa_cd:IsPurgeException() return true end