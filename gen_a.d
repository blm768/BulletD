module main;

import std.array;
import std.file;
import std.path;
import std.stdio;

import bullet.bindings.bindings;

int main(string[] args) {
	auto of = File("gen_b.d", "w");
	string generators;

	of.writeln(`module main;
import std.file;
import std.stdio;
`);
	foreach(filename; dirEntries("bullet", SpanMode.depth)) {
		if(isFile(filename) && filename[$ - 2 .. $] == ".d") {
			string moduleName = filename[0 .. $ - 2].replace(dirSeparator, ".");
			string writeFunction = moduleName ~ ".writeBindings";
			string cppFilename = buildPath("glue", filename[0 .. $-2] ~ ".cpp");
			of.writeln("import ", moduleName, ";");
			generators ~= "\t static if(__traits(compiles, " ~ writeFunction ~ ")) {\n";
			generators ~= "\t\tf = File(\"" ~ cppFilename ~ "\");\n";
			generators ~= "\t\t" ~ writeFunction ~ "(f);\n";
			generators ~= "\t}\n";
		}
	}
	of.writeln("\n" ~ `int main(string[] args) {
	File f;

	if(!exists("glue")) {
		mkdir("glue");
	}
	`);
	of.writeln(generators);
	of.writeln(`	return 0;
}
`);
	return 0;
}

