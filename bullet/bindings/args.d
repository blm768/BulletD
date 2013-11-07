module bullet.bindings.args;

import bullet.bindings.bindings;

template argList(alias transform, size_t start, ArgTypes ...)
{
	static if(ArgTypes.length == 0)
		enum argList = "";
	else static if(ArgTypes.length == 1)
	{
		private alias transformed = transform!(ArgTypes[0]);
		enum argList = transformed ~ " a" ~ start.to!string();
	}
	else
		enum argList = argList!(transform, start, ArgTypes[0]) ~ ", " ~ argList!(transform, start + 1, ArgTypes[1 .. $]);
}

template argNames(size_t n)
{
	static if(n == 0)
		enum argNames = "";
	else static if(n == 1)
		enum argNames = "a" ~ (n - 1).to!string();
	else
		enum argNames = argNames!(n - 1) ~ ", a" ~ (n - 1).to!string();
}
