module bullet.bindings.types;

import std.traits;

version(genBindings) {
	template cppSize(string cppName) {
		enum size_t cppSize = 1;
	}
} else {
	public import bullet.bindings.sizes;
}

/++
Dummy type wrapper that indicates to the binding generator that a parameter should be given the ref storage class
+/
struct RefParam(T) {}

template dType(T) {
	enum dType = T.stringof;
}

template dType(T: RefParam!T) {
	enum dType = "ref " ~ dType!T;
}

//TODO: how to handle shared?
template cppType(T) {
	static if(!isMutable!T) {
		enum cppType = "const " ~ cppType!(Unqual!T);
	} else static if(isUnsigned!T) {
		enum cppType = "unsigned " ~ cppType!(Signed!T);
	} else static if(isArray!T) {
		enum cppType = "(" ~ cppType!(typeof(T[0])) ~ ")*";
	} else {
		enum cppType = T.stringof;
	}
}

template cppType(T: byte) {
	enum cppType = "char";
}

template cppType(T: RefParam!T) {
	enum cppType = cppType!T ~ "&";
}

template cppTypes(Types ...) {
	static assert(Types.length > 0);
	static if(Types.length == 1) {
		alias cppType!(Types[0]) cppTypes;
	} else {
		enum cppTypes = cppType!(Types[0]) ~ ", " ~ cppTypes!(Types[1 .. $]);
	}
}

