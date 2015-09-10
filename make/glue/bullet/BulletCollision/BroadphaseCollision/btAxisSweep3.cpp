#include <new>
#include <BulletCollision/BroadphaseCollision/btAxisSweep3.h>
extern "C" btAxisSweep3* _glue_758820012428166174(const btVector3& a0, const btVector3& a1) {
	return new btAxisSweep3(a0, a1);
}

