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
			string writeCall = moduleName ~ ".writeBindings(f)";
			string cppFilename = buildPath("glue", filename[0 .. $-2] ~ ".cpp");
			string cppDir = dirName(cppFilename);
			of.writeln("import ", moduleName, ";");
			generators ~= "\tstatic if(__traits(compiles, " ~ writeCall ~ ")) {\n";
			generators ~= "\t\tif(!exists(\"" ~ cppDir ~ "\")) {\n";
			generators ~= "\t\t\tmkdirRecurse(\"" ~ cppDir ~ "\");\n";
			generators ~= "\t\t}\n";
			generators ~= "\t\tf = File(\"" ~ cppFilename ~ "\", \"w\");\n";
			generators ~= "\t\t" ~ writeCall ~ ";\n";
			generators ~= "\t}\n";
		}
	}
	of.writeln("\n" ~ `int main(string[] args) {
	File f;
	`);
	of.writeln(generators);
	of.writeln("\t\nbullet.bindings.bindings.writeSizeFile();");
	of.writeln(`	return 0;
}
`);
	return 0;
}

