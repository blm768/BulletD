module main;

import std.stdio;

import bullet.linearMath.btScalar;

int main(string[] args) {
	auto obj = btTypedObject.opCall(1);

	writeln(obj.getObjectType());

	return 0;
}

