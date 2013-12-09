module bullet.bindings.constructor;

import bullet.bindings.bindings;

enum opNew_funcName = "cppNew";

mixin template opNew(ArgTypes ...)
{
	/*
	static btTypedObject* cppNew(int a0);@Binding immutable string _d_glue__glue_14415621040282311846 = `extern(C) btTypedObject* _glue_14415621040282311846(int a0);`;
	*/
	mixin(    dMethod!(typeof(this),    "static", typeof(this)*, opNew_funcName, ArgTypes));

	static if(bindSymbols)
		mixin(cMethod!(typeof(this), cNewBinding, typeof(this)*, opNew_funcName, ArgTypes));


	static if(bindSymbols)
	{
		this(ArgTypes)
		{

		}
	}
	else
	{
		// Fake a default param if no params needed, because structs cannot have no-param constructors
		static if(ArgTypes.length <= 0)
			enum argL = "ParamNone ParamNone__";
		else
			enum argL = argList!(dType, 0, ArgTypes);

		enum argN = argNames!(ArgTypes.length);

		mixin("this(" ~ argL ~ ") {" ~
			"_this = (cast(ubyte*)(" ~ opNew_funcName ~ "(" ~ argN ~ ")))[0..cppSize!(cppName)];" ~ // set _this to slice of C pointer
			"_references++;"~
			"}");
	}
}
