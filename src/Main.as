const string PluginName = Meta::ExecutingPlugin().Name;
const string MenuTitle = "\\$dd5" + Icons::Magic + "\\$z " + PluginName;

void Main(){
    startnew(LoadFonts);
    // VehicleState::RegisterOnVehicleStateUpdateCallback(OnVehicleUpdate);
    // check permissions and version
    CheckAndSetGameVersionSafe();
    while (!GameVersionSafe) sleep(500);
    HookVehicleVisUpdate.Apply();
}

UI::Font@ f_MonoSpace = null;

void LoadFonts() {
	@f_MonoSpace = UI::LoadFont("DroidSansMono.ttf");
}


void RenderMenu() {
    if (!GameVersionSafe) {
        UI::BeginDisabled();
        UI::MenuItem(MenuTitle, Icons::ExclamationTriangle);
        UI::EndDisabled();
        return;
    }
    if (UI::BeginMenu(MenuTitle)) {
        if (UI::MenuItem("Enable Skidless Ghosts", "", S_EnableSkidlessGhosts)) {
            S_EnableSkidlessGhosts = !S_EnableSkidlessGhosts;
        }
        if (UI::MenuItem("Skidless Ghosts only while driving?", "", S_SkidlessGhostsOnlyWhileDriving)) {
            S_SkidlessGhostsOnlyWhileDriving = !S_SkidlessGhostsOnlyWhileDriving;
        }
        if (UI::MenuItem("Clear Skids on Restart", "", S_ClearSkidsOnRestart)) {
            S_ClearSkidsOnRestart = !S_ClearSkidsOnRestart;
        }
        if (UI::MenuItem("Clear Skids on Respawn", "", S_ClearSkidsOnRespawn)) {
            S_ClearSkidsOnRespawn = !S_ClearSkidsOnRespawn;
        }
        if (UI::MenuItem("Hotkey: Toggle Skidless Ghosts", GetHotkey_SkidlessGhosts(), false)) {
            EditHotkeys_OpenWindow();
        }
        if (UI::MenuItem("Hotkey: Clear Skids", GetHotkey_ClearSkids(), false)) {
            EditHotkeys_OpenWindow();
        }

        UI::Separator();

        if (UI::MenuItem("Plugin Features Enabled", "", S_EnablePluginFeatures)) {
            S_EnablePluginFeatures = !S_EnablePluginFeatures;
        }
        AddSimpleTooltip("Disable plugin features without disabling dependent plugins.");

        UI::Separator();

        if (UI::MenuItem("VehicleState Update Hook Enabled", "", HookVehicleVisUpdate.IsApplied())) {
            HookVehicleVisUpdate.Toggle();
        }
        AddSimpleTooltip("This is REQUIRED for dependent plugins to work. Disabling this will only disable skidless ghosts and dependent plugins.");


        // HookVehicleVisUpdate.Toggle();
        // HookVehicleVisUpdate.IsApplied();
        UI::EndMenu();
    }
}


void Render() {
    RenderEditHotkeysWindow();
}


#if TMNEXT
// rcx = CSceneVehicleVis, rdx = CSceneVehicleVisState
void OnVehicleUpdate(uint id, uint64 ptr) {
    // auto id = Dev::ReadUInt32(ptr);
    // trace('ptr: ' + Text::FormatPointer(ptr) + ", id: " + Text::Format("%08x", id));
    if (id & 0xFF000000 != 0x04000000) return;
    SetWheelsFlying(ptr);
}
void SetWheelsFlying(uint64 visStatePtr) {
    // trace('wheels flying: ' + Text::FormatPointer(visStatePtr));
    // setting these to zero makes the camera think the vehicle is flying, 6 and 7 work
    // todo: read them first and only overwrite if ==4
    Dev_WriteChecked(visStatePtr + O_VEHICLESTATE_FL_FLYING, uint(0x7), 4);
    Dev_WriteChecked(visStatePtr + O_VEHICLESTATE_FR_FLYING, uint(0x7), 4);
    Dev_WriteChecked(visStatePtr + O_VEHICLESTATE_RL_FLYING, uint(0x7), 4);
    Dev_WriteChecked(visStatePtr + O_VEHICLESTATE_RR_FLYING, uint(0x7), 4);
}

void Dev_WriteChecked(uint64 addr, uint value, uint expected) {
    if (addr == 0) return;
    if (expected != Dev::ReadUInt32(addr)) return;
    Dev::Write(addr, value);
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
    // trace('FL :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (0 * WheelStructLength) + 0x14));
    // trace('FR :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (1 * WheelStructLength) + 0x14));
    // trace('RL :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (2 * WheelStructLength) + 0x14));
    // trace('RR :' + Dev::ReadUInt32(visStatePtr + WheelsStartOffset + (3 * WheelStructLength) + 0x14));
    Dev::Write(visStatePtr + WheelsStartOffset + (0 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (1 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (2 * WheelStructLength) + 0x14, uint(0x0));
    Dev::Write(visStatePtr + WheelsStartOffset + (3 * WheelStructLength) + 0x14, uint(0x0));
}
#endif

//remove any hooks
void OnDestroyed() { _Unload(); }
void OnDisabled() { _Unload(); }
void _Unload() {
    // VehicleState::DeregisterVehicleStateUpdateCallbacks();
    CheckUnhookAllRegisteredHooks();
    FreeAllAllocated();
}
