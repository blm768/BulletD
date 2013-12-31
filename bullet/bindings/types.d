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

module bullet.bindings.types;

import std.traits;

import bullet.bindings.bindings;

static if(bindSymbols)
{
	template cppSize(string cppName)
	{
		enum size_t cppSize = 1;
	}
}
else
	public import bullet.bindings.sizes;

struct ParamNone {} // param used to get around param-less constructors for structs

struct ParamConst(T) {}
struct ParamRef(T) {}
struct ParamPtr(T) {}
struct ParamReturn(T) {} // param returned by bt method, doesn't change type, only used as flag

template dType(T)
{
	enum dType = T.stringof;
}

template dType(T: ParamConst!T)
{
	enum dType = "const " ~ dType!T ~ "*";
}

template dType(T: ParamReturn!T)
{
	enum dType = dType!T;
}

template dType(T: ParamRef!T)
{
	enum dType = dType!T ~ "*";
}

template dType(T: ParamPtr!T)
{
	enum dType = dType!T ~ "*";
}

template cppType(T)
{
	static if(!isMutable!T)
		enum cppType = "const " ~ cppType!(Unqual!T);
	else static if(isUnsigned!T)
		enum cppType = "unsigned " ~ cppType!(Signed!T);
	else static if(isArray!T)
		enum cppType = "(" ~ cppType!(typeof(T[0])) ~ ")*";
	else static if(hasMember!(T, "cppName")) // use cppName if it exists (also fixes A::B nested structs)
		enum cppType = T.cppName;
	else
		enum cppType = T.stringof;
}

template cppType(T: byte)
{
	enum cppType = "char";
}

template cppType(T: ParamConst!T)
{
	enum cppType = "const " ~ cppType!T ~ "&";
}

template cppType(T: ParamRef!T)
{
	enum cppType = cppType!T ~ "&";
}

template cppType(T: ParamPtr!T)
{
	enum cppType = cppType!T ~ "*";
}

template cppType(T: ParamReturn!T)
{
	enum cppType = cppType!T;
}

template cppTypes(Types ...)
{
	static assert(Types.length > 0);

	static if(Types.length == 1)
		alias cppType!(Types[0]) cppTypes;
	else
		enum cppTypes = cppType!(Types[0]) ~ ", " ~ cppTypes!(Types[1 .. $]);
}

// unused
/*template typeName(T, bool makeCpp)
{
	static if(isBasicType!T)
		enum typeName = T.stringof;
	else static if(isPointer!T)
		enum typeName = typeName!(PointerTarget!T, makeCpp) ~ "*";
	else static if(is(T: U[], U))
		enum typeName = typeName!(U, makeCpp) ~ "[]";
	else
	{
		import std.string: chompPrefix;
		enum dName = chompPrefix(fullyQualifiedName!T, moduleName!T ~ ".");

		static if(makeCpp)
		{
			import std.array:replace;
			enum typeName = replace(dName, ".", "::");
		}
		else
			enum typeName = dName;
	}
}*/
