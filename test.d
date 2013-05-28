module main;

import std.stdio;

import bullet.collision.broadphase.dbvt;

int main(string[] args) {
	auto bp = btDbvt.opCall();

	return 0;
}

