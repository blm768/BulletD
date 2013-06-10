module main;

import std.stdio;

import bullet.collision.broadphase.dbvtBroadphase;
import bullet.collision.dispatch.defaultCollisionConfiguration;
import bullet.collision.dispatch.collisionDispatcher;
import bullet.linearMath.btScalar;

int main(string[] args) {
	auto bp = btDbvtBroadphase.cppNew();
	auto cc = btDefaultCollisionConfiguration.cppNew();
	auto di = btCollisionDispatcher.cppNew(cc);

	return 0;
}

