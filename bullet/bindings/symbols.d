module bullet.bindings.symbols;

import std.conv: to;

import bullet.bindings.bindings;

version(genBindings)
	enum bool bindSymbols = true;
else
	enum bool bindSymbols = false;

version(Windows)
	enum bool adjustSymbols = true;
else
	enum bool adjustSymbols = false;

static if(adjustSymbols)
{
	static if(!bindSymbols)
		public import bullet.bindings.glue;

	template symbolName(Class, string name, ArgTypes ...)
	{
		enum symbolName = "_glue_" ~ fnv1a(Class.stringof ~ " " ~ name ~ "(" ~ argList!(dType, 0, ArgTypes) ~ ")").to!string();
	}

	//Applies the 64-bit FNV-1a hash function to a string
	ulong fnv1a(string str) pure
	{
		ulong hash = 14695981039346656037u;

		foreach(char c; str)
		{
			hash ^= cast(ulong)c;
			hash *= 1099511628211;
		}

		return hash;
	}
}
