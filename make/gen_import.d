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
import std.file;
import std.path;
import std.stdio;
import std.string;

void writeImport(string dir) {
	auto f = File(dir.buildPath("all.d"), "w");
	//map is needed to remove a layer of const
	//To do: file bug?
	auto pkgtmp = dir.pathSplitter.map!((s) => s[]);
	auto pkg = std.string.join(pkgtmp, ".");
	f.write("module " ~ pkg ~ ".all;\n\n");
	foreach(entry; dirEntries(dir, SpanMode.shallow)) {
		auto name = entry.baseName.stripExtension;
		if(name == "all" || name[0] == '.') {
			continue;
		}
		if(entry.isDir) {
			f.write("public import " ~ pkg ~ "." ~ name ~ ".all;\n");
		} else {
			f.write("public import " ~ pkg ~ "." ~ name ~ ";\n");
		}
	}
}

int main(string[] args) {
	writeImport("bullet");
	foreach(dir; dirEntries("bullet", SpanMode.breadth)) {
		if(!dir.isDir) {
			continue;
		}
		writeImport(dir);
	}

	return 0;
}

