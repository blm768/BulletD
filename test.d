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
bool deb = true;

void helloWorld()
{
	if(deb)writeln(`broadphase`);
	auto broadphase = btDbvtBroadphase(ParamNone());
	//if(deb)writeln(broadphase);

	if(deb)writeln(`collisionConfiguration`);
	auto collisionConfiguration = btDefaultCollisionConfiguration(ParamNone());
	//if(deb)writeln(collisionConfiguration);
	if(deb)writeln(`dispatcher`);
	auto dispatcher = btCollisionDispatcher(collisionConfiguration.ptr);
	//if(deb)writeln(dispatcher);

	if(deb)writeln(`solver`);
	auto solver = btSequentialImpulseConstraintSolver(ParamNone());
	//if(deb)writeln(solver);

	if(deb)writeln(`world`);
	auto world = btCollisionWorld(dispatcher.ptr, broadphase.ptr, collisionConfiguration.ptr);
	//if(deb)writeln(world);

	if(deb)writeln(`world2`);
	auto world2 = btDiscreteDynamicsWorld(dispatcher.ptr, broadphase.ptr, solver.ptr, collisionConfiguration.ptr);
	//if(deb)writeln(world2);

	if(deb)writeln(`gravitySet`);
	btVector3 gravitySet = btVector3(0, -11, 0);
	//if(deb)writeln(gravitySet);
	if(deb)writeln(gravitySet.getX());
	if(deb)writeln(gravitySet.getY());
	if(deb)writeln(gravitySet.getZ());
	world2.setGravity(gravitySet.ptr);

	if(deb)writeln(`gravityGet`);
	btVector3 gravityGet = world2.getGravity();
	//if(deb)writeln(gravityGet);
	if(deb)writeln(gravityGet.getX());
	if(deb)writeln(gravityGet.getY());
	if(deb)writeln(gravityGet.getZ());

	
/+	

// init

	btCollisionShape* groundShape = new btStaticPlaneShape(btVector3(0,1,0),1);

	btCollisionShape* fallShape = new btSphereShape(1);

	btDefaultMotionState* groundMotionState = new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,-1,0)));
	btRigidBody::btRigidBodyConstructionInfo
			groundRigidBodyCI(0,groundMotionState,groundShape,btVector3(0,0,0));
	btRigidBody* groundRigidBody = new btRigidBody(groundRigidBodyCI);
	dynamicsWorld->addRigidBody(groundRigidBody);
	

	btDefaultMotionState* fallMotionState =
			new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,50,0)));
	btScalar mass = 1;
	btVector3 fallInertia(0,0,0);
	fallShape->calculateLocalInertia(mass,fallInertia);
	btRigidBody::btRigidBodyConstructionInfo fallRigidBodyCI(mass,fallMotionState,fallShape,fallInertia);
	btRigidBody* fallRigidBody = new btRigidBody(fallRigidBodyCI);
	dynamicsWorld->addRigidBody(fallRigidBody);

// loop

	for (int i=0 ; i<300 ; i++)
	{
		dynamicsWorld->stepSimulation(1/60.f,10);

		btTransform trans;
		fallRigidBody->getMotionState()->getWorldTransform(trans);

		std::cout << "sphere height: " << trans.getOrigin().getY() << std::endl;
	}

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
