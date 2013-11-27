module main;

import std.stdio;
import std.conv;
import core.memory;

import bullet.all;

void main()
{
	bool loop = true;

	while(loop)
	{
		//test();
		helloWorld();

		GC.minimize();
		loop = false;
	}

}

void helloWorld()
{
	auto broadphase = btDbvtBroadphase();
	writeln(broadphase);

	auto collisionConfiguration = btDefaultCollisionConfiguration(ParamNone());
	writeln(collisionConfiguration);
	auto dispatcher = btCollisionDispatcher(collisionConfiguration.ptr);
	writeln(dispatcher);

	auto solver = btSequentialImpulseConstraintSolver(ParamNone());
	writeln(solver);

	auto world = btCollisionWorld(dispatcher.ptr, broadphase.ptr, collisionConfiguration.ptr);
	writeln(world);

	auto world2 = btDiscreteDynamicsWorld(dispatcher.ptr, broadphase.ptr, solver.ptr, collisionConfiguration.ptr);
	writeln(world2);
	
	btVector3 gravity = btVector3(12,13,14);
	writeln(gravity);
	writeln(gravity.getX());
	writeln(gravity.getY());
	writeln(gravity.getZ());
	world2.setGravity(gravity.ptr);

	auto gravity2 = (world2.getGravity()).ptr;
	writeln(gravity2);
	writeln(gravity2.getX());
	writeln(gravity2.getY());
	writeln(gravity2.getZ());
	
	//btVector3 tmp1 = world2.getGravity();
	//btVector3 tmp2 = tmp1;
	//writeln(tmp);
	//writeln(tmp2);
	

	//auto world2 = btDynamicsWorld(dispatcher.ptr, broadphase.ptr, collisionConfiguration.ptr);
	//writeln(world2);
	//auto dynamicsWorld = btDiscreteDynamicsWorld(dispatcher.ptr, broadphase.ptr, solver.ptr, collisionConfiguration.ptr);
/+	
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
}

void test()
{
	//TODO implement all necessary classes for above example

	writeln("-- typed_obj");
	btTypedObject typed_obj = btTypedObject(12);
	writeln(typed_obj);
	test(typed_obj);

	writeln("-- vec3");
	btVector3 vec3 = btVector3(12, 13, 14);
	writeln(vec3);
	vec3._this[2] = 80;
	writeln(vec3.getX());
	writeln(vec3.getY());
	writeln(vec3.getZ());
	
	writeln("-- quat");
	btQuaternion quat = btQuaternion(12, 13, 14, 15);
	writeln(quat);
	writeln(quat.getX());
	writeln(quat.getY());
	writeln(quat.getZ());
	writeln(quat.getW());
	
	writeln("-- trans");
	btTransform trans = btTransform(quat.ptr, vec3.ptr);
	writeln(trans);
	btScalar[16] retGL;
	trans.getOpenGLMatrix(retGL.ptr);
	writeln(retGL);
	
	writeln("-- def_motion_state");
	btDefaultMotionState def_motion_state = btDefaultMotionState(ParamNone());//trans.ptr);
	writeln(def_motion_state);

	def_motion_state.getWorldTransform(trans.ptr);
	writeln(trans);
	trans.getOpenGLMatrix(retGL.ptr);
	writeln(retGL);

	/*writeln("-- cppDelete");
	def_motion_state.cppDelete();
	trans.cppDelete();
	quat.cppDelete();
	vec3.cppDelete();
	typed_obj.cppDelete();
	*/
	
	writeln("-- END");
}

void test(btTypedObject bt)
{
	writeln("test");
	writeln(bt);	
}