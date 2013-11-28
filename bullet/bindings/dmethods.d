module bullet.bindings.dmethods;

import bullet.bindings.bindings;

enum Binding;

/*
called by dMethod:
	void _destroy()

called by dGlue:
	extern(C) void _glue_12203819563545677224(ref btTypedObject a0)
*/
template dMethodCommon(string qualifiers, T, string name, ArgTypes ...)
{
	enum dMethodCommon = qualifiers ~ " " ~ dType!T ~ " " ~ name ~ "(" ~ argList!(dType, 0, ArgTypes) ~ ")";
}

template dMethod(Class, string qualifiers, T, string name, ArgTypes ...)
{
	private enum common = dMethodCommon!(qualifiers, T, name, ArgTypes);

	static if(adjustSymbols)
	{
		import std.string: split, canFind;

		private enum isStatic = qualifiers.split.canFind("static");

		private enum symName = symbolName!(Class, name, ArgTypes);

		/*
			void _destroy();
			@Binding immutable string _d_glue__glue_12203819563545677224 = `extern(C) void _glue_12203819563545677224(ref btTypedObject a0);`;
		*/
		static if(bindSymbols)
		{
			private enum glueExtern = dGlueDefineExtern!(Class, T, symName, isStatic, ArgTypes);

			enum dMethod = common ~ ";" ~
				"@Binding immutable string _d_glue_" ~ symName ~ " = `" ~ glueExtern ~ "`;";
		}
		/*
 			void _destroy() {return _glue_12203819563545677224(this);}
		*/
		else
		{
			enum glueCallExtern = dGlueCallExtern!(isStatic, ArgTypes);

			/*static if(T.stringof != "void")
			{
				enum dMethod = common ~ " {" ~
					"auto tmp = " ~ symName ~ "(" ~	glueCallExtern ~ ");" ~
					//"import std.stdio;writeln(tmp.sizeof);" ~
					"return tmp;"
					//"return " ~ symName ~ "(" ~	glueCallExtern ~ ");" ~
					"}";
			}
			else
				enum dMethod = common ~ " {" ~
					"return " ~ symName ~ "(" ~	glueCallExtern ~ ");" ~
					"}";
			*/
			static if(dMethod3!T == ")")//dType!T != "void" && dType!T != "int" && dType!T != "float")
			{
				enum dMethod = common ~ " {" ~
					//"return " ~ dMethod2!T ~ symName ~ "(" ~ glueCallExtern ~ ")" ~ dMethod3!T ~ ";" ~
					"auto tmp = " ~ symName ~ "(" ~ glueCallExtern ~ ");" ~
					"import std.stdio;writeln(tmp);writeln(&tmp);" ~
					"auto tmp2 = " ~ dMethod2!T ~ "&tmp" ~ dMethod3!T ~ ";" ~
					"writeln(tmp2);writeln(&tmp2);writeln(tmp2.ptr);" ~
					"return tmp2;" ~
					"}";
					pragma(msg, dMethod);
			}
			else
				enum dMethod = common ~ " {" ~
					"return " ~ symName ~ "(" ~	glueCallExtern ~ ");" ~
					"}";
		}
	}
	else
	{
		enum dMethod = "extern(C) " ~ common ~ ";";
	}		
}

template dMethod2(T)
{
	enum dMethod2 = "";
}
template dMethod3(T)
{
	enum dMethod3 = "";
}

template dMethod2(T: ParamTmp!T)
{
	//enum dMethod2 = dType!T ~ "(";
	enum dMethod2 = dType!T ~ "(";
}
template dMethod3(T: ParamTmp!T)
{
	enum dMethod3 = ")";
}




static if(adjustSymbols)
{
	/*
		extern(C) void _glue_12203819563545677224(ref btTypedObject a0);
	*/
	template dGlueDefineExtern(Class, T, string symName, bool isStatic, ArgTypes ...)
	{
		static if(isStatic)
			enum dGlueDefineExtern = dMethodCommon!("extern(C)", T, symName,                 ArgTypes) ~ ";";
		else
			enum dGlueDefineExtern = dMethodCommon!("extern(C)", T, symName, ParamRef!Class, ArgTypes) ~ ";";
	}

	/*
		this, a0
	*/
	template dGlueCallExtern(bool isStatic, ArgTypes ...)
	{
		static if(isStatic)
			enum dGlueCallExtern = argNames!(ArgTypes.length);
		else
			// pass _this.ptr, which is equal to the original C pointer
			enum dGlueCallExtern = "cast(typeof(this)*)_this.ptr" ~ (ArgTypes.length ? ", " : "") ~ argNames!(ArgTypes.length);
	}
}


mixin template method(T, string name, ArgTypes ...)
{
	mixin(dMethod!(typeof(this), "", T, name, ArgTypes));

	static if(bindSymbols)
		mixin(cMethod!(typeof(this), cMethodBinding, T, name, ArgTypes));
}
