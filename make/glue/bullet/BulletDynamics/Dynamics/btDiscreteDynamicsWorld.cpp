#include <new>
#include <BulletDynamics/Dynamics/btDiscreteDynamicsWorld.h>
extern "C" btDiscreteDynamicsWorld* _glue_5873808952164790537(btDispatcher* a0, btBroadphaseInterface* a1, btConstraintSolver* a2, btCollisionConfiguration* a3) {
	return new btDiscreteDynamicsWorld(a0, a1, a2, a3);
}

extern "C" void _glue_8833661320392587818(btDiscreteDynamicsWorld* _this, btRigidBody* a0, short a1, short a2) {
	return _this->addRigidBody(a0, a1, a2); 
}

