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
import std.stdio;
`);
	foreach(filename; dirEntries("bullet", SpanMode.depth)) {
		if(isFile(filename) && filename[$ - 2 .. $] == ".d") {
			string moduleName = filename[0 .. $ - 2].replace(dirSeparator, ".");
			string writeCall = moduleName ~ ".writeBindings()";
			of.writeln("import ", moduleName, ";");
			generators ~= "\tf = File(\"" ~ filename ~ "\");\n";
			generators ~= "\t" ~ writeCall ~ ";\n";
		}
	}
	of.writeln("\nint main(string[] args) {
	File f;
	");
	of.writeln(generators);
	of.writeln(`	return 0;
}
`);
	return 0;
}

