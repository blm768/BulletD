#include <new>
#include <LinearMath/btMotionState.h>
extern "C" void _glue_15994059426651831639(btMotionState* _this) {
	delete _this;
}

extern "C" void _glue_14488334691765138110(btMotionState* _this, btTransform& a0) {
	return _this->getWorldTransform(a0); 
}

extern "C" void _glue_3836868645181206759(btMotionState* _this, const btTransform& a0) {
	return _this->setWorldTransform(a0); 
}

