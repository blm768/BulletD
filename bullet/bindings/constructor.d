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
}

/+
mixin template constructor()
{
	mixin opNew!();

	mixin(dMethod!(typeof(this), "static", typeof(this), "opCall"));

	static if(bindSymbols)
		mixin(cMethod!(typeof(this), cFakeConstructorBinding, typeof(this), "opCall"));
}

mixin template constructor(ArgTypes ...)
{
	mixin opNew!(ArgTypes);

	static if(bindSymbols)
	{
		mixin(cMethod!(typeof(this), cConstructorBinding, void, "_construct", ArgTypes));

		this(ArgTypes) {}
	}
	else
	{
		extern(C) void _construct(ArgTypes);

		this(ArgTypes args)
		{
			_construct(args);
		}
	}
}
+/
