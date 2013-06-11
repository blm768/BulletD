module main;

import std.stdio;

import bullet.collision.broadphase.dbvtBroadphase;
import bullet.collision.dispatch.defaultCollisionConfiguration;
import bullet.collision.dispatch.collisionDispatcher;
import bullet.dynamics.constraintSolver.sequentialImpulseConstraintSolver;

int main(string[] args) {
	auto bp = btDbvtBroadphase.cppNew();
	auto cc = btDefaultCollisionConfiguration.cppNew();
	auto di = btCollisionDispatcher.cppNew(&cc._super);
	auto cs = btSequentialImpulseConstraintSolver.cppNew();

	cs.cppDelete();
	di.cppDelete();
	cc.cppDelete();
	bp.cppDelete();

	return 0;
}

