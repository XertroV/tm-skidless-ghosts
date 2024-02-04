/*
 * HOTKEYS
 */

[Setting hidden]
VirtualKey S_ToggleSkidlessGhostsHotkey = VirtualKey::F8;

[Setting hidden]
bool S_EnableToggleSkidlessGhostsHotkey = false;

[Setting hidden]
VirtualKey S_ClearSkidsHotkey = VirtualKey::C;

[Setting hidden]
bool S_EnableClearSkidsHotkey = false;




UI::InputBlocking OnKeyPress(bool down, VirtualKey key) {
    if (down && rebindInProgress) {
        ReportRebindKey(key);
        return UI::InputBlocking::Block;
    }
    if (S_EnableToggleSkidlessGhostsHotkey && down && key == S_ToggleSkidlessGhostsHotkey) {
        return OnPressToggleSkidlessGhostsHotkey();
    }
    if (S_EnableClearSkidsHotkey && down && key == S_ClearSkidsHotkey) {
        return OnPressClearSkidsHotkey();
    }
    return UI::InputBlocking::DoNothing;
}





[SettingsTab name="Hotkeys" icon="Th" order="1"]
void S_HotkeysTab() {
    if (UI::BeginTable("bindings", 4, UI::TableFlags::SizingStretchSame)) {
        UI::TableSetupColumn("Key", UI::TableColumnFlags::WidthStretch, 1.1);
        UI::TableSetupColumn("Binding", UI::TableColumnFlags::WidthStretch, .3f);
        UI::TableSetupColumn("", UI::TableColumnFlags::WidthFixed, 70);
        UI::TableSetupColumn("", UI::TableColumnFlags::WidthFixed, 100);
        UI::TableHeadersRow();

        S_ToggleSkidlessGhostsHotkey = DrawKeyBinding("Toggle Skidless Ghosts", S_ToggleSkidlessGhostsHotkey);
        S_EnableToggleSkidlessGhostsHotkey = DrawKeyBindSwitch("toggle-skidless-ghosts", S_EnableToggleSkidlessGhostsHotkey);

        S_ClearSkidsHotkey = DrawKeyBinding("Clear Skids", S_ClearSkidsHotkey);
        S_EnableClearSkidsHotkey = DrawKeyBindSwitch("clear-skids", S_EnableClearSkidsHotkey);

        UI::EndTable();
    }
    UI::Separator();
    if (rebindInProgress) {
        UI::Text("Press a key to bind, or Esc to cancel.");
    } else {
        UI::Text("\\$888Enable hotkeys and rebind them.");
        UI::Text("\\$888Status messages will appear here.");
    }
    UI::Dummy(vec2(0, 20));
}

string activeKeyName;
VirtualKey tmpKey;
bool gotNextKey = false;
bool rebindInProgress = false;
bool rebindAborted = false;
VirtualKey DrawKeyBinding(const string &in name, VirtualKey &in valIn) {
    bool amActive = rebindInProgress && activeKeyName == name;
    bool amDone = (rebindAborted || gotNextKey) && !rebindInProgress && activeKeyName == name;
    UI::PushID(name);

    UI::TableNextRow();
    UI::TableNextColumn();
    UI::AlignTextToFramePadding();
    UI::Text(name);

    UI::TableNextColumn();
    UI::Text(tostring(valIn));

    UI::TableNextColumn();
    UI::BeginDisabled(rebindInProgress);
    if (UI::Button("Rebind")) StartRebind(name);
    UI::EndDisabled();

    UI::PopID();
    // if (amActive) {
        // UI::SameLine();
        // UI::Text("Press a key to bind, or Esc to cancel.");
    // }
    if (amDone) {
        if (gotNextKey) {
            ResetBindingState();
            return tmpKey;
        } else {
            UI::SameLine();
            UI::Text("\\$888Rebind aborted.");
        }
    }
    return valIn;
}

bool DrawKeyBindSwitch(const string &in id, bool val) {
    UI::TableNextColumn();
    return UI::Checkbox("Enabled##" + id, val);
}

void ResetBindingState() {
    rebindInProgress = false;
    activeKeyName = "";
    gotNextKey = false;
    rebindAborted = false;
}

void StartRebind(const string &in name) {
    if (rebindInProgress) return;
    rebindInProgress = true;
    activeKeyName = name;
    gotNextKey = false;
    rebindAborted = false;
}

void ReportRebindKey(VirtualKey key) {
    if (!rebindInProgress) return;
    if (key == VirtualKey::Escape) {
        rebindInProgress = false;
        rebindAborted = true;
    } else {
        rebindInProgress = false;
        gotNextKey = true;
        tmpKey = key;
    }
}


// separate window

bool g_HotkeyWindowOpen = false;

void EditHotkeys_OpenWindow() {
    g_HotkeyWindowOpen = true;
}

void RenderEditHotkeysWindow() {
    if (!g_HotkeyWindowOpen) return;
    UI::SetNextWindowSize(450, 0, UI::Cond::Appearing);
    if (UI::Begin(PluginName + ": Edit Hotkeys", g_HotkeyWindowOpen)) {
        S_HotkeysTab();
    }
    UI::End();
}


// -------------- HOTKEYS --------------



UI::InputBlocking OnPressToggleSkidlessGhostsHotkey() {
#if DEV
    trace('OnPressToggleSkidlessGhostsHotkey');
#endif
    S_EnableSkidlessGhosts = !S_EnableSkidlessGhosts;
    Notify("Skidless ghosts " + (S_EnableSkidlessGhosts ? "\\$4e4 ENABLED " + Icons::Magic : "\\$e44 DISABLED " + Icons::Stop));
    return UI::InputBlocking::DoNothing;
}

UI::InputBlocking OnPressClearSkidsHotkey() {
#if DEV
    trace('OnPressClearSkidsHotkey');
#endif
    ClearSkids();
    Notify("\\$4e4  Skids cleared   " + Icons::Trash);
    return UI::InputBlocking::DoNothing;
}

string GetHotkey_SkidlessGhosts() {
    return !S_EnableToggleSkidlessGhostsHotkey ? "<disabled>" : tostring(S_ToggleSkidlessGhostsHotkey);
}

string GetHotkey_ClearSkids() {
    return !S_EnableClearSkidsHotkey ? "<disabled>" : tostring(S_ClearSkidsHotkey);
}
