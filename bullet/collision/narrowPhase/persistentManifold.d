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

module bullet.collision.narrowPhase.persistentManifold;

version = MAINTAIN_PERSISTENCY;
version = KEEP_DEEPEST_POINT;
btTypedObject q;

debug(persistency) {
	import std.stdio;
}

import bullet.collision.narrowPhase.manifoldPoint;
import bullet.linearMath.btVector3;
import bullet.linearMath.btTransform;

//struct btCollisionResult;

///maximum contact breaking and merging threshold
btScalar					gContactBreakingThreshold = cast(btScalar)0.02;

alias bool function(void* userPersistentData) ContactDestroyedCallback;
alias bool function(ref btManifoldPoint cp, void* body0, void* body1) ContactProcessedCallback;
ContactDestroyedCallback	gContactDestroyedCallback;
ContactProcessedCallback	gContactProcessedCallback;

//the enum starts at 1024 to avoid type conflicts with btTypedConstraint
enum btContactManifoldTypes {
	MIN_CONTACT_MANIFOLD_TYPE = 1024,
	BT_PERSISTENT_MANIFOLD_TYPE
};

immutable size_t MANIFOLD_CACHE_SIZE = 4;

///btPersistentManifold is a contact point cache, it stays persistent as long as objects are overlapping in the broadphase.
///Those contact points are created by the collision narrow phase.
///The cache can be empty, or hold 1,2,3 or 4 points. Some collision algorithms (GJK) might only add one point at a time.
///updates/refreshes old contact points, and throw them away if necessary (distance becomes too large)
///reduces the cache to 4 points, when more then 4 points are added, using following rules:
///the contact point with deepest penetration is always kept, and it tries to maximuze the area covered by the points
///note that some pairs of objects might have more then one contact manifold.


//ATTRIBUTE_ALIGNED16( class) btPersistentManifold : public btTypedObject
align(8) class btPersistentManifold:  btTypedObject {

	btManifoldPoint m_pointCache[MANIFOLD_CACHE_SIZE];

	/// this two body pointers can point to the physics rigidbody class.
	/// Object will allow any rigidbody class
	Object m_body0;
	Object m_body1;

	int	m_cachedPoints;

	btScalar m_contactBreakingThreshold;
	btScalar m_contactProcessingThreshold;


	/// sort cached points so most isolated points come first
	int	sortCachedPoints()(const auto ref btManifoldPoint pt) {
		//calculate 4 possible cases areas, and take biggest area
		//also need to keep 'deepest'

		int maxPenetrationIndex = -1;
		version(KEEP_DEEPEST_POINT) {
			btScalar maxPenetration = pt.getDistance();
			for (int i=0; i < 4; i++) {
				if (m_pointCache[i].getDistance() < maxPenetration) {
					maxPenetrationIndex = i;
					maxPenetration = m_pointCache[i].getDistance();
				}
			}
		}

		btScalar res0 = 0.0, res1 = 0.0, res2 = 0.0, res3 = 0.0;

		if (maxPenetrationIndex != 0) {
			btVector3 a0 = pt.m_localPointA - m_pointCache[1].m_localPointA;
			btVector3 b0 = m_pointCache[3].m_localPointA - m_pointCache[2].m_localPointA;
			btVector3 cross = a0.cross(b0);
			res0 = cross.length2();
		}
		if (maxPenetrationIndex != 1) {
			btVector3 a1 = pt.m_localPointA - m_pointCache[0].m_localPointA;
			btVector3 b1 = m_pointCache[3].m_localPointA - m_pointCache[2].m_localPointA;
			btVector3 cross = a1.cross(b1);
			res1 = cross.length2();
		}
		if (maxPenetrationIndex != 2) {
			btVector3 a2 = pt.m_localPointA - m_pointCache[0].m_localPointA;
			btVector3 b2 = m_pointCache[3].m_localPointA - m_pointCache[1].m_localPointA;
			btVector3 cross = a2.cross(b2);
			res2 = cross.length2();
		}
		if (maxPenetrationIndex != 3) {
			btVector3 a3 = pt.m_localPointA - m_pointCache[0].m_localPointA;
			btVector3 b3 = m_pointCache[2].m_localPointA - m_pointCache[1].m_localPointA;
			btVector3 cross = a3.cross(b3);
			res3 = cross.length2();
		}

		btVector4 maxvec = btVector4(res0, res1, res2, res3);
		int biggestarea = maxvec.closestAxis4();
		return biggestarea;
	}

	int	findContactPoint()(const btManifoldPoint* unUsed, int numUnused, const auto ref btManifoldPoint pt);

public:

	int	m_companionIdA;
	int	m_companionIdB;

	int m_index1a;

	this() {
		super(btContactManifoldTypes.BT_PERSISTENT_MANIFOLD_TYPE);
	}

	this(Object body0, Object body1, int, btScalar contactBreakingThreshold, btScalar contactProcessingThreshold) {
		super(btContactManifoldTypes.BT_PERSISTENT_MANIFOLD_TYPE);
		m_body0 = body0;
		m_body1 = body1;
		m_contactBreakingThreshold = contactBreakingThreshold;
		m_contactProcessingThreshold = contactProcessingThreshold;
	}

	inout(Object) getBody0() inout { return m_body0;}
	inout(Object) getBody1() inout { return m_body1;}

	void setBodies(Object body0, Object body1) {
		m_body0 = body0;
		m_body1 = body1;
	}

	void clearUserCache(ref btManifoldPoint pt) {
		void* oldPtr = pt.m_userPersistentData;
		if (oldPtr) {
			debug(persistency) {
				int i;
				int occurence = 0;
				for (i=0;i < m_cachedPoints; i++) {
					if (m_pointCache[i].m_userPersistentData == oldPtr) {
						occurence++;
						if (occurence > 1)
							writeln("Error in clearUserCache.");
					}
				}
				btAssert(occurence <= 0);
			}

			if (pt.m_userPersistentData && gContactDestroyedCallback) {
				(*gContactDestroyedCallback)(pt.m_userPersistentData);
				pt.m_userPersistentData = 0;
			}

			debug(persistency) {
					DebugPersistency();
			}
		}
	}

	debug(persistency) {
		void DebugPersistency() {
			int i;
			writefln("DebugPersistency : numPoints %d", m_cachedPoints);
			for (i=0;i<m_cachedPoints;i++) {
				writefln("m_pointCache[%d].m_userPersistentData = %x", i, m_pointCache[i].m_userPersistentData);
			}
		}
	}

	int	getNumContacts() const { return m_cachedPoints;}

	const ref btManifoldPoint getContactPoint(int index) const {
		btAssert(index < m_cachedPoints);
		return m_pointCache[index];
	}

	ref btManifoldPoint getContactPoint(int index) {
		btAssert(index < m_cachedPoints);
		return m_pointCache[index];
	}

	///@todo: get this margin from the current physics / collision environment
	btScalar getContactBreakingThreshold() const {
		return m_contactBreakingThreshold;
	}

	btScalar getContactProcessingThreshold() const {
		return m_contactProcessingThreshold;
	}

	int getCacheEntry()(const auto ref btManifoldPoint newPoint) const {
		btScalar shortestDist =  getContactBreakingThreshold() * getContactBreakingThreshold();
		int size = getNumContacts();
		int nearestPoint = -1;
		foreach(int i, ref const(btManifoldPoint) mp; m_pointCache[0 .. size]) {
			btVector3 diffA =  mp.m_localPointA - newPoint.m_localPointA;
			const btScalar distToManiPoint = diffA.dot(diffA);
			if( distToManiPoint < shortestDist ) {
				shortestDist = distToManiPoint;
				nearestPoint = i;
			}
		}
		return nearestPoint;
	}

	int addManifoldPoint()(const auto ref btManifoldPoint newPoint) {
		btAssert(validContactDistance(newPoint));

		int insertIndex = getNumContacts();
		if (insertIndex == MANIFOLD_CACHE_SIZE) {
			static if(MANIFOLD_CACHE_SIZE >= 4) {
				//sort cache so best points come first, based on area
				insertIndex = sortCachedPoints(newPoint);
			} else {
				insertIndex = 0;
			}
		clearUserCache(m_pointCache[insertIndex]);

		} else {
			m_cachedPoints++;
		}

		if (insertIndex<0)
			insertIndex = 0;

		btAssert(m_pointCache[insertIndex].m_userPersistentData == 0);
		m_pointCache[insertIndex] = newPoint;
		return insertIndex;
	}

	//To do: reduce the amount of indexing in here.
	void removeContactPoint (int index) {
		clearUserCache(m_pointCache[index]);

		int lastUsedIndex = getNumContacts() - 1;
//		m_pointCache[index] = m_pointCache[lastUsedIndex];
		if(index != lastUsedIndex)  {
			m_pointCache[index] = m_pointCache[lastUsedIndex];
			//get rid of duplicated userPersistentData pointer
			m_pointCache[lastUsedIndex].m_userPersistentData = 0;
			m_pointCache[lastUsedIndex].mConstraintRow[0].m_accumImpulse = 0.f;
			m_pointCache[lastUsedIndex].mConstraintRow[1].m_accumImpulse = 0.f;
			m_pointCache[lastUsedIndex].mConstraintRow[2].m_accumImpulse = 0.f;

			m_pointCache[lastUsedIndex].m_appliedImpulse = 0.f;
			m_pointCache[lastUsedIndex].m_lateralFrictionInitialized = false;
			m_pointCache[lastUsedIndex].m_appliedImpulseLateral1 = 0.f;
			m_pointCache[lastUsedIndex].m_appliedImpulseLateral2 = 0.f;
			m_pointCache[lastUsedIndex].m_lifeTime = 0;
		}

		btAssert(m_pointCache[lastUsedIndex].m_userPersistentData == 0);
		m_cachedPoints--;
	}

	//To do: reduce the amount of indexing in here.
	void replaceContactPoint()(const auto ref btManifoldPoint newPoint, int insertIndex) {
		btAssert(validContactDistance(newPoint));

		version(MAINTAIN_PERSISTENCY) {
			int	lifeTime = m_pointCache[insertIndex].getLifeTime();
			btScalar	appliedImpulse = m_pointCache[insertIndex].mConstraintRow[0].m_accumImpulse;
			btScalar	appliedLateralImpulse1 = m_pointCache[insertIndex].mConstraintRow[1].m_accumImpulse;
			btScalar	appliedLateralImpulse2 = m_pointCache[insertIndex].mConstraintRow[2].m_accumImpulse;
			//bool isLateralFrictionInitialized = m_pointCache[insertIndex].m_lateralFrictionInitialized;

			btAssert(lifeTime>=0);
			void* cache = m_pointCache[insertIndex].m_userPersistentData;

			m_pointCache[insertIndex] = newPoint;

			m_pointCache[insertIndex].m_userPersistentData = cache;
			m_pointCache[insertIndex].m_appliedImpulse = appliedImpulse;
			m_pointCache[insertIndex].m_appliedImpulseLateral1 = appliedLateralImpulse1;
			m_pointCache[insertIndex].m_appliedImpulseLateral2 = appliedLateralImpulse2;

			m_pointCache[insertIndex].mConstraintRow[0].m_accumImpulse =  appliedImpulse;
			m_pointCache[insertIndex].mConstraintRow[1].m_accumImpulse = appliedLateralImpulse1;
			m_pointCache[insertIndex].mConstraintRow[2].m_accumImpulse = appliedLateralImpulse2;


			m_pointCache[insertIndex].m_lifeTime = lifeTime;
		} else {
			clearUserCache(m_pointCache[insertIndex]);
			m_pointCache[insertIndex] = newPoint;
		}
	}


	bool validContactDistance()(const auto ref btManifoldPoint pt) const {
		return pt.m_distance1 <= getContactBreakingThreshold();
	}

	/// calculated new worldspace coordinates and depth, and reject points that exceed the collision margin
	void refreshContactPoints()(const auto ref btTransform trA, const auto ref btTransform trB) {
		int i;
		debug(persistency) {
			writefln("refreshContactPoints posA = (%f,%f,%f) posB = (%f,%f,%f)",
				trA.getOrigin().getX(),
				trA.getOrigin().getY(),
				trA.getOrigin().getZ(),
				trB.getOrigin().getX(),
				trB.getOrigin().getY(),
				trB.getOrigin().getZ());
		}
		/// first refresh worldspace positions and distance
		foreach_reverse(ref btManifoldPoint manifoldPoint; m_pointCache[0 .. getNumContacts()]) {
			manifoldPoint.m_positionWorldOnA = trA( manifoldPoint.m_localPointA );
			manifoldPoint.m_positionWorldOnB = trB( manifoldPoint.m_localPointB );
			manifoldPoint.m_distance1 = (manifoldPoint.m_positionWorldOnA - manifoldPoint.m_positionWorldOnB).dot(manifoldPoint.m_normalWorldOnB);
			manifoldPoint.m_lifeTime++;
		}

		/// then
		btScalar distance2d;
		btVector3 projectedDifference,projectedPoint;

		//Not using foreach_reverse because the loop is directly modifying the array during iteration
		//and I want to play it safe
		for (i = getNumContacts() - 1; i >= 0; i--) {
			//I don't think D supports references in this situation.
			btManifoldPoint* manifoldPoint = m_pointCache + i;
			//contact becomes invalid when signed distance exceeds margin (projected on contactnormal direction)
			if (!validContactDistance(*manifoldPoint)){
				removeContactPoint(i);
			} else {
				//contact also becomes invalid when relative movement orthogonal to normal exceeds margin
				projectedPoint = manifoldPoint.m_positionWorldOnA - manifoldPoint.m_normalWorldOnB * manifoldPoint.m_distance1;
				projectedDifference = manifoldPoint.m_positionWorldOnB - projectedPoint;
				distance2d = projectedDifference.dot(projectedDifference);
				if (distance2d  > getContactBreakingThreshold() * getContactBreakingThreshold()) {
					removeContactPoint(i);
				} else {
					//contact point processed callback
					if (gContactProcessedCallback)
						(*gContactProcessedCallback)(*manifoldPoint, m_body0,m_body1);
				}
			}
		}
		debug(persistency) {
			DebugPersistency();
		}
	}

	void	clearManifold() {
		int i;
		for (i=0; i < m_cachedPoints; i++) {
			clearUserCache(m_pointCache[i]);
		}
		m_cachedPoints = 0;
	}
};
