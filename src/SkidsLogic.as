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
        if (!IsSkidEmitter(emitter) && SeenSkidEmitter(emitter)) continue;
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
