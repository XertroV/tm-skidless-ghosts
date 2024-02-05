FunctionHookHelper@ HookVehicleVisUpdate = FunctionHookHelper(
    "48 8B CF E8 ?? ?? ?? ?? 0f 54 05 ?? ?? ?? ?? e8 ?? ?? ?? ?? f3 44 0f 10 8f 24 02 00 00",
    3, 0, "AfterVehicleVisUpdateSpeed"
);

void AfterVehicleVisUpdateSpeed(uint64 r11) {
    // trace('r11: ' + Text::FormatPointer(r11));
    auto id = Dev::ReadUInt32(r11);
    if (id == 0) return;
    SkidsMagician::RunCallbacks(id, r11);
    if (!S_EnableSkidlessGhosts) return;
    if (S_SkidlessGhostsOnlyWhileDriving && !g_IsPlayerDriving) return;
    OnVehicleUpdate(id, r11);
}
