namespace SkidsMagician {
	// Register a callback for late in the process when a vehicle state is updated. (Will forward to VehicleState when implemented there)
	import void RegisterOnVehicleStateUpdateCallback(OnVehicleStateUpdated@ func) from "SkidsMagician";
	// Deregister all callbacks from the calling plugin. (Will forward to VehicleState when implemented there)
	import void DeregisterVehicleStateUpdateCallbacks() from "SkidsMagician";
}
