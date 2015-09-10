#include <new>
#include <BulletCollision/CollisionShapes/btTriangleIndexVertexArray.h>
extern "C" void _glue_7898575193019463924(btIndexedMesh* _this) {
	delete _this;
}

extern "C" btIndexedMesh* _glue_17879763439112184517() {
	return new btIndexedMesh();
}

extern "C" btTriangleIndexVertexArray* _glue_15376463940486339350() {
	return new btTriangleIndexVertexArray();
}

extern "C" btTriangleIndexVertexArray* _glue_11702915094675657358(int a0, int* a1, int a2, int a3, float* a4, int a5) {
	return new btTriangleIndexVertexArray(a0, a1, a2, a3, a4, a5);
}

extern "C" void _glue_3803489378364360790(btTriangleIndexVertexArray* _this, const btIndexedMesh& a0, PHY_ScalarType a1) {
	return _this->addIndexedMesh(a0, a1); 
}

