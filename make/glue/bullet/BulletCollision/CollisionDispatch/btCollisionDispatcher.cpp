#include <new>
#include <BulletCollision/CollisionDispatch/btCollisionDispatcher.h>
extern "C" btCollisionDispatcher* _glue_13000924400507141707(btCollisionConfiguration* a0) {
	return new btCollisionDispatcher(a0);
}

