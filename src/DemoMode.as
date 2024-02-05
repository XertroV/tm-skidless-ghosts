void DemoCoro() {
    while (true) {
        if (!m_EnableDemoMode) {
            sleep(1000);
            continue;
        }
        RunDemo();
        yield();
    }
}

bool m_EnableDemoMode = false;

[SettingsTab name="Demo" order=50]
void Render_SettingsTab_Demo() {
    m_EnableDemoMode = UI::Checkbox("Enable Demo Mode", m_EnableDemoMode);
    UI::TextWrapped("This will make a funky sinusoidal effect on skids.\nOnly for asphalt, dirt and grass.\nIt will interfere with clearing skids.");
}

// in skid points; note: 4 per frame b/c of 4 wheels
const uint HALF_DEMO_PERIOD = 13;
const uint DEMO_PERIOD = 26;
uint lastDemoRun = 0;

void RunDemo() {
    // NSceneParticleVis_SMgr
    auto mgr = FindManager(0x300b4000);
    if (mgr is null) return;
    auto particleVisMgr = D_NSceneParticleVis_SMgr(mgr.ptr);
    auto emitters = particleVisMgr.ActiveEmitters;
    auto nbEmitters = emitters.Length;
    int offCounter = (Time::Now >> 7) % DEMO_PERIOD;

    for (uint i = 0; i < nbEmitters; i++) {
        auto emitter = emitters.GetActiveEmitter(i);
        if (!DEMO_IsSkidEmitter(emitter) /*&& SeenSkidEmitter(emitter)*/) continue;
        auto points = emitter.PointsStruct.SkidsPoints;
        // optimize this to avoid 10ms exec time -> improves to about 2-3ms
        auto nbPoints = points.Length;
        if (nbPoints == 0) continue;
        auto firstPoint = points.GetPoint(0);
        auto pointsStartPointer = firstPoint.Ptr;
        auto pointSize = firstPoint.ElSize;
        auto invisOffset = firstPoint.InvisibleOffset;
        for (uint j = 0; j < nbPoints; j++) {
            Dev::Write(pointsStartPointer + j * pointSize + invisOffset, uint(offCounter / HALF_DEMO_PERIOD));
            offCounter = (offCounter - 1) % DEMO_PERIOD;
            // auto point = points.GetPoint(j);
            // point.Invisible = true;
        }
    }
}

bool DEMO_IsSkidEmitter(NSceneParticleVis_ActiveEmitter@ emitter) {
    return emitter.emitterType == 5 &&
        DEMO_DoesEmitterHaveSkidMat(emitter);
}

string[] demoSkidMatNames = {
    "WheelMarksAsphalt",
    "GrassMarkGround",
    "WheelMarksDirt"
};

bool DEMO_DoesEmitterHaveSkidMat(NSceneParticleVis_ActiveEmitter@ emitter) {
    CPlugParticleEmitterSubModel@ subModel = emitter.EmitterSubModel;
    if (subModel is null) return false;
    auto nod = Dev::GetOffsetNod(subModel, O_CPlugParticleEmitterSubModel_Render + 0x10);
    if (nod is null) return false;
    auto mat = cast<CPlugMaterial>(nod);
    if (mat is null) return false;
    auto fid = GetFidFromNod(mat);
    if (fid is null) return false;
    return DEMO_MatFidIsForSkids(fid);
}

bool DEMO_MatFidIsForSkids(CSystemFidFile@ fid) {
    return demoSkidMatNames.Find(fid.ShortFileName) >= 0;
}
