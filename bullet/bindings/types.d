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

struct ParamNone {}
struct ParamConst(T) {}
struct ParamRef(T) {}
struct ParamPtr(T) {}

template dType(T)
{
	enum dType = T.stringof;
}

template dType(T: ParamConst!T)
{
	enum dType = "const " ~ dType!T ~ "*";
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

template cppTypes(Types ...)
{
	static assert(Types.length > 0);

	static if(Types.length == 1)
		alias cppType!(Types[0]) cppTypes;
	else
		enum cppTypes = cppType!(Types[0]) ~ ", " ~ cppTypes!(Types[1 .. $]);
}
