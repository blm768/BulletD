module bullet.bindings.sizes;

template cppSize(string cppName: `btBroadphaseInterface`) {
	enum size_t cppSize = 4;
}

template cppSize(string cppName: `btDbvtBroadphase`) {
	enum size_t cppSize = 196;
}

template cppSize(string cppName: `btDispatcher`) {
	enum size_t cppSize = 4;
}

template cppSize(string cppName: `btCollisionConfiguration`) {
	enum size_t cppSize = 4;
}

template cppSize(string cppName: `btCollisionDispatcher`) {
	enum size_t cppSize = 5260;
}

template cppSize(string cppName: `btCollisionObject`) {
	enum size_t cppSize = 264;
}

template cppSize(string cppName: `btCollisionWorld`) {
	enum size_t cppSize = 80;
}

template cppSize(string cppName: `btDefaultCollisionConstructionInfo`) {
	enum size_t cppSize = 24;
}

template cppSize(string cppName: `btDefaultCollisionConfiguration`) {
	enum size_t cppSize = 92;
}

template cppSize(string cppName: `btCollisionShape`) {
	enum size_t cppSize = 12;
}

template cppSize(string cppName: `btConcaveShape`) {
	enum size_t cppSize = 16;
}

template cppSize(string cppName: `btConvexInternalShape`) {
	enum size_t cppSize = 52;
}

template cppSize(string cppName: `btConvexShape`) {
	enum size_t cppSize = 12;
}

template cppSize(string cppName: `btSphereShape`) {
	enum size_t cppSize = 52;
}

template cppSize(string cppName: `btStaticPlaneShape`) {
	enum size_t cppSize = 84;
}

template cppSize(string cppName: `btConstraintSolver`) {
	enum size_t cppSize = 4;
}

template cppSize(string cppName: `btSequentialImpulseConstraintSolver`) {
	enum size_t cppSize = 196;
}

template cppSize(string cppName: `btDiscreteDynamicsWorld`) {
	enum size_t cppSize = 324;
}

template cppSize(string cppName: `btDynamicsWorld`) {
	enum size_t cppSize = 176;
}

template cppSize(string cppName: `btRigidBody::btRigidBodyConstructionInfo`) {
	enum size_t cppSize = 140;
}

template cppSize(string cppName: `btRigidBody`) {
	enum size_t cppSize = 616;
}

template cppSize(string cppName: `btDefaultMotionState`) {
	enum size_t cppSize = 200;
}

template cppSize(string cppName: `btMotionState`) {
	enum size_t cppSize = 4;
}

template cppSize(string cppName: `btQuaternion`) {
	enum size_t cppSize = 16;
}

template cppSize(string cppName: `btTypedObject`) {
	enum size_t cppSize = 4;
}

template cppSize(string cppName: `btTransform`) {
	enum size_t cppSize = 64;
}

template cppSize(string cppName: `btVector3`) {
	enum size_t cppSize = 16;
}

