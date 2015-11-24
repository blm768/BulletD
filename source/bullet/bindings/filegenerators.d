// BulletD - a D binding for the Bullet Physics engine
// written in the D programming language
//
// Copyright: Ben Merritt 2012 - 2013,
//            MeinMein 2013 - 2014.
// License:   Boost License 1.0
//            (See accompanying file LICENSE_1_0.txt or copy at
//             http://www.boost.org/LICENSE_1_0.txt)
// Authors:   Ben Merrit,
//            Gerbrand Kamphuis (meinmein.com).

module bullet.bindings.filegenerators;

import bullet.bindings.bindings;

static if(bindSymbols)
{
	public import std.stdio;

	string[] bindingClasses;
	string[] bindingIncludes;

	// bullet/bindings/glue.d
	static if(adjustSymbols)
	{
		string[] dGlueFunctions;

		void writeDGlue()
		{
			auto f = File("bullet/bindings/generated/glue.d", "w");

			f.write("module bullet.bindings.glue;\n\nimport bullet.all;\n\n");

			foreach(fn; dGlueFunctions)
				f.writeln(fn);
		}
	}
	else
		void writeDGlue() {}

	// glue/bullet/bindings/*.cpp
	void writeIncludes(File f, string[] includes ...)
	{
		f.writeln("#include <new>");

		foreach(s; includes)
		{
			f.writeln(s);
			bindingIncludes ~= s;
		}
	}

	// gen_c.cpp & bullet/bindings/sizes.d
	void writeGenC()
	{
		//TODO: remove (esp. hard-coded path)
		auto f = File("glue/gen_c.cpp", "w");
		f.writeln("#include <fstream>");

		foreach(s; bindingIncludes)
			f.writeln(s);

		f.writeln(`
using namespace std;
int main(int argc, char** argv) {
	ofstream f;
	f.open("bullet/bindings/sizes.d");

	f << "module bullet.bindings.sizes;\n\n";
	`);

		foreach(cppName; bindingClasses)
		{
			f.writeln("\t", "f << \"template cppSize(string cppName: `", cppName, "`) {\\n\";");
			f.writeln("\t", `f << "\tenum size_t cppSize = " << sizeof(` ~ cppName ~ `) << ";\n";`);
			f.writeln("\t", `f << "}\n" << endl;`);
		}

		f.writeln("}");
	}
}

// collect data for writeDGlue and writeGenC
mixin template bindingData()
{
	import std.algorithm: startsWith;
	import bullet.bindings.introspection;
	static if(bindSymbols)
	{
		import std.stdio: File;

		static void writeBindings(File f)
		{
			bindingClasses ~= cppName;

				foreach(member; BindingMembers!(typeof(this)))
				{
					static if(member.startsWith("_d_glue_"))
						dGlueFunctions ~= __traits(getMember, typeof(this), member);

					static if(member.length > 9 && member[0 .. 9] == "_binding_")
						f.writeln(__traits(getMember, typeof(this), member));
				}
			}
		}
}
