#include <new>
#include <BulletCollision/CollisionShapes/btBoxShape.h>
extern "C" btBoxShape* _glue_9444651889195778523(const btVector3& a0) {
	return new btBoxShape(a0);
}

