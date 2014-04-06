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

module bullet.BulletCollision.CollisionDispatch.btCollisionObject;

import bullet.bindings.bindings;
import bullet.LinearMath.btScalar;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionDispatch/btCollisionObject.h>");

		btCollisionObject.writeBindings(f);
	}
}

struct btCollisionObject
{
	mixin classBasic!"btCollisionObject";

	mixin method!(int, "getCollisionFlags");
	mixin method!(void, "setCollisionFlags", int);

	mixin method!(int, "getActivationState");
	mixin method!(void, "setActivationState", int);
	mixin method!(void, "forceActivationState", int);

	mixin method!(void, "setCcdMotionThreshold", btScalar);
	mixin method!(void, "setCcdSweptSphereRadius", btScalar);

	enum CollisionFlags
	{
		CF_STATIC_OBJECT = 1,
		CF_KINEMATIC_OBJECT = 2,
		CF_NO_CONTACT_RESPONSE = 4,
		CF_CUSTOM_MATERIAL_CALLBACK = 8,
		CF_CHARACTER_OBJECT = 16,
		CF_DISABLE_VISUALIZE_OBJECT = 32,
		CF_DISABLE_SPU_COLLISION_PROCESSING = 64,
	}
}

enum
{
	ACTIVE_TAG = 1,
	ISLAND_SLEEPING = 2,
	WANTS_DEACTIVATION = 3,
	DISABLE_DEACTIVATION = 4,
	DISABLE_SIMULATION = 5,
}
