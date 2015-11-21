module bullet.bindings.sizes;

//If we haven't generated the sizes file, we can't use it, so we fake the size as 1.
version(genBindings) {
	template cppSize(string cppName) {
		enum size_t cppSize = 1;
	}
} else {
	public import bullet.bindings.generated.sizes;
}
