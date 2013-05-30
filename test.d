module main;

import std.stdio;

import bullet.collision.broadphase.dbvtBroadphase;
import bullet.linearMath.btScalar;

int main(string[] args) {
	auto bp = btDbvtBroadphase.cppNew();

	bp.cppDelete();

	return 0;
}

