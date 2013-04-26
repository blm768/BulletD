module bullet.bindings.types;

import std.traits;

template dType(T) {
	alias T dType;
}

//To do: how to handle shared?
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

template cppTypes(Types ...) {
	static assert(Types.length > 0);
	static if(Types.length == 1) {
		alias cppType!(Types[0]) cppTypes;
	} else {
		enum cppTypes = cppType!(Types[0]) ~ ", " ~ cppTypes!(Types[1 .. $]);
	}
}

template cppCompatibleType(T) {
	static if(isArray!T) {
		alias typeof(T[0])* cppCompatibleType;
	} else {
		alias T cppCompatibleType;
	} 
}

template cppCompatibleTypes(Types ...) {
	static assert(Types.length > 0);
	static if(Types.length == 1) {
		enum cppCompatibleTypes = cppCompatibleType!(Types[0]).stringof;
	} else {
		enum cppCompatibleTypes = cppCompatibleType!(Types[0]).stringof ~ ", " ~ cppCompatibleTypes!(Types[1 .. $]);
	}
}

template smartStringof(T) {
	enum smartStringof = T.stringof;
}

template smartStringof(string s) {
	alias s smartStringof;
}

version(genBindings) {
	template cppSize(T) {
		enum size_t cppSize = 1;
	}
}


