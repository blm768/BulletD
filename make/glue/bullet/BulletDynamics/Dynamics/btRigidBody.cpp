#include <new>
#include <BulletDynamics/Dynamics/btRigidBody.h>
extern "C" void _glue_4884238214018246702(btRigidBody::btRigidBodyConstructionInfo* _this) {
	delete _this;
}

extern "C" btRigidBody::btRigidBodyConstructionInfo* _glue_15765351327237009908(float a0, btMotionState* a1, btCollisionShape* a2, const btVector3& a3) {
	return new btRigidBody::btRigidBodyConstructionInfo(a0, a1, a2, a3);
}

extern "C" btRigidBody::btRigidBodyConstructionInfo* _glue_9672248084536362609(float a0, btMotionState* a1, btCollisionShape* a2) {
	return new btRigidBody::btRigidBodyConstructionInfo(a0, a1, a2);
}

extern "C" void _glue_6891598763882917615(btRigidBody::btRigidBodyConstructionInfo* _this, float a0) {
	return _this->setFriction(a0); 
}

extern "C" void _glue_285793969632579932(btRigidBody::btRigidBodyConstructionInfo* _this, float a0) {
	return _this->setRollingFriction(a0); 
}

extern "C" btRigidBody* _glue_4515767707078461954(const btRigidBody::btRigidBodyConstructionInfo& a0) {
	return new btRigidBody(a0);
}

extern "C" btMotionState* _glue_18182572735777148042(btRigidBody* _this) {
	return _this->getMotionState(); 
}

extern "C" btVector3 _glue_14305016414761638952(btRigidBody* _this) {
	return _this->getAngularFactor(); 
}

extern "C" void _glue_10555408849902069412(btRigidBody* _this, const btVector3& a0) {
	return _this->setAngularFactor(a0); 
}

extern "C" btVector3 _glue_7272312242990012167(btRigidBody* _this) {
	return _this->getLinearFactor(); 
}

extern "C" void _glue_341846010789341181(btRigidBody* _this, const btVector3& a0) {
	return _this->setLinearFactor(a0); 
}

extern "C" void _glue_12322653337366358443(btRigidBody* _this, const btTransform& a0) {
	return _this->setCenterOfMassTransform(a0); 
}

extern "C" void _glue_11258204586396095090(btRigidBody* _this, float a0, float a1) {
	return _this->setDamping(a0, a1); 
}

extern "C" void _glue_1070732980113643819(btRigidBody* _this, const btVector3& a0, const btVector3& a1) {
	return _this->applyForce(a0, a1); 
}

extern "C" void _glue_13870902659496064607(btRigidBody* _this, const btVector3& a0) {
	return _this->applyCentralForce(a0); 
}

extern "C" void _glue_15533035594959934503(btRigidBody* _this, const btVector3& a0, const btVector3& a1) {
	return _this->applyImpulse(a0, a1); 
}

extern "C" void _glue_5550115215887182179(btRigidBody* _this, const btVector3& a0) {
	return _this->applyCentralImpulse(a0); 
}

extern "C" void _glue_10520613491040672465(btRigidBody* _this, const btVector3& a0) {
	return _this->applyTorque(a0); 
}

extern "C" void _glue_10090755650433858316(btRigidBody* _this, const btVector3& a0) {
	return _this->applyTorqueImpulse(a0); 
}

extern "C" btVector3 _glue_6281548206294992568(btRigidBody* _this) {
	return _this->getAngularVelocity(); 
}

extern "C" btVector3 _glue_4787064771493203007(btRigidBody* _this) {
	return _this->getLinearVelocity(); 
}

