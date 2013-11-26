module bullet.bindings.classes;

import bullet.bindings.bindings;

mixin template classBasic(string _cppName)
{
	mixin bindingData;

	mixin className!_cppName;
	mixin classSize;
	mixin classPtr;
	mixin refCounting;
	mixin destructor;

	@disable this();
}

mixin template className(string _cppName)
{
	enum string cppName = _cppName;
}

mixin template classSize()
{
	// by not making _this be a static array,
	// the C pointer returned by cppNew can be sliced and retained:
	// _this = (cast(ubyte*)(cppNew(args)))[0..cppSize!(cppName)]
	// iow. C pointer == _this.ptr
	ubyte[] _this; //ubyte[cppSize!(cppName)] _this;
}

mixin template classPtr()
{
	// get the C pointer
	typeof(this)* ptr() { return cast(typeof(this)*)_this.ptr; }
}

// Count references when struct is constructed, destructed or copied
// Not thread safe?
mixin template refCounting()
{
	uint references = 0;

	// On struct postblit/copy
	this(this)
	{
		// increment references
		references++;
	}
}


mixin template classParent(string _cppName)
{
	mixin bindingData;

	mixin className!_cppName;
	mixin classSize;
	mixin classPtr;
	mixin refCounting;
	mixin destructor;

	//@disable this();
}

// uses Super destructor
// uses Super ptr
// uses Super _this, but with size of this, not size of Super
// uses Super refCounting
mixin template classChild(string _cppName, Super)
{
	mixin bindingData;

	mixin className!_cppName;
	//mixin classSize;
	//mixin classPtr;
	mixin classPtr!Super;
	//mixin refCounting;
	//mixin destructor;

	//@disable this();
}

// Change ptr() to always return a Super* instead of this*
// Does this work everywhere?
// (replacement for alias this, which I cannot get to work)
mixin template classPtr(Super)
{
	// get the C pointer
	//Super* ptr() { return cast(Super*)_this.ptr; }

	Super _super;
	alias _super this;
}