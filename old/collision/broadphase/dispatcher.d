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

module bullet.collision.broadphase.dispatcher;

import bullet.linearMath.btScalar;

import bullet.collision.broadphase.broadphaseProxy;
import bullet.collision.broadphase.collisionAlgorithm;
import bullet.collision.broadphase.overlappingPairCache;
import bullet.collision.narrowPhase.persistentManifold;
import bullet.collision.dispatch.collisionObject;
import bullet.linearMath.btAlignedObjectArray;
import bullet.linearMath.btIDebugDraw;
import bullet.linearMath.btPoolAllocator;
import bullet.linearMath.btStackAlloc;

struct btDispatcherInfo {
	enum DispatchFunc {
		discrete = 1,
		continuous
	};

	btScalar	m_timeStep = 0.0;
	int			m_stepCount;
	int			m_dispatchFunc = DispatchFunc.discrete;
	/*mutable*/ btScalar m_timeOfImpact = 1.0;
	bool		m_useContinuous = true;
	btIDebugDraw m_debugDraw;
	bool		m_enableSatConvex;
	bool		m_enableSPU = true;
	bool		m_useEpa = true;
	btScalar	m_allowedCcdPenetration = 0.04;
	bool		m_useConvexConservativeDistanceUtil;
	btScalar	m_convexConservativeDistanceThreshold = 0.0;
	btStackAlloc*	m_stackAllocator;
};

///The btDispatcher interface class can be used in combination with broadphase to dispatch calculations for overlapping pairs.
///For example for pairwise collision detection, calculating contact points stored in btPersistentManifold or user callbacks (game logic).
//To do: make interface again?
class btDispatcher {

public:

	btCollisionAlgorithm* findAlgorithm(btCollisionObject* body0, btCollisionObject* body1, btPersistentManifold* sharedManifold = null);

	btPersistentManifold getNewManifold(void* body0, void* body1);

	void releaseManifold(btPersistentManifold* manifold);

	void clearManifold(btPersistentManifold* manifold);

	bool needsCollision(btCollisionObject* body0,btCollisionObject* body1);

	bool needsResponse(btCollisionObject* body0,btCollisionObject* body1);

	void dispatchAllCollisionPairs()(btOverlappingPairCache* pairCache, const auto ref btDispatcherInfo dispatchInfo, btDispatcher* dispatcher);

	int getNumManifolds() const;

	inout(btPersistentManifold) getManifoldByIndexInternal(int index) inout;

	btAlignedObjectArray!btPersistentManifold getInternalManifoldArray();

	inout(btPoolAllocator!btPersistentManifold) getInternalManifoldPool() inout;

	void* allocateCollisionAlgorithm(int size);

	void freeCollisionAlgorithm(void* ptr);

};

