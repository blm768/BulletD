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
			// decrement references
			references--;
			
			// if no references remain, call cppDelete
			if(references <= 0 && _this.length > 0)
				cppDelete();
		}
	}
}
