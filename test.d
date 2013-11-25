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

	bool loop = true;

	while(loop)
	{
		GC.minimize();
		test();

		loop = false;
	}

}

import core.memory;

void test()
{
	//TODO implement all necessary classes for above example

	//writeln("-- typed_obj");
	//btTypedObject typed_obj = btTypedObject.cppNew(12);

	/+
	auto typed_obj = btTypedObject(12);
	//auto tmp = *typed_obj;
	//writeln(tmp);
	//writeln(&tmp);
	writeln(typed_obj.getObjectType());
	writeln(typed_obj);
	writeln(&typed_obj);
	writeln(&typed_obj._this);
	writeln(typed_obj.ptr2());
+/	
	//writeln("-- vec3");
	//auto vec3 = btVector3.cppNew(12, 13, 14);
	
/+	auto vec3 = btVector3(12, 13, 14);
	writeln(&vec3);
	writeln(&vec3._this);
	writeln(vec3.ptr2());
	writeln(&vec3._thisP);

	vec3._thisP.cppDelete();

	writeln(`-`);
	auto vec3_ = btVector3.cppNew(12, 13, 14);
	writeln(vec3_);
	writeln(&vec3_._this);
	writeln(vec3_.ptr2());
	writeln(vec3_._thisP);

	vec3_._thisP.cppDelete();
+/


	/*writeln(`vec3  * `, &vec3);
	writeln(`_this * `, &vec3._this);
	writeln(`_this * `, &vec3._this[0]);
	writeln(`_thisP  `, vec3._thisP);
	writeln(`_th.ptr `, vec3._this.ptr);

	writeln(`_this `, vec3._this);
	writeln(`x `, vec3.getX());
	writeln(`y `, vec3.getY());
	writeln(`z `, vec3.getZ());

	vec3._this[2] = 80;

	writeln(`_this `, vec3._this);
	writeln(`x `, vec3.getX());
	writeln(`y `, vec3.getY());
	writeln(`z `, vec3.getZ());
	*/
	//vec3.cppDelete();


	btVector3 vec3 = btVector3(12, 13, 14);
	writeln(vec3);
	writeln(`_this `, vec3._this);
	writeln(`x `, vec3.getX());
	writeln(`y `, vec3.getY());
	writeln(`z `, vec3.getZ());

	/+vec3._this[2] = 80;

	writeln(`_this `, vec3._this);
	writeln(`x `, vec3.getX());
	writeln(`y `, vec3.getY());
	writeln(`z `, vec3.getZ());
	+/
	
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
	btDefaultMotionState def_motion_state = btDefaultMotionState();//trans.ptr);
	writeln(def_motion_state);

	def_motion_state.getWorldTransform(trans.ptr);
	writeln(trans);
	trans.getOpenGLMatrix(retGL.ptr);
	writeln(retGL);
/+
	writeln("-- def_motion_state2");
	auto def_motion_state2 = btDefaultMotionState.cppNew(*trans);
	writeln(def_motion_state2);
	//writeln(def_motion_state2._this);

	def_motion_state2.getWorldTransform(*trans);
	writeln(trans);
	trans.getOpenGLMatrix(retGL.ptr);
	writeln(retGL);

	writeln("-- cppDelete");
	def_motion_state.cppDelete();
	trans.cppDelete();
	quat.cppDelete();
	vec3._thisP.cppDelete();
	typed_obj.cppDelete();+/

	//writeln("-- END");
}
