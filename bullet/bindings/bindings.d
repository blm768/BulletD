module bullet.bindings.bindings;

import std.conv;
import std.string;
public import std.traits;

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
				static if(member != `__fieldDtor` && isSomeString!(typeof(__traits(getMember, typeof(this), member)))) {
					foreach(attribute; __traits(getAttributes, __traits(getMember, typeof(this), member))) {
						static if(is(attribute == Binding)) {
							f.writeln(__traits(getMember, typeof(this), member));
						}
					}
				}
			}
		}
	}
}

mixin template classBinding(string _cppName) {
	mixin basicClassBinding!(_cppName);

	mixin destructor;

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

/++
Creates a binding to a C++ method
+/
mixin template method(T, string name, ArgTypes ...) {
	mixin("extern(C) " ~ T.stringof ~ " " ~ name ~ "(" ~ argList!(dType, 0, ArgTypes) ~ ");");
	version(genBindings) {
		mixin("@Binding immutable string binding_" ~ mixin(name ~ ".mangleof") ~ " = cMethodBinding!(typeof(this), T, name, \"" ~ mixin(name ~ ".mangleof") ~ "\", ArgTypes);");
	}
}

/++
Creates a binding to a C++ constructor

If there are no arguments, the constructor is faked using a static opCall().
+/
mixin template constructor() {
	mixin("extern(C) static typeof(this) opCall();");
	mixin newConstructor!();
	version(genBindings) {
		mixin("@Binding immutable string binding_" ~ opCall.mangleof ~ " = cCreateDefaultObjectBinding!(typeof(this), \"" ~ opCall.mangleof ~ "\");");
	}
}

///ditto
mixin template constructor(ArgTypes ...) {
	mixin("private extern(C) void _construct(" ~ argList!(dType, 0, ArgTypes) ~ ");");
	mixin newConstructor!(ArgTypes);
	version(genBindings) {
		this(ArgTypes) {}
		mixin("@Binding immutable string binding_" ~ _construct.mangleof ~ " = cConstructorBinding!(typeof(this), \"" ~ _construct.mangleof ~ "\", ArgTypes);");
	} else {
		//To do: figure out why directly forwarding this() to the C++ constructor causes a segfault when constructing temporaries.
		this(ArgTypes args) {
			_construct(args);
		}
	}
}

/++
Creates a binding to the C++ "new" operator
+/
mixin template newConstructor(ArgTypes ...) {
	mixin("extern(C) static typeof(this)* cppNew(" ~ argList!(dType, 0, ArgTypes) ~ ");");
	version(genBindings) {
		mixin("@Binding immutable string binding_" ~ cppNew.mangleof ~ " = cNewBinding!(typeof(this), \"" ~ cppNew.mangleof ~ "\", ArgTypes);");
	}
}

/++
Creates a binding to the C++ destructor

Automatically mixed in by classBinding
+/
mixin template destructor() {
	//To do: rename destroy()?
	mixin("extern(C) void destroy();");
	mixin("extern(C) void cppDelete();");
	version(genBindings) {
		mixin("@Binding immutable string binding_" ~ destroy.mangleof ~ " = cDestructorBinding!(typeof(this), \"" ~ destroy.mangleof ~ "\");");
		mixin("@Binding immutable string binding_" ~ cppDelete.mangleof ~ " = cDeleteBinding!(typeof(this), \"" ~ cppDelete.mangleof ~ "\");");
		~this() {}
	} else {
		~this() {
			destroy();
		}
	}
}

template argList(alias transform, size_t start, ArgTypes ...) {
	static if(ArgTypes.length == 0) {
		enum argList = "";
	} else static if(ArgTypes.length == 1) {
		private alias transformed = transform!(ArgTypes[0]);
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

	template cCreateDefaultObjectBinding(Class, string mangledName) {
		enum cCreateDefaultObjectBinding = `extern "C" ` ~ Class.cppName ~ " " ~ mangledName ~ "() {\n" ~
			"\treturn " ~ Class.cppName ~ "();\n" ~
			"}\n";
	}

	template cConstructorBinding(Class, string mangledName, ArgTypes ...) {
		enum cConstructorBinding = `extern "C" void ` ~ mangledName ~ "(" ~ Class.cppName ~ "* _this" ~ (ArgTypes.length ? ", " : "") ~ argList!(cppType, 0, ArgTypes) ~ ") {\n" ~
			"\tnew(_this) " ~ Class.cppName ~ "(" ~ argNames!(ArgTypes.length) ~ ");\n" ~
			"}\n";
	}

	//To do: array new/delete?
	template cNewBinding(Class, string mangledName, ArgTypes ...) {
		enum cNewBinding = `extern "C" ` ~ Class.cppName ~ "* " ~ mangledName ~ "(" ~ argList!(cppType, 0, ArgTypes) ~ ") {\n" ~
			"\treturn new " ~ Class.cppName ~ "(" ~ argNames!(ArgTypes.length) ~ ");\n" ~
			"}\n";
	}

	template cDestructorBinding(Class, string mangledName) {
		enum cDestructorBinding = `extern "C" void ` ~ mangledName ~ "(" ~ Class.cppName ~ "* _this) {\n" ~
			"\t_this->~" ~ Class.cppName ~ "();\n" ~
			"}\n";
	}
	
	template cDeleteBinding(Class, string mangledName) {
		enum cDeleteBinding = `extern "C" void ` ~ mangledName ~ "(" ~ Class.cppName ~ "* _this) {\n" ~
			"\tdelete _this;\n" ~
			"}\n";
	}

	//Nasty, icky global variables used for binding generation
	string[] bindingIncludes;
	string[] bindingClasses;

	void writeIncludes(File f, string[] includes ...) {
		f.writeln("#include <new>");
		foreach(s; includes) {
			f.writeln(s);
			bindingIncludes ~= s;
		}
	}

	void writeGenC() {
		auto f = File("gen_c.cpp", "w");
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


