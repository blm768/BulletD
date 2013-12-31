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

module bullet.BulletCollision.CollisionShapes.btSphereShape;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionShapes.btConvexInternalShape;
import bullet.LinearMath.btScalar;
import bullet.LinearMath.btVector3;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionShapes/btSphereShape.h>");

		btSphereShape.writeBindings(f);
	}
}

struct btSphereShape
{
	mixin classChild!("btSphereShape", btConvexInternalShape);

	mixin opNew!(btScalar);

	mixin method!(btScalar, "getRadius");
	mixin method!(void, "calculateLocalInertia", btScalar, ParamRef!btVector3);
}
