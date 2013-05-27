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

//Port of Bullet Physics to D

module bullet.collision.dispatch.manifoldResult;

import bullet.collision.dispatch.collisionObject;
import bullet.collision.narrowPhase.manifoldPoint;
import bullet.collision.narrowPhase.persistentManifold;
import bullet.linearMath.btScalar;
import bullet.linearMath.btTransform;

alias bool function(ref btManifoldPoint cp, const btCollisionObject colObj0, int partId0, int index0,
	const btCollisionObject colObj1, int partId1, int index1) ContactAddedCallback;
extern ContactAddedCallback	gContactAddedCallback;

///btManifoldResult is a helper class to manage  contact results
///To do: restore inheritance?
class btManifoldResult/+: btDiscreteCollisionDetectorInterface.Result+/ {
protected:

	btPersistentManifold m_manifold;

	//we need this for compounds
	btTransform	m_rootTransA;
	btTransform	m_rootTransB;

	btCollisionObject m_body0;
	btCollisionObject m_body1;
	int	m_partId0 = -1;
	int m_partId1 = -1;
	int m_index0 = -1;
	int m_index1 = -1;


public:
	this() {}

	this(btCollisionObject body0,btCollisionObject body1);

	~this() {};

	void setPersistentManifold(btPersistentManifold manifold) {
		m_manifold = manifold;
	}

	inout(btPersistentManifold) getPersistentManifold() inout {
		return m_manifold;
	}

	void setShapeIdentifiersA(int partId0, int index0) {
		m_partId0=partId0;
		m_index0=index0;
	}

	void setShapeIdentifiersB(int partId1,int index1) {
		m_partId1=partId1;
		m_index1=index1;
	}

	void addContactPoint()(const auto ref btVector3 normalOnBInWorld, const auto ref btVector3 pointInWorld, btScalar depth);

	void refreshContactPoints() {
		btAssert(m_manifold !is null);
		if (!m_manifold.getNumContacts())
			return;

		bool isSwapped = m_manifold.getBody0() != m_body0;

		if (isSwapped) {
			m_manifold.refreshContactPoints(m_rootTransB,m_rootTransA);
		} else {
			m_manifold.refreshContactPoints(m_rootTransA,m_rootTransB);
		}
	}

	const(btCollisionObject) getBody0Internal() const {
		return m_body0;
	}

	const(btCollisionObject) getBody1Internal() const {
		return m_body1;
	}

}
