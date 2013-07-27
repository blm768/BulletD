module main;

import std.stdio;

import bullet.all;

int main(string[] args) {
	auto bp = btDbvtBroadphase.cppNew();
	auto cConfig = btDefaultCollisionConfiguration.cppNew();
	auto di = btCollisionDispatcher.cppNew(&cConfig._super);
	auto cs = btSequentialImpulseConstraintSolver.cppNew();
	auto world = btDiscreteDynamicsWorld.cppNew(&di._super, &bp._super, &cs._super, &cConfig._super);

	auto gravity = btVector3(0.0, -1.0, 0.0);
	world.setGravity(gravity);

	auto orientation = btQuaternion(0, 0, 0, 1);

	auto floor = btStaticPlaneShape.cppNew(btVector3(0, 0, 0), 1);
	auto floorMotionState = btDefaultMotionState.cppNew(btTransform(orientation, btVector3(0, 0, 0)));

	auto fall = btSphereShape.cppNew(1);
	auto fallMotionState = btDefaultMotionState.cppNew(btTransform(orientation, btVector3(0, 0, 0)));

	fall.cppDelete();
	floorMotionState.cppDelete();
	floor.cppDelete();

	world.cppDelete();
	cs.cppDelete();
	di.cppDelete();
	cConfig.cppDelete();
	bp.cppDelete();

	return 0;
}

