require("items/makora/wheel_of_harmony_shared")

item_wheel_of_harmony3 = class({})

function item_wheel_of_harmony3:GetIntrinsicModifierName()
    return WheelOfHarmonyShared.GetIntrinsicModifierName(self)
end

function item_wheel_of_harmony3:OnSpellStart()
    WheelOfHarmonyShared.OnSpellStart(self)
end

function item_wheel_of_harmony3:OnChargeCountChanged(_chargeCount, ...)
end
