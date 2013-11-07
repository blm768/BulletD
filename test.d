module main;

import std.stdio;
import std.conv;

import bullet.all;

void main()
{
/+	auto bp = btDbvtBroadphase.cppNew();
	auto cConfig = btDefaultCollisionConfiguration.cppNew();
	auto di = btCollisionDispatcher.cppNew(&cConfig._super);
	auto cs = btSequentialImpulseConstraintSolver.cppNew();
	auto world = btDiscreteDynamicsWorld.cppNew(&di._super, &bp._super, &cs._super, &cConfig._super);
	
	auto gravity = btVector3(0.0, -1.0, 0.0);
	world.setGravity(gravity);

	auto orientation = btQuaternion(0, 0, 0, 1);
	
	auto floor = btStaticPlaneShape.cppNew(btVector3(0, 0, 0), 1);
	auto floorMotionState = btDefaultMotionState.cppNew(btTransform(orientation, btVector3(0, 0, 0)));

	auto fall = btSphereShape.cppNew(1);
	auto fallMotionState = btDefaultMotionState.cppNew(btTransform(orientation, btVector3(0, 0, 0)));

	fall.cppDelete();
	floorMotionState.cppDelete();
	floor.cppDelete();

	world.cppDelete();
	cs.cppDelete();
	di.cppDelete();
	cConfig.cppDelete();
	bp.cppDelete();
+/

	//TODO implement all necessary classes for above example

	writeln("-- typed_obj");
	auto typed_obj = btTypedObject.cppNew(12);
	writeln(typed_obj);
	writeln(typed_obj.getObjectType());
	
	writeln("-- vec3");
	auto vec3 = btVector3.cppNew(12, 13, 14);
	writeln(vec3);
	writeln(vec3.getX());
	writeln(vec3.getY());
	writeln(vec3.getZ());
	
	writeln("-- quat");
	auto quat = btQuaternion.cppNew(12, 13, 14, 15);
	writeln(quat);
	writeln(quat.getX());
	writeln(quat.getY());
	writeln(quat.getZ());
	writeln(quat.getW());
	
	writeln("-- trans");
	auto trans = btTransform.cppNew(*quat, *vec3);
	writeln(trans);
	btScalar[16] retGL;
	trans.getOpenGLMatrix(retGL.ptr);
	writeln(retGL);
	
	writeln("-- def_motion_state");
	auto def_motion_state = btDefaultMotionState.cppNew();
	writeln(def_motion_state);
	writeln(def_motion_state._this);

	def_motion_state.getWorldTransform(*trans);
	writeln(trans);
	trans.getOpenGLMatrix(retGL.ptr);
	writeln(retGL);

	writeln("-- def_motion_state2");
	auto def_motion_state2 = btDefaultMotionState.cppNew(*trans);
	writeln(def_motion_state2);
	writeln(def_motion_state2._this);

	def_motion_state2.getWorldTransform(*trans);
	writeln(trans);
	trans.getOpenGLMatrix(retGL.ptr);
	writeln(retGL);

	writeln("-- cppDelete");
	def_motion_state.cppDelete();
	trans.cppDelete();
	quat.cppDelete();
	vec3.cppDelete();
	typed_obj.cppDelete();

	writeln("-- END");
}
