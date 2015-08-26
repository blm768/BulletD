#include <new>
#include <BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.h>
extern "C" void _glue_13108773797729780024(btDefaultCollisionConstructionInfo* _this) {
	delete _this;
}

extern "C" btDefaultCollisionConstructionInfo* _glue_2507265615340265113() {
	return new btDefaultCollisionConstructionInfo();
}

extern "C" btDefaultCollisionConfiguration* _glue_4746541786788591088() {
	return new btDefaultCollisionConfiguration();
}

extern "C" btDefaultCollisionConfiguration* _glue_10862414240927891630(const btDefaultCollisionConstructionInfo& a0) {
	return new btDefaultCollisionConfiguration(a0);
}

