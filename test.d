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
		writeln(`========================================loop`);
		
		helloWorld();
		
		GC.collect();
		GC.minimize();
		loop = false;
	}

}
bool deb1 = true;
bool deb2 = true;

void helloWorld()
{

//init

	if(deb1)writeln(`broadphase`);
	auto broadphase = btDbvtBroadphase(ParamNone());
	if(deb2)writeln(broadphase);

	if(deb1)writeln(`collisionConfiguration`);
	auto collisionConfiguration = btDefaultCollisionConfiguration(ParamNone());
	if(deb2)writeln(collisionConfiguration);

	if(deb1)writeln(`dispatcher`);
	auto dispatcher = btCollisionDispatcher(collisionConfiguration.ptr);
	if(deb2)writeln(dispatcher);

	if(deb1)writeln(`solver`);
	auto solver = btSequentialImpulseConstraintSolver(ParamNone());
	if(deb2)writeln(solver);

	if(deb1)writeln(`dynamicsWorld`);
	auto dynamicsWorld = btDiscreteDynamicsWorld(dispatcher.ptr, broadphase.ptr, solver.ptr, collisionConfiguration.ptr);
	if(deb2)writeln(dynamicsWorld);
	if(deb1)writeln(dynamicsWorld.getGravity().getY());
	if(deb1)dynamicsWorld.setGravity(btVector3(0, -10, 0).ptr);
	if(deb1)writeln(dynamicsWorld.getGravity().getY());

	if(deb1)writeln(`groundShape`);
	btStaticPlaneShape groundShape = btStaticPlaneShape(btVector3(0, 1, 0).ptr, 1);
	if(deb2)writeln(groundShape);
	if(deb1)writeln(groundShape.getPlaneConstant());

	if(deb1)writeln(`fallShape`);
	btSphereShape fallShape = btSphereShape(1);
	if(deb2)writeln(fallShape);
	if(deb1)writeln(fallShape.getRadius());

	if(deb1)writeln(`groundMotionState`);
	btTransform transform = btTransform(btQuaternion(0, 0, 0, 1).ptr, btVector3(0, -1, 0).ptr);
	btDefaultMotionState groundMotionState = btDefaultMotionState(transform.ptr);
	if(deb2)writeln(groundMotionState);
	if(deb1)groundMotionState.getWorldTransform(transform.ptr);
	if(deb1)writeln(transform.getOrigin().getY());

	if(deb1)writeln(`groundRigidBodyCI`);
	btRigidBodyConstructionInfo groundRigidBodyCI = btRigidBodyConstructionInfo(0, groundMotionState.ptr, groundShape.ptr, btVector3(0, 0, 0).ptr);
	if(deb2)writeln(groundRigidBodyCI);
	
	if(deb1)writeln(`groundRigidBody`);
	btRigidBody groundRigidBody = btRigidBody(groundRigidBodyCI.ptr);
	if(deb2)writeln(groundRigidBody);

	dynamicsWorld.addRigidBody(cast(btRigidBody*)groundRigidBody.ptr); // FIXME cast is needed :( overload .ptr function?

	if(deb1)writeln(`fallMotionState`);
	btDefaultMotionState fallMotionState = btDefaultMotionState(btTransform(btQuaternion(0, 0, 0, 1).ptr, btVector3(0, 50, 0).ptr).ptr);
	if(deb2)writeln(fallMotionState);

	btScalar mass = 1;
	btVector3 fallInertia = btVector3(0, 0, 0);
	fallShape.calculateLocalInertia(mass, fallInertia.ptr);

	if(deb1)writeln(`fallRigidBodyCI`);
	btRigidBodyConstructionInfo fallRigidBodyCI = btRigidBodyConstructionInfo(mass, fallMotionState.ptr, fallShape.ptr, fallInertia.ptr);
	if(deb2)writeln(fallRigidBodyCI);
	if(deb1)writeln(`fallRigidBody`);
	btRigidBody fallRigidBody = btRigidBody(fallRigidBodyCI.ptr);
	if(deb2)writeln(fallRigidBody);

	dynamicsWorld.addRigidBody(cast(btRigidBody*)fallRigidBody.ptr);

// loop
	for(int i = 0; i < 300; i++)
	{
		if(deb1)writeln("loop ", i);
		dynamicsWorld.stepSimulation(1f/60f, 10);

		btTransform trans = btTransform(ParamNone());

		//fallRigidBody.getMotionState().getWorldTransform(trans.ptr);

		if(deb1)writeln(`getMotionState`);
		btMotionState* mot = fallRigidBody.getMotionState();
		if(deb2)writeln(mot);
		btMotionState mot2 = btMotionState(mot);// FIXME do this step automatically
		if(deb2)writeln(mot2);

		btDefaultMotionState mot3 = cast(btDefaultMotionState)mot2;
		if(deb2)writeln(mot3);
		if(deb2)writeln(mot3._references);
		mot3._references++;


		if(deb1)writeln(`getWorldTransform`);
		mot3.getWorldTransform(trans.ptr);
		if(deb2)writeln(trans);

		writeln("sphere height: ", trans.getOrigin().getY());
	}
	

/+	

// cleanup

	dynamicsWorld->removeRigidBody(fallRigidBody);
	delete fallRigidBody->getMotionState();
	delete fallRigidBody;

	dynamicsWorld->removeRigidBody(groundRigidBody);
	delete groundRigidBody->getMotionState();
	delete groundRigidBody;


	delete fallShape;

	delete groundShape;


	delete dynamicsWorld;
	delete solver;
	delete collisionConfiguration;
	delete dispatcher;
	delete broadphase;

	return 0;
+/
}
