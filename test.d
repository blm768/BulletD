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

		//GC.minimize();
		loop = false;
	}

}

void helloWorld()
{
	writeln(`broadphase`);
	auto broadphase = btDbvtBroadphase(ParamNone());
	//writeln(broadphase);

	writeln(`collisionConfiguration`);
	auto collisionConfiguration = btDefaultCollisionConfiguration(ParamNone());
	//writeln(collisionConfiguration);
	writeln(`dispatcher`);
	auto dispatcher = btCollisionDispatcher(collisionConfiguration.ptr);
	//writeln(dispatcher);

	writeln(`solver`);
	auto solver = btSequentialImpulseConstraintSolver(ParamNone());
	//writeln(solver);

	writeln(`world`);
	auto world = btCollisionWorld(dispatcher.ptr, broadphase.ptr, collisionConfiguration.ptr);
	//writeln(world);

	writeln(`world2`);
	auto world2 = btDiscreteDynamicsWorld(dispatcher.ptr, broadphase.ptr, solver.ptr, collisionConfiguration.ptr);
	//writeln(world2);
	
	
	writeln(`gravity`);
	btVector3 gravity = btVector3(0,-11,0);
	writeln(gravity);
	writeln(gravity.getX());
	writeln(gravity.getY());
	writeln(gravity.getZ());
	//world2.setGravity(gravity.ptr);
	
	writeln(`--gravity2`);
	btVector3 gravity2 = world2.getGravity();
	writeln(`--gravity2-----`);

	writeln(gravity2);
	writeln(gravity2.ptr);

	writeln(gravity2.getX());
	writeln(gravity2.getY());
	writeln(gravity2.getZ());

	// test changing the returned vec3 & using it to set a new gravity
	
	gravity2._this[6] = 48;
	world2.setGravity(gravity2.ptr);
	btVector3 gravity3 = world2.getGravity();
	writeln(gravity3);

	writeln(gravity3.getX());
	writeln(gravity2.getY());
	writeln(gravity3.getZ());
	/*writeln(`--gravity3`);
	btVector3 gravity3 = btVector3(1,10,100);
	writeln(gravity3);
	writeln(gravity3.ptr);
	gravity3._this = (cast(ubyte*)(&gravity2))[0..cppSize!"btVector3"];
	writeln(gravity3);
	writeln(gravity3.ptr);

	writeln(gravity3.getX());
	writeln(gravity3.getY());
	writeln(gravity3.getZ());*/

/*	writeln(`--gravity4`);
	btVector3 gravity4 = btVector3(gravity2);
	writeln(gravity4);
	writeln(gravity4.ptr);

	writeln(gravity4.getX());
	writeln(gravity4.getY());
	writeln(gravity4.getZ());
*/	
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
/+
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
+/
