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
