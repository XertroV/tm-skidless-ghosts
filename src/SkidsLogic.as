void ClearSkids() {
    // NSceneParticleVis_SMgr
    auto mgr = FindManager(0x300b4000);
    if (mgr is null) return;
    auto particleVisMgr = Dev_NSceneParticleVis_SMgr(mgr.ptr);
    auto emitters = particleVisMgr.ActiveEmitters;
    ResetSeenEmitters();
    auto nbEmitters = emitters.Length;
    for (uint i = 0; i < nbEmitters; i++) {
        auto emitter = emitters.GetActiveEmitter(i);
        if (!IsSkidEmitter(emitter) /*&& SeenSkidEmitter(emitter)*/) continue;
        auto points = emitter.PointsStruct.SkidsPoints;
        auto nbPoints = points.Length;
        for (uint j = 0; j < nbPoints; j++) {
            auto point = points.GetPoint(j);
            point.Invisible = true;
        }
    }
}

// auto emitterName = GetEmitterNameOnlyRelevant(emitter);

dictionary seenEmitters;

void ResetSeenEmitters() {
    seenEmitters.DeleteAll();
}

bool IsSkidEmitter(NSceneParticleVis_ActiveEmitter@ emitter) {
    return emitter.emitterType == 5 &&
        DoesEmitterHaveSkidMat(emitter);
}

bool DoesEmitterHaveSkidMat(NSceneParticleVis_ActiveEmitter@ emitter) {
    auto subModel = emitter.EmitterSubModel;
    if (subModel is null) return false;
    auto nod = Dev::GetOffsetNod(subModel, GetOffset(subModel, "Render") + 0x10);
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
//     "WheelMarksWood",
//     "WheelMarksMetal",
//     "WheelMarksIce",
//     "WheelMarksMud",
//     "WheelMarksWater",
//     "WheelMarksGravel",
//     "WheelMarksLeaves",
//     "WheelMarksPuddle",
//     "WheelMarksOil",
//     "WheelMarksPavement",
//     "WheelMarksRock",
//     "WheelMarksRubber",
//     "WheelMarksTarmac",
//     "WheelMarksTire",
//     "WheelMarksTrack",
//     "WheelMarksTrail",
//     "WheelMarksTrain",
//     "WheelMarksTram",
//     "WheelMarksTunnel",
//     "WheelMarksUnderground",
//     "WheelMarksWall",
//     "WheelMarksWater",
//     "WheelMarksWet",
//     "WheelMarksWood",
//     "WheelMarksWooden",
//     "WheelMarksYellow",
//     "WheelMarksZebra",
//     "WheelMarksZigzag"
// };
