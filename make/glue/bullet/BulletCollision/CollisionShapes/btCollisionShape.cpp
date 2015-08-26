#include <new>
#include <BulletCollision/CollisionShapes/btCollisionShape.h>
extern "C" void _glue_10827548791891431243(btCollisionShape* _this) {
	delete _this;
}

extern "C" void _glue_3352658093558691985(btCollisionShape* _this, float a0, btVector3& a1) {
	return _this->calculateLocalInertia(a0, a1); 
}

extern "C" float _glue_16319011272816997419(btCollisionShape* _this) {
	return _this->getMargin(); 
}

extern "C" void _glue_3779256736581058006(btCollisionShape* _this, float a0) {
	return _this->setMargin(a0); 
}

