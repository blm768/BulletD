module bullet.bindings.classes;

import bullet.bindings.bindings;

mixin template className(string _cppName)
{
	enum string cppName = _cppName;
}

mixin template classSize()
{
	ubyte[cppSize!(cppName)] _this;
}
