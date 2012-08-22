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

module bullet.collision.narrowPhase.manifoldPoint;

import bullet.linearMath.btVector3;
import bullet.linearMath.btTransformUtil;

// Don't change following order of parameters
align(2) struct btConstraintRow {
	btScalar m_normal[3];
	btScalar m_rhs;
	btScalar m_jacDiagInv;
	btScalar m_lowerLimit;
	btScalar m_upperLimit;
	btScalar m_accumImpulse;
};

alias btConstraintRow PfxConstraintRow;

/// ManifoldContactPoint collects and maintains persistent contactpoints.
/// used to improve stability and performance of rigidbody dynamics response.
///To do: make everything use pointers to this?
struct btManifoldPoint {
	public:

		this()(const auto ref btVector3 pointA, const auto ref btVector3 pointB,
				const auto ref btVector3 normal, btScalar distance) {
			m_localPointA = pointA;
			m_localPointB = pointB;
			m_normalWorldOnB = normal;
			m_distance1 = distance;
			mConstraintRow[0].m_accumImpulse = 0.f;
			mConstraintRow[1].m_accumImpulse = 0.f;
			mConstraintRow[2].m_accumImpulse = 0.f;
		}



		btVector3 m_localPointA;
		btVector3 m_localPointB;
		btVector3	m_positionWorldOnB;
		///m_positionWorldOnA is redundant information, see getPositionWorldOnA(), but for clarity
		btVector3	m_positionWorldOnA;
		btVector3 m_normalWorldOnB;

		btScalar	m_distance1;
		btScalar	m_combinedFriction = 0.0;
		btScalar	m_combinedRestitution = 0.0;

		//BP mod, store contact triangles.
		int	   m_partId0;
		int      m_partId1;
		int      m_index0;
		int      m_index1;

		/*mutable*/ void*	m_userPersistentData;
		btScalar		m_appliedImpulse;

		bool			m_lateralFrictionInitialized;
		btScalar		m_appliedImpulseLateral1 = 0.0;
		btScalar		m_appliedImpulseLateral2 = 0.0;
		btScalar		m_contactMotion1 = 0.0;
		btScalar		m_contactMotion2 = 0.0;
		btScalar		m_contactCFM1 = 0.0;
		btScalar		m_contactCFM2 = 0.0;

		int				m_lifeTime;//lifetime of the contactpoint in frames

		btVector3		m_lateralFrictionDir1;
		btVector3		m_lateralFrictionDir2;



		btConstraintRow mConstraintRow[3];


		btScalar getDistance() const {
			return m_distance1;
		}

		int	getLifeTime() const {
			return m_lifeTime;
		}

		const ref btVector3 getPositionWorldOnA() const {
			return m_positionWorldOnA;
			//return m_positionWorldOnB + m_normalWorldOnB * m_distance1;
		}

		const ref btVector3 getPositionWorldOnB() const {
			return m_positionWorldOnB;
		}

		void	setDistance(btScalar dist) {
			m_distance1 = dist;
		}

		///this returns the most recent applied impulse, to satisfy contact constraints by the constraint solver
		btScalar	getAppliedImpulse() const {
			return m_appliedImpulse;
		}
};
