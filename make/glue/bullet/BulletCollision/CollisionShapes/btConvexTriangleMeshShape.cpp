#include <new>
#include <BulletCollision/CollisionShapes/btConvexTriangleMeshShape.h>
extern "C" btConvexTriangleMeshShape* _glue_15703488498455655529(btStridingMeshInterface* a0, char a1) {
	return new btConvexTriangleMeshShape(a0, a1);
}

