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

module bullet.bindings.classes;

import bullet.bindings.bindings;

mixin template classBasic(string _cppName)
{
	mixin bindingData;

	mixin className!_cppName;
	mixin classSize;
	//mixin classPtr;
	//mixin refCounting;
	//mixin constructorCopy;
	//mixin constructorObject;
	mixin safeCast;
	mixin destructor;

	@disable this();
}

mixin template className(string _cppName)
{
	enum string cppName = _cppName;
}

mixin template classSize()
{
	ubyte[cppSize!(cppName)] _this;
}

mixin template classSizeChild()
{
	import std.conv: to;
	mixin("ubyte[cppSize!(cppName) - cppSize!(Super.cppName)] _this" ~ to!string(countSupers!(typeof(this))) ~ ";");
}


/*mixin template classPtr()
{
	// get the C pointer
	typeof(this)* ptr() { return cast(typeof(this)*)_this.ptr; }
}*/

// mixin super class
// child uses _super._this, so do not mixin classPtr for child class
mixin template classSuper(Super)
{
	Super _super;
	alias _super this;
}

// Count references when struct is constructed, destructed or copied
// Not thread safe?
/*mixin template refCounting()
{
	uint _references = 0;
}*/

// Copy constructor
// Increases reference count
/*mixin template constructorCopy()
{
	this(this)
	{
		_references++;
	}
}*/

/*mixin template constructorObject()
{
	// construct obj from returned c++ obj
	this(typeof(this) obj_In)
	{
		// only do this for c++ constructed obj (not D objects nor c++ returned obj*)
		//assert(obj_In._references == 0);
		
		// .dup obj as ubyte array
		// pointer is not a c++ pointer, cppNew/cppDelete are not involved/needed
		_this = (cast(ubyte*)&obj_In)[0..cppSize!cppName].dup;

		//_references = 2; // set refs to 2, so on ~this it becomes 1, and thus cppDelete is never called
	}

	this(typeof(this)* obj_In)
	{		
		// pointer is a c++ pointer
		_this = (cast(ubyte*)obj_In)[0..cppSize!cppName];

		//_references = 1; // set refs to 1, so on ~this it becomes 0, and thus cppDelete is called
	}
}*/

mixin template safeCast()
{
	Other* as(Other)()
	{
		static if(isSuper!(typeof(this), Other) >= 0)
			return cast(Other*)&this;
		else
			static assert(false, "safeCast: Other is not a Super");
	}
}

mixin template classChild(string _cppName, Super)
{
	mixin bindingData;

	mixin classSuper!Super;

	mixin className!_cppName;
	mixin classSizeChild;
	mixin safeCast;

	@disable this();
}

// Checks if This "inherits" from Other (via Super _super; alias _super this;)
//  0: This == Other
// +n: Number of steps between This and Other
// -n: This does not "inherit" from Other
template isSuper(This, Other)
{
	// base success case: they're the same
	static if(is(This == Other))
		enum isSuper = 0;
	// has a _super
	else static if(__traits(hasMember, This, "_super"))
	{
		// _super type is Other
		static if(is(typeof(This._super) == Other))
			enum isSuper = 1;
		// _super type is not Other, so continue checking
		else
		{
			enum cnt = isSuper!(typeof(This._super), Other);
			enum isSuper = cnt > 0 ? 1 + cnt : cnt;
		}
	}
	// base fail case: does not have a _super
	else
		enum isSuper = -1;
}

// Count the total number of _supers that This "inherits".
template countSupers(This)
{
	static if(__traits(hasMember, This, "_super"))
		enum countSupers = 1 + countSupers!(typeof(This._super));
	else
		enum countSupers = 0;
}