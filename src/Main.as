void Main(){
    VehicleState::RegisterOnVehicleStateUpdateCallback(OnVehicleUpdate);
}

#if TM2020
// rcx = CSceneVehicleVis, rdx = CSceneVehicleVisState
void OnVehicleUpdate(uint id, uint64 rdx) {
    // auto id = Dev::ReadUInt32(rdx);
    trace('rdx: ' + Text::FormatPointer(rdx) + ", id: " + Text::Format("%08x", id));
    if (id & 0xFF000000 != 0x04000000) return;
    SetWheelsFlying(rdx);
}
void SetWheelsFlying(uint64 visStatePtr) {
    trace('wheels flying: ' + Text::FormatPointer(visStatePtr));
    Dev::Write(visStatePtr + O_VEHICLESTATE_FL_FLYING, uint(0x0));
    Dev::Write(visStatePtr + O_VEHICLESTATE_FR_FLYING, uint(0x0));
    Dev::Write(visStatePtr + O_VEHICLESTATE_RL_FLYING, uint(0x0));
    Dev::Write(visStatePtr + O_VEHICLESTATE_RR_FLYING, uint(0x0));
}
#elif MP4
void OnVehicleUpdate(uint id, uint64 ptr) {
    if (id == 0) return;
    SetWheelsFlying(ptr);
}
#elif TURBO
void OnVehicleUpdate(uint id, uint64 ptr) {
    trace("on vehicle update: " + Text::FormatPointer(ptr) + ", id: " + id);
    // if (id == 0) return;
    SetWheelsFlying(ptr);
}
#endif

#if MP4
void SetWheelsFlying(uint64 visStatePtr) {
    // trace('wheels flying: ' + Text::FormatPointer(visStatePtr));
    // trace('FL :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (0 * WheelStructLength) + 0x14));
    // trace('FR :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (1 * WheelStructLength) + 0x14));
    // trace('RL :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (2 * WheelStructLength) + 0x14));
    // trace('RR :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (3 * WheelStructLength) + 0x14));
    Dev::Write(visStatePtr + WheelsStartOffset + (0 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (1 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (2 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (3 * WheelStructLength) + 0x14, uint(0x0));
}
#elif TURBO
void SetWheelsFlying(uint64 visStatePtr) {
    // trace('wheels flying: ' + Text::FormatPointer(visStatePtr));
    // Dev::Write(visStatePtr + WheelsStartOffset + (0 * WheelStructLength) + 0x14, uint(0x0));
    // Dev::Write(visStatePtr + WheelsStartOffset + (1 * WheelStructLength) + 0x14, uint(0x0));
    // Dev::Write(visStatePtr + WheelsStartOffset + (2 * WheelStructLength) + 0x14, uint(0x0));
    // Dev::Write(visStatePtr + WheelsStartOffset + (3 * WheelStructLength) + 0x14, uint(0x0));
    // trace('FL :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (0 * WheelStructLength) + 0x14));
    // trace('FR :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (1 * WheelStructLength) + 0x14));
    // trace('RL :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (2 * WheelStructLength) + 0x14));
    // trace('RR :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (3 * WheelStructLength) + 0x14));
}
#endif

//remove any hooks
void OnDestroyed() { _Unload(); }
void OnDisabled() { _Unload(); }
void _Unload() {
    VehicleState::DeregisterVehicleStateUpdateCallbacks();
}
