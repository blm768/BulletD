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

module bullet.BulletCollision.CollisionShapes.btTriangleIndexVertexArray;

import bullet.bindings.bindings;
import bullet.BulletCollision.CollisionShapes.btStridingMeshInterface;
import bullet.BulletCollision.CollisionShapes.btConcaveShape;
import bullet.LinearMath.btScalar;

static if(bindSymbols)
{
	static void writeBindings(File f)
	{
		f.writeIncludes("#include <BulletCollision/CollisionShapes/btTriangleIndexVertexArray.h>");

		btIndexedMesh.writeBindings(f);
		btTriangleIndexVertexArray.writeBindings(f);
	}
}

struct btIndexedMesh
{
	mixin classBasic!"btIndexedMesh";

	mixin opNew!();

	mixin member!(int,		"m_numTriangles",			0);
	mixin member!(char*,	"m_triangleIndexBase",		int.sizeof);
	mixin member!(int,		"m_triangleIndexStride",	int.sizeof+(char*).sizeof);
	mixin member!(int,		"m_numVertices",			int.sizeof+(char*).sizeof+int.sizeof);
	mixin member!(char*,	"m_vertexBase",				int.sizeof+(char*).sizeof+int.sizeof+int.sizeof);
	mixin member!(int,		"m_vertexStride",			int.sizeof+(char*).sizeof+int.sizeof+int.sizeof+int.sizeof);
	mixin member!(PHY_ScalarType, "m_indexType",		int.sizeof+(char*).sizeof+int.sizeof+int.sizeof+int.sizeof+int.sizeof);
	mixin member!(PHY_ScalarType, "m_vertexType",		int.sizeof+(char*).sizeof+int.sizeof+int.sizeof+int.sizeof+PHY_ScalarType.sizeof);
}

struct btTriangleIndexVertexArray
{
	mixin classChild!("btTriangleIndexVertexArray", btStridingMeshInterface);

	mixin opNew!();
	mixin opNew!(int, int*, int, int, btScalar*, int);

	mixin method!(void, "addIndexedMesh", ParamRefConst!btIndexedMesh, PHY_ScalarType);
}
