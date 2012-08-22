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

module bullet.collision.dispatch.collisionDispatcher;

import bullet.collision.broadphase.broadphasePair;
import bullet.collision.broadphase.collisionAlgorithm;
import bullet.collision.dispatch.collisionObject;
import bullet.collision.broadphase.overlappingPairCache;
import bullet.collision.dispatch.collisionConfiguration;
import bullet.collision.shapes.collisionShape;
import bullet.linearMath.btPoolAllocator;

int gNumManifold = 0;

debug(bullet) {
	import std.stdio;
}

///user can override this nearcallback for collision filtering and more finegrained control over collision detection
alias void function(ref btBroadphasePair collisionPair, ref btCollisionDispatcher dispatcher, const ref btDispatcherInfo dispatchInfo) btNearCallback;


///btCollisionDispatcher supports algorithms that handle ConvexConvex and ConvexConcave collision pairs.
///Time of Impact, Closest Points and Penetration Depth.
class btCollisionDispatcher: btDispatcher {

protected:

	int		m_dispatcherFlags;

	btAlignedObjectArray!(btPersistentManifold*) m_manifoldsPtr;

	btManifoldResult	m_defaultManifoldResult;

	btNearCallback		m_nearCallback;
	
	btPoolAllocator*	m_collisionAlgorithmPoolAllocator;

	btPoolAllocator*	m_persistentManifoldPoolAllocator;

	btCollisionAlgorithmCreateFunc* m_doubleDispatch[MAX_BROADPHASE_COLLISION_TYPES][MAX_BROADPHASE_COLLISION_TYPES];

	btCollisionConfiguration*	m_collisionConfiguration;


public:

	enum DispatcherFlags {
		CD_STATIC_STATIC_REPORTED = 1,
		CD_USE_RELATIVE_CONTACT_BREAKING_THRESHOLD = 2,
		CD_DISABLE_CONTACTPOOL_DYNAMIC_ALLOCATION = 4
	};

	int	getDispatcherFlags() const {
		return m_dispatcherFlags;
	}

	void setDispatcherFlags(int flags) {
		m_dispatcherFlags = flags;
	}

	///registerCollisionCreateFunc allows registration of custom/alternative collision create functions
	void registerCollisionCreateFunc(int proxyType0, int proxyType1, btCollisionAlgorithmCreateFunc* createFunc) {
		m_doubleDispatch[proxyType0][proxyType1] = createFunc;
	}

	final int getNumManifolds() const { 
		return cast(int)m_manifoldsPtr.size();
	}

	final btPersistentManifold** getInternalManifoldPointer() {
		return &m_manifoldsPtr[0];
	}

	final btPersistentManifold* getManifoldByIndexInternal(int index) {
		return m_manifoldsPtr[index];
	}

	final const btPersistentManifold* getManifoldByIndexInternal(int index) const {
		return m_manifoldsPtr[index];
	}

	this(btCollisionConfiguration* collisionConfiguration) {
		m_dispatcherFlags = DispatcherFlags.CD_USE_RELATIVE_CONTACT_BREAKING_THRESHOLD;
		m_collisionConfiguration = collisionConfiguration;
		
		int i;

		setNearCallback(defaultNearCallback);
		
		m_collisionAlgorithmPoolAllocator = collisionConfiguration.getCollisionAlgorithmPool();

		m_persistentManifoldPoolAllocator = collisionConfiguration.getPersistentManifoldPool();

		for (i=0; i < MAX_BROADPHASE_COLLISION_TYPES; i++)
		{
			for (int j=0;j<MAX_BROADPHASE_COLLISION_TYPES;j++)
			{
				m_doubleDispatch[i][j] = m_collisionConfiguration.getCollisionAlgorithmCreateFunc(i,j);
				btAssert(m_doubleDispatch[i][j]);
			}
		}
	}

	~this();

	btPersistentManifold* getNewManifold(void* b0, void* b1) {
		gNumManifold++;
	
		//btAssert(gNumManifold < 65535);
		
		btCollisionObject* body0 = cast(btCollisionObject*)b0;
		btCollisionObject* body1 = cast(btCollisionObject*)b1;

		//optional relative contact breaking threshold, turned on by default (use setDispatcherFlags to switch off feature for improved performance)
		
		btScalar contactBreakingThreshold =  (m_dispatcherFlags & DispatcherFlags.CD_USE_RELATIVE_CONTACT_BREAKING_THRESHOLD) ? 
			btMin(body0.getCollisionShape().getContactBreakingThreshold(gContactBreakingThreshold), body1.getCollisionShape().getContactBreakingThreshold(gContactBreakingThreshold))
			: gContactBreakingThreshold;

		btScalar contactProcessingThreshold = btMin(body0.getContactProcessingThreshold(), body1.getContactProcessingThreshold());
			
		void* mem = 0;
		
		if (m_persistentManifoldPoolAllocator.getFreeCount())
		{
			mem = m_persistentManifoldPoolAllocator.allocate(sizeof(btPersistentManifold));
		} else
		{
			//we got a pool memory overflow, by default we fallback to dynamically allocate memory. If we require a contiguous contact pool then assert.
			if ((m_dispatcherFlags&CD_DISABLE_CONTACTPOOL_DYNAMIC_ALLOCATION)==0)
			{
				mem = btAlignedAlloc(sizeof(btPersistentManifold),16);
			} else
			{
				btAssert(0);
				//make sure to increase the m_defaultMaxPersistentManifoldPoolSize in the btDefaultCollisionConstructionInfo/btDefaultCollisionConfiguration
				return 0;
			}
		}
		btPersistentManifold* manifold = new(mem) btPersistentManifold (body0,body1,0,contactBreakingThreshold,contactProcessingThreshold);
		manifold.m_index1a = m_manifoldsPtr.size();
		m_manifoldsPtr.push_back(manifold);

		return manifold;
	}
	
	void releaseManifold(btPersistentManifold manifold) {
		gNumManifold--;

		//printf("releaseManifold: gNumManifold %d\n",gNumManifold);
		clearManifold(manifold);

		int findIndex = manifold.m_index1a;
		btAssert(findIndex < m_manifoldsPtr.size());
		m_manifoldsPtr.swap(findIndex, m_manifoldsPtr.size()-1);
		m_manifoldsPtr[findIndex].m_index1a = findIndex;
		m_manifoldsPtr.pop_back();

		if (m_persistentManifoldPoolAllocator.validPtr(manifold)) {
			m_persistentManifoldPoolAllocator.freeMemory(manifold);
		}
		//Otherwise, let the GC handle it.
	}


	void clearManifold(btPersistentManifold manifold) {
		manifold.clearManifold();
	}

			
	btCollisionAlgorithm* findAlgorithm(btCollisionObject* body0, btCollisionObject* body1, btPersistentManifold* sharedManifold = null) {
		btCollisionAlgorithmConstructionInfo ci;

		ci.m_dispatcher1 = this;
		ci.m_manifold = sharedManifold;
		btCollisionAlgorithm* algo = m_doubleDispatch[body0.getCollisionShape().getShapeType()][body1.getCollisionShape().getShapeType()].CreateCollisionAlgorithm(ci, body0, body1);

		return algo;
	}
		
	bool needsCollision(btCollisionObject body0, btCollisionObject body1) {
		btAssert(body0 !is null);
		btAssert(body1 !is null);

		bool needsCollision = true;

		debug(bullet) {
			if (!(m_dispatcherFlags & DispatcherFlags.CD_STATIC_STATIC_REPORTED)) {
				//broadphase filtering already deals with this
				if (body0.isStaticOrKinematicObject() && body1.isStaticOrKinematicObject()) {
					m_dispatcherFlags |= DispatcherFlags.CD_STATIC_STATIC_REPORTED;
					writeln("Warning: btCollisionDispatcher.needsCollision: static-static collision!");
				}
			}
		}

		if ((!body0.isActive()) && (!body1.isActive()))
			needsCollision = false;
		else if (!body0.checkCollideWith(body1))
			needsCollision = false;
		
		return needsCollision;
	}
	
	bool needsResponse(btCollisionObject body0, btCollisionObject body1) {
		//here you can do filtering
		bool hasResponse = 
			(body0.hasContactResponse() && body1.hasContactResponse());
		//no response between two static/kinematic bodies:
		hasResponse = hasResponse &&
			((!body0.isStaticOrKinematicObject()) ||(! body1.isStaticOrKinematicObject()));
		return hasResponse;
	}
	
	void dispatchAllCollisionPairs()(btOverlappingPairCache pairCache, const auto ref btDispatcherInfo dispatchInfo, btDispatcher dispatcher) {
		//m_blockedForChanges = true;

		auto collisionCallback = btCollisionPairCallback(dispatchInfo, this);

		pairCache.processAllOverlappingPairs(&collisionCallback, dispatcher);

		//m_blockedForChanges = false;
	}

	void setNearCallback(btNearCallback	nearCallback) {
		m_nearCallback = nearCallback; 
	}

	btNearCallback getNearCallback() const {
		return m_nearCallback;
	}

	//by default, Bullet will use this near callback
	static void defaultNearCallback()(ref btBroadphasePair collisionPair, ref btCollisionDispatcher dispatcher, const auto ref btDispatcherInfo dispatchInfo) {
		btCollisionObject colObj0 = *cast(btCollisionObject*)collisionPair.m_pProxy0.m_clientObject;
		btCollisionObject colObj1 = *cast(btCollisionObject*)collisionPair.m_pProxy1.m_clientObject;

		if (dispatcher.needsCollision(colObj0, colObj1)) {
			//dispatcher will keep algorithms persistent in the collision pair
			if (!collisionPair.m_algorithm) {
				collisionPair.m_algorithm = dispatcher.findAlgorithm(colObj0, colObj1);
			}

			if (collisionPair.m_algorithm) {
				btManifoldResult contactPointResult(colObj0, colObj1);
				
				if (dispatchInfo.m_dispatchFunc == 	btDispatcherInfo.DISPATCH_DISCRETE) {
					//discrete collision detection query
					collisionPair.m_algorithm.processCollision(colObj0, colObj1, dispatchInfo, &contactPointResult);
				} else {
					//continuous collision detection query, time of impact (toi)
					btScalar toi = collisionPair.m_algorithm.calculateTimeOfImpact(colObj0, colObj1,dispatchInfo, &contactPointResult);
					if (dispatchInfo.m_timeOfImpact > toi)
						dispatchInfo.m_timeOfImpact = toi;
				}
			}
		}
	}

	void* allocateCollisionAlgorithm(int size) {
		//If the allocator is configured to be overflow-safe (the default), this will work just fine.
		return m_collisionAlgorithmPoolAllocator.allocate();
	}

	void freeCollisionAlgorithm(void* ptr) {
		if (m_collisionAlgorithmPoolAllocator.validPtr(ptr)) {
			m_collisionAlgorithmPoolAllocator.freeMemory(ptr);
		}
		//Otherwise, let the GC handle it.
	}

	btCollisionConfiguration*	getCollisionConfiguration() {
		return m_collisionConfiguration;
	}

	const btCollisionConfiguration*	getCollisionConfiguration() const {
		return m_collisionConfiguration;
	}

	void	setCollisionConfiguration(btCollisionConfiguration* config) {
		m_collisionConfiguration = config;
	}

	btPoolAllocator* getInternalManifoldPool() {
		return m_persistentManifoldPoolAllocator;
	}

	const btPoolAllocator*	getInternalManifoldPool() const {
		return m_persistentManifoldPoolAllocator;
	}

};

///interface for iterating all overlapping collision pairs, no matter how those pairs are stored (array, set, map etc)
///this is useful for the collision dispatcher.
class btCollisionPairCallback: btOverlapCallback {
	const btDispatcherInfo* m_dispatchInfo;
	btCollisionDispatcher	m_dispatcher;

public:

	this()(const auto ref btDispatcherInfo dispatchInfo, btCollisionDispatcher dispatcher) {
		m_dispatchInfo = &dispatchInfo;
		m_dispatcher = dispatcher;
	}

	/*btCollisionPairCallback& operator=(btCollisionPairCallback& other)
	{
		m_dispatchInfo = other.m_dispatchInfo;
		m_dispatcher = other.m_dispatcher;
		return *this;
	}
	*/

	bool processOverlap(ref btBroadphasePair pair) {
		(*m_dispatcher.getNearCallback())(pair, m_dispatcher, m_dispatchInfo);

		return false;
	}
};
