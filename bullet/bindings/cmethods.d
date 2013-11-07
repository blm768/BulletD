module bullet.bindings.cmethods;

import bullet.bindings.bindings;

template cMethod(Class, alias generator, T, string name, ArgTypes ...)
{
	static if(adjustSymbols)
		private enum symName = symbolName!(Class, name, ArgTypes);
	else
		private enum symName = __traits(getMember, Class, name).mangleof;
	
	private enum generated = generator!(Class, T, name, symName, ArgTypes);

	enum cMethod = "@Binding immutable string _binding_" ~ symName ~ " = `" ~ generated ~ "`;";
}

static if(bindSymbols)
{
/+
	//Acts more like a factory function rather than a regular constructor
	template cFakeConstructorBinding(Class, T: Class, string name: "opCall", string symName, ArgTypes ...) {
		enum cFakeConstructorBinding = `extern "C" ` ~ Class.cppName ~ " " ~ symName ~ "(" ~ argList!(cppType, 0, ArgTypes) ~ ") {\n" ~
			"\treturn " ~ Class.cppName ~ "(" ~ argNames!(ArgTypes.length) ~ ");\n" ~
			"}\n";
	}
+/

	/*
	extern "C" btTypedObject* _glue_14415621040282311846(int a0) {
		return new btTypedObject(a0);
	}
	*/
	template cNewBinding(Class, T, string name, string symName, ArgTypes ...)
	{
		enum cNewBinding = `extern "C" ` ~ Class.cppName ~ "* " ~ symName ~ "(" ~ argList!(cppType, 0, ArgTypes) ~ ") {\n" ~
			"\treturn new " ~ Class.cppName ~ "(" ~ argNames!(ArgTypes.length) ~ ");\n" ~
			"}\n";
	}

	/*
	extern "C" void _glue_12865466367869950215(btTypedObject* _this) {
		new(_this) btTypedObject();
	}
	*/
	template cConstructorBinding(Class, T: void, string name: "_construct", string symName, ArgTypes ...)
	{
		enum cConstructorBinding = `extern "C" void ` ~ symName ~ "(" ~ Class.cppName ~ "* _this" ~ (ArgTypes.length ? ", " : "") ~ argList!(cppType, 0, ArgTypes) ~ ") {\n" ~
			"\tnew(_this) " ~ Class.cppName ~ "(" ~ argNames!(ArgTypes.length) ~ ");\n" ~
			"}\n";
	}

	/*
	extern "C" void _glue_12203819563545677224(btTypedObject* _this) {
		_this->~btTypedObject();
	}
	*/
	template cDestructorBinding(Class, T, string name, string symName)
	{
		enum cDestructorBinding = `extern "C" void ` ~ symName ~ "(" ~ Class.cppName ~ "* _this) {\n" ~
			"\t_this->~" ~ Class.cppName ~ "();\n" ~
			"}\n";
	}
	
	/*
	extern "C" void _glue_6994084960380865591(btTypedObject* _this) {
		delete _this;
	}
	*/
	template cDeleteBinding(Class, T, string name, string symName)
	{
		enum cDeleteBinding = `extern "C" void ` ~ symName ~ "(" ~ Class.cppName ~ "* _this) {\n" ~
			"\tdelete _this;\n" ~
			"}\n";
	}

	/*
	extern "C" int _glue_286838161497014998(btTypedObject* _this) {
	        return _this->getObjectType();
	}
	*/
	template cMethodBinding(Class, T, string name, string symName, ArgTypes ...)
	{
		enum cMethodBinding = `extern "C" ` ~ cppType!T ~ " " ~ symName ~ "(" ~ Class.cppName ~ "* _this" ~ (ArgTypes.length ? ", " : "") ~ argList!(cppType, 0, ArgTypes) ~ ") {\n" ~
			"\treturn _this->" ~ name ~ "(" ~ argNames!(ArgTypes.length) ~ "); \n" ~
		"}\n";
	}
}
