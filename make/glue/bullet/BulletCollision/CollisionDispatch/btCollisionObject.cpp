#include <new>
#include <BulletCollision/CollisionDispatch/btCollisionObject.h>
extern "C" void _glue_1972811791224781183(btCollisionObject* _this) {
	delete _this;
}

extern "C" int _glue_7070823249320121754(btCollisionObject* _this) {
	return _this->getCollisionFlags(); 
}

extern "C" void _glue_8955543096945371348(btCollisionObject* _this, int a0) {
	return _this->setCollisionFlags(a0); 
}

extern "C" int _glue_1287475661781599988(btCollisionObject* _this) {
	return _this->getActivationState(); 
}

extern "C" void _glue_10329122860489910258(btCollisionObject* _this, int a0) {
	return _this->setActivationState(a0); 
}

extern "C" void _glue_16888171217633166027(btCollisionObject* _this, int a0) {
	return _this->forceActivationState(a0); 
}

extern "C" void _glue_15064411428807018155(btCollisionObject* _this, float a0) {
	return _this->setCcdMotionThreshold(a0); 
}

extern "C" void _glue_13513108424429214084(btCollisionObject* _this, float a0) {
	return _this->setCcdSweptSphereRadius(a0); 
}

extern "C" btTransform& _glue_11861286568079055505(btCollisionObject* _this) {
	return _this->getWorldTransform(); 
}

extern "C" void _glue_3001502881072541055(btCollisionObject* _this, const btTransform& a0) {
	return _this->setWorldTransform(a0); 
}

extern "C" void* _glue_13111103308321417205(btCollisionObject* _this) {
	return _this->getUserPointer(); 
}

extern "C" void _glue_16992283721250016874(btCollisionObject* _this, void* a0) {
	return _this->setUserPointer(a0); 
}

