module bullet.bindings.bindings;

import std.conv;
import std.stdio;
import std.string;
import std.traits;

public import bullet.bindings.types;

template tuple(T ...) {
	alias T tuple;
}

template isInstanceMember(alias member) {
	enum isInstanceMember = __traits(compiles, member.offsetof);
}

mixin template classBinding(string _cppName) {
	immutable string cppName = _cppName; 

	version(genBindings) {
		static void writeBindings(File f) {
			enum typeof(this) instance = typeof(this).init;
			foreach(member; __traits(allMembers, typeof(this))) {
				foreach(attribute; __traits(getAttributes, __traits(getMember, typeof(this), member))) {
					static if(is(attribute == Binding)) {
						f.writeln(__traits(getMember, typeof(this), member));
					}
				}
			}
		}
	}

	private:
	ubyte[cppSize!(typeof(this))] _this;
}

enum Binding;

template method(T, string name, ArgTypes ...) {
	mixin("extern(C) " ~ T.stringof ~ " " ~ name ~ "(" ~ argList!(dType, 0, ArgTypes) ~ ");");
	version(genBindings) {
		mixin("@Binding immutable string binding_" ~ mixin(name ~ ".mangleof") ~ " = cMethodBinding!(typeof(this), T, name, \"" ~ mixin(name ~ ".mangleof") ~ "\", ArgTypes);");
	}
//		return " ~ cMangledName!(typeof(this), name, ArgTypes) ~ "(" ~ argNames!(ArgTypes.length) ~ ");	
//	}");
}

template constructor(ArgTypes ...) {
	mixin("extern(C) static typeof(this) opCall(" ~ argList!(dType, 0, ArgTypes) ~ ");");
	version(genBindings) {
		mixin("@Binding immutable string binding_" ~ opCall.mangleof ~ " = cConstructorBinding!(typeof(this), \"" ~ opCall.mangleof ~ "\", ArgTypes);");
	}
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
		pragma(msg, mangledName);
		enum cMethodBinding = `extern "C" ` ~ cppType!T ~ " " ~ mangledName ~ "(" ~ argList!(cppType, 0, ArgTypes) ~ (ArgTypes.length ? ", " : "") ~ Class.cppName ~ "* _this) {\n" ~
			"\treturn _this->" ~ name ~ "(" ~ argNames!(ArgTypes.length) ~ "); \n" ~
		"}\n";
	}

	template cConstructorBinding(Class, string mangledName, ArgTypes ...) {
		enum cConstructorBinding = `extern "C" ` ~ Class.cppName ~ " " ~ mangledName ~ "(" ~ argList!(cppType, 0, ArgTypes) ~ ") {\n" ~
			"\treturn " ~ Class.cppName ~ "(" ~ argNames!(ArgTypes.length) ~ ");\n" ~
			"}\n";
	}
}


