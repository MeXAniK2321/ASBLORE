LinkLuaModifier("modifier_item_knife", "items/item_nanaya_knife", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nanaya_instinct", "items/item_nanaya_knife", LUA_MODIFIER_MOTION_NONE)

item_nanaya_knife = item_nanaya_knife or class({})

function item_nanaya_knife:GetIntrinsicModifierName()
    return "modifier_item_knife"
end
function item_nanaya_knife:CastFilterResult()
    if IsServer() then
	    local hCaster         = self:GetCaster()
	    local hBloodModifier  = hCaster:HasModifier("nanaya_blood_modifier")

	    if hBloodModifier and
            IsNotNull(hBloodModifier) then
            local hModifier      = hCaster:FindModifierByNameAndCaster("nanaya_blood_modifier", hCaster)
            local iModifierCount = hModifier.iKills
            local iKillsCounter  = self:GetSpecialValueFor("ghoul_kills") or 10
		
            if iModifierCount then
                if iModifierCount >= iKillsCounter then
                    return UF_SUCCESS
                end
            end
	    end
	    return UF_FAIL_CUSTOM
    end
end
function item_nanaya_knife:GetCustomCastError()
	return "#nanaya_instinct_cast_error"
end
function item_nanaya_knife:OnSpellStart()
	local hCaster 	= self:GetCaster()
	local fDuration = self:GetSpecialValueFor("ghoul_duration") or 35

	hCaster:AddNewModifier(hCaster, self, "modifier_nanaya_instinct", {duration = fDuration})
end


modifier_item_knife = modifier_item_knife or class({})

function modifier_item_knife:IsHidden()return true end
function modifier_item_knife:RemoveOnDeath() return false end
function modifier_item_knife:IsPurgable() return false end
function modifier_item_knife:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_knife:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end
function modifier_item_knife:OnCreated(table)
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    if IsServer() then
        EmitGlobalSound("nanaya.kill")
        EmitGlobalSound("nanaya.heart")
        self.parent:FindAbilityByName("nanaya_blood"):SetLevel(2)
        self.modifier_scepter = self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_ultimate_scepter", {})
        self.parent:FindAbilityByName("nanaya_slashes"):SetLevel(1)
        self.parent:SwapAbilities("nanaya_slashes", "nanaya_blood", true, false)
	end
end
function modifier_item_knife:GetModifierHealthBonus()
    return self:GetAbility():GetSpecialValueFor('hp')
end
function modifier_item_knife:GetModifierBonusStats_Agility()
    return self:GetAbility():GetSpecialValueFor('str')
end
function modifier_item_knife:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor('dmg')
end


---------------------------------------------------------------------------------------------------------------
-- Nanaya Instinct Modifier
---------------------------------------------------------------------------------------------------------------
modifier_nanaya_instinct = modifier_nanaya_instinct or class({})

function modifier_nanaya_instinct:IsHidden() return false end
function modifier_nanaya_instinct:IsDebuff() return false end
function modifier_nanaya_instinct:DeclareFunctions()
    local func = {  MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, 
    				MODIFIER_EVENT_ON_ORDER, 
    				MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, 
    				MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE, 
		}
		return func
end
function modifier_nanaya_instinct:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor("ghoul_cd") or 20
end
function modifier_nanaya_instinct:OnOrder(args)
	if args.unit ~= self:GetParent() or self.sex ~= true or args.unit:IsCommandRestricted() or args.unit:IsStunned() then return end

	if (args.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE) or (args.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION) then
	  	self:NanayaBlink(args.new_pos)
	end
	if (args.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET) then
	  	self:NanayaBlink(args.target:GetAbsOrigin() + (self.parent:GetAbsOrigin() - args.target:GetAbsOrigin()):Normalized()*100)
	end
end
function modifier_nanaya_instinct:NanayaBlink(location)
	self.sex = false

	if (location - self.parent:GetAbsOrigin()):Length2D() > self.dist then 
		location = self:GetParent():GetAbsOrigin() + (((location - self:GetParent():GetAbsOrigin()):Normalized()) * self.dist)
	end

	local nanaya_knife10 = ParticleManager:CreateParticle("particles/maybedashvpcffinal1.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())

	local nanaya_clone_jump = ParticleManager:CreateParticle("particles/blink_z1.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
	ParticleManager:SetParticleControlEnt(nanaya_knife10, 0, caster, PATTACH_POINT, "attach_hand", self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(nanaya_clone_jump, 1, GetGroundPosition(self.parent:GetAbsOrigin(), nil))

	local nanaya_clone = ParticleManager:CreateParticle("particles/nanaya_image_clone.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
	ParticleManager:SetParticleControl(nanaya_clone, 0, GetGroundPosition(self.parent:GetAbsOrigin(), nil)) --0.35
	ParticleManager:SetParticleControl(nanaya_clone, 2, Vector(3, 9, 0))
	ParticleManager:SetParticleControl(nanaya_clone, 4, location)
		  	
	FindClearSpaceForUnit(self:GetParent(), location, true)

	self.parent:EmitSound("nanaya.jumpforward")

	ParticleManager:SetParticleControl(nanaya_knife10, 4, location)
end
if IsServer() then 
	function modifier_nanaya_instinct:OnAbilityFullyCast(args)
		if args.unit ~= self:GetParent() or args.ability:IsItem() then return end
        self.sex = true
	end
end
function modifier_nanaya_instinct:OnCreated()
	self.dist = 450
	self.parent = self:GetParent()
	--CustomGameEventManager:Send_ServerToPlayer(self.parent:GetPlayerOwner(), "emit_horn_sound", {sound="nanaya_pizza"})
    if IsServer() then
    	self.parent:SetMaterialGroup("WhiteShadow")
    	self.sex = true
		local sAbil1 = self.parent:GetAbilityByIndex(4)
	    if sAbil1:GetAbilityName() == "nanaya_slashes" then
			sAbil1:EndCooldown()
		end
		self.nanaya_right_eye = ParticleManager:CreateParticle("particles/nanaya_eyes.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt(self.nanaya_right_eye, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_right_eye", self.parent:GetAbsOrigin(), true)

	    self.nanaya_left_eye = ParticleManager:CreateParticle("particles/nanaya_eyes.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
		ParticleManager:SetParticleControlEnt(self.nanaya_left_eye, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_left_eye", self.parent:GetAbsOrigin(), true)

		local instinct_enter = ParticleManager:CreateParticle("particles/nanaya/nanaya_instinct_white_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
		ParticleManager:ReleaseParticleIndex(instinct_enter)
	end
end
function modifier_nanaya_instinct:GetModifierMoveSpeed_Absolute()
    return self:GetAbility():GetSpecialValueFor("ghoul_movespeed") or 600
end
function modifier_nanaya_instinct:GetTexture()
    return "custom/nanaya/nanaya_eyes_upgrade"
end
function modifier_nanaya_instinct:OnRemoved()
	if not IsServer() then return end
	--print (self.nanaya_right_eye)
	self:GetParent():SetMaterialGroup("BlackShadow")
	ParticleManager:DestroyParticle(self.nanaya_left_eye, false)
	ParticleManager:ReleaseParticleIndex(self.nanaya_left_eye)
	ParticleManager:DestroyParticle(self.nanaya_right_eye, false)
	ParticleManager:ReleaseParticleIndex(self.nanaya_right_eye)
	local instinct_quit = ParticleManager:CreateParticle("particles/nanaya/nanaya_instinct_black_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:ReleaseParticleIndex(instinct_quit)
end
                 