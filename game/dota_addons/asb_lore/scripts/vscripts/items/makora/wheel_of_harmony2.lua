require("items/makora/wheel_of_harmony_shared")

item_wheel_of_harmony2 = class({})

function item_wheel_of_harmony2:GetIntrinsicModifierName()
    return WheelOfHarmonyShared.GetIntrinsicModifierName(self)
end

function item_wheel_of_harmony2:OnSpellStart()
    WheelOfHarmonyShared.OnSpellStart(self)
end

function item_wheel_of_harmony2:OnChargeCountChanged(_chargeCount, ...)
end
