module bullet.bindings.bindings;

import std.conv;
import std.stdio;
import std.string;
import std.traits;

public import bullet.bindings.types;

mixin template classBinding(string _cppName) {
	enum cppName = _cppName; 

	static void writeBindings(File f) {
		foreach(member; __traits(allMembers, typeof(this))) {
			pragma(msg, member);
		}
	}

	private:
	ubyte[cppSize!(typeof(this))] _this;
}

enum Binding;

template method(T, string name, ArgTypes ...) {
	mixin("extern(C) " ~ T.stringof ~ " " ~ name ~ "(" ~ argList!(dType, 0, ArgTypes) ~ ");");
	version(genBindings) {
		pragma(msg, name ~ ArgTypes.stringof ~ ".mangleof");
		private enum mangledName = mixin(name ~ ".mangleof");
		mixin("@Binding string binding_" ~ mangledName ~ " = cMethodBinding!(typeof(this), T, name, mangledName, ArgTypes);");
	}
//		return " ~ cMangledName!(typeof(this), name, ArgTypes) ~ "(" ~ argNames!(ArgTypes.length) ~ ");	
//	}");
	//mixin("extern(C) " ~ T.stringof ~ " " ~ cMangledName!(typeof(this), name, ArgTypes) ~ "(" ~ cppCompatibleTypes!(ArgTypes) ~ ");");
}

template cMangledName(Class, string name, ArgTypes ...) {
	enum cMangledName = "bullet_" ~ Class.stringof ~ "_" ~ name;
}

template argList(alias transform, size_t start, ArgTypes ...) {
	static if(ArgTypes.length == 0) {
		enum argList = "";
	} else static if(ArgTypes.length == 1) {
		private alias transformed = smartStringof!(transform!(ArgTypes[0]));
		enum argList = transformed ~ " a" ~ start.to!string();
	} else {
		enum argList = argList!(transform, start, ArgTypes[0]) ~ ", " ~ argList!(transform, start + 1, ArgTypes[1 .. $]);
	}
}

template argNames(size_t n) {
	static if(n == 0) {
		enum argNames = "";
	} else static if(n == 1) {
		enum argNames = "a" ~ (n - 1).to!string();
	} else {
		enum argNames = argNames!(n - 1) ~ ", a" ~ (n - 1).to!string();
	}
}

version(genBindings) {
	template cMethodBinding(Class, T, string name, string mangledName, ArgTypes ...) {
		enum cMethodBinding = cppType!T ~ " " ~ mangledName ~ "(" ~ argList!(cppType, 0, ArgTypes) ~ (ArgTypes.length ? ", " : "") ~ Class.cppName ~ "* _this) {\n" ~
			"\treturn _this." ~ name ~ "(" ~ argNames!(ArgTypes.length) ~ (ArgTypes.length ? ", " : "") ~ "_this); \n" ~
		"};\n";
	}
}


