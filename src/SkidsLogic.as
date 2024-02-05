void ClearSkids() {
    // NSceneParticleVis_SMgr
    auto mgr = FindManager(0x300b4000);
    if (mgr is null) return;
    auto particleVisMgr = D_NSceneParticleVis_SMgr(mgr.ptr);
    auto emitters = particleVisMgr.ActiveEmitters;
    auto nbEmitters = emitters.Length;
    for (uint i = 0; i < nbEmitters; i++) {
        auto emitter = emitters.GetActiveEmitter(i);
        if (!IsSkidEmitter(emitter) /*&& SeenSkidEmitter(emitter)*/) continue;
        auto points = emitter.PointsStruct.SkidsPoints;
        // optimize this to avoid 10ms exec time -> improves to about 2-3ms
        auto nbPoints = points.Length;
        if (nbPoints == 0) continue;
        auto firstPoint = points.GetPoint(0);
        auto pointsStartPointer = firstPoint.Ptr;
        auto pointSize = firstPoint.ElSize;
        auto invisOffset = firstPoint.InvisibleOffset;
        for (uint j = 0; j < nbPoints; j++) {
            Dev::Write(pointsStartPointer + j * pointSize + invisOffset, uint(1));
            // auto point = points.GetPoint(j);
            // point.Invisible = true;
        }
    }
}

bool IsSkidEmitter(NSceneParticleVis_ActiveEmitter@ emitter) {
    return emitter.emitterType == 5 &&
        DoesEmitterHaveSkidMat(emitter);
}

const uint16 O_CPlugParticleEmitterSubModel_Render = GetOffset('CPlugParticleEmitterSubModel', "Render");

bool DoesEmitterHaveSkidMat(NSceneParticleVis_ActiveEmitter@ emitter) {
    CPlugParticleEmitterSubModel@ subModel = emitter.EmitterSubModel;
    if (subModel is null) return false;
    auto nod = Dev::GetOffsetNod(subModel, O_CPlugParticleEmitterSubModel_Render + 0x10);
    if (nod is null) return false;
    auto mat = cast<CPlugMaterial>(nod);
    if (mat is null) return false;
    auto fid = GetFidFromNod(mat);
    if (fid is null) return false;
    return MatFidIsForSkids(fid);
}

bool MatFidIsForSkids(CSystemFidFile@ fid) {
    return skidMatNames.Find(fid.ShortFileName) >= 0;
}

string[] skidMatNames = {
    "WheelMarksAsphalt",
    "GrassMarkFenceIntens"
    "GrassMarkGround"
    "WheelMarksIce",
    "WheelMarksDirt",
    "WheelMarksSnow",
    "WheelMarksSand",
    "WheelMarksWet"
};
