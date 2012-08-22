/*
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2003-2006 Erwin Coumans  http://continuousphysics.com/Bullet/

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.
Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it freely,
subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

//D port of Bullet Physics

module bullet.collision.broadphase.broadphaseInterface;

import bullet.collision.broadphase.broadphaseProxy;
import bullet.collision.broadphase.dispatcher;
import bullet.collision.broadphase.overlappingPairCache;
import bullet.linearMath.btVector3;

abstract class btBroadphaseAabbCallback {
	~this() {}
	bool process(const btBroadphaseProxy* proxy);
}

class btBroadphaseRayCallback: btBroadphaseAabbCallback {
	///added some cached data to accelerate ray-AABB tests
	btVector3	m_rayDirectionInverse;
	uint		m_signs[3];
	btScalar	m_lambda_max;

	//~this() {}
}

abstract class btBroadphaseInterface {
public:
	~this() {}

	btBroadphaseProxy*	createProxy()(const auto ref btVector3 aabbMin, const auto ref btVector3 aabbMax, int shapeType, void* userPtr, short collisionFilterGroup, short collisionFilterMask, btDispatcher* dispatcher,void* multiSapProxy);
	void destroyProxy(btBroadphaseProxy proxy, btDispatcher dispatcher);
	void setAabb()(btBroadphaseProxy* proxy, const auto ref btVector3 aabbMin, const auto ref btVector3 aabbMax, btDispatcher* dispatcher);
	void getAabb()(btBroadphaseProxy* proxy, auto ref btVector3 aabbMin, auto ref btVector3 aabbMax ) const;

	void rayTest()(const auto ref btVector3 rayFrom, const auto ref btVector3 rayTo, auto ref btBroadphaseRayCallback rayCallback, const auto ref btVector3 aabbMin = btVector3(0,0,0), const auto ref btVector3 aabbMax = btVector3(0,0,0));

	void aabbTest()(const auto ref btVector3 aabbMin, const auto ref btVector3 aabbMax, auto ref btBroadphaseAabbCallback callback);

	///calculateOverlappingPairs is optional: incremental algorithms (sweep and prune) might do it during the set aabb
	void calculateOverlappingPairs(btDispatcher* dispatcher);

	btOverlappingPairCache*	getOverlappingPairCache();
	const btOverlappingPairCache* getOverlappingPairCache() const;

	///getAabb returns the axis aligned bounding box in the 'global' coordinate frame
	///will add some transform later
	void getBroadphaseAabb()(auto ref btVector3 aabbMin, auto ref btVector3 aabbMax) const;

	///reset broadphase internal structures, to ensure determinism/reproducability
	void resetPool(btDispatcher* dispatcher) { cast(void) dispatcher; };

	void printStats();
};
