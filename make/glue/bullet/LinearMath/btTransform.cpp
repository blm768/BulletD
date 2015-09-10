#include <new>
#include <LinearMath/btTransform.h>
extern "C" void _glue_6977853485594856708(btTransform* _this) {
	delete _this;
}

extern "C" btTransform* _glue_3856588485821534133() {
	return new btTransform();
}

extern "C" btTransform* _glue_5280374802791548786(const btQuaternion& a0, const btVector3& a1) {
	return new btTransform(a0, a1);
}

extern "C" void _glue_396504011422534465(btTransform* _this, float* a0) {
	return _this->getOpenGLMatrix(a0); 
}

extern "C" btVector3 _glue_4664654905998864256(btTransform* _this) {
	return _this->getOrigin(); 
}

extern "C" btQuaternion _glue_2849393724679729200(btTransform* _this) {
	return _this->getRotation(); 
}

