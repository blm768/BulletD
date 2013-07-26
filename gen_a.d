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
		if(isFile(filename)) {
			auto basename = filename.baseName;
			if(basename == "all.d" || basename[0] == '.') {
				continue;
			}
			string dir = dirName(filename);
			if(dir == buildPath("bullet", "bindings")) {
				continue;
			}
			string moduleName = filename[0 .. $ - 2].replace(dirSeparator, ".");
			string writeCall = moduleName ~ ".writeBindings(f)";
			string cppFilename = buildPath("glue", filename[0 .. $-2] ~ ".cpp");
			string cppDir = dirName(cppFilename);
			of.writeln("import ", moduleName, ";");
			//Removed for now to prevent silent failure if writeBindings() isn't defined
			//generators ~= "\tstatic if(__traits(compiles, " ~ writeCall ~ ")) {\n";
			generators ~= "\tif(!exists(\"" ~ cppDir ~ "\")) {\n";
			generators ~= "\t\tmkdirRecurse(\"" ~ cppDir ~ "\");\n";
			generators ~= "\t}\n";
			generators ~= "\tf = File(\"" ~ cppFilename ~ "\", \"w\");\n";
			generators ~= "\t" ~ writeCall ~ ";\n\n";
			//generators ~= "\t}\n";
		}
	}
	of.writeln("\n" ~ `int main(string[] args) {
	File f;
	`);
	of.writeln(generators);
	of.writeln("\tbullet.bindings.bindings.writeGenC();");
	of.writeln(`	return 0;
}
`);
	return 0;
}

