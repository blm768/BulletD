module bullet.bindings.classes;

import bullet.bindings.bindings;

mixin template className(string _cppName)
{
	enum string cppName = _cppName;

	//@disable this();
}

mixin template classSize()
{
	// by not making _this be a static array,
	// the C pointer returned by cppNew can be sliced and retained:
	// _this = (cast(ubyte*)(cppNew(args)))[0..cppSize!(cppName)]
	// iow. C pointer == _this.ptr
	ubyte[] _this; //ubyte[cppSize!(cppName)] _this;

	// get the C pointer
	typeof(this)* ptr() { return cast(typeof(this)*)_this.ptr; }
}
