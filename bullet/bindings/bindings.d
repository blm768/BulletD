module bullet.bindings.bindings;

import std.conv;
//import std.stdio;
import std.string;
import std.traits;

version(genBindings) {
	public import std.stdio;
}

public import bullet.bindings.types;

template tuple(T ...) {
	alias T tuple;
}

template isInstanceMember(alias member) {
	enum isInstanceMember = __traits(compiles, member.offsetof);
}

mixin template basicClassBinding(string _cppName) {
	immutable string cppName = _cppName; 

	version(genBindings) {
		import std.stdio;

		static void writeBindings(File f) {
			bindingClasses ~= cppName;

			enum typeof(this) instance = typeof(this).init;
			foreach(member; __traits(allMembers, typeof(this))) {
				//Skips pseudo-members such as __fieldDtor, which cause errors.
				//To do: file bug report?
				static if(!(member.length >= 2 && member[0 .. 2] == "__")) {
					foreach(attribute; __traits(getAttributes, __traits(getMember, typeof(this), member))) {
						static if(is(attribute == Binding)) {
							f.writeln(__traits(getMember, typeof(this), member));
						}
					}
				}
			}
		}
	}

	//To do: disable default constructor?
	//@disable this();

	mixin destructor;
}

mixin template classBinding(string _cppName) {
	mixin basicClassBinding!(_cppName);

	//To do: prevent access to superclass constructors?

	private:
	ubyte[cppSize!(cppName)] _this;
}

mixin template subclassBinding(string _cppName, Super) {
	mixin basicClassBinding!(_cppName);
	Super _super;
	alias _super this;

	private:
	ubyte[cppSize!(cppName) - cppSize!(Super.cppName)] _extra;
}

enum Binding;

template method(T, string name, ArgTypes ...) {
	mixin("extern(C) " ~ T.stringof ~ " " ~ name ~ "(" ~ argList!(dType, 0, ArgTypes) ~ ");");
	version(genBindings) {
		mixin("@Binding immutable string binding_" ~ mixin(name ~ ".mangleof") ~ " = cMethodBinding!(typeof(this), T, name, \"" ~ mixin(name ~ ".mangleof") ~ "\", ArgTypes);");
	}
}

template constructor(ArgTypes ...) {
	mixin("extern(C) static typeof(this) opCall(" ~ argList!(dType, 0, ArgTypes) ~ ");");
	version(genBindings) {
		mixin("@Binding immutable string binding_" ~ opCall.mangleof ~ " = cConstructorBinding!(typeof(this), \"" ~ opCall.mangleof ~ "\", ArgTypes);");
	}
}

template destructor() {
	mixin("extern(C) void destroy();");
	version(genBindings) {
		mixin("@Binding immutable string binding_" ~ destroy.mangleof ~ " = cDestructorBinding!(typeof(this), \"" ~ destroy.mangleof ~ "\");");
		~this() {}
	} else {
		~this() {
			destroy();
		}
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
		enum cMethodBinding = `extern "C" ` ~ cppType!T ~ " " ~ mangledName ~ "(" ~ Class.cppName ~ "* _this" ~ (ArgTypes.length ? ", " : "") ~ argList!(cppType, 0, ArgTypes) ~ ") {\n" ~
			"\treturn _this->" ~ name ~ "(" ~ argNames!(ArgTypes.length) ~ "); \n" ~
		"}\n";
	}

	template cConstructorBinding(Class, string mangledName, ArgTypes ...) {
		enum cConstructorBinding = `extern "C" void ` ~ mangledName ~ "(" ~ Class.cppName ~ "* _this" ~ (ArgTypes.length ? ", " : "") ~ argList!(cppType, 0, ArgTypes) ~ ") {\n" ~
			"\t*_this = " ~ Class.cppName ~ "(" ~ argNames!(ArgTypes.length) ~ ");\n" ~
			"}\n";
	}
	template cDestructorBinding(Class, string mangledName) {
		enum cDestructorBinding = `extern "C" void ` ~ mangledName ~ "(" ~ Class.cppName ~ "* _this) {\n" ~
			"\t_this->~" ~ Class.cppName ~ "();\n" ~
			"}\n";
	}

	//Nasty, icky global variables used for binding generation
	string[] bindingIncludes;
	string[] bindingClasses;

	void writeIncludes(File f, string[] includes ...) {
		foreach(s; includes) {
			f.writeln(s);
			bindingIncludes ~= s;
		}
	}

	void writeSizeFile() {
		auto f = File("gen_sizes.cpp", "w");
		f.writeln("#include <fstream>");
		foreach(s; bindingIncludes) {
			f.writeln(s);
		}
		f.writeln(`
using namespace std;
int main(int argc, char** argv) {
	ofstream f;
	f.open("bullet/bindings/sizes.d");

	f << "module bullet.bindings.sizes;\n\n";
	`);
		foreach(cppName; bindingClasses) {
			//To do: escape quotes in cppName?
			f.writeln("\t", "f << \"template cppSize(string cppName: `", cppName, "`) {\\n\";");
			f.writeln("\t", `f << "\tenum size_t cppSize = " << sizeof(` ~ cppName ~ `) << ";\n";`);
			f.writeln("\t", `f << "}\n" << endl;`);
		}
		f.writeln("}");
	}
}


