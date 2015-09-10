#include <fstream>
#include <BulletCollision/BroadphaseCollision/btAxisSweep3.h>
#include <BulletCollision/BroadphaseCollision/btBroadphaseInterface.h>
#include <BulletCollision/BroadphaseCollision/btDbvtBroadphase.h>
#include <BulletCollision/BroadphaseCollision/btDispatcher.h>
#include <BulletCollision/CollisionDispatch/btCollisionConfiguration.h>
#include <BulletCollision/CollisionDispatch/btCollisionDispatcher.h>
#include <BulletCollision/CollisionDispatch/btCollisionObject.h>
#include <BulletCollision/CollisionDispatch/btCollisionWorld.h>
#include <BulletCollision/CollisionDispatch/btDefaultCollisionConfiguration.h>
#include <BulletCollision/CollisionShapes/btBoxShape.h>
#include <BulletCollision/CollisionShapes/btBvhTriangleMeshShape.h>
#include <BulletCollision/CollisionShapes/btCollisionShape.h>
#include <BulletCollision/CollisionShapes/btCompoundShape.h>
#include <BulletCollision/CollisionShapes/btConcaveShape.h>
#include <BulletCollision/CollisionShapes/btConvexHullShape.h>
#include <BulletCollision/CollisionShapes/btConvexInternalShape.h>
#include <BulletCollision/CollisionShapes/btConvexShape.h>
#include <BulletCollision/CollisionShapes/btConvexTriangleMeshShape.h>
#include <BulletCollision/CollisionShapes/btPolyhedralConvexShape.h>
#include <BulletCollision/CollisionShapes/btSphereShape.h>
#include <BulletCollision/CollisionShapes/btStaticPlaneShape.h>
#include <BulletCollision/CollisionShapes/btStridingMeshInterface.h>
#include <BulletCollision/CollisionShapes/btTriangleIndexVertexArray.h>
#include <BulletCollision/CollisionShapes/btTriangleMesh.h>
#include <BulletCollision/CollisionShapes/btTriangleMeshShape.h>
#include <BulletDynamics/ConstraintSolver/btConstraintSolver.h>
#include <BulletDynamics/ConstraintSolver/btSequentialImpulseConstraintSolver.h>
#include <BulletDynamics/Dynamics/btDiscreteDynamicsWorld.h>
#include <BulletDynamics/Dynamics/btDynamicsWorld.h>
#include <BulletDynamics/Dynamics/btRigidBody.h>
#include <LinearMath/btDefaultMotionState.h>
#include <LinearMath/btMotionState.h>
#include <LinearMath/btQuaternion.h>
#include <LinearMath/btScalar.h>
#include <LinearMath/btTransform.h>
#include <LinearMath/btVector3.h>

using namespace std;
int main(int argc, char** argv) {
	ofstream f;
	f.open("bullet/bindings/sizes.d");

	f << "module bullet.bindings.sizes;\n\n";
	
	f << "template cppSize(string cppName: `btAxisSweep3`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btAxisSweep3) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btBroadphaseInterface`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btBroadphaseInterface) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btDbvtBroadphase`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btDbvtBroadphase) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btDispatcher`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btDispatcher) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btCollisionConfiguration`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btCollisionConfiguration) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btCollisionDispatcher`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btCollisionDispatcher) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btCollisionObject`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btCollisionObject) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btCollisionWorld`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btCollisionWorld) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btCollisionWorld::RayResultCallback`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btCollisionWorld::RayResultCallback) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btCollisionWorld::ClosestRayResultCallback`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btCollisionWorld::ClosestRayResultCallback) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btDefaultCollisionConstructionInfo`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btDefaultCollisionConstructionInfo) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btDefaultCollisionConfiguration`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btDefaultCollisionConfiguration) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btBoxShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btBoxShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btBvhTriangleMeshShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btBvhTriangleMeshShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btCollisionShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btCollisionShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btCompoundShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btCompoundShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btConcaveShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btConcaveShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btConvexHullShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btConvexHullShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btConvexInternalShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btConvexInternalShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btConvexShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btConvexShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btConvexTriangleMeshShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btConvexTriangleMeshShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btPolyhedralConvexShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btPolyhedralConvexShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btPolyhedralConvexAabbCachingShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btPolyhedralConvexAabbCachingShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btSphereShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btSphereShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btStaticPlaneShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btStaticPlaneShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btStridingMeshInterface`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btStridingMeshInterface) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btIndexedMesh`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btIndexedMesh) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btTriangleIndexVertexArray`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btTriangleIndexVertexArray) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btTriangleMesh`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btTriangleMesh) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btTriangleMeshShape`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btTriangleMeshShape) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btConstraintSolver`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btConstraintSolver) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btSequentialImpulseConstraintSolver`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btSequentialImpulseConstraintSolver) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btDiscreteDynamicsWorld`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btDiscreteDynamicsWorld) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btDynamicsWorld`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btDynamicsWorld) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btRigidBody::btRigidBodyConstructionInfo`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btRigidBody::btRigidBodyConstructionInfo) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btRigidBody`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btRigidBody) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btDefaultMotionState`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btDefaultMotionState) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btMotionState`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btMotionState) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btQuaternion`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btQuaternion) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btTypedObject`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btTypedObject) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btTransform`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btTransform) << ";\n";
	f << "}\n" << endl;
	f << "template cppSize(string cppName: `btVector3`) {\n";
	f << "\tenum size_t cppSize = " << sizeof(btVector3) << ";\n";
	f << "}\n" << endl;
}
