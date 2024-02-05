#if SIG_DEVELOPER

[SettingsTab name="Debug" icon="Icons::Cogs" order=99]
void RenderDebugSettingsTab() {
    UI::Text("g_IsPlayerDriving: " + g_IsPlayerDriving);
    UI::Text("g_EnableSkidlessGhostsThisFrame: " + g_EnableSkidlessGhostsThisFrame);
    DGameCamera@ gameCamera = GetGameCamera(GetApp());
    if (gameCamera !is null) {
        CopiableLabeledValue("Viewing Entity ID", Text::Format("0x%08x", gameCamera.ViewingEntityId));
        CopiableLabeledValue("Viewing Entity source class ID", Text::Format("0x%08x", gameCamera.ViewingClassId));
        CopiableLabeledValue("Mediatracker Vis Ent ID", Text::Format("0x%08x", gameCamera.MTVisEntId));
        CopiableLabeledValue("Vis Ent ID 2", Text::Format("0x%08x", gameCamera.VisEntId2));
        CopiableLabeledValue("Source Class ID 2", Text::Format("0x%08x", gameCamera.PlayerClassId3));
        UI::Text("ChosenCamera: " + gameCamera.ChosenCamera);
    } else {
        UI::Text("No Game Camera");
    }
}

#endif
