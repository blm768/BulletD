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

module bullet.bindings.destructor;

import bullet.bindings.bindings;

enum opDelete_funcName = "cppDelete";

mixin template destructor()
{
	//mixin(dMethod!(typeof(this), "", void, "_destroy"));
	mixin(dMethod!(typeof(this), "", void, opDelete_funcName));

	static if(bindSymbols)
	{
		//mixin(cMethod!(typeof(this), cDestructorBinding, void, "_destroy"));
		mixin(cMethod!(typeof(this), cDeleteBinding,	 void, opDelete_funcName));

		//~this() {}
	}
	else
	{
		/+~this()
		{
			_references--;

			// if this is the last reference, call cppDelete
			if(_references <= 0 && _this.length > 0)
				cppDelete();

			//_this.length = 0;
		}+/
	}
}

// mixin a scope(exit) to automatically call cppDelete on a bt var
string btScopeDelete(alias var)()
{
	return "scope(exit) " ~ __traits(identifier, var) ~ "." ~ opDelete_funcName ~ "();";
}
