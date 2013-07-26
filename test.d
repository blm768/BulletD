module main;

import std.stdio;

import bullet.collision.broadphase.all;
import bullet.collision.dispatch.all;
import bullet.dynamics.constraintSolver.all;
import bullet.dynamics.dynamics.all;
import bullet.collision.collisionShapes.all;

int main(string[] args) {
	auto bp = btDbvtBroadphase.cppNew();
	auto cc = btDefaultCollisionConfiguration.cppNew();
	auto di = btCollisionDispatcher.cppNew(&cc._super);
	auto cs = btSequentialImpulseConstraintSolver.cppNew();
	auto dw = btDiscreteDynamicsWorld.cppNew(&di._super, &bp._super, &cs._super, &cc._super);

	auto gravity = btVector3(0.0, -1.0, 0.0);
	dw.setGravity(gravity);

	//auto floor = btStaticPlaneShape.cppNew(btVector3(0, 0, 0), 1);


	//floor.cppDelete();

	dw.cppDelete();
	cs.cppDelete();
	di.cppDelete();
	cc.cppDelete();
	bp.cppDelete();

	return 0;
}

