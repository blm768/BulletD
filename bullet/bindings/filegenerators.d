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
			auto f = File("bullet/bindings/glue.d", "w");
			
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
		auto f = File("gen_c.cpp", "w");
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
	static if(bindSymbols)
	{
		import std.stdio: File;

		static void writeBindings(File f)
		{
			bindingClasses ~= cppName;

			static if(adjustSymbols)
			{
				foreach(member; __traits(allMembers, typeof(this)))
				{
					static if(member.length <= 2 || member[0 .. 2] != "__")
					{
						// To avoid the following errors:
						// error: first argument is not a symbol
						// error: invalid foreach aggregate false
						static if(member != bullet.bindings.constructor.opNew_funcName)
						{
							foreach(attribute; __traits(getAttributes, __traits(getMember, typeof(this), member)))
							{
								static if(is(attribute == Binding))
								{
									static if(member.length > 8 && member[0 .. 8] == "_d_glue_")
										dGlueFunctions ~= __traits(getMember, typeof(this), member);

									static if(member.length > 9 && member[0 .. 9] == "_binding_")
										f.writeln(__traits(getMember, typeof(this), member));
								}
							}
						}
					}
				}
			}
		}
	}
}
