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

module bullet.BulletCollision.CollisionShapes.btTriangleMesh;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionShapes.btTriangleIndexVertexArray;
import bullet.LinearMath.btVector3;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionShapes/btTriangleMesh.h>");

		btTriangleMesh.writeBindings(f);
	}
}

struct btTriangleMesh
{
	mixin classChild!("btTriangleMesh", btTriangleIndexVertexArray);

	mixin opNew!(bool, bool);

	mixin method!(void, "addTriangle", ParamRefConst!btVector3, ParamRefConst!btVector3, ParamRefConst!btVector3, bool);
	mixin method!(int, "getNumTriangles");
	mixin method!(void, "preallocateVertices", int);
	mixin method!(void, "preallocateIndices", int);
}

