/*
Bullet Continuous Collision Detection and Physics Library
Copyright (c) 2003-2009 Erwin Coumans  http://bulletphysics.org

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

module bullet.collision.shapes.collisionShape;

import bullet.collision.broadphase.broadphaseProxy; //for the shape types
import bullet.linearMath.btMatrix3x3;
import bullet.linearMath.btSerializer;
import bullet.linearMath.btTransform;
import bullet.linearMath.btVector3;


///The btCollisionShape class provides an interface for collision shapes that can be shared among btCollisionObjects.
abstract class btCollisionShape {
protected:
	int m_shapeType = BroadphaseNativeTypes.INVALID_SHAPE_PROXYTYPE;
	void* m_userPointer;

public:

	///getAabb returns the axis aligned bounding box in the coordinate frame of the given transform t.
	void getAabb()(const auto ref btTransform t, ref btVector3 aabbMin, ref btVector3 aabbMax) const;

	void getBoundingSphere(ref btVector3 center, ref btScalar radius) const {
		btTransform tr;
		tr.setIdentity();
		btVector3 aabbMin,aabbMax;

		getAabb(tr,aabbMin,aabbMax);

		radius = (aabbMax-aabbMin).length()*btScalar(0.5);
		center = (aabbMin+aabbMax)*btScalar(0.5);
	}

	///getAngularMotionDisc returns the maximus radius needed for Conservative Advancement to handle time-of-impact with rotations.
	btScalar getAngularMotionDisc() const {
		//To do: cache this value to improve performance
		btVector3	center;
		btScalar disc;
		getBoundingSphere(center, disc);
		disc += (center).length();
		return disc;
	}

	btScalar getContactBreakingThreshold(btScalar defaultContactThresholdFactor) const {
		return getAngularMotionDisc() * defaultContactThreshold;
	}

	///calculateTemporalAabb calculates the enclosing aabb for the moving object over interval [0..timeStep)
	///result is conservative
	void calculateTemporalAabb()(const auto ref btTransform curTrans, const auto ref btVector3 linvel,
			const auto ref btVector3 angvel, btScalar timeStep, ref btVector3 temporalAabbMin,
			btVector3 temporalAabbMax) const {
		//start with static aabb
		getAabb(curTrans,temporalAabbMin,temporalAabbMax);

		btScalar temporalAabbMaxx = temporalAabbMax.getX();
		btScalar temporalAabbMaxy = temporalAabbMax.getY();
		btScalar temporalAabbMaxz = temporalAabbMax.getZ();
		btScalar temporalAabbMinx = temporalAabbMin.getX();
		btScalar temporalAabbMiny = temporalAabbMin.getY();
		btScalar temporalAabbMinz = temporalAabbMin.getZ();

		// add linear motion
		btVector3 linMotion = linvel*timeStep;
		///@todo: simd would have a vector max/min operation, instead of per-element access
		if (linMotion.x() > cast(btScalar)0.0)
			temporalAabbMaxx += linMotion.x(); 
		else
			temporalAabbMinx += linMotion.x();
		if (linMotion.y() > cast(btScalar)0.0)
			temporalAabbMaxy += linMotion.y(); 
		else
			temporalAabbMiny += linMotion.y();
		if (linMotion.z() > cast(btScalar)0.0)
			temporalAabbMaxz += linMotion.z(); 
		else
			temporalAabbMinz += linMotion.z();

		//add conservative angular motion
		btScalar angularMotion = angvel.length() * getAngularMotionDisc() * timeStep;
		auto angularMotion3d = btVector3(angularMotion,angularMotion,angularMotion);
		temporalAabbMin = btVector3(temporalAabbMinx,temporalAabbMiny,temporalAabbMinz);
		temporalAabbMax = btVector3(temporalAabbMaxx,temporalAabbMaxy,temporalAabbMaxz);

		temporalAabbMin -= angularMotion3d;
		temporalAabbMax += angularMotion3d;
	}

	final bool isPolyhedral() const {
		return btBroadphaseProxy.isPolyhedral(getShapeType());
	}

	final bool isConvex2d() const {
		return btBroadphaseProxy.isConvex2d(getShapeType());
	}

	final bool isConvex() const {
		return btBroadphaseProxy.isConvex(getShapeType());
	}
	
	final bool isNonMoving() const {
		return btBroadphaseProxy.isNonMoving(getShapeType());
	}
	
	final bool isConcave() const {
		return btBroadphaseProxy.isConcave(getShapeType());
	}
	final bool isCompound() const {
		return btBroadphaseProxy.isCompound(getShapeType());
	}

	final bool isSoftBody() const {
		return btBroadphaseProxy.isSoftBody(getShapeType());
	}

	///isInfinite is used to catch simulation error (aabb check)
	final bool isInfinite() const {
		return btBroadphaseProxy.isInfinite(getShapeType());
	}

	version(__SPU__) {
		void	setLocalScaling()(const auto ref btVector3 scaling);
		const ref btVector3 getLocalScaling() const;
		void calculateLocalInertia(btScalar mass, ref btVector3 inertia) const;

		//debugging support
		string getName() const;
	}

	
	final int getShapeType() const { return m_shapeType; }
	void setMargin(btScalar margin);
	btScalar getMargin() const;

	
	///optional user data pointer
	void setUserPointer(void*  userPtr) {
		m_userPointer = userPtr;
	}

	void* getUserPointer() const {
		return cast(void*)m_userPointer;
	}

	int	calculateSerializeBufferSize() const {
		return btCollisionShapeData.sizeof;
	}

	///fills the dataBuffer and returns the struct name (and 0 on failure)
	string serialize(ubyte[] dataBuffer, btSerializer serializer) const {
		btCollisionShapeData* shapeData = cast(btCollisionShapeData*)dataBuffer;
		string name = serializer.findNameForPointer(&this);
		shapeData.m_name = cast(char*)serializer.getUniquePointer(name);
		if (shapeData.m_name) {
			serializer.serializeName(name);
		}
		shapeData.m_shapeType = m_shapeType;
		//shapeData->m_padding//??
		return "btCollisionShapeData";
	}

	void serializeSingleShape(btSerializer serializer) const {
		int len = calculateSerializeBufferSize();
		btChunk* chunk = serializer.allocate(len, 1);
		string structType = serialize(chunk.m_oldPtr, serializer);
		serializer.finalizeChunk(chunk, structType, BT_SHAPE_CODE, cast(void*)&this);
	}
};	

///do not change those serialization structures, it requires an updated sBulletDNAstr/sBulletDNAstr64
struct	btCollisionShapeData
{
	char	*m_name;
	int		m_shapeType;
	char	m_padding[4];
};
