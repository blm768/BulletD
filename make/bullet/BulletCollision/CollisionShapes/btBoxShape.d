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

module bullet.BulletCollision.CollisionShapes.btBoxShape;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionShapes.btPolyhedralConvexShape;
import bullet.LinearMath.btVector3;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionShapes/btBoxShape.h>");

		btBoxShape.writeBindings(f);
	}
}

struct btBoxShape
{
	mixin classChild!("btBoxShape", btPolyhedralConvexShape);

	mixin opNew!(ParamRefConst!btVector3);
}
