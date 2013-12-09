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

	if(deb)writeln(`dynamicsWorld`);
	auto dynamicsWorld = btDiscreteDynamicsWorld(dispatcher.ptr, broadphase.ptr, solver.ptr, collisionConfiguration.ptr);
	//if(deb)writeln(dynamicsWorld);
	if(deb)writeln(dynamicsWorld.getGravity().getY());
	if(deb)dynamicsWorld.setGravity(btVector3(0, -11, 0).ptr);
	if(deb)writeln(dynamicsWorld.getGravity().getY());

	if(deb)writeln(`groundShape`);
	btStaticPlaneShape groundShape = btStaticPlaneShape(btVector3(0, 1, 0).ptr, 1);
	//if(deb)writeln(groundShape);
	if(deb)writeln(groundShape.getPlaneConstant());

	if(deb)writeln(`fallShape`);
	btSphereShape fallShape = btSphereShape(1);
	//if(deb)writeln(fallShape);
	if(deb)writeln(fallShape.getRadius());

	if(deb)writeln(`groundMotionState`);
	btTransform transform = btTransform(btQuaternion(0, 0, 0, 1).ptr, btVector3(0, -1, 0).ptr);
	btDefaultMotionState groundMotionState = btDefaultMotionState(transform.ptr);
	//if(deb)writeln(groundMotionState);
	if(deb)	groundMotionState.getWorldTransform(transform.ptr);
	if(deb)writeln(transform.getOrigin().getY());

	if(deb)writeln(`groundRigidBodyCI`);
	btRigidBodyConstructionInfo groundRigidBodyCI = btRigidBodyConstructionInfo(0, groundMotionState.ptr, groundShape.ptr, btVector3(0, 0, 0).ptr);
	//if(deb)writeln(groundRigidBodyCI);
	
	if(deb)writeln(`groundRigidBody`);
	btRigidBody groundRigidBody = btRigidBody(groundRigidBodyCI.ptr);
	//if(deb)writeln(groundRigidBody);

	dynamicsWorld.addRigidBody(cast(btRigidBody*)groundRigidBody.ptr); // FIXME cast is needed :( overload .ptr function?

/+	

// init

	btDefaultMotionState* fallMotionState =	new btDefaultMotionState(btTransform(btQuaternion(0,0,0,1),btVector3(0,50,0)));
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
