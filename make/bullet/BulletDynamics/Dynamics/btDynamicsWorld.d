// BulletD - a D binding for the Bullet Physics engine
// written in the D programming language
//
// Copyright: Ben Merritt 2012 - 2013,
//            MeinMein 2013 - 2014.
// License:   Boost License 1.0
//            (See accompanying file LICENSE_1_0.txt or copy at
//             http://www.boost.org/LICENSE_1_0.txt)
// Authors:   Ben Merrit,
//            Gerbrand Kamphuis (meinmein.com).

module bullet.BulletDynamics.Dynamics.btDynamicsWorld;

import bullet.bindings.bindings;
public import bullet.BulletCollision.CollisionDispatch.btCollisionWorld;
public import bullet.BulletDynamics.Dynamics.btRigidBody;
public import bullet.LinearMath.btScalar;
public import bullet.LinearMath.btVector3;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletDynamics/Dynamics/btDynamicsWorld.h>");

		btDynamicsWorld.writeBindings(f);
	}
}

struct btDynamicsWorld
{
	mixin classChild!("btDynamicsWorld", btCollisionWorld);

	mixin method!(int, "stepSimulation", btScalar, int);

	mixin method!(void, "addRigidBody", ParamPtr!btRigidBody);
	mixin method!(void, "removeRigidBody", ParamPtr!btRigidBody);

	mixin method!(ParamReturn!btVector3, "getGravity");
	mixin method!(void, "setGravity", ParamRefConst!btVector3);
}
