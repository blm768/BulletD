#include <new>
#include <BulletCollision/CollisionShapes/btBvhTriangleMeshShape.h>
extern "C" btBvhTriangleMeshShape* _glue_5243797632295368627(btStridingMeshInterface* a0, char a1, char a2) {
	return new btBvhTriangleMeshShape(a0, a1, a2);
}

