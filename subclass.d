// TODO Try implementing something like this again?
/+
mixin template subclassBinding(string _cppName, Super) {
	mixin basicClassBinding!(_cppName);
	
	Super _super;
	alias _super this;

	protected:
	ubyte[cppSize!(cppName) - cppSize!(Super.cppName)] _extra;
}
+/