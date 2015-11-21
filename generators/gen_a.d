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

import std.algorithm;
import std.array;
import std.file;
import std.path;
import std.stdio;

import bullet.bindings.bindings;

enum string bindingUtilsDir = buildPath("bullet", "bindings");
enum string outputFilename = buildPath("generators", "gen_b.d");

int main(string[] args) {
	immutable string sourceDir = buildPath("source").absolutePath;

	auto of = File(outputFilename, "w");

	//Used as a hacky pseudo-set
	//TODO: just don't use this?
	ubyte[string] cppDirectories;
	string[string] cppFilesForModules;

	of.writeln(`module main;
import std.file;
import std.stdio;

import bullet.all;

int main(string[] args) {
	File f;
`);

	auto dSourceFiles = dirEntries(sourceDir, SpanMode.depth);
	//TODO: restore.
		//.filter! (f => (f.isFile() && f.endsWith(".d")));
	foreach(entry; dSourceFiles) {
		if(!(entry.name.isFile && entry.name.endsWith(".d"))) {
			continue;
		}
		auto filename = entry.name.relativePath(sourceDir);
		auto basename = filename.baseName;
		auto dirname = filename.dirName;
		if(basename == "all.d" || dirname == bindingUtilsDir) {
			continue;
		}
		string moduleName = filename[0 .. $ - 2].replace(dirSeparator, ".");
		string cppFilename = buildPath("glue", filename[0 .. $-2] ~ ".cpp");
		string cppDir = cppFilename.dirName;
		cppDirectories[cppDir] = 0;
		of.writeln("\tf = File(`" ~ cppFilename ~ "`, `w`);");
		of.writeln("\t" ~ moduleName ~ ".writeBindings(f);\n");
	}
	of.writeln("\tbullet.bindings.bindings.writeGenC();");
	of.writeln("\tbullet.bindings.bindings.writeDGlue();");
	of.writeln(`	return 0;
}
`);
	foreach(cppDir, dummy; cppDirectories) {
		if(!cppDir.exists) {
			mkdirRecurse(cppDir);
		}
	}

	return 0;
}
