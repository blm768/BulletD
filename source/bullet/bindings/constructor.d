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

module bullet.bindings.constructor;

import bullet.bindings.bindings;

enum opNew_funcName = "cppNew";

mixin template opNew(ArgTypes ...)
{
	/*
	static btTypedObject* cppNew(int a0);@Binding immutable string _d_glue__glue_14415621040282311846 = `extern(C) btTypedObject* _glue_14415621040282311846(int a0);`;
	*/
	//TODO: put this back in once we can make it work.
	/+
	mixin(dMethod!(typeof(this), "static", typeof(this)*, opNew_funcName, ArgTypes));

	static if(bindSymbols)
		mixin(cMethod!(typeof(this), cNewBinding, typeof(this)*, opNew_funcName, ArgTypes));
	+/

/+	static if(bindSymbols)
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
	}+/
}
