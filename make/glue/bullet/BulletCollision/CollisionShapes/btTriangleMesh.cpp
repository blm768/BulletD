#include <new>
#include <BulletCollision/CollisionShapes/btTriangleMesh.h>
extern "C" btTriangleMesh* _glue_14387650731134949611(char a0, char a1) {
	return new btTriangleMesh(a0, a1);
}

extern "C" void _glue_11115367147844206995(btTriangleMesh* _this, const btVector3& a0, const btVector3& a1, const btVector3& a2, char a3) {
	return _this->addTriangle(a0, a1, a2, a3); 
}

extern "C" int _glue_6055296685635286968(btTriangleMesh* _this) {
	return _this->getNumTriangles(); 
}

extern "C" void _glue_3218948254247565482(btTriangleMesh* _this, int a0) {
	return _this->preallocateVertices(a0); 
}

extern "C" void _glue_6201948031980499180(btTriangleMesh* _this, int a0) {
	return _this->preallocateIndices(a0); 
}

