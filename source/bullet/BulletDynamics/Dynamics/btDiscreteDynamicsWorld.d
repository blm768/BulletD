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

module bullet.BulletDynamics.Dynamics.btDiscreteDynamicsWorld;

import bullet.bindings.bindings;
public import bullet.BulletDynamics.Dynamics.btDynamicsWorld;
public import bullet.BulletCollision.BroadphaseCollision.btDispatcher;
public import bullet.BulletCollision.BroadphaseCollision.btBroadphaseInterface;
public import bullet.BulletDynamics.ConstraintSolver.btConstraintSolver;
public import bullet.BulletCollision.CollisionDispatch.btCollisionConfiguration;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletDynamics/Dynamics/btDiscreteDynamicsWorld.h>");

		btDiscreteDynamicsWorld.writeBindings(f);
	}
}

struct btDiscreteDynamicsWorld
{
	mixin classChild!("btDiscreteDynamicsWorld", btDynamicsWorld);

	mixin opNew!(ParamPtr!btDispatcher, ParamPtr!btBroadphaseInterface, ParamPtr!btConstraintSolver, ParamPtr!btCollisionConfiguration);

	mixin method!(void, "addRigidBody", ParamPtr!btRigidBody, short, short);
}
