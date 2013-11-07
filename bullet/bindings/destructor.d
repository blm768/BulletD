module bullet.bindings.destructor;

import bullet.bindings.bindings;

mixin template destructor()
{
	//mixin(dMethod!(typeof(this), "", void, "_destroy"));
	mixin(dMethod!(typeof(this), "", void, "cppDelete"));

	static if(bindSymbols)
	{
		//mixin(cMethod!(typeof(this), cDestructorBinding, void, "_destroy"));
		mixin(cMethod!(typeof(this), cDeleteBinding,	 void, "cppDelete"));

		~this() {}
	}
	else
	{
		~this()
		{
			//_destroy();
			cppDelete();
		}
	}

	@disable this();// is having a D created bt* useful, even when the C++ side object has not been created?
}
