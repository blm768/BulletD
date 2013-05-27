module main;
import std.file;
import std.stdio;

import bullet.bindings.bindings;
import bullet.bindings.types;
import bullet.linearMath.btScalar;

int main(string[] args) {
	File f;

	if(!exists("glue")) {
		mkdir("glue");
	}
	
	 static if(__traits(compiles, bullet.bindings.bindings.writeBindings)) {
		f = File("glue/bullet/bindings/bindings.cpp");
		bullet.bindings.bindings.writeBindings(f);
	}
	 static if(__traits(compiles, bullet.bindings.types.writeBindings)) {
		f = File("glue/bullet/bindings/types.cpp");
		bullet.bindings.types.writeBindings(f);
	}
	 static if(__traits(compiles, bullet.linearMath.btScalar.writeBindings)) {
		f = File("glue/bullet/linearMath/btScalar.cpp");
		bullet.linearMath.btScalar.writeBindings(f);
	}

	return 0;
}

