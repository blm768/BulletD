#include <new>
#include <BulletDynamics/Dynamics/btDynamicsWorld.h>
extern "C" int _glue_6958382111819585941(btDynamicsWorld* _this, float a0, int a1) {
	return _this->stepSimulation(a0, a1); 
}

extern "C" void _glue_12681317878558903880(btDynamicsWorld* _this, btRigidBody* a0) {
	return _this->addRigidBody(a0); 
}

extern "C" void _glue_17308567765720202805(btDynamicsWorld* _this, btRigidBody* a0) {
	return _this->removeRigidBody(a0); 
}

extern "C" btVector3 _glue_2494698868894258820(btDynamicsWorld* _this) {
	return _this->getGravity(); 
}

extern "C" void _glue_9389991354871762952(btDynamicsWorld* _this, const btVector3& a0) {
	return _this->setGravity(a0); 
}

