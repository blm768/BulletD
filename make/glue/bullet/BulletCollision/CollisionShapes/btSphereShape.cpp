#include <new>
#include <BulletCollision/CollisionShapes/btSphereShape.h>
extern "C" btSphereShape* _glue_13483827938183421778(float a0) {
	return new btSphereShape(a0);
}

extern "C" float _glue_3822519737767409766(btSphereShape* _this) {
	return _this->getRadius(); 
}

