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

module bullet.collision.dispatch.collisionObject;

import bullet.linearMath.btMatrix3x3;
import bullet.linearMath.btSerializer;
import bullet.linearMath.btTransform;
import bullet.linearMath.btVector3;

//island management, m_activationState1
enum {int ACTIVE_TAG = 1, ISLAND_SLEEPING, WANTS_DEACTIVATION, DISABLE_DEACTIVATION, DISABLE_SIMULATION};

import bullet.collision.broadphase.broadphaseProxy;
import bullet.collision.shapes.collisionShape;
import bullet.linearMath.btMotionState;
import bullet.linearMath.btAlignedObjectArray;

alias btAlignedObjectArray!btCollisionObject btCollisionObjectArray;

version(BT_USE_DOUBLE_PRECISION) {
	alias btCollisionObjectDoubleData btCollisionObjectData;
	string btCollisionObjectDataName = "btCollisionObjectDoubleData";
} else {
	alias btCollisionObjectFloatData btCollisionObjectData;
	string btCollisionObjectDataName = "btCollisionObjectFloatData";
}


/// btCollisionObject can be used to manage collision detection objects.
/// btCollisionObject maintains all information that is needed for a collision detection: Shape, Transform and AABB proxy.
/// They can be added to the btCollisionWorld.
align(2) class btCollisionObject {

protected:

	btTransform	m_worldTransform = btTransform(btMatrix3x3.identityMatrix, btVector3(0, 0, 0));

	///m_interpolationWorldTransform is used for CCD and interpolation
	///it can be either previous or future (predicted) transform
	btTransform	m_interpolationWorldTransform;
	//those two are experimental: just added for bullet time effect, so you can still apply impulses (directly modifying velocities)
	//without destroying the continuous interpolated motion (which uses this interpolation velocities)
	btVector3	m_interpolationLinearVelocity;
	btVector3	m_interpolationAngularVelocity;

	btVector3	m_anisotropicFriction = btVector3(1.0, 1.0, 1.0);
	int			m_hasAnisotropicFriction;
	btScalar	m_contactProcessingThreshold = BT_LARGE_FLOAT;

	btBroadphaseProxy m_broadphaseHandle;
	btCollisionShape m_collisionShape;
	///m_extensionPointer is used by some internal low-level Bullet extensions.
	void* m_extensionPointer;

	///m_rootCollisionShape is temporarily used to store the original collision shape
	///The m_collisionShape might be temporarily replaced by a child collision shape during collision detection purposes
	///If it is NULL, the m_collisionShape is not temporarily replaced.
	btCollisionShape m_rootCollisionShape;

	int				m_collisionFlags = CollisionFlags.CF_STATIC_OBJECT;

	int				m_islandTag1 = -1;
	int				m_companionId = -1;

	int				m_activationState1 = 1;
	btScalar m_deactivationTime = 0.0;

	btScalar m_friction = 0.5;
	btScalar m_restitution = 0.0;

	///m_internalType is reserved to distinguish Bullet's btCollisionObject, btRigidBody, btSoftBody, btGhostObject etc.
	///do not assign your own m_internalType unless you write a new dynamics object class.
	int				m_internalType = CollisionObjectTypes.CO_COLLISION_OBJECT;

	///users can point to their objects, m_userPointer is not used by Bullet, see setUserPointer/getUserPointer
	void*			m_userObjectPointer;

	///time of impact calculation
	btScalar		m_hitFraction = 1.0;

	///Swept sphere radius (0.0 by default), see btConvexConvexAlgorithm::
	btScalar		m_ccdSweptSphereRadius = 0.0;

	/// Don't do continuous collision detection if the motion (in one step) is less then m_ccdMotionThreshold
	btScalar m_ccdMotionThreshold = 0.0;

	/// If some object should have elaborate collision filtering by sub-classes
	int			m_checkCollideWith;

	bool checkCollideWithOverride(btCollisionObject /* co */) {
		return true;
	}

public:

	//BT_DECLARE_ALIGNED_ALLOCATOR();

	enum CollisionFlags {
		CF_STATIC_OBJECT= 1,
		CF_KINEMATIC_OBJECT= 2,
		CF_NO_CONTACT_RESPONSE = 4,
		CF_CUSTOM_MATERIAL_CALLBACK = 8,//this allows per-triangle material (friction/restitution)
		CF_CHARACTER_OBJECT = 16,
		CF_DISABLE_VISUALIZE_OBJECT = 32, //disable debug drawing
		CF_DISABLE_SPU_COLLISION_PROCESSING = 64//disable parallel/SPU processing
	};

	enum CollisionObjectTypes {
		CO_COLLISION_OBJECT =1,
		CO_RIGID_BODY=2,
		///CO_GHOST_OBJECT keeps track of all objects overlapping its AABB and that pass its collision filter
		///It is useful for collision sensors, explosion objects, character controller etc.
		CO_GHOST_OBJECT=4,
		CO_SOFT_BODY=8,
		CO_HF_FLUID=16,
		CO_USER_TYPE=32
	};

	bool mergesSimulationIslands() const {
		///static objects, kinematic and object without contact response don't merge islands
		return  ((m_collisionFlags & (CollisionFlags.CF_STATIC_OBJECT |
			CollisionFlags.CF_KINEMATIC_OBJECT | CollisionFlags.CF_NO_CONTACT_RESPONSE))==0);
	}

	ref const(btVector3) getAnisotropicFriction() const {
		return m_anisotropicFriction;
	}

	void setAnisotropicFriction()(const auto ref btVector3 anisotropicFriction) {
		m_anisotropicFriction = anisotropicFriction;
		m_hasAnisotropicFriction = (anisotropicFriction[0]!=1.f) || (anisotropicFriction[1]!=1.f) || (anisotropicFriction[2]!=1.f);
	}

	bool hasAnisotropicFriction() const {
		return m_hasAnisotropicFriction != 0;
	}

	///the constraint solver can discard solving contacts, if the distance is above this threshold. 0 by default.
	///Note that using contacts with positive distance can improve stability. It increases, however, the chance of colliding with degerate contacts, such as 'interior' triangle edges
	void	setContactProcessingThreshold(btScalar contactProcessingThreshold) {
		m_contactProcessingThreshold = contactProcessingThreshold;
	}

	btScalar	getContactProcessingThreshold() const {
		return m_contactProcessingThreshold;
	}

	bool isStaticObject() const {
		return (m_collisionFlags & CollisionFlags.CF_STATIC_OBJECT) != 0;
	}

	bool isKinematicObject() const {
		return (m_collisionFlags & CollisionFlags.CF_KINEMATIC_OBJECT) != 0;
	}

	bool isStaticOrKinematicObject() const {
		return (m_collisionFlags & (CollisionFlags.CF_KINEMATIC_OBJECT | CollisionFlags.CF_STATIC_OBJECT)) != 0 ;
	}

	bool hasContactResponse() const {
		return (m_collisionFlags & CollisionFlags.CF_NO_CONTACT_RESPONSE)==0;
	}

	void setCollisionShape(btCollisionShape collisionShape) {
		m_collisionShape = collisionShape;
		m_rootCollisionShape = collisionShape;
	}

	inout(btCollisionShape) getCollisionShape() inout {
		return m_collisionShape;
	}

	inout(btCollisionShape) getRootCollisionShape() inout {
		return m_rootCollisionShape;
	}

	///Avoid using this internal API call
	///internalSetTemporaryCollisionShape is used to temporary replace the actual collision shape by a child collision shape.
	void internalSetTemporaryCollisionShape(btCollisionShape collisionShape) {
		m_collisionShape = collisionShape;
	}

	///Avoid using this internal API call, the extension pointer is used by some Bullet extensions.
	///If you need to store your own user pointer, use 'setUserPointer/getUserPointer' instead.
	@property inout(void*) internalGetExtensionPointer() inout {
		return m_extensionPointer;
	}

	///Avoid using this internal API call, the extension pointer is used by some Bullet extensions
	///If you need to store your own user pointer, use 'setUserPointer/getUserPointer' instead.
	@property void internalSetExtensionPointer(void* pointer) {
		m_extensionPointer = pointer;
	}

	int getActivationState() const { return m_activationState1;}

	void setActivationState(int newState) {
		if ( (m_activationState1 != DISABLE_DEACTIVATION) && (m_activationState1 != DISABLE_SIMULATION))
		m_activationState1 = newState;
	}

	void	setDeactivationTime(btScalar time) {
		m_deactivationTime = time;
	}

	btScalar getDeactivationTime() const {
		return m_deactivationTime;
	}

	void forceActivationState(int newState) {
		m_activationState1 = newState;
	}

	void activate(bool forceActivation = false) {
		if (forceActivation || !(m_collisionFlags & (CollisionFlags.CF_STATIC_OBJECT | CollisionFlags.CF_KINEMATIC_OBJECT))) {
			setActivationState(ACTIVE_TAG);
			m_deactivationTime = cast(btScalar)0.0;
		}
	}

	bool isActive() const {
		return ((getActivationState() != ISLAND_SLEEPING) && (getActivationState() != DISABLE_SIMULATION));
	}

	void setRestitution(btScalar rest) {
		m_restitution = rest;
	}

	btScalar getRestitution() const {
		return m_restitution;
	}

	void	setFriction(btScalar frict) {
		m_friction = frict;
	}

	btScalar getFriction() const {
		return m_friction;
	}

	///reserved for Bullet internal usage
	int	getInternalType() const {
		return m_internalType;
	}

	ref inout(btTransform) getWorldTransform() inout {
		return m_worldTransform;
	}

	void setWorldTransform()(const auto ref btTransform worldTrans) {
		m_worldTransform = worldTrans;
	}

	inout(btBroadphaseProxy) getBroadphaseHandle() inout {
		return m_broadphaseHandle;
	}

	void setBroadphaseHandle(btBroadphaseProxy handle) {
		m_broadphaseHandle = handle;
	}

	ref const(btTransform) getInterpolationWorldTransform() const {
		return m_interpolationWorldTransform;
	}

	ref btTransform getInterpolationWorldTransform() {
		return m_interpolationWorldTransform;
	}

	void setInterpolationWorldTransform()(const auto ref btTransform trans) {
		m_interpolationWorldTransform = trans;
	}

	void setInterpolationLinearVelocity()(const auto ref btVector3 linvel) {
		m_interpolationLinearVelocity = linvel;
	}

	void setInterpolationAngularVelocity()(const auto ref btVector3 angvel) {
		m_interpolationAngularVelocity = angvel;
	}

	ref const(btVector3) getInterpolationLinearVelocity() const {
		return m_interpolationLinearVelocity;
	}

	ref const(btVector3) getInterpolationAngularVelocity() const {
		return m_interpolationAngularVelocity;
	}

	int getIslandTag() const {
		return	m_islandTag1;
	}

	void setIslandTag(int tag) {
		m_islandTag1 = tag;
	}

	int getCompanionId() const {
		return	m_companionId;
	}

	void setCompanionId(int id) {
		m_companionId = id;
	}

	btScalar getHitFraction() const {
		return m_hitFraction;
	}

	void setHitFraction(btScalar hitFraction) {
		m_hitFraction = hitFraction;
	}

	int	getCollisionFlags() const {
		return m_collisionFlags;
	}

	void setCollisionFlags(int flags) {
		m_collisionFlags = flags;
	}

	///Swept sphere radius (0.0 by default), see btConvexConvexAlgorithm::
	btScalar getCcdSweptSphereRadius() const {
		return m_ccdSweptSphereRadius;
	}

	///Swept sphere radius (0.0 by default), see btConvexConvexAlgorithm::
	void setCcdSweptSphereRadius(btScalar radius) {
		m_ccdSweptSphereRadius = radius;
	}

	btScalar 	getCcdMotionThreshold() const {
		return m_ccdMotionThreshold;
	}

	btScalar getCcdSquareMotionThreshold() const {
		return m_ccdMotionThreshold*m_ccdMotionThreshold;
	}



	/// Don't do continuous collision detection if the motion (in one step) is less then m_ccdMotionThreshold
	void	setCcdMotionThreshold(btScalar ccdMotionThreshold) {
		m_ccdMotionThreshold = ccdMotionThreshold;
	}

	///users can point to their objects, userPointer is not used by Bullet
	inout(void*) getUserPointer() inout {
		return m_userObjectPointer;
	}

	///users can point to their objects, userPointer is not used by Bullet
	void setUserPointer(void* userPointer) {
		m_userObjectPointer = userPointer;
	}

	bool checkCollideWith(btCollisionObject co)	{
		if (m_checkCollideWith)
			return checkCollideWithOverride(co);
		return true;
	}

	int calculateSerializeBufferSize() const {
		return btCollisionObjectData.sizeof;
	}

	///fills the dataBuffer and returns the struct name (or an empty string on failure)
	///Currently unported
	///To do: make ths throw an exception?
	string serialize(void* dataBuffer, btSerializer serializer) const {
		return "";
		/+btCollisionObjectData* dataOut = cast(btCollisionObjectData*)dataBuffer;

		m_worldTransform.serialize(dataOut.m_worldTransform);
		m_interpolationWorldTransform.serialize(dataOut.m_interpolationWorldTransform);
		m_interpolationLinearVelocity.serialize(dataOut.m_interpolationLinearVelocity);
		m_interpolationAngularVelocity.serialize(dataOut.m_interpolationAngularVelocity);
		m_anisotropicFriction.serialize(dataOut.m_anisotropicFriction);
		dataOut.m_hasAnisotropicFriction = m_hasAnisotropicFriction;
		dataOut.m_contactProcessingThreshold = m_contactProcessingThreshold;
		dataOut.m_broadphaseHandle = null;
		assert(false);
		//To do: get working
		//dataOut.m_collisionShape = serializer.getUniquePointer(m_collisionShape);
		dataOut.m_rootCollisionShape = null;//@todo
		dataOut.m_collisionFlags = m_collisionFlags;
		dataOut.m_islandTag1 = m_islandTag1;
		dataOut.m_companionId = m_companionId;
		dataOut.m_activationState1 = m_activationState1;
		dataOut.m_activationState1 = m_activationState1;
		dataOut.m_deactivationTime = m_deactivationTime;
		dataOut.m_friction = m_friction;
		dataOut.m_restitution = m_restitution;
		dataOut.m_internalType = m_internalType;

		string name = serializer.findNameForPointer(cast(void*)this);
		//To do: get working
		//dataOut.m_name = cast(char*)serializer.getUniquePointer(name);
		if (dataOut.m_name) {
			serializer.serializeName(name);
		}
		dataOut.m_hitFraction = m_hitFraction;
		dataOut.m_ccdSweptSphereRadius = m_ccdSweptSphereRadius;
		dataOut.m_ccdMotionThreshold = m_ccdMotionThreshold;
		dataOut.m_ccdMotionThreshold = m_ccdMotionThreshold;
		dataOut.m_checkCollideWith = m_checkCollideWith;

		return btCollisionObjectDataName;+/
	}

	void serializeSingleObject(btSerializer serializer) const {
		int len = calculateSerializeBufferSize();
		btChunk* chunk = serializer.allocate(len, 1);
		string structType = serialize(chunk.m_oldPtr, serializer);
		serializer.finalizeChunk(chunk, structType, BT_COLLISIONOBJECT_CODE, cast(void*)this);
	}

};

///do not change those serialization structures, it requires an updated sBulletDNAstr/sBulletDNAstr64
struct	btCollisionObjectDoubleData
{
	void					*m_broadphaseHandle;
	void					*m_collisionShape;
	btCollisionShapeData	*m_rootCollisionShape;
	char					*m_name;

	btTransformDoubleData	m_worldTransform;
	btTransformDoubleData	m_interpolationWorldTransform;
	btVector3DoubleData		m_interpolationLinearVelocity;
	btVector3DoubleData		m_interpolationAngularVelocity;
	btVector3DoubleData		m_anisotropicFriction;
	double					m_contactProcessingThreshold;
	double					m_deactivationTime;
	double					m_friction;
	double					m_restitution;
	double					m_hitFraction;
	double					m_ccdSweptSphereRadius;
	double					m_ccdMotionThreshold;

	int						m_hasAnisotropicFriction;
	int						m_collisionFlags;
	int						m_islandTag1;
	int						m_companionId;
	int						m_activationState1;
	int						m_internalType;
	int						m_checkCollideWith;

	char	m_padding[4];
};

///do not change those serialization structures, it requires an updated sBulletDNAstr/sBulletDNAstr64
struct	btCollisionObjectFloatData
{
	void					*m_broadphaseHandle;
	void					*m_collisionShape;
	btCollisionShapeData	*m_rootCollisionShape;
	char					*m_name;

	btTransformFloatData	m_worldTransform;
	btTransformFloatData	m_interpolationWorldTransform;
	btVector3FloatData		m_interpolationLinearVelocity;
	btVector3FloatData		m_interpolationAngularVelocity;
	btVector3FloatData		m_anisotropicFriction;
	float					m_contactProcessingThreshold;
	float					m_deactivationTime;
	float					m_friction;
	float					m_restitution;
	float					m_hitFraction;
	float					m_ccdSweptSphereRadius;
	float					m_ccdMotionThreshold;

	int						m_hasAnisotropicFriction;
	int						m_collisionFlags;
	int						m_islandTag1;
	int						m_companionId;
	int						m_activationState1;
	int						m_internalType;
	int						m_checkCollideWith;
};
