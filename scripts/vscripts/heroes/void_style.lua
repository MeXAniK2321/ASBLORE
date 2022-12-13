LinkLuaModifier("modifier_void_style", "heroes/void_style", LUA_MODIFIER_MOTION_NONE)

void_style = class({})

function void_style:IsStealable() return true end
function void_style:IsHiddenWhenStolen() return false end
function void_style:GetIntrinsicModifierName()
	return "modifier_void_style"
end
function void_style:GetAbilityTextureName()
	local caster = self:GetCaster()
	local stacks = caster:GetModifierStackCount("modifier_void_style", caster)
	if stacks == 1 then
		return "shu_legs"
	elseif stacks == 2 then
		return "shu_scyssors"
	end

	return self.BaseClass.GetAbilityTextureName(self)
end
function void_style:OnSpellStart()
	local caster = self:GetCaster()
EmitSoundOn("shu.2", caster)
	local style = caster:FindModifierByNameAndCaster("modifier_void_style", caster)
	if style and not style:IsNull() then
		local stacks = style:GetStackCount()
		if stacks >= 2 then
			style:SetStackCount(0)
		else
			style:IncrementStackCount()
		end

		local sword = caster:FindAbilityByName("void_bomb")
		local scyssors = caster:FindAbilityByName("void_cut")
		local legs = caster:FindAbilityByName("sky_walk")

		if sword and scyssors and legs then
			local name1, name2, active1, active2 = "void_bomb", "sky_walk", false, true
			if stacks == 1 then
				name1, name2 = "sky_walk", "void_cut"
			elseif stacks == 2 then
				name1, name2 = "void_cut", "void_bomb"
			end

			caster:SwapAbilities(name1, name2, active1, active2)

			
		end
	end
end
---------------------------------------------------------------------------------------------------------------------
modifier_void_style = class({})
function modifier_void_style:IsHidden() return true end
function modifier_void_style:IsDebuff() return false end
function modifier_void_style:IsPurgable() return false end
function modifier_void_style:IsPurgeException() return false end
function modifier_void_style:RemoveOnDeath() return false end
function modifier_void_style:DeclareFunctions()
	local func = {	
					MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
					MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,

					MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

					MODIFIER_PROPERTY_EVASION_CONSTANT,
					MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
					MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
					}
	return func
end
function modifier_void_style:GetModifierPreAttack_BonusDamage()
	if self.parent:PassivesDisabled() or self:GetStackCount() ~= 0 then
		return nil
	end

	return self.attack
end
function modifier_void_style:GetModifierEvasion_Constant()
	if self.parent:PassivesDisabled() or self:GetStackCount() ~= 2 then
		return nil
	end

	return self.as
end
function modifier_void_style:GetModifierMoveSpeedBonus_Constant()
	if self.parent:PassivesDisabled() or self:GetStackCount() ~= 1 then
		return nil
	end

	return self.ms
end
function modifier_void_style:OnStackCountChanged(iStackCount)
	if IsServer() then
		self:ForceRefresh()

		if self.Charge_FX then
			ParticleManager:DestroyParticle(self.Charge_FX, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX)
		end

		if self.Charge_FX2 then
			ParticleManager:DestroyParticle(self.Charge_FX2, false)
			ParticleManager:ReleaseParticleIndex(self.Charge_FX2)
		end

		local stacks = self:GetStackCount()

		if stacks == 0 then
			self.Charge_FX =   	ParticleManager:CreateParticle("particles/shu_void.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
								ParticleManager:SetParticleControl(self.Charge_FX, 0, self.parent:GetAbsOrigin())
	                            ParticleManager:SetParticleControlEnt(  self.Charge_FX,
	                                                                    0,
	                                                                    self.parent,
	                                                                    PATTACH_POINT_FOLLOW,
	                                                                    "attach_sword",
	                                                                    Vector(0,0,0),
	                                                                    true)
																		self.Charge_FX2 =  	ParticleManager:CreateParticle("particles/shu_void.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                            	ParticleManager:SetParticleControlEnt(  self.Charge_FX2,
                                                                    	0,
                                                                    	self.parent,
                                                                    	PATTACH_POINT_FOLLOW,
                                                                    	"attach_sword2",
                                                                    	Vector(0,0,0),
                                                                    	true)
	                            
		elseif stacks == 2 then
	  		self.Charge_FX =   	ParticleManager:CreateParticle("particles/shu_void2.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                            	ParticleManager:SetParticleControlEnt(  self.Charge_FX,
                                                                    	0,
                                                                    	self.parent,
                                                                    	PATTACH_POINT_FOLLOW,
                                                                    	"attack_hand",
                                                                    	Vector(0,0,0),
                                                                    	true)

	  		

		else
	  		self.Charge_FX =   	ParticleManager:CreateParticle("particles/shu_void3.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                            	ParticleManager:SetParticleControlEnt(  self.Charge_FX,
                                                                    	0,
                                                                    	self.parent,
                                                                    	PATTACH_POINT_FOLLOW,
                                                                    	"attach_foot",
                                                                    	Vector(0,0,0),
                                                                    	true)

	  		self.Charge_FX2 =  	ParticleManager:CreateParticle("particles/shu_void3.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self.parent)
                            	ParticleManager:SetParticleControlEnt(  self.Charge_FX2,
                                                                    	0,
                                                                    	self.parent,
                                                                    	PATTACH_POINT_FOLLOW,
                                                                    	"attach_foot2",
                                                                    	Vector(0,0,0),
                                                                    	true)	
        end
	end
end
function modifier_void_style:OnCreated(hTable)
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()


	self.attack = self.ability:GetSpecialValueFor("attack")
	self.as = self.ability:GetSpecialValueFor("as")
	self.ms = self.ability:GetSpecialValueFor("ms")

	if IsServer() then
		if not self.first_learned then
			self.first_learned = true
			
			self:SetStackCount(0)
		end
	end
end
function modifier_void_style:OnRefresh(hTable)
	self:OnCreated(hTable)
end