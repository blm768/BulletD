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

module bullet.BulletDynamics.Dynamics.btRigidBody;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionDispatch.btCollisionObject;
import bullet.BulletCollision.CollisionShapes.btCollisionShape;
import bullet.LinearMath.btMotionState;
import bullet.LinearMath.btVector3;
import bullet.LinearMath.btScalar;
import bullet.LinearMath.btTransform;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletDynamics/Dynamics/btRigidBody.h>");

		btRigidBodyConstructionInfo.writeBindings(f);
		btRigidBody.writeBindings(f);
	}
}

// In c++ this is nested in btRigidBody, but doing that in D is more trouble than it is worth.
// Instead, just set the cppName to A::B
struct btRigidBodyConstructionInfo
{
	mixin classBasic!"btRigidBody::btRigidBodyConstructionInfo";

	mixin opNew!(btScalar, ParamPtr!btMotionState, ParamPtr!btCollisionShape, ParamRefConst!btVector3);
	mixin opNew!(btScalar, ParamPtr!btMotionState, ParamPtr!btCollisionShape);

	mixin method!(void, "setFriction", btScalar);
	mixin method!(void, "setRollingFriction", btScalar);
}

struct btRigidBody
{
	mixin classChild!("btRigidBody", btCollisionObject);

	mixin opNew!(ParamRefConst!(btRigidBodyConstructionInfo));

	mixin method!(ParamReturn!(btMotionState*), "getMotionState");

	mixin method!(ParamReturn!btVector3, "getAngularFactor");
	mixin method!(void, "setAngularFactor", ParamRefConst!btVector3);

	mixin method!(ParamReturn!btVector3, "getLinearFactor");
	mixin method!(void, "setLinearFactor", ParamRefConst!btVector3);

	mixin method!(void, "setCenterOfMassTransform", ParamRefConst!btTransform);

	mixin method!(void, "setDamping", btScalar, btScalar);

	mixin method!(void, "applyForce", ParamRefConst!btVector3, ParamRefConst!btVector3);
	mixin method!(void, "applyCentralForce", ParamRefConst!btVector3);
	mixin method!(void, "applyImpulse", ParamRefConst!btVector3, ParamRefConst!btVector3);
	mixin method!(void, "applyCentralImpulse", ParamRefConst!btVector3);
	mixin method!(void, "applyTorque", ParamRefConst!btVector3);
	mixin method!(void, "applyTorqueImpulse", ParamRefConst!btVector3);

	mixin method!(ParamReturn!btVector3, "getAngularVelocity");
	mixin method!(ParamReturn!btVector3, "getLinearVelocity");
}
