module main;
import std.file;
import std.stdio;

import bullet.all;

int main(string[] args) {
	File f;

	if(!exists(`glue/bullet/BulletCollision/BroadphaseCollision`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/BroadphaseCollision`);
	}
	f = File(`glue/bullet/BulletCollision/BroadphaseCollision/btAxisSweep3.cpp`, `w`);
	bullet.BulletCollision.BroadphaseCollision.btAxisSweep3.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/BroadphaseCollision`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/BroadphaseCollision`);
	}
	f = File(`glue/bullet/BulletCollision/BroadphaseCollision/btBroadphaseInterface.cpp`, `w`);
	bullet.BulletCollision.BroadphaseCollision.btBroadphaseInterface.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/BroadphaseCollision`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/BroadphaseCollision`);
	}
	f = File(`glue/bullet/BulletCollision/BroadphaseCollision/btDbvtBroadphase.cpp`, `w`);
	bullet.BulletCollision.BroadphaseCollision.btDbvtBroadphase.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/BroadphaseCollision`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/BroadphaseCollision`);
	}
	f = File(`glue/bullet/BulletCollision/BroadphaseCollision/btDispatcher.cpp`, `w`);
	bullet.BulletCollision.BroadphaseCollision.btDispatcher.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionDispatch`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionDispatch`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionDispatch/btCollisionConfiguration.cpp`, `w`);
	bullet.BulletCollision.CollisionDispatch.btCollisionConfiguration.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionDispatch`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionDispatch`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionDispatch/btCollisionDispatcher.cpp`, `w`);
	bullet.BulletCollision.CollisionDispatch.btCollisionDispatcher.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionDispatch`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionDispatch`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionDispatch/btCollisionObject.cpp`, `w`);
	bullet.BulletCollision.CollisionDispatch.btCollisionObject.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionDispatch`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionDispatch`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionDispatch/btCollisionWorld.cpp`, `w`);
	bullet.BulletCollision.CollisionDispatch.btCollisionWorld.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionDispatch`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionDispatch`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.cpp`, `w`);
	bullet.BulletCollision.CollisionDispatch.btDefaultCollisionConfiguration.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btBoxShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btBoxShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btBvhTriangleMeshShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btBvhTriangleMeshShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btCollisionShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btCollisionShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btCompoundShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btCompoundShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btConcaveShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btConcaveShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btConvexHullShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btConvexHullShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btConvexInternalShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btConvexInternalShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btConvexShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btConvexShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btConvexTriangleMeshShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btConvexTriangleMeshShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btPolyhedralConvexShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btPolyhedralConvexShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btSphereShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btSphereShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btStaticPlaneShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btStaticPlaneShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btStridingMeshInterface.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btStridingMeshInterface.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btTriangleIndexVertexArray.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btTriangleIndexVertexArray.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btTriangleMesh.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btTriangleMesh.writeBindings(f);

	if(!exists(`glue/bullet/BulletCollision/CollisionShapes`)) {
		mkdirRecurse(`glue/bullet/BulletCollision/CollisionShapes`);
	}
	f = File(`glue/bullet/BulletCollision/CollisionShapes/btTriangleMeshShape.cpp`, `w`);
	bullet.BulletCollision.CollisionShapes.btTriangleMeshShape.writeBindings(f);

	if(!exists(`glue/bullet/BulletDynamics/ConstraintSolver`)) {
		mkdirRecurse(`glue/bullet/BulletDynamics/ConstraintSolver`);
	}
	f = File(`glue/bullet/BulletDynamics/ConstraintSolver/btConstraintSolver.cpp`, `w`);
	bullet.BulletDynamics.ConstraintSolver.btConstraintSolver.writeBindings(f);

	if(!exists(`glue/bullet/BulletDynamics/ConstraintSolver`)) {
		mkdirRecurse(`glue/bullet/BulletDynamics/ConstraintSolver`);
	}
	f = File(`glue/bullet/BulletDynamics/ConstraintSolver/btSequentialImpulseConstraintSolver.cpp`, `w`);
	bullet.BulletDynamics.ConstraintSolver.btSequentialImpulseConstraintSolver.writeBindings(f);

	if(!exists(`glue/bullet/BulletDynamics/Dynamics`)) {
		mkdirRecurse(`glue/bullet/BulletDynamics/Dynamics`);
	}
	f = File(`glue/bullet/BulletDynamics/Dynamics/btDiscreteDynamicsWorld.cpp`, `w`);
	bullet.BulletDynamics.Dynamics.btDiscreteDynamicsWorld.writeBindings(f);

	if(!exists(`glue/bullet/BulletDynamics/Dynamics`)) {
		mkdirRecurse(`glue/bullet/BulletDynamics/Dynamics`);
	}
	f = File(`glue/bullet/BulletDynamics/Dynamics/btDynamicsWorld.cpp`, `w`);
	bullet.BulletDynamics.Dynamics.btDynamicsWorld.writeBindings(f);

	if(!exists(`glue/bullet/BulletDynamics/Dynamics`)) {
		mkdirRecurse(`glue/bullet/BulletDynamics/Dynamics`);
	}
	f = File(`glue/bullet/BulletDynamics/Dynamics/btRigidBody.cpp`, `w`);
	bullet.BulletDynamics.Dynamics.btRigidBody.writeBindings(f);

	if(!exists(`glue/bullet/LinearMath`)) {
		mkdirRecurse(`glue/bullet/LinearMath`);
	}
	f = File(`glue/bullet/LinearMath/btDefaultMotionState.cpp`, `w`);
	bullet.LinearMath.btDefaultMotionState.writeBindings(f);

	if(!exists(`glue/bullet/LinearMath`)) {
		mkdirRecurse(`glue/bullet/LinearMath`);
	}
	f = File(`glue/bullet/LinearMath/btMotionState.cpp`, `w`);
	bullet.LinearMath.btMotionState.writeBindings(f);

	if(!exists(`glue/bullet/LinearMath`)) {
		mkdirRecurse(`glue/bullet/LinearMath`);
	}
	f = File(`glue/bullet/LinearMath/btQuaternion.cpp`, `w`);
	bullet.LinearMath.btQuaternion.writeBindings(f);

	if(!exists(`glue/bullet/LinearMath`)) {
		mkdirRecurse(`glue/bullet/LinearMath`);
	}
	f = File(`glue/bullet/LinearMath/btScalar.cpp`, `w`);
	bullet.LinearMath.btScalar.writeBindings(f);

	if(!exists(`glue/bullet/LinearMath`)) {
		mkdirRecurse(`glue/bullet/LinearMath`);
	}
	f = File(`glue/bullet/LinearMath/btTransform.cpp`, `w`);
	bullet.LinearMath.btTransform.writeBindings(f);

	if(!exists(`glue/bullet/LinearMath`)) {
		mkdirRecurse(`glue/bullet/LinearMath`);
	}
	f = File(`glue/bullet/LinearMath/btVector3.cpp`, `w`);
	bullet.LinearMath.btVector3.writeBindings(f);

	bullet.bindings.bindings.writeGenC();
	bullet.bindings.bindings.writeDGlue();
	return 0;
}

