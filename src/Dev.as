uint16 GetOffset(const string &in className, const string &in memberName) {
    // throw exception when something goes wrong.
    auto ty = Reflection::GetType(className);
    auto memberTy = ty.GetMember(memberName);
    if (memberTy.Offset == 0xFFFF) throw("Invalid offset: 0xFFFF");
    return memberTy.Offset;
}
uint16 GetOffset(CMwNod@ obj, const string &in memberName) {
    if (obj is null) return 0xFFFF;
    // throw exception when something goes wrong.
    auto ty = Reflection::TypeOf(obj);
    if (ty is null) throw("could not find a type for object");
    auto memberTy = ty.GetMember(memberName);
    if (memberTy is null) throw(ty.Name + " does not have a child called " + memberName);
    if (memberTy.Offset == 0xFFFF) throw("Invalid offset: 0xFFFF");
    return memberTy.Offset;
}

const uint16 O_VEHICLESTATE_FL_FLYING = GetOffset("CSceneVehicleVisState", "FLBreakNormedCoef") + 4;
const uint16 O_VEHICLESTATE_FR_FLYING = GetOffset("CSceneVehicleVisState", "FRBreakNormedCoef") + 4;
const uint16 O_VEHICLESTATE_RL_FLYING = GetOffset("CSceneVehicleVisState", "RLBreakNormedCoef") + 4;
const uint16 O_VEHICLESTATE_RR_FLYING = GetOffset("CSceneVehicleVisState", "RRBreakNormedCoef") + 4;
