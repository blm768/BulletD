//Bullet Continuous Collision Detection and Physics Library
//Copyright (c) 2003-2006 Erwin Coumans  http://continuousphysics.com/Bullet/

//
// btAxisSweep3.h
//
// Copyright (c) 2006 Simon Hobbs
//
// This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
// 1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
//
// 2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//
// 3. This notice may not be removed or altered from any source distribution.

//D port of Bullet Physics

module bullet.collision.broadphase.axisSweep3;

import bullet.linearMath.btMatrix3x3;
import bullet.linearMath.btVector3;
import bullet.collision.broadphase.overlappingPairCache;

version = USE_OVERLAP_TEST_ON_REMOVES;

/// The internal templace class btAxisSweep3Internal implements the sweep and prune broadphase.
/// It uses quantized integers to represent the begin and end points for each of the 3 axis.
/// Don't use this class directly, use btAxisSweep3 or bt32BitAxisSweep3 instead.
class btAxisSweep3Internal(BP_FP_INT_TYPE): btBroadphaseInterface {
protected:

	BP_FP_INT_TYPE	m_bpHandleMask;
	BP_FP_INT_TYPE	m_handleSentinel;

	public:
	
 //BT_DECLARE_ALIGNED_ALLOCATOR();

	class Edge {
	public:
		BP_FP_INT_TYPE m_pos;			// low bit is min/max
		BP_FP_INT_TYPE m_handle;

		BP_FP_INT_TYPE IsMax() const {return cast(BP_FP_INT_TYPE)(m_pos & 1);}
	};

	public:
	class Handle: btBroadphaseProxy {
	public:
	//BT_DECLARE_ALIGNED_ALLOCATOR();
	
		// indexes into the edge arrays
		BP_FP_INT_TYPE[3] m_minEdges, m_maxEdges;		// 6 * 2 = 12
		//BP_FP_INT_TYPE m_uniqueId;
		btBroadphaseProxy*	m_dbvtProxy;//for faster raycast
		//void* m_pOwner; this is now in btBroadphaseProxy.m_clientObject
	
		void SetNextFree(BP_FP_INT_TYPE next) {m_minEdges[0] = next;}
		BP_FP_INT_TYPE GetNextFree() const {return m_minEdges[0];}
	};		// 24 bytes + 24 for Edge structures = 44 bytes total per entry

	
	protected:
	btVector3 m_worldAabbMin;						// overall system bounds
	btVector3 m_worldAabbMax;						// overall system bounds

	btVector3 m_quantize;						// scaling factor for quantization

	BP_FP_INT_TYPE m_numHandles;						// number of active handles
	BP_FP_INT_TYPE m_maxHandles;						// max number of handles
	Handle* m_pHandles;						// handles pool
	
	BP_FP_INT_TYPE m_firstFreeHandle;		// free handles list

	Edge* m_pEdges[3];						// edge arrays for the 3 axes (each array has m_maxHandles * 2 + 2 sentinel entries)
	void* m_pEdgesRawPtr[3];

	btOverlappingPairCache* m_pairCache;

	///btOverlappingPairCallback is an additional optional user callback for adding/removing overlapping pairs, similar interface to btOverlappingPairCache.
	btOverlappingPairCallback* m_userPairCallback;
	
	bool	m_ownsPairCache;

	int	m_invalidPair;

	///additional dynamic aabb structure, used to accelerate ray cast queries.
	///can be disabled using a optional argument in the constructor
	btDbvtBroadphase*	m_raycastAccelerator;
	btOverlappingPairCache*	m_nullPairCache;


	// allocation/deallocation
	BP_FP_INT_TYPE allocHandle();
	void freeHandle(BP_FP_INT_TYPE handle);
	

	bool testOverlap2D(const Handle* pHandleA, const Handle* pHandleB, int axis0, int axis1);

	version(DEBUG_BROADPHASE) {
		void debugPrintAxis(int axis, bool checkCardinality = true);
	}

	//Overlap* AddOverlap(BP_FP_INT_TYPE handleA, BP_FP_INT_TYPE handleB);
	//void RemoveOverlap(BP_FP_INT_TYPE handleA, BP_FP_INT_TYPE handleB);

	void sortMinDown(int axis, BP_FP_INT_TYPE edge, btDispatcher* dispatcher, bool updateOverlaps );
	void sortMinUp(int axis, BP_FP_INT_TYPE edge, btDispatcher* dispatcher, bool updateOverlaps );
	void sortMaxDown(int axis, BP_FP_INT_TYPE edge, btDispatcher* dispatcher, bool updateOverlaps );
	void sortMaxUp(int axis, BP_FP_INT_TYPE edge, btDispatcher* dispatcher, bool updateOverlaps );

	public:

	this()(const auto ref btVector3 worldAabbMin, const auto ref btVector3 worldAabbMax, BP_FP_INT_TYPE handleMask, BP_FP_INT_TYPE handleSentinel, BP_FP_INT_TYPE maxHandles = 16384, btOverlappingPairCache* pairCache=0, bool disableRaycastAccelerator = false);

	//~this();

	BP_FP_INT_TYPE getNumHandles() const {
		return m_numHandles;
	}

	void calculateOverlappingPairs(btDispatcher* dispatcher);
	
	BP_FP_INT_TYPE addHandle()(const auto ref btVector3 aabbMin, const auto ref btVector3 aabbMax, void* pOwner, short collisionFilterGroup, short collisionFilterMask, btDispatcher* dispatcher, void* multiSapProxy);
	void removeHandle(BP_FP_INT_TYPE handle, btDispatcher* dispatcher);
	void updateHandle()(BP_FP_INT_TYPE handle, const auto ref btVector3 aabbMin, const auto ref btVector3 aabbMax, btDispatcher* dispatcher);
	Handle* getHandle(BP_FP_INT_TYPE index) const {return m_pHandles + index;}

	void resetPool(btDispatcher* dispatcher);

	void processAllOverlappingPairs(btOverlapCallback* callback);

	//Broadphase Interface
	btBroadphaseProxy*	createProxy()(const auto ref btVector3 aabbMin, const auto ref btVector3 aabbMax,int shapeType, void* userPtr , short collisionFilterGroup, short collisionFilterMask, btDispatcher* dispatcher, void* multiSapProxy);
	void destroyProxy(btBroadphaseProxy* proxy,btDispatcher* dispatcher);
	void setAabb()(btBroadphaseProxy* proxy, const auto ref btVector3 aabbMin, const auto ref btVector3 aabbMax, btDispatcher* dispatcher);
	void getAabb()(btBroadphaseProxy* proxy, ref btVector3 aabbMin, ref btVector3 aabbMax) const;
	
	void	rayTest()(const auto ref btVector3 rayFrom, const auto ref btVector3 rayTo, ref btBroadphaseRayCallback rayCallback, const auto ref btVector3 aabbMin = btVector3(0,0,0), const auto ref btVector3 aabbMax = btVector3(0,0,0));
	void	aabbTest()(const auto ref btVector3 aabbMin, const auto ref btVector3 aabbMax, ref btBroadphaseAabbCallback callback);

	
	void quantize()(BP_FP_INT_TYPE* valOut, const auto ref btVector3 point, int isMax) const;
	///unQuantize should be conservative: aabbMin/aabbMax should be larger then 'getAabb' result
	void unQuantize()(btBroadphaseProxy* proxy, ref btVector3 aabbMin, ref btVector3 aabbMax ) const;
	
	bool testAabbOverlap(btBroadphaseProxy* proxy0, btBroadphaseProxy* proxy1);

	btOverlappingPairCache*	getOverlappingPairCache() {
		return m_pairCache;
	}
	const btOverlappingPairCache*	getOverlappingPairCache() const {
		return m_pairCache;
	}

	void	setOverlappingPairUserCallback(btOverlappingPairCallback* pairCallback) {
		m_userPairCallback = pairCallback;
	}
	const btOverlappingPairCallback*	getOverlappingPairUserCallback() const {
		return m_userPairCallback;
	}

	///getAabb returns the axis aligned bounding box in the 'global' coordinate frame
	///will add some transform later
	void getBroadphaseAabb(ref btVector3 aabbMin, ref btVector3 aabbMax) const {
		aabbMin = m_worldAabbMin;
		aabbMax = m_worldAabbMax;
	}

	void	printStats() {
/*		printf("btAxisSweep3.h\n");
		printf("numHandles = %d, maxHandles = %d\n",m_numHandles,m_maxHandles);
		printf("aabbMin=%f,%f,%f,aabbMax=%f,%f,%f\n",m_worldAabbMin.getX(),m_worldAabbMin.getY(),m_worldAabbMin.getZ(),
			m_worldAabbMax.getX(),m_worldAabbMax.getY(),m_worldAabbMax.getZ());
			*/
	}

};