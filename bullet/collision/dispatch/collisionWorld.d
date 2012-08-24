/*
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2003-2006 Erwin Coumans  http://bulletphysics.com/Bullet/

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

module bullet.collision.dispatch.collisionWorld;

/**
 * @mainpage Bullet Documentation
 *
 * @section intro_sec Introduction
 * Bullet Collision Detection & Physics SDK
 *
 * Bullet is a Collision Detection and Rigid Body Dynamics Library. The Library is Open Source and free for commercial use, under the ZLib license ( http://opensource.org/licenses/zlib-license.php ).
 *
 * The main documentation is Bullet_User_Manual.pdf, included in the source code distribution.
 * There is the Physics Forum for feedback and general Collision Detection and Physics discussions.
 * Please visit http://www.bulletphysics.com
 *
 * @section install_sec Installation
 *
 * @subsection step1 Step 1: Download
 * You can download the Bullet Physics Library from the Google Code repository: http://code.google.com/p/bullet/downloads/list
 *
 * @subsection step2 Step 2: Building
 * Bullet main build system for all platforms is cmake, you can download http://www.cmake.org
 * cmake can autogenerate projectfiles for Microsoft Visual Studio, Apple Xcode, KDevelop and Unix Makefiles.
 * The easiest is to run the CMake cmake-gui graphical user interface and choose the options and generate projectfiles.
 * You can also use cmake in the command-line. Here are some examples for various platforms:
 * cmake . -G "Visual Studio 9 2008"
 * cmake . -G Xcode
 * cmake . -G "Unix Makefiles"
 * Although cmake is recommended, you can also use autotools for UNIX: ./autogen.sh ./configure to create a Makefile and then run make.
 *
 * @subsection step3 Step 3: Testing demos
 * Try to run and experiment with BasicDemo executable as a starting point.
 * Bullet can be used in several ways, as Full Rigid Body simulation, as Collision Detector Library or Low Level / Snippets like the GJK Closest Point calculation.
 * The Dependencies can be seen in this documentation under Directories
 *
 * @subsection step4 Step 4: Integrating in your application, full Rigid Body and Soft Body simulation
 * Check out BasicDemo how to create a btDynamicsWorld, btRigidBody and btCollisionShape, Stepping the simulation and synchronizing your graphics object transform.
 * Check out SoftDemo how to use soft body dynamics, using btSoftRigidDynamicsWorld.
 * @subsection step5 Step 5 : Integrate the Collision Detection Library (without Dynamics and other Extras)
 * Bullet Collision Detection can also be used without the Dynamics/Extras.
 * Check out btCollisionWorld and btCollisionObject, and the CollisionInterfaceDemo.
 * @subsection step6 Step 6 : Use Snippets like the GJK Closest Point calculation.
 * Bullet has been designed in a modular way keeping dependencies to a minimum. The ConvexHullDistance demo demonstrates direct use of btGjkPairDetector.
 *
 * @section copyright Copyright
 * For up-to-data information and copyright and contributors list check out the Bullet_User_Manual.pdf
 *
 */

import bullet.collision.broadphase.broadphaseInterface;
import bullet.collision.broadphase.broadphaseProxy;
import bullet.collision.broadphase.overlappingPairCache;
import bullet.collision.dispatch.collisionConfiguration;
import bullet.collision.dispatch.collisionDispatcher;
import bullet.collision.dispatch.collisionObject;
import bullet.collision.narrowPhase.manifoldPoint;
import bullet.collision.shapes.collisionShape;
//import bullet.collision.shapes.convexShape;
import bullet.linearMath.btAlignedObjectArray;
import bullet.linearMath.btIDebugDraw;
import bullet.linearMath.btSerializer;
import bullet.linearMath.btStackAlloc;
import bullet.linearMath.btTransform;
import bullet.linearMath.btVector3;

///CollisionWorld is interface and container for the collision detection
class btCollisionWorld {


protected:

	btAlignedObjectArray!btCollisionObject	m_collisionObjects;

	btDispatcher	m_dispatcher1;

	btDispatcherInfo	m_dispatchInfo;

	btStackAlloc	m_stackAlloc;

	btBroadphaseInterface	m_broadphasePairCache;

	btIDebugDraw	m_debugDrawer;

	///m_forceUpdateAllAabbs can be set to false as an optimization to only update active object AABBs
	///it is true by default, because it is error-prone (setting the position of static objects wouldn't update their AABB)
	bool m_forceUpdateAllAabbs;

	void serializeCollisionObjects(btSerializer serializer);

public:
	this(btDispatcher dispatcher, btBroadphaseInterface broadphasePairCache,
		btCollisionConfiguration collisionConfiguration);

	~this();

	void setBroadphase(btBroadphaseInterface pairCache) {
		m_broadphasePairCache = pairCache;
	}

	inout(btBroadphaseInterface) getBroadphase() inout {
		return m_broadphasePairCache;
	}

	btOverlappingPairCache getPairCache() {
		return m_broadphasePairCache.getOverlappingPairCache();
	}

	inout(btDispatcher) getDispatcher() inout {
		return m_dispatcher1;
	}

	void updateSingleAabb(btCollisionObject colObj);

	void updateAabbs();

	void	setDebugDrawer(btIDebugDraw debugDrawer) {
		m_debugDrawer = debugDrawer;
	}

	btIDebugDraw getDebugDrawer() {
		return m_debugDrawer;
	}

	void debugDrawWorld();

	void debugDrawObject()(const auto ref btTransform worldTransform, const btCollisionShape shape,
		const auto ref btVector3 color);


	///LocalShapeInfo gives extra information for complex shapes
	///Currently, only btTriangleMeshShape is available, so it just contains triangleIndex and subpart
	struct	LocalShapeInfo {
		int	m_shapePart;
		int	m_triangleIndex;

		//const btCollisionShape*	m_shapeTemp;
		//const btTransform*	m_shapeLocalTransform;
	};

	struct	LocalRayResult {
		this()(btCollisionObject collisionObject,
				LocalShapeInfo localShapeInfo,
				const auto ref btVector3 hitNormalLocal,
				btScalar hitFraction) {
			m_collisionObject = collisionObject;
			m_localShapeInfo = localShapeInfo;
			m_hitNormalLocal = hitNormalLocal;
			m_hitFraction = hitFraction;
		}

		btCollisionObject		m_collisionObject;
		LocalShapeInfo*			m_localShapeInfo;
		btVector3				m_hitNormalLocal;
		btScalar				m_hitFraction;

	};

	///RayResultCallback is used to report new raycast results
	scope class RayResultCallback {
		btScalar	m_closestHitFraction = 1.0;
		btCollisionObject	m_collisionObject;
		short	m_collisionFilterGroup = btBroadphaseProxy.CollisionFilterGroups.DefaultFilter;
		short	m_collisionFilterMask = btBroadphaseProxy.CollisionFilterGroups.AllFilter;
      //@BP Mod - Custom flags, currently used to enable backface culling on tri-meshes, see btRaycastCallback
      uint m_flags;

		bool hasHit() const {
			return (m_collisionObject !is null);
		}

		bool needsCollision(btBroadphaseProxy proxy0) const {
			bool collides = (proxy0.m_collisionFilterGroup & m_collisionFilterMask) != 0;
			collides = collides && (m_collisionFilterGroup & proxy0.m_collisionFilterMask);
			return collides;
		}

		btScalar addSingleResult(ref LocalRayResult rayResult, bool normalInWorldSpace);
	};

	scope class ClosestRayResultCallback: RayResultCallback {
		this()(const auto ref btVector3 rayFromWorld, const auto ref btVector3 rayToWorld) {
			m_rayFromWorld = rayFromWorld;
			m_rayToWorld = rayToWorld;
		}

		btVector3	m_rayFromWorld;//used to calculate hitPointWorld from hitFraction
		btVector3	m_rayToWorld;

		btVector3	m_hitNormalWorld;
		btVector3	m_hitPointWorld;

		btScalar addSingleResult(ref LocalRayResult rayResult, bool normalInWorldSpace) {
			//caller already does the filter on the m_closestHitFraction
			btAssert(rayResult.m_hitFraction <= m_closestHitFraction);

			m_closestHitFraction = rayResult.m_hitFraction;
			m_collisionObject = rayResult.m_collisionObject;
			if (normalInWorldSpace){
				m_hitNormalWorld = rayResult.m_hitNormalLocal;
			} else {
				///need to transform normal into worldspace
				m_hitNormalWorld = m_collisionObject.getWorldTransform().getBasis() * rayResult.m_hitNormalLocal;
			}
			m_hitPointWorld.setInterpolate3(m_rayFromWorld, m_rayToWorld, rayResult.m_hitFraction);
			return rayResult.m_hitFraction;
		}
	};

	scope class AllHitsRayResultCallback: RayResultCallback {
		this()(const auto ref btVector3 rayFromWorld, const auto ref btVector3 rayToWorld) {
			m_rayFromWorld = rayFromWorld;
			m_rayToWorld = rayToWorld;
		}

		btAlignedObjectArray!btCollisionObject		m_collisionObjects;

		btVector3	m_rayFromWorld;//used to calculate hitPointWorld from hitFraction
		btVector3	m_rayToWorld;

		btAlignedObjectArray!btVector3	m_hitNormalWorld;
		btAlignedObjectArray!btVector3	m_hitPointWorld;
		btAlignedObjectArray!btScalar	m_hitFractions;

		btScalar addSingleResult(ref LocalRayResult rayResult, bool normalInWorldSpace) {
			m_collisionObject = rayResult.m_collisionObject;
			m_collisionObjects.push_back(rayResult.m_collisionObject);
			btVector3 hitNormalWorld;
			if (normalInWorldSpace) {
				hitNormalWorld = rayResult.m_hitNormalLocal;
			} else {
				///need to transform normal into worldspace
				hitNormalWorld = m_collisionObject.getWorldTransform().getBasis()*rayResult.m_hitNormalLocal;
			}
			m_hitNormalWorld.push_back(hitNormalWorld);
			btVector3 hitPointWorld;
			hitPointWorld.setInterpolate3(m_rayFromWorld,m_rayToWorld,rayResult.m_hitFraction);
			m_hitPointWorld.push_back(hitPointWorld);
			m_hitFractions.push_back(rayResult.m_hitFraction);
			return m_closestHitFraction;
		}
	};


	struct LocalConvexResult {
		//If there's no constructor, D allows constructor syntax like a struct literal.
		btCollisionObject		m_hitCollisionObject;
		LocalShapeInfo*			m_localShapeInfo;
		btVector3				m_hitNormalLocal;
		btVector3				m_hitPointLocal;
		btScalar				m_hitFraction;
	};

	///RayResultCallback is used to report new raycast results
	abstract scope class ConvexResultCallback {
		btScalar	m_closestHitFraction = 1.0;
		short		m_collisionFilterGroup = btBroadphaseProxy.CollisionFilterGroups.DefaultFilter;
		short		m_collisionFilterMask = btBroadphaseProxy.CollisionFilterGroups.AllFilter;

		bool hasHit() const {
			return (m_closestHitFraction < cast(btScalar)1.0);
		}

		bool needsCollision(btBroadphaseProxy proxy0) const {
			bool collides = (proxy0.m_collisionFilterGroup & m_collisionFilterMask) != 0;
			collides = collides && (m_collisionFilterGroup & proxy0.m_collisionFilterMask);
			return collides;
		}

		btScalar addSingleResult(ref LocalConvexResult convexResult, bool normalInWorldSpace);
	};

	scope class ClosestConvexResultCallback: ConvexResultCallback {
		this()(const auto ref btVector3 convexFromWorld, const auto ref btVector3 convexToWorld) {
			m_convexFromWorld = convexFromWorld;
			m_convexToWorld = convexToWorld;
		}

		btVector3	m_convexFromWorld;//used to calculate hitPointWorld from hitFraction
		btVector3	m_convexToWorld;

		btVector3	m_hitNormalWorld;
		btVector3	m_hitPointWorld;
		btCollisionObject	m_hitCollisionObject;

		btScalar addSingleResult(ref LocalConvexResult convexResult, bool normalInWorldSpace) {
			//caller already does the filter on the m_closestHitFraction
			btAssert(convexResult.m_hitFraction <= m_closestHitFraction);

			m_closestHitFraction = convexResult.m_hitFraction;
			m_hitCollisionObject = convexResult.m_hitCollisionObject;
			if (normalInWorldSpace) {
				m_hitNormalWorld = convexResult.m_hitNormalLocal;
			} else {
				///need to transform normal into worldspace
				m_hitNormalWorld = m_hitCollisionObject.getWorldTransform().getBasis()*convexResult.m_hitNormalLocal;
			}
			m_hitPointWorld = convexResult.m_hitPointLocal;
			return convexResult.m_hitFraction;
		}
	};

	///ContactResultCallback is used to report contact points
	abstract scope class ContactResultCallback {
		short	m_collisionFilterGroup = btBroadphaseProxy.CollisionFilterGroups.DefaultFilter;
		short	m_collisionFilterMask = btBroadphaseProxy.CollisionFilterGroups.AllFilter;

		bool needsCollision(btBroadphaseProxy proxy0) const {
			bool collides = (proxy0.m_collisionFilterGroup & m_collisionFilterMask) != 0;
			collides = collides && (m_collisionFilterGroup & proxy0.m_collisionFilterMask);
			return collides;
		}

		btScalar addSingleResult(ref btManifoldPoint cp, const btCollisionObject colObj0, int partId0, int index0,
			const btCollisionObject colObj1, int partId1, int index1);
	};



	int	getNumCollisionObjects() const {
		return cast(int)m_collisionObjects.size();
	}

	/// rayTest performs a raycast on all objects in the btCollisionWorld, and calls the resultCallback
	/// This allows for several queries: first hit, all hits, any hit, dependent on the value returned by the callback.
	void rayTest()(const auto ref btVector3 rayFromWorld, const auto ref btVector3 rayToWorld, ref RayResultCallback resultCallback) const;

	/// convexTest performs a swept convex cast on all objects in the btCollisionWorld, and calls the resultCallback
	/// This allows for several queries: first hit, all hits, any hit, dependent on the value return by the callback.
	void convexSweepTest()(const btConvexShape castShape, const auto ref btTransform from,
		const auto ref btTransform to, ref ConvexResultCallback resultCallback,
		btScalar allowedCcdPenetration = cast(btScalar)0.0) const;

	///contactTest performs a discrete collision test between colObj against all objects in the btCollisionWorld, and calls the resultCallback.
	///it reports one or more contact points for every overlapping object (including the one with deepest penetration)
	void contactTest(btCollisionObject colObj, ref ContactResultCallback resultCallback);

	///contactTest performs a discrete collision test between two collision objects and calls the resultCallback if overlap if detected.
	///it reports one or more contact points (including the one with deepest penetration)
	void contactPairTest(btCollisionObject colObjA, btCollisionObject colObjB, ref ContactResultCallback resultCallback);


	/// rayTestSingle performs a raycast call and calls the resultCallback. It is used internally by rayTest.
	/// In a future implementation, we consider moving the ray test as a virtual method in btCollisionShape.
	/// This allows more customization.
	static void	rayTestSingle()(const auto ref btTransform rayFromTrans, const auto ref btTransform rayToTrans,
					  btCollisionObject collisionObject,
					  const btCollisionShape collisionShape,
					  const auto ref btTransform colObjWorldTransform,
					  ref RayResultCallback resultCallback);

	/// objectQuerySingle performs a collision detection query and calls the resultCallback. It is used internally by rayTest.
	static void	objectQuerySingle()(const btConvexShape castShape, const auto ref btTransform rayFromTrans,
					  const auto ref btTransform rayToTrans,
					  btCollisionObject collisionObject,
					  const btCollisionShape collisionShape,
					  const auto ref btTransform colObjWorldTransform,
					  ref ConvexResultCallback resultCallback,
					  btScalar allowedPenetration);

	void addCollisionObject(btCollisionObject collisionObject,
		short collisionFilterGroup = btBroadphaseProxy.CollisionFilterGroups.DefaultFilter,
		short collisionFilterMask=btBroadphaseProxy.CollisionFilterGroups.AllFilter);

	ref inout(btCollisionObjectArray) getCollisionObjectArray() inout {
		return m_collisionObjects;
	}


	void removeCollisionObject(btCollisionObject collisionObject);

	void performDiscreteCollisionDetection();

	ref inout(btDispatcherInfo) getDispatchInfo() inout {
		return m_dispatchInfo;
	}

	bool	getForceUpdateAllAabbs() const {
		return m_forceUpdateAllAabbs;
	}

	void setForceUpdateAllAabbs(bool forceUpdateAllAabbs) {
		m_forceUpdateAllAabbs = forceUpdateAllAabbs;
	}

	///Preliminary serialization test for Bullet 2.76. Loading those files requires a separate parser (Bullet/Demos/SerializeDemo)
	void serialize(btSerializer serializer);

};
