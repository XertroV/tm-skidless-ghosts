FunctionHookHelper@ HookVehicleVisUpdate = FunctionHookHelper(
    "48 8B CF E8 ?? ?? ?? ?? 0f 54 05 ?? ?? ?? ?? e8 ?? ?? ?? ?? f3 44 0f 10 8f 24 02 00 00",
    3, 0, "AfterVehicleVisUpdateSpeed"
);

void AfterVehicleVisUpdateSpeed(uint64 r11) {
    // trace('r11: ' + Text::FormatPointer(r11));
    auto id = Dev::ReadUInt32(r11);
    if (id == 0) return;
    SkidsMagician::RunCallbacks(id, r11);
    if (!g_EnableSkidlessGhostsThisFrame) return;
    OnVehicleUpdate(id, r11);
    return;
    // // position
    // // vec3 posState = Dev::ReadVec3(r11 + 0x50);
    // // Dev::Write(r11 + 0x50, posState + vec3(0, 32, 0));
    // if (r10 < 0xFFFFFFFF) {
    //     // trace('bad r10 (vehicle vis) pointer: ' + Text::FormatPointer(r10));
    //     return;
    // }
    // // vec3 pos = Dev::ReadVec3(r10 + 0x15C);
    // // Dev::Write(r10 + 0x15C, pos + vec3(0, 32, 0));
    // // trace('r10: ' + Text::FormatPointer(r10) + ', pos: ' + pos.ToString() + ', posState: ' + posState.ToString());
}





// // updating after this allows us to
// FunctionHookHelper@ HookExtractVehicleState = FunctionHookHelper(
//     //                            VV stack offsets, might change but we [VV]  need it for the pattern to work
//     // E8 C3 46 52 FF 4C 8B 84 24 88 00 00 00 4D 85 C0 74 23 48 8B 84 24 90 00 00 00 48 85 C0
//       "E8 ?? ?? ?? ?? 4C 8B 84 24 88 00 00 00 4D 85 C0 74 23 48 8B 84 24 90 00 00 00 48 85 C0 74 16",
//     0, 0, "AfterExtractVehicleState"
// );

// void AfterExtractVehicleState(uint64 rcx) {
//     return;
//     // rcx is stack pointer, vehicle mgr at D0
//     // trace('rcx: ' + Text::FormatPointer(rcx) + " at " + Time::Now);
//     auto vehicleMgr = Dev::ReadUInt64(rcx + 0xD0);
//     // trace('vehicleMgr: ' + Text::FormatPointer(vehicleMgr));
//     if (vehicleMgr == 0) return;
//     auto vclass = Dev::ReadUInt32(vehicleMgr + 0x8);
//     // CSceneVehicleVis class id
//     if (vclass != 0xA018000) return;
//     auto vehicle1Ptr = Dev::ReadUInt64(vehicleMgr + 0x18);
//     auto nbVehicles = Dev::ReadUInt32(vehicleMgr + 0x28);
//     if (nbVehicles == 0) return;
//     // trace('vehicle1Ptr: ' + Text::FormatPointer(vehicle1Ptr) + ', nbVehicles: ' + nbVehicles);
//     auto pos = Dev::ReadVec3(vehicle1Ptr + 0x50);
//     // Dev::Write(vehicle1Ptr + 0x50, pos + vec3(0, 32, 0));
// }
