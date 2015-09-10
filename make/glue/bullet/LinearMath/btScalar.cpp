#include <new>
#include <LinearMath/btScalar.h>
extern "C" void _glue_6994084960380865591(btTypedObject* _this) {
	delete _this;
}

extern "C" btTypedObject* _glue_14415621040282311846(int a0) {
	return new btTypedObject(a0);
}

extern "C" int _glue_286838161497014998(btTypedObject* _this) {
	return _this->getObjectType(); 
}

