#include <new>
#include <LinearMath/btDefaultMotionState.h>
extern "C" btDefaultMotionState* _glue_14562921094655045483() {
	return new btDefaultMotionState();
}

extern "C" btDefaultMotionState* _glue_7116665388677514833(const btTransform& a0) {
	return new btDefaultMotionState(a0);
}

