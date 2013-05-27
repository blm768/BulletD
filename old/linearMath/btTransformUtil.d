/*
Copyright (c) 2003-2006 Gino van den Bergen / Erwin Coumans  http://continuousphysics.com/Bullet/

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from the use of this software.
Permission is granted to anyone to use this software for any purpose, 
including commercial applications, and to alter it and redistribute it freely, 
subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.
*/

module bullet.linearMath.btTransformUtil;

import bullet.linearMath.btTransform;

import bullet.linearMath.btMatrix3x3;


immutable btScalar ANGULAR_MOTION_THRESHOLD = cast(btScalar)0.5 * SIMD_HALF_PI;

btVector3 btAabbSupport()(const auto ref btVector3 halfExtents, const auto ref btVector3 supportDir) {
	return btVector3(supportDir.x() < cast(btScalar)0.0 ? -halfExtents.x() : halfExtents.x(),
      supportDir.y() < cast(btScalar)0.0 ? -halfExtents.y() : halfExtents.y(),
      supportDir.z() < cast(btScalar)0.0 ? -halfExtents.z() : halfExtents.z()); 
}

/// Utils related to temporal transforms
struct btTransformUtil {

public:

	static void integrateTransform()(const auto ref btTransform curTrans, const auto ref btVector3 linvel,
			const auto ref btVector3 angvel, btScalar timeStep, ref btTransform predictedTransform) {
		predictedTransform.setOrigin(curTrans.getOrigin() + linvel * timeStep);
		version(QUATERNION_DERIVATIVE) {
			btQuaternion predictedOrn = curTrans.getRotation();
			predictedOrn += (angvel * predictedOrn) * (timeStep * cast(btScalar)0.5);
			predictedOrn.normalize();
		} else {
			//Exponential map
			//google for "Practical Parameterization of Rotations Using the Exponential Map", F. Sebastian Grassia

			btVector3 axis;
			btScalar fAngle = angvel.length(); 
			//limit the angular motion
			if (fAngle*timeStep > ANGULAR_MOTION_THRESHOLD) {
				fAngle = ANGULAR_MOTION_THRESHOLD / timeStep;
			}

			if ( fAngle < cast(btScalar)0.001 ) {
				// use Taylor's expansions of sync function
				axis = angvel * (cast(btScalar)0.5 * timeStep - (timeStep*timeStep*timeStep) * 
					cast(btScalar)0.020833333333 * fAngle * fAngle);
			} else {
				// sync(fAngle) = sin(c*fAngle)/t
				axis = angvel * (btSin(cast(btScalar)0.5 * fAngle * timeStep) / fAngle);
			}
			auto dorn  = btQuaternion(axis.x(), axis.y(), axis.z(), btCos(fAngle * timeStep * cast(btScalar)0.5));
			btQuaternion orn0 = curTrans.getRotation();

			btQuaternion predictedOrn = dorn * orn0;
			predictedOrn.normalize();
		}
		predictedTransform.setRotation(predictedOrn);
	}

	static void	calculateVelocityQuaternion()(const auto ref btVector3 pos0, const auto ref btVector3 pos1,
			const auto ref btQuaternion orn0, const auto ref btQuaternion orn1, btScalar timeStep,
			ref btVector3 linVel, ref btVector3 angVel) {
		linVel = (pos1 - pos0) / timeStep;
		btVector3 axis;
		btScalar  angle;
		if (orn0 != orn1) {
			calculateDiffAxisAngleQuaternion(orn0, orn1, axis, angle);
			angVel = axis * angle / timeStep;
		} else {
			angVel.setValue(0, 0, 0);
		}
	}

	static void calculateDiffAxisAngleQuaternion()(const auto ref btQuaternion orn0,
			const auto ref btQuaternion orn1a, ref btVector3 axis, ref btScalar angle) {
		btQuaternion orn1 = orn0.nearest(orn1a);
		btQuaternion dorn = orn1 * orn0.inverse();
		angle = dorn.getAngle();
		axis = btVector3(dorn.x(),dorn.y(),dorn.z());
		axis[3] = cast(btScalar)0.0;
		//check for axis length
		btScalar len = axis.length2();
		if (len < SIMD_EPSILON*SIMD_EPSILON)
			axis = btVector3(cast(btScalar)1.0, cast(btScalar)0.0, cast(btScalar)0.0);
		else
			axis /= btSqrt(len);
	}

	static void	calculateVelocity()(const auto ref btTransform transform0, const auto ref btTransform transform1,
			btScalar timeStep, ref btVector3 linVel, ref btVector3 angVel) {
		linVel = (transform1.getOrigin() - transform0.getOrigin()) / timeStep;
		btVector3 axis;
		btScalar  angle;
		calculateDiffAxisAngle(transform0, transform1, axis, angle);
		angVel = axis * angle / timeStep;
	}

	static void calculateDiffAxisAngle()(const auto ref btTransform transform0,
			const auto ref btTransform transform1, ref btVector3 axis, ref btScalar angle) {
		btMatrix3x3 dmat = transform1.getBasis() * transform0.getBasis().inverse();
		btQuaternion dorn;
		dmat.getRotation(dorn);

		///floating point inaccuracy can lead to w component > 1..., which breaks 
		dorn.normalize();
		
		angle = dorn.getAngle();
		axis = btVector3(dorn.x(),dorn.y(),dorn.z());
		axis[3] = cast(btScalar)0.0;
		//check for axis length
		btScalar len = axis.length2();
		if (len < SIMD_EPSILON*SIMD_EPSILON)
			axis = btVector3(cast(btScalar)1.0, cast(btScalar)0.0, cast(btScalar)0.0);
		else
			axis /= btSqrt(len);
	}

};


///The btConvexSeparatingDistanceUtil can help speed up convex collision detection 
///by conservatively updating a cached separating distance/vector instead of re-calculating the closest distance
struct btConvexSeparatingDistanceUtil {
	btQuaternion	m_ornA;
	btQuaternion	m_ornB;
	btVector3	m_posA;
	btVector3	m_posB;
	
	btVector3	m_separatingNormal;

	btScalar	m_boundingRadiusA;
	btScalar	m_boundingRadiusB;
	btScalar	m_separatingDistance = 0.0;

public:
	this(btScalar boundingRadiusA, btScalar boundingRadiusB) {
		m_boundingRadiusA = boundingRadiusA;
		m_boundingRadiusB = boundingRadiusB;
	}

	btScalar getConservativeSeparatingDistance() {
		return m_separatingDistance;
	}

	void updateSeparatingDistance()(const auto ref btTransform transA, const auto ref btTransform transB) {
		const btVector3* toPosA = &transA.getOrigin();
		const btVector3* toPosB = &transB.getOrigin();
		btQuaternion toOrnA = transA.getRotation();
		btQuaternion toOrnB = transB.getRotation();

		if (m_separatingDistance > 0.0) {
			btVector3 linVelA, angVelA, linVelB, angVelB;
			btTransformUtil.calculateVelocityQuaternion(m_posA, *toPosA, m_ornA, toOrnA, cast(btScalar)1.0, linVelA, angVelA);
			btTransformUtil.calculateVelocityQuaternion(m_posB, *toPosB, m_ornB, toOrnB, cast(btScalar)1.0, linVelB, angVelB);
			btScalar maxAngularProjectedVelocity = angVelA.length() * m_boundingRadiusA + angVelB.length() * m_boundingRadiusB;
			btVector3 relLinVel = (linVelB - linVelA);
			btScalar relLinVelocLength = relLinVel.dot(m_separatingNormal);
			if (relLinVelocLength<0.f) {
				relLinVelocLength = 0.f;
			}
	
			btScalar	projectedMotion = maxAngularProjectedVelocity + relLinVelocLength;
			m_separatingDistance -= projectedMotion;
		}
	
		m_posA = *toPosA;
		m_posB = *toPosB;
		m_ornA = toOrnA;
		m_ornB = toOrnB;
	}

	void initSeparatingDistance()(const auto ref btVector3 separatingVector, btScalar separatingDistance,
			const auto ref btTransform transA, const auto ref btTransform transB) {
		m_separatingDistance = separatingDistance;

		if (m_separatingDistance>0.f) {
			m_separatingNormal = separatingVector;
			
			const btVector3* toPosA = &transA.getOrigin();
			const btVector3* toPosB = &transB.getOrigin();
			btQuaternion toOrnA = transA.getRotation();
			btQuaternion toOrnB = transB.getRotation();
			m_posA = *toPosA;
			m_posB = *toPosB;
			m_ornA = toOrnA;
			m_ornB = toOrnB;
		}
	}

};

