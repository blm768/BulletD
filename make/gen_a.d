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

module main;

import std.array;
import std.file;
import std.path;
import std.stdio;

import bullet.bindings.bindings;

enum string bindingUtilsDir = buildPath("bullet", "bindings");

int main(string[] args) {
	auto of = File("gen_b.d", "w");

	of.writeln(`module main;
import std.file;
import std.stdio;

import bullet.all;

int main(string[] args) {
	File f;
`);
	foreach(filename; dirEntries("bullet", SpanMode.depth)) {
		if(filename.length < 3 || filename[$-2 .. $] != ".d") {
			continue;
		}
		if(!isFile(filename)) {
			continue;
		}
		auto basename = filename.baseName;
		auto dirname = filename.dirName;
		if(basename == "all.d" || dirname == bindingUtilsDir) {
			continue;
		}
		string moduleName = filename[0 .. $ - 2].replace(dirSeparator, ".");
		string writeCall = moduleName ~ ".writeBindings(f)";
		string cppFilename = buildPath("glue", filename[0 .. $-2] ~ ".cpp");
		string cppDir = dirName(cppFilename);
		//TODO: make directory creation more elegant.
		//(The current method tries more than once to create most directories.)
		of.writeln("\tif(!exists(`" ~ cppDir ~ "`)) {");
		of.writeln("\t\tmkdirRecurse(`" ~ cppDir ~ "`);");
		of.writeln("\t}");
		of.writeln("\tf = File(`" ~ cppFilename ~ "`, `w`);");
		of.writeln("\t" ~ writeCall ~ ";\n");
	}
	of.writeln("\tbullet.bindings.bindings.writeGenC();");
	of.writeln("\tbullet.bindings.bindings.writeDGlue();");
	of.writeln(`	return 0;
}
`);
	return 0;
}

