#include <new>
#include <BulletCollision/CollisionDispatch/btCollisionWorld.h>
extern "C" void _glue_2253717427798243966(btCollisionWorld* _this) {
	delete _this;
}

extern "C" btCollisionWorld* _glue_4224701925183016620(btDispatcher* a0, btBroadphaseInterface* a1, btCollisionConfiguration* a2) {
	return new btCollisionWorld(a0, a1, a2);
}

extern "C" int _glue_15268693220944532710(btCollisionWorld* _this) {
	return _this->getNumCollisionObjects(); 
}

extern "C" void _glue_2637625235282980639(btCollisionWorld* _this, char a0) {
	return _this->setForceUpdateAllAabbs(a0); 
}

extern "C" void _glue_1274604030649153080(btCollisionWorld* _this, const btVector3& a0, const btVector3& a1, btCollisionWorld::RayResultCallback& a2) {
	return _this->rayTest(a0, a1, a2); 
}

extern "C" void _glue_8055712403592070552(btCollisionWorld::RayResultCallback* _this) {
	delete _this;
}

extern "C" void _glue_4515084757053745310(btCollisionWorld::RayResultCallback* _this, short a0) {
	return _this->setCollisionFilterGroup(a0); 
}

extern "C" void _glue_9608555419191765707(btCollisionWorld::RayResultCallback* _this, short a0) {
	return _this->setCollisionFilterMask(a0); 
}

extern "C" char _glue_14899376346912188185(btCollisionWorld::RayResultCallback* _this) {
	return _this->hasHit(); 
}

extern "C" btCollisionWorld::ClosestRayResultCallback* _glue_6368326428790911221(const btVector3& a0, const btVector3& a1) {
	return new btCollisionWorld::ClosestRayResultCallback(a0, a1);
}

extern "C" btVector3 _glue_10533668068702630982(btCollisionWorld::ClosestRayResultCallback* _this) {
	return _this->getHitPointWorld(); 
}

extern "C" btVector3 _glue_8216974739574135259(btCollisionWorld::ClosestRayResultCallback* _this) {
	return _this->getHitNormalWorld(); 
}

extern "C" btCollisionObject* _glue_4187923897053989886(btCollisionWorld::ClosestRayResultCallback* _this) {
	return _this->getCollisionObject(); 
}

