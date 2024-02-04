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






namespace NodPtrs {
    void InitializeTmpPointer() {
        g_TmpPtrSpace = RequestMemory(0x1000);
        auto nod = CMwNod();
        uint64 tmp = Dev::GetOffsetUint64(nod, 0);
        Dev::SetOffset(nod, 0, g_TmpPtrSpace);
        @g_TmpSpaceAsNod = Dev::GetOffsetNod(nod, 0);
        Dev::SetOffset(nod, 0, tmp);
    }

    uint64 g_TmpPtrSpace = 0;
    CMwNod@ g_TmpSpaceAsNod = null;
}

CMwNod@ Dev_GetArbitraryNodAt(uint64 ptr) {
    if (NodPtrs::g_TmpPtrSpace == 0) {
        NodPtrs::InitializeTmpPointer();
    }
    if (ptr == 0) throw('null pointer passed');
    Dev::SetOffset(NodPtrs::g_TmpSpaceAsNod, 0, ptr);
    return Dev::GetOffsetNod(NodPtrs::g_TmpSpaceAsNod, 0);
}

uint64 Dev_GetPointerForNod(CMwNod@ nod) {
    if (NodPtrs::g_TmpPtrSpace == 0) {
        NodPtrs::InitializeTmpPointer();
    }
    if (nod is null) return 0;
    Dev::SetOffset(NodPtrs::g_TmpSpaceAsNod, 0, nod);
    return Dev::GetOffsetUint64(NodPtrs::g_TmpSpaceAsNod, 0);
}

CMwNod@ Dev_GetNodFromPointer(uint64 ptr) {
    if (ptr < 0xFFFFFFFF || ptr % 8 != 0 || ptr >> 48 > 0) {
        return null;
    }
    return Dev_GetArbitraryNodAt(ptr);
}




bool Dev_PointerLooksBad(uint64 ptr) {
    if (ptr < 0x10000000000) return true;
    if (ptr % 8 != 0) return true;
    if (ptr > Dev::BaseAddressEnd()) return true;
    return false;
}




NodWithPtr@ FollowOffsets(uint[]@ offsets, CMwNod@ startNod = null) {
	if (startNod is null) {
		@startNod = GetApp();
	}
	auto @retNod = NodWithPtr(startNod);
	for (uint i = 0; i < offsets.Length; i++) {
		auto offset = offsets[i];
		if (retNod is null || retNod.nod is null) return null;
		@retNod = NodWithPtr(retNod.nod, offset);
	}
    if (retNod.nod is null) return null;
	return retNod;
}


class NodWithPtr {
	CMwNod@ nod;
	uint64 ptr;

	NodWithPtr(CMwNod@ nod) {
		@this.nod = nod;
		ptr = Dev_GetPointerForNod(nod);
	}

	NodWithPtr(CMwNod@ nod, uint offset) {
		if (nod is null) return;
		@this.nod = Dev::GetOffsetNod(nod, offset);
		this.ptr = Dev::GetOffsetUint64(nod, offset);
	}

	NodWithPtr(ISceneVis@ nod, uint offset) {
		if (nod is null) return;
		@this.nod = Dev::GetOffsetNod(nod, offset);
		this.ptr = Dev::GetOffsetUint64(nod, offset);
	}

	// void DrawClickablePointer(const string &in name) {
	// 	UI::Text(name + ": ");
	// 	UI::SameLine();
	// 	::DrawClickablePointer(name, this.ptr);
	// }
}




uint32 GetMwId(const string &in name) {
    auto x = MwId();
    x.SetName(name);
    return x.Value;
}
string GetMwIdName(uint id) {
    auto x = MwId(id);
    return x.GetName();
}




uint64[] memoryAllocations = array<uint64>();

uint64 Dev_Allocate(uint size, bool exec = false) {
    return RequestMemory(size, exec);
}

uint64 RequestMemory(uint size, bool exec = false) {
    auto ptr = Dev::Allocate(size, exec);
    memoryAllocations.InsertLast(ptr);
    return ptr;
}

void FreeAllAllocated() {
    for (uint i = 0; i < memoryAllocations.Length; i++) {
        Dev::Free(memoryAllocations[i]);
    }
    memoryAllocations.RemoveRange(0, memoryAllocations.Length);
}
